//
//  GYZNavigationController.m
//  GyazzForiPhone
//
//  Created by 桜井雄介 on 2013/04/15.
//  Copyright (c) 2013年 Masui Lab. All rights reserved.
//

#import "GYZNavigationController.h"

@interface GYZNavigationController ()

@end

@implementation GYZNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        // iOS6
        if (self.view.bounds.size.width > 320) {
            [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbgipad"] forBarMetrics:UIBarMetricsDefault];
        }else{
            [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbg"] forBarMetrics:UIBarMetricsDefault];
        }
    }else if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")){
        [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbg7"] forBarMetrics:UIBarMetricsDefault];
        
    }
    NSDictionary *attrs = @{
                            UITextAttributeTextColor: [UIColor whiteColor],
                            UITextAttributeTextShadowColor: [UIColor darkGrayColor]
                            };
    [self.navigationBar setTitleTextAttributes:attrs];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
