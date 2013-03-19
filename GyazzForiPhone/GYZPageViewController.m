//
//  GYZPageViewController.m
//  GyazzForiPhone
//
//  Created by 桜井雄介 on 2013/03/13.
//  Copyright (c) 2013年 桜井雄介. All rights reserved.
//

#import "GYZPageViewController.h"
#import "GYZPage.h"
#import <AFNetworking.h>
@interface GYZPageViewController ()

@end

@implementation GYZPageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSString *path = [NSString stringWithFormat:@"%@/%@",[self.page.gyazz absoluteURLPath],self.page.title];
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:path]];
    $(@"%@",path);
    [self.webView loadRequest:req];
    [self.page.gyazz getTextOfPage:self.page success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *s = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSString *html = [self parsePageText:s];
        $(@"%@",html);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        ;
    }];
    path = @"http://gyazz.com/Gyazz/Wiki%E3%83%9A%E3%83%BC%E3%82%B8%E3%81%AE%E7%B7%A8%E9%9B%86%E6%96%B9%E6%B3%95/text";
    req = [NSURLRequest requestWithURL:[NSURL URLWithString:path]];
    AFHTTPRequestOperation *ro = [[AFHTTPRequestOperation alloc] initWithRequest:req];
    [ro setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        abort();
    }];
    [[NSOperationQueue mainQueue] addOperation:ro];
}

/* 
 タグ
 キーワードを “[[”と “]]” で囲むと、キーワードページへのリンクになります。
 “[[目次]]” ⇒ 目次
 名前とキーワードを「::」で連結した文字列を “[[”と “]]” で囲むと、別のGyazzページのページへのリンクになります。
 “[[UIPedia::Index]]” ⇒ UIPedia::Index
 キーワードは省略可能です
 キーワードを “[[[”と “]]]” で囲むと太字になります。
 “[[[太字]]]” ⇒ 太字
 URLを “[[”と “]]” で囲むとリンクになります。
 “[[http://tangocho.org/]]” ⇒ http://tangocho.org/
 URLと文字列を空白で区切って “[[”と “]]” で囲むとその文字列がURLへのリンクになります。
 “[[http://tangocho.org/ 単語帳]]” ⇒ 単語帳
 画像URLを “[[”と “]]” で囲むと画像が表示されます。
 “[[http://gyazo.com/e181a577e8908a63af0dad213dbfc82a.png]]” ⇒ “”
 画像URLを “[[[”と “]]]” で囲むと縮小画像が表示されます。
 URLと画像URLを空白で区切って “[[”と “]]” で囲むとリンク付き画像が表示されます。
 “[[http://pitecan.com/ http://gyazo.com/e181a577e8908a63af0dad213dbfc82a.png]]” ⇒ “”
 キーワードを “[[@” と “]]” で囲むと、twitterページへのリンクになります。
 “[[@masui]]” ⇒ @masui
 */

- (NSString*)parsePageText:(NSString*)text
{
    // 改行で分割
    NSMutableString *html = [NSMutableString string];
    NSArray *lines = [text componentsSeparatedByString:@"\n"];
    for (int i = 0, max = lines.count ; i < max ; i++) {
        NSString *line = [lines objectAtIndex:i];
        line = [line stringByReplacingOccurrencesOfString:@"[[[" withString:@"<b>"];
        line = [line stringByReplacingOccurrencesOfString:@"]]]" withString:@"</b>"];
        NSLog(@"brefore : %@",line);
        
        NSString *linkPattern = @"\\[\\[(.+)\\]\\]";
        NSError *e = nil;
        NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:linkPattern
                                                                             options:0
                                                                               error:&e];
        if(e != nil){
            NSLog(@"%@", [e description]);
        }        
        
        NSArray *matches = [reg matchesInString:line options:0 range:NSMakeRange(0, line.length)];
        
        $(@"matches : %i",matches.count);
        for (NSTextCheckingResult *tcr in matches) {
            
            // マッチから[[と]]を覗いた範囲
//            $(@"number of ranges : %i",tcr.numberOfRanges);
            NSRange range = [tcr rangeAtIndex:1];
            NSString *replace = @"";
            // innerだけにトリミング
            NSString *link = [line substringWithRange:range];
            NSString *linkText = [link copy];
            $(@"link text : %@",linkText);
            // URLリンク
            NSString *urlLinkPat = @"http:\\/\\/.+";
            // Gyazz内部リンク
            NSString *gyazzLinkPat = @".+:.+";
            
            // URLリンクか？
            if ([link rangeOfString:urlLinkPat options:NSRegularExpressionSearch].location != NSNotFound) {
                // 分割できれば分割
                NSArray *comp = [link componentsSeparatedByString:@" "];
                if (comp.count > 1) {
                    NSArray *comp = [link componentsSeparatedByString:@" "];
                    link = [comp objectAtIndex:0];
                    linkText = [comp objectAtIndex:1];
                }
                NSString *imgLinkPat = @"\\.(png|jpg|gif)";
                // 画像リンク
                if ([link rangeOfString:imgLinkPat options:NSRegularExpressionSearch].location != NSNotFound) {
                    if (comp.count > 1) {
                        // 画像+リンク
                        NSString *a = [NSString stringWithFormat:@"<a href=\"%@\"><img src=\"%@\" /></a>",link,linkText];
                        replace = a;
                    }else{
                        // 画像のみ
                        NSString *img = [NSString stringWithFormat:@"<img src=\"%@\" />",link];
                        replace = img;
                    }
                }else if (comp.count > 1){
                    // リンク+名前
                    NSString *a = [NSString stringWithFormat:@"<a href=\"%@\">%@</a>",link,linkText];
                    replace = a;
                }
            }
            // Twitterのリンクか？
            else if ([link characterAtIndex:0] == '@'){
                // Twitter
                NSString *sn = [link substringWithRange:NSMakeRange(1, link.length-1)];
                NSString *twitter = [NSString stringWithFormat:@"twitter://user?screen_name=%@",sn];
                NSString *a = [NSString stringWithFormat:@"<a href=\"%@\">%@</a>",twitter,sn];
                replace = a;
            }
            // 外部Gyazzリンクか？
            else if ([link rangeOfString:gyazzLinkPat options:NSRegularExpressionSearch].location != NSNotFound){
                NSArray *comps = [link componentsSeparatedByString:@":"];
                link = [NSString stringWithFormat:@"http:/gyazz.com/%@/%@",[comps objectAtIndex:0],[comps objectAtIndex:1]];
                NSString *a = [NSString stringWithFormat:@"<a href=\"%@\">%@</a>",link,linkText];
                replace = a;
            }// 内部Gyazzリンクか？
            else{
                link = [NSString stringWithFormat:@"http:/gyazz.com/%@/%@",self.page.gyazz.name,linkText];
                NSString *a = [NSString stringWithFormat:@"<a href=\"%@\">%@</a>",link,linkText];
                replace = a;
            }
            $(@"replace : %@",replace);
            line = [line stringByReplacingCharactersInRange:NSMakeRange(range.location-2, range.length+4) withString:replace];
        }
        line = [NSString stringWithFormat:@"<div id=\"line-%i\" class=\"line\">%@</div>",i,line];
        NSLog(@"after : %@",line);
        [html appendFormat:@"%@\n",line];
    }
    return html;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    NSURLCredential *credential = [NSURLCredential credentialWithUser:self.page.gyazz.username
                                                             password:self.page.gyazz.password
                                                          persistence:NSURLCredentialPersistenceNone];
    [[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    $(@"%@",error);
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

@end
