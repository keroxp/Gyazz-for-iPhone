//
//  GYZUserData.h
//  GyazzForiPhone
//
//  Created by 桜井雄介 on 2013/03/13.
//  Copyright (c) 2013年 桜井雄介. All rights reserved.
//

#import <Foundation/Foundation.h>

/* 通知用のキー */
extern NSString *const GYZUserDataDidChangeNotification;

@class GYZGyazz,GYZPage;
@interface GYZUserData : NSObject

// リモート通知をAppDelegateから受け取るメソッド
+ (void)iCloudStoreDidChange:(NSNotification*)notification;
/* 現在表示中のGyazz */
+ (GYZGyazz*)currentGyazz;
/* 現在表示中のGyazzを設定 */
+ (void)setCurrentGyazz:(GYZGyazz*)gyazz;
/* 登録中のGyazzListを読み込み */
+ (NSMutableArray*)gyazzList;
/* 登録中のGyazzListを保存 */
+ (void)saveGyazzList;
/* チェックリスト */
+ (NSMutableArray*)watchList;
/* チェックリストを保存 */
+ (void)saveWatchList;

@end
