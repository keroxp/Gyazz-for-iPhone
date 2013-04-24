//
//  GYZNavigationTitleView.m
//  GyazzForiPhone
//
//  Created by 桜井雄介 on 2013/04/15.
//  Copyright (c) 2013年 Masui Lab. All rights reserved.
//

#import "GYZNavigationTitleView.h"

@implementation GYZNavigationTitleView

- (id)initWithTitle:(NSString *)title
{
    if (self = [super initWithFrame:CGRectMake(0, 0, 218, 44)]) {
        [self.titleLabel setFont:[UIFont boldSystemFontOfSize:18.0f]];
        [self.titleLabel setShadowColor:[UIColor blackColor]];
        [self.titleLabel setShadowOffset:CGSizeMake(0, 0.5)];
        [self setTitle:title forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"titlebg"] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"titlebg_selected"] forState:UIControlStateHighlighted];
    }
    return self;
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
