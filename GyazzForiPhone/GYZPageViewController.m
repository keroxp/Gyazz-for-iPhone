//
//  GYZPageViewController.m
//  GyazzForiPhone
//
//  Created by 桜井雄介 on 2013/03/13.
//  Copyright (c) 2013年 桜井雄介. All rights reserved.
//

#import <SVProgressHUD.h>
#import "GYZPageViewController.h"
#import "GYZPageEditViewController.h"
#import "GYZPage.h"
#import "GYZUserData.h"
#import "GYZNavigationTitleView.h"
#import "GYZNavigationStackViewController.h"
#import "GYZToolbar.h"
#import "GYZBarButton.h"

@interface GYZPageViewController ()
{
    NSURL *_URLToMove;
    UIToolbar *_toolbar;
    UIRefreshControl *_refreshControl;
}

@end

@implementation GYZPageViewController

+ (GYZPageViewController *)pageViewControllerWithPage:(GYZPage *)page enableCheckButton:(BOOL)checkButton
{
    @autoreleasepool {
        UIStoryboard *s = [UIStoryboard storyboardWithName:@"PageStoryboard" bundle:[NSBundle mainBundle]];
        GYZPageViewController *p = [s instantiateInitialViewController];
        [p setPage:page];
        [p setCheckButtonEnabled:checkButton];
        return p;
    }
}

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
    // タイトルを設定
    __block __weak typeof (self) __self = self;
    self.title = self.page.title;
    // リフレッシュを追加
    UIRefreshControl *rc = [[UIRefreshControl alloc] init];
    [rc addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    _refreshControl = rc;
    [self.webView.scrollView addSubview:rc];
    // デリゲートを設定
    [self.webView setDelegate:self];
    // 影を消す
    for(UIView *wview in [[[self.webView subviews] objectAtIndex:0] subviews]) {
        if([wview isKindOfClass:[UIImageView class]]) { wview.hidden = YES; }
    }
    // スクロール速度を上げる
    [self.webView.scrollView setDecelerationRate:UIScrollViewDecelerationRateNormal];
    // 戻るボタン
    [self.navigationItem setHidesBackButton:YES];
    UIImage *bi = [UIImage imageNamed:@"backicon"];
    UIButton *b = [[UIButton alloc] initWithFrame:CGRectZero];
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        b.frame = CGRectMake(0, 0, 35, 44);
    }else{
        b.frame = CGRectMake(0, 0, 20, 44);
    }
    [b setImage:bi forState:UIControlStateNormal];
    [b addEventHandler:^(id sender) {
        [__self.navigationController popViewControllerAnimated:YES];
    } forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item_ = [[UIBarButtonItem alloc] initWithCustomView:b];
    [self.navigationItem setLeftBarButtonItem:item_];
    
    // 履歴
    GYZNavigationTitleView *title = [[GYZNavigationTitleView alloc] initWithTitle:self.page.title];
    [title addEventHandler:^(id sender) {
        [__self performSegueWithIdentifier:@"showStack" sender:__self];
    } forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setTitleView:title];
    
    // 読み込み
    [self refresh:rc];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 右上に編集ボタンを追加
    //    GYZBarButton *edit = [GYZBarButton barButtonWithStyle:GYZBarButtonStyleEdit];
    //    [edit addEventHandler:^(id sender) {
    //        [self performSegueWithIdentifier:@"showEdit" sender:self];
    //    } forControlEvents:UIControlEventTouchUpInside];
    //    UIBarButtonItem *e = [[UIBarButtonItem alloc] initWithCustomView:edit];
    //    [self.navigationItem setRightBarButtonItem:e];
    
    // チェックリストが有効な遷移なら
    if (self.isCheckButtonEnabled) {
        // チェックリストに追加ボタンを追加
        UIButton *add = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 38, 31)];
        __block UIButton *__add = add;
        if ([[GYZUserData watchList] containsObject:self.page]) {
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
                [add setImage:[UIImage imageNamed:@"addicon_selected7"] forState:UIControlStateNormal];
            }else{
                [add setImage:[UIImage imageNamed:@"addicon_selected"] forState:UIControlStateNormal];
            }
        }else{
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
                [add setImage:[UIImage imageNamed:@"addicon7"] forState:UIControlStateNormal];
            }else{
                [add setImage:[UIImage imageNamed:@"addicon"] forState:UIControlStateNormal];
            }
        }
        __block __weak typeof (self) __self = self;
        [add addEventHandler:^(id sender) {
            if ([[GYZUserData watchList] containsObject:__self.page]) {
                NSString *m = [NSString stringWithFormat:@"%@\nチェックリストから削除しました",__self.page.title];
                [[GYZUserData watchList] removeObject:__self.page];
                [GYZUserData saveWatchList];
                [SVProgressHUD showErrorWithStatus:NSLocalizedString(m, )];
                [__add setImage:[UIImage imageNamed:@"addicon"] forState:UIControlStateNormal];
            }else{
                NSString *m = [NSString stringWithFormat:@"%@\nチェックリストに追加しました",__self.page.title];
                [[GYZUserData watchList] addObject:__self.page];
                [GYZUserData saveWatchList];
                [SVProgressHUD showSuccessWithStatus:NSLocalizedString(m, )];
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
                    [__add setImage:[UIImage imageNamed:@"addicon_selected7"] forState:UIControlStateNormal];
                }else{
                    [__add setImage:[UIImage imageNamed:@"addicon_selected"] forState:UIControlStateNormal];
                }
            }
        } forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *additem = [[UIBarButtonItem alloc] initWithCustomView:add];
        // iPhoneならツールバーを追加して追加
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            // ツールバーを表示
            if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
                [self.navigationController.toolbar setBackgroundImage:[UIImage imageNamed:@"toolbg"] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
            }
            [self.navigationController setToolbarHidden:NO animated:NO];
            UIBarButtonItem *sp = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
            [self setToolbarItems:@[sp,additem,sp]];
        }else if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            UIBarButtonItem *e = self.navigationItem.rightBarButtonItem;
            if (e) {
                [self.navigationItem setRightBarButtonItems:@[e,additem]];
            }else{
                [self.navigationItem setRightBarButtonItem:additem];
            }
        }
    }    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setToolbarHidden:YES];
}

