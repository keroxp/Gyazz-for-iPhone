//
//  GYZToolbar.m
//  GyazzForiPhone
//
//  Created by 桜井雄介 on 2013/04/21.
//  Copyright (c) 2013年 Masui Lab. All rights reserved.
//

#import "GYZToolbar.h"

@implementation GYZToolbar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self setBackgroundImage:[UIImage imageNamed:@"navbg7"] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    }else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        [self setBackgroundImage:[UIImage imageNamed:@"toolbgipad"] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    }
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self commonInit];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
