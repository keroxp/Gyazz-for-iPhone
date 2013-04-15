//
//  GYZBarButton.m
//  GyazzForiPhone
//
//  Created by 桜井雄介 on 2013/04/16.
//  Copyright (c) 2013年 Masui Lab. All rights reserved.
//

#import "GYZBarButton.h"
#import <QuartzCore/QuartzCore.h>

@implementation GYZBarButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
        [self.titleLabel setShadowColor:[UIColor blackColor]];
        [self.titleLabel setShadowOffset:CGSizeMake(0, 0.5)];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGPathRef path = CGPathCreateWithRect(rect, NULL);
    [[UIColor clearColor] setFill];
    [[UIColor whiteColor] setStroke];
    CGContextSetLineWidth(context, 3);
    CGContextAddPath(context, path);
    CGContextDrawPath(context, kCGPathFillStroke);
    CGPathRelease(path);
}


@end
