//
//  GYZBarButton.h
//  GyazzForiPhone
//
//  Created by 桜井雄介 on 2013/04/16.
//  Copyright (c) 2013年 Masui Lab. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    GYZBarButtonStyleNone = 0,
    GYZBarButtonStyleAdd,
    GYZBarButtonStyleEdit,
}GYZBarButtonStyle;

@interface GYZBarButton : UIButton

/* テキストボタンを取得 */
+ (GYZBarButton*)barButtonWithText:(NSString*)text;
/* アイコンボタンを取得 */
+ (GYZBarButton*)barButtonWithStyle:(GYZBarButtonStyle)style;

@end
