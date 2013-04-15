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
	// Do any additional setup after loading the view.
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbg"] forBarMetrics:UIBarMetricsDefault];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
