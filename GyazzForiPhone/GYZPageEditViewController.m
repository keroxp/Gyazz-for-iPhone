//
//  GYZPageEditViewController.m
//  GyazzForiPhone
//
//  Created by 桜井雄介 on 2013/04/14.
//  Copyright (c) 2013年 Masui Lab. All rights reserved.
//

#import "GYZPageEditViewController.h"

@interface GYZPageEditViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation GYZPageEditViewController

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
