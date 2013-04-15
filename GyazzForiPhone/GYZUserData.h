//
//  GYZUserData.h
//  GyazzForiPhone
//
//  Created by 桜井雄介 on 2013/03/13.
//  Copyright (c) 2013年 桜井雄介. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GYZGyazz,GYZPage;
@interface GYZUserData : NSObject

/* 登録中のGyazzListを保存 */
+ (void)saveGyazzList;
/* 登録中のGyazzListを読み込み */
+ (NSMutableArray*)gyazzList;
/* 現在表示中のGyazzを設定 */
+ (void)setCurrentGyazz:(GYZGyazz*)gyazz;
/* 現在表示中のGyazz */
+ (GYZGyazz*)currentGyazz;
/* チェックリスト */
+ (NSMutableArray*)watchList;
/* チェックリストを保存 */
+ (void)saveWatchList;

@end
