//
//  GYZLicenseViewController.m
//  GyazzForiPhone
//
//  Created by 桜井雄介 on 2013/04/16.
//  Copyright (c) 2013年 Masui Lab. All rights reserved.
//

#import "GYZLicenseViewController.h"

@interface GYZLicenseViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation GYZLicenseViewController

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
    NSString *path = [[NSBundle mainBundle] pathForResource:@"licence" ofType:@"html"];
    NSString *html = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    [self.webView loadHTMLString:html baseURL:nil];
    self.title = NSLocalizedString(@"著作権情報", );
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
