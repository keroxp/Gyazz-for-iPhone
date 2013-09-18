//
//  GYZSectionHeaderView.m
//  GyazzForiPhone
//
//  Created by 桜井雄介 on 2013/04/15.
//  Copyright (c) 2013年 Masui Lab. All rights reserved.
//

#import "GYZSectionHeaderView.h"

@implementation GYZSectionHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithTitle:(NSString *)title constraintToSize:(CGSize)size
{
    if (self = [super initWithFrame:CGRectMake(0, 0, size.width, 22)]) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, size.width - 20, 22)];
        [label setText:title];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setFont:[UIFont boldSystemFontOfSize:14.0f]];
        [label setTextColor:[UIColor colorWithRed:(float)116/255 green:(float)116/255 blue:(float)116/255 alpha:1.0f]];
        [label setShadowOffset:CGSizeMake(0, 0.5f)];
        [label setShadowColor:[UIColor whiteColor]];
        [self addSubview:label];
//        UIImageView *iv = [[UIImageView alloc] initWithFrame:self.bounds];
//        [iv setImage:[UIImage imageNamed:@"sectionbg"]];
        [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"sectionbg7"]]];
//        [self insertSubview:iv belowSubview:label];
        _titleLabel = label;
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