- (void)refresh:(UIRefreshControl*)sender
{
    [sender beginRefreshing];
    UIEdgeInsets is = self.webView.scrollView.contentInset;
    [self.webView.scrollView setContentOffset:CGPointMake(0, -is.top) animated:YES];
    __block __weak typeof (self) __self = self;
    [self.page getHTMLWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [sender endRefreshing];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        //        $(@"%@",str);
        [__self.webView loadHTMLString:str baseURL:[NSURL URLWithString:__self.page.absoluteURLPath]];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [sender endRefreshing];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"エラー", )
                                                     message:[error localizedDescription]
                                                    delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", ) otherButtonTitles:nil, nil];
        [av  show];
        $(@"%@",error);
    }];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showStack"]) {
        GYZNavigationStackViewController *vc = (GYZNavigationStackViewController*)[[segue destinationViewController] topViewController];
        [vc setController:self.navigationController];
    }else if ([segue.identifier isEqualToString:@"showEdit"]){
        GYZPageEditViewController *pv = (GYZPageEditViewController*)[[segue destinationViewController] topViewController];
        [pv setPage:self.page];
    }
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
        NSError *e = nil;
        
        //        $(@"brefore : %@",line);
        
        NSString *linkPattern = @"\\[\\[(.+)\\]\\]";
        e = nil;
        NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:linkPattern
                                                                             options:0
                                                                               error:&e];
        if(e != nil){
            NSLog(@"%@", [e description]);
        }
        
        NSArray *matches = [reg matchesInString:line options:0 range:NSMakeRange(0, line.length)];
        
        //        $(@"matches : %i",matches.count);
        for (NSTextCheckingResult *tcr in matches) {
            
            // マッチから[[と]]を覗いた範囲
            NSRange range = [tcr rangeAtIndex:1];
            NSString *replace = @"";
            // innerだけにトリミング
            NSString *link = [line substringWithRange:range];
            NSString *linkText = [link copy];
            //            $(@"link text : %@",linkText);
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
            //            $(@"replace : %@",replace);
            line = [line stringByReplacingCharactersInRange:NSMakeRange(range.location-2, range.length+4) withString:replace];
        }
        line = [NSString stringWithFormat:@"<div id=\"line-%i\" class=\"line\">%@</div>",i,line];
        //        $(@"after : %@",line);
        [html appendFormat:@"%@",line];
    }
    return html;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Web View

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    $(@"%@",error);
    [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"読み込みエラー", )];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    switch (navigationType) {
        case UIWebViewNavigationTypeLinkClicked: {
            _URLToMove = [request URL];
            // URLをデコード
            NSString *urlstr = [request.URL.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            // 同じGyazzの中への遷移か？
            if ([urlstr rangeOfString:self.page.gyazz.absoluteURLPath].location != NSNotFound) {
                // ページのタイトルを取得
                NSString *pat = [NSString stringWithFormat:@"%@/(.+)",self.page.gyazz.absoluteURLPath];
                NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:pat options:0 error:nil];
                NSTextCheckingResult *tr = [reg firstMatchInString:urlstr
                                                           options:0
                                                             range:NSMakeRange(0,urlstr.length)];
                NSRange r = [tr rangeAtIndex:1];
                NSString *title = [urlstr substringWithRange:r];;
                // ナビゲーションを進める
                GYZPage *page = [[GYZPage alloc] initWithGyazz:self.page.gyazz title:title modtime:0];
                GYZPageViewController *pvc = [GYZPageViewController pageViewControllerWithPage:page enableCheckButton:YES];
                [self.navigationController pushViewController:pvc animated:YES];
            }else if ([urlstr rangeOfString:@"twitter://"].location != NSNotFound){
                // Twitterのリンクならアプリでひらく
                [[UIApplication sharedApplication] openURL:request.URL];
            }else{
                // 通常のwebページなら別のViewControllerで遷移
                SVModalWebViewController *web = [[SVModalWebViewController alloc] initWithURL:request.URL];
                [self presentViewController:web animated:YES completion:NULL];
            }
        }
            return NO;
            break;
            
        default:
            break;
    }
    return YES;
}

@end
