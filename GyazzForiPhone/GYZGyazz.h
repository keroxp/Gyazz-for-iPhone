//
//  GYZGyazz.h
//  GyazzForiPhone
//
//  Created by 桜井雄介 on 2013/03/13.
//  Copyright (c) 2013年 桜井雄介. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GYZPage, AFHTTPRequestOperation;

@interface GYZGyazz : NSObject  <NSCoding>

/* Gyazzの名前 */
@property (readonly) NSString *name;
/* Basic認証用のUserName */
@property () NSString *username;
/* Basic認証用のパスワード */
@property () NSString *password;
/* ウォッチリスト */
@property (readonly) NSMutableArray *watchList;

/* コンストラクタ */
- (id)initWithName:(NSString*)name;
/* 自身のページリストを取得する */
- (void)getPageListWithWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/* 対象ページのテキストを取得 */
- (void)getTextOfPage:(GYZPage*)page
              success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/* 対象ページの関連ページを取得 */
- (void)getRelatedOfPage:(GYZPage*)page
                 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/* URLパス */
- (NSString*)absoluteURLPath;
/* UserDefaultsに保存 */
- (void)save;

@end
