//
//  GYZPageViewController.h
//  GyazzForiPhone
//
//  Created by 桜井雄介 on 2013/03/13.
//  Copyright (c) 2013年 桜井雄介. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GYZPage;

@interface GYZPageViewController : UIViewController
<UIWebViewDelegate,NSURLConnectionDelegate>

/* WevView */
@property (weak, nonatomic) IBOutlet UIWebView *webView;
/* 表示するページ */
@property () GYZPage *page;

@end
