//
//  GYZPage.h
//  GyazzForiPhone
//
//  Created by 桜井雄介 on 2013/03/13.
//  Copyright (c) 2013年 桜井雄介. All rights reserved.
//

#import "GYZWebModel.h"
#import "GYZGyazz.h"

@class GYZGyazz;

@interface GYZPage : GYZWebModel

/* 所属するGyazz */
@property () GYZGyazz *gyazz;
/* タイトル */
@property (readonly) NSString *title;
/* 最終更新日付 */
@property (readonly) NSDate *modifiedDate;
/* ページのテキスト。あれば */
@property (nonatomic) NSString *text;
/* テキストのHTML出力。あれば */
@property (nonatomic) NSString *htmlText;
/* 関連ページ 。あれば */
@property (nonatomic) NSString *relatedPages;

/* JSONArrayからページリストを作る */
+ (NSArray*)pagesFromJSONArray:(NSArray*)JSONArray ofGyazz:(GYZGyazz*)gyazz;

/* コンストラクタ*/
- (id)initWithGyazz:(GYZGyazz*)gyazz title:(NSString*)title modtime:(NSInteger)modtime;


/* 対象ページのテキストを取得 */
- (void)getTextWithSuccess:(GYZNetworkSuccessBlock)success
                   failure:(GYZNetworkFailureBlock)failure;

/* 対象ページの関連ページを取得 */
- (void)getRelatedWithSuccess:(GYZNetworkSuccessBlock)success
                      failure:(GYZNetworkFailureBlock)failure;

/* 対象ページのHTMLを取得 */
- (void)getHTMLWithSuccess:(GYZNetworkSuccessBlock)success
                   failure:(GYZNetworkFailureBlock)failure;

/* ページを保存 */
- (void)saveWithText:(NSString*)text
             success:(GYZNetworkSuccessBlock)success
             failure:(GYZNetworkFailureBlock)failure;

@end
