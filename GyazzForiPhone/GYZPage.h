//
//  GYZPage.h
//  GyazzForiPhone
//
//  Created by 桜井雄介 on 2013/03/13.
//  Copyright (c) 2013年 桜井雄介. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GYZGyazz.h"

@class GYZGyazz;

@interface GYZPage : NSObject <NSCoding>

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
/* URL */
@property (readonly) NSString *absoluteString;

/* JSONArrayからページリストを作る */
+ (NSArray*)pagesFromJSONArray:(NSArray*)JSONArray ofGyazz:(GYZGyazz*)gyazz;

/* コンストラクタ*/
- (id)initWithGyazz:(GYZGyazz*)gyazz title:(NSString*)title modtime:(NSInteger)modtime;


@end
