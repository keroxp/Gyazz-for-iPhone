//
//  GYZWebModel.m
//  GyazzForiPhone
//
//  Created by 桜井雄介 on 2013/04/21.
//  Copyright (c) 2013年 Masui Lab. All rights reserved.
//

#import "GYZWebModel.h"

@implementation GYZWebModel

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_username forKey:@"username"];
    [aCoder encodeObject:_password forKey:@"password"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _username = [aDecoder decodeObjectForKey:@"username"];
        _password = [aDecoder decodeObjectForKey:@"password"];
    }
    return self;
}

- (void)accessWithURLRequest:(NSURLRequest *)request success:(GYZNetworkSuccessBlock)success failure:(GYZNetworkFailureBlock)failure
{
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    __block __weak typeof (self) __self = self;
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
            [__self setUsername:nil];
            [__self setPassword:nil];
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ユーザ名もしくはパスワードが違います", ) message:nil];
            [av setCancelButtonWithTitle:@"OK" handler:^{
                [__self accessToURL:request.URL.absoluteString success:success failure:failure];
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            }];
            [av show];
        } else {
            if (__self.username.length && __self.password.length) {
                $(@"id pass あり");
                NSURLCredential *credential = [NSURLCredential credentialWithUser:__self.username password:__self.password persistence:NSURLCredentialPersistenceNone];
                [[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
                
            }else{
                $(@"id pass なし");
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"認証が必要です", ) message:nil];
                __block UIAlertView *__av = av;
                [av setCancelButtonWithTitle:NSLocalizedString(@"やめる", ) handler:^{
                    [connection cancel];
                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                    [__self setUsername:nil];
                    [__self setPassword:nil];
                }];
                [av addButtonWithTitle:NSLocalizedString(@"認証", ) handler:^{
                    [__self setUsername:[[__av textFieldAtIndex:0] text]];
                    [__self setPassword:[[__av textFieldAtIndex:1] text]];
                    // リトライ
                    [__self accessToURL:request.URL.absoluteString success:success failure:failure];
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

- (void)accessToURL:(NSString *)URL success:(GYZNetworkSuccessBlock)success failure:(GYZNetworkFailureBlock)failure
{
    $(@"%@,%@,%@",URL,self.username,self.password);
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:[URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [self accessWithURLRequest:req success:success failure:failure];
}

@end
