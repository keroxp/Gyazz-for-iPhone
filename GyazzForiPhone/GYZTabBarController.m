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
    [self.tabBar setBackgroundImage:[UIImage imageNamed:@"tabbg_light"]];
    [self.tabBar setSelectionIndicatorImage:[UIImage imageNamed:@"tabselectionbg"]];

    UITabBarItem *list = [self.tabBar.items objectAtIndex:0];
    [list setFinishedSelectedImage:[UIImage imageNamed:@"listicon_selected"] withFinishedUnselectedImage:[UIImage imageNamed:@"listicon"]];
    UITabBarItem *check = [self.tabBar.items objectAtIndex:1];
    [check setFinishedSelectedImage:[UIImage imageNamed:@"checkicon_selected"] withFinishedUnselectedImage:[UIImage imageNamed:@"checkicon"]];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // なければ登録させる
    if ([[GYZUserData gyazzList] count] == 0) {
        [self performSegueWithIdentifier:@"showGyazzList" sender:self];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
