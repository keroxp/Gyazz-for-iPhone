//
//  GYZTabBarController.m
//  GyazzForiPhone
//
//  Created by 桜井雄介 on 2013/03/13.
//  Copyright (c) 2013年 桜井雄介. All rights reserved.
//

#import "GYZTabBarController.h"
#import "GYZUserData.h"
@interface GYZTabBarController ()

@end

@implementation GYZTabBarController

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
	// Do any additional setup after loading the view.    
    UITabBarItem *list = [self.tabBar.items objectAtIndex:0];
    UITabBarItem *check = [self.tabBar.items objectAtIndex:1];
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        [list setFinishedSelectedImage:[UIImage imageNamed:@"listicon_selected"] withFinishedUnselectedImage:[UIImage imageNamed:@"listicon"]];
        [check setFinishedSelectedImage:[UIImage imageNamed:@"checkicon_selected"] withFinishedUnselectedImage:[UIImage imageNamed:@"checkicon"]];
        if (self.view.bounds.size.width > 320) {
            [self.tabBar setBackgroundImage:[UIImage imageNamed:@"tabbgipad_light"]];
//        [self.tabBar setSelectionIndicatorImage:[UIImage imageNamed:@"tabselectionbgipad"]];
            
        }else{
            [self.tabBar setBackgroundImage:[UIImage imageNamed:@"tabbg_light"]];
            [self.tabBar setSelectionIndicatorImage:[UIImage imageNamed:@"tabselectionbg"]];
        }
    }else{
        [list setFinishedSelectedImage:[UIImage imageNamed:@"listicon7"] withFinishedUnselectedImage:[UIImage imageNamed:@"listicon7"]];
        [check setFinishedSelectedImage:[UIImage imageNamed:@"checkicon7"] withFinishedUnselectedImage:[UIImage imageNamed:@"checkicon7"]];
        for (UITabBarItem *i in self.tabBar.items) {
            [i setTitleTextAttributes:@{UITextAttributeTextColor: kiOS7MainColor} forState:UIControlStateSelected];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
