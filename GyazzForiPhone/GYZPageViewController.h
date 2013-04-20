//
//  GYZPageViewController.h
//  GyazzForiPhone
//
//  Created by 桜井雄介 on 2013/03/13.
//  Copyright (c) 2013年 桜井雄介. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SVWebViewController.h>

@class GYZPage;

@interface GYZPageViewController : UIViewController
<UIWebViewDelegate,NSURLConnectionDelegate>

/*  */
+ (GYZPageViewController*)pageViewControllerWithPage:(GYZPage*)page enableCheckButton:(BOOL)checkButton;

/* WevView */
@property (weak, nonatomic) IBOutlet UIWebView *webView;
/* Chcek Button */
@property (assign, getter = isCheckButtonEnabled) BOOL checkButtonEnabled;
/* 表示するページ */
@property () GYZPage *page;
/* 再読み込み */
- (void)refresh:(UIRefreshControl*)sender;

@end
