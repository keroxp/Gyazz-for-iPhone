//
//  GYZNavigationStackViewController.h
//  GyazzForiPhone
//
//  Created by 桜井雄介 on 2013/04/15.
//  Copyright (c) 2013年 Masui Lab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYZNavigationStackViewController : UITableViewController

@property (weak) UINavigationController *controller;

- (id)initWithStyle:(UITableViewStyle)style navigationController:(UINavigationController*)controller;

@end
