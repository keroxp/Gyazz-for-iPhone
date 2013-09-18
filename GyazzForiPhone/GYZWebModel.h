//
//  GYZWebModel.h
//  GyazzForiPhone
//
//  Created by 桜井雄介 on 2013/04/21.
//  Copyright (c) 2013年 Masui Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^GYZNetworkSuccessBlock)(AFHTTPRequestOperation *operation, id responseObj);
typedef void (^GYZNetworkFailureBlock)(AFHTTPRequestOperation *operation, NSError *e) ;

@interface GYZWebModel : NSObject <NSCoding>

/* Basic認証用のUserName */
@property () NSString *username;
/* Basic認証用のパスワード */
@property () NSString *password;

/* 対象URLにアクセス */
- (void)accessToURL:(NSString *)URL
             success:(GYZNetworkSuccessBlock)success
            failure:(GYZNetworkFailureBlock)failure;

- (void)accessWithURLRequest:(NSURLRequest*)request
                     success:(GYZNetworkSuccessBlock)success
                     failure:(GYZNetworkFailureBlock)failure;

@end

@interface GYZWebModel (Abstract)

/* URLパス */
- (NSString*)absoluteURLPath;
/* URL */
- (NSURL*)absoluteURL;


@end