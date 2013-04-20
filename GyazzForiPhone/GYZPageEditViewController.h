//
//  GYZPageEditViewController.h
//  GyazzForiPhone
//
//  Created by 桜井雄介 on 2013/04/14.
//  Copyright (c) 2013年 Masui Lab. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GYZPage;

@interface GYZPageEditViewController : UIViewController

+ (GYZPageEditViewController*)controllerWithPage:(GYZPage*)page;

@property (nonatomic) GYZPage *page;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@end
