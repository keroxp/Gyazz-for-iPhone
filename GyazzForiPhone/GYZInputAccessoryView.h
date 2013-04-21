//
//  GYZInputAccessoryView.h
//  GyazzForiPhone
//
//  Created by 桜井雄介 on 2013/04/21.
//  Copyright (c) 2013年 Masui Lab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYZInputAccessoryView : UIToolbar

@property (weak,readonly) UITextView *textView;

- (id)initWithTextView:(UITextView*)textView;

@end
