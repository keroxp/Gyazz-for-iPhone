//
//  GYZBarButton.m
//  GyazzForiPhone
//
//  Created by 桜井雄介 on 2013/04/16.
//  Copyright (c) 2013年 Masui Lab. All rights reserved.
//

#import "GYZBarButton.h"
#import <QuartzCore/QuartzCore.h>

#define kTextButtonFrame CGRectMake(0, 0, 66, 28)
#define kDefaultFrame CGRectMake(0,0,32,32)

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
    // 文字ボタンなら枠を追加
    if ([self titleForState:UIControlStateNormal]) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGPathRef path = CGPathCreateWithRect(rect, NULL);
        [[UIColor clearColor] setFill];
        [[UIColor whiteColor] setStroke];
        CGContextSetLineWidth(context, 3);
        CGContextAddPath(context, path);
        CGContextDrawPath(context, kCGPathFillStroke);
        CGPathRelease(path);
        
    }
}

+ (GYZBarButton *)barButtonWithText:(NSString *)text
{
    GYZBarButton *b = [[GYZBarButton alloc] initWithFrame:kTextButtonFrame];
    [b setTitle:text forState:UIControlStateNormal];
    return b;
}

+ (GYZBarButton *)barButtonWithStyle:(GYZBarButtonStyle)style
{
    GYZBarButton *b = [[GYZBarButton alloc] initWithFrame:kDefaultFrame];
    switch (style) {
        case GYZBarButtonStyleNone:
            break;
        case GYZBarButtonStyleAdd:
            break;
        case GYZBarButtonStyleEdit:
            [b setImage:[UIImage imageNamed:@"editicon"] forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
    return b;
}
@end
