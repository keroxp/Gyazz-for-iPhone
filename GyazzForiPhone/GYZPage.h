//
//  GYZPage.h
//  GyazzForiPhone
//
//  Created by 桜井雄介 on 2013/03/13.
//  Copyright (c) 2013年 Ê°ú‰∫ïÈõÑ‰ªã. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GYZGyazz;

@interface GYZPage : NSObject

/* 所属するGyazz */
@property () GYZGyazz *gyazz;
/* タイトル */
@property (readonly) NSString *title;
/* 最終更新日付 */
@property (readonly) NSDate *modifiedDate;
/* ページのテキスト。あれば */
@property (readonly) NSString *text;
/* テキストのHTML出力。あれば */
@property (readonly) NSString *htmlText;

/* JSONArrayからページリストを作る */
+ (NSArray*)pagesFromJSONArray:(NSArray*)JSONArray ofGyazz:(GYZGyazz*)gyazz;

/* コンストラクタ*/
- (id)initWithGyazz:(GYZGyazz*)gyazz title:(NSString*)title modtime:(NSInteger)modtime;

/* テキストを取得 */
- (void)getTextWithCompletion:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, id JSON))completion
                      failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON))failure;
/* 関連を取得 */
- (void)getRelatedPagesWithCompletion:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, id JSON))completion
                              failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON))failure;

@end
