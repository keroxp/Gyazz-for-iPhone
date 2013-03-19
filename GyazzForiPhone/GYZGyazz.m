//
//  GYZGyazz.m
//  GyazzForiPhone
//
//  Created by 桜井雄介 on 2013/03/13.
//  Copyright (c) 2013年 桜井雄介. All rights reserved.
//

#import "GYZGyazz.h"
#import "GYZPage.h"
#import "GYZUserData.h"
#import <AFNetworking.h>
#import <JSONKit.h>
#import <BlocksKit.h>

#define kAPIURL @"http://gyazz.com"

@interface GYZGyazz ()

/* APIにアクセス */
- (void)_accessToURL:(NSString*)URL
             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end

@implementation GYZGyazz

- (id)initWithName:(NSString *)name
{
    if (self = [super init]) {
        _name = name;
        _watchList = [NSMutableArray array];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeObject:_username forKey:@"username"];
    [aCoder encodeObject:_password forKey:@"password"];
    NSData *d = [NSKeyedArchiver archivedDataWithRootObject:_watchList];
    [aCoder encodeObject:d forKey:@"watchlist"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _name = [aDecoder decodeObjectForKey:@"name"];
        _username = [aDecoder decodeObjectForKey:@"username"];
        _password = [aDecoder decodeObjectForKey:@"password"];
        NSData *d = [aDecoder decodeObjectForKey:@"watchlist"];
        NSArray *a = [NSKeyedUnarchiver unarchiveObjectWithData:d];
        _watchList = [a mutableCopy];
    }
    return self;
}

- (void)getPageListWithWithSuccess:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    NSString *path = [NSString stringWithFormat:@"%@/__list",[self absoluteURLPath]];
    [self _accessToURL:path success:success failure:failure];
}

- (void)getTextOfPage:(GYZPage *)page success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    // 自身以外のページは取得しない
    if (page.gyazz != self) {
        return;
    }
    NSString *path = [NSString stringWithFormat:@"%@/%@/text",[self absoluteURLPath],[page title]];
    [self _accessToURL:path success:success failure:failure];
}

- (void)getRelatedOfPage:(GYZPage *)page success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    if ([page gyazz] != self) {
        return;
    }
    NSString *path = [NSString stringWithFormat:@"%@/%@/related",[self absoluteURLPath],[page title]];
    [self _accessToURL:path success:success failure:failure];
}

- (NSString *)absoluteURLPath
{
    return [NSString stringWithFormat:@"%@/%@",kAPIURL,_name];
}

- (void)save
{
    // 保存
    [GYZUserData saveGyazzList];
}

#pragma mark - Private 

- (void)_accessToURL:(NSString *)URL
             success:(void (^)(AFHTTPRequestOperation *, id))success
             failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    $(@"%@,%@,%@",URL,_username,_password);
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:[URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:req];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        $(@"%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        if (success) {
            success(operation,responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        $(@"%@",error.localizedDescription);
        if (failure) {
            failure(operation,error);
        }
    }];
    // Basic認証用のコールバックブロック
    [op setAuthenticationChallengeBlock:^(NSURLConnection *connection, NSURLAuthenticationChallenge *challenge) {
        
        if ([challenge proposedCredential]) {
            //IDパスワードが違うときこっちに来る
            $(@"idとpassが違う");
            [connection cancel];
            [self setUsername:nil];
            [self setPassword:nil];
        } else {
            if (self.username.length && self.password.length) {
                $(@"id pass あり");
                NSURLCredential *credential = [NSURLCredential credentialWithUser:_username password:_password persistence:NSURLCredentialPersistenceNone];
                [[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
                
            }else{
                $(@"id pass なし");
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"認証が必要です", ) message:nil];
                __block UIAlertView *__av = av;
                [av setCancelButtonWithTitle:NSLocalizedString(@"やめる", ) handler:^{
                    [connection cancel];
                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                    [self setUsername:nil];
                    [self setPassword:nil];
                }];
                [av addButtonWithTitle:NSLocalizedString(@"認証", ) handler:^{
                    [self setUsername:[[__av textFieldAtIndex:0] text]];
                    [self setPassword:[[__av textFieldAtIndex:1] text]];
                    // リトライ
                    [self _accessToURL:URL success:success failure:failure];
                }];
                [av setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
                [[av textFieldAtIndex:0] setPlaceholder:NSLocalizedString(@"ユーザ名", )];
                [[av textFieldAtIndex:1] setPlaceholder:NSLocalizedString(@"パスワード", )];
                [[av textFieldAtIndex:1] setSecureTextEntry:YES];
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [av show];
                }];
            }
        }
    }];
    NSOperationQueue *q = [[NSOperationQueue alloc] init];
    [q addOperation:op];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

@end
