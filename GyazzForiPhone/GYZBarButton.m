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

+ (GYZBarButton *)textButtonForText:(NSString*)text
{
    GYZBarButton *b = [[GYZBarButton alloc] initWithFrame:kTextButtonFrame];
    [b setTitle:NSLocalizedString(@"編集", ) forState:UIControlStateNormal];
    return b;
}

+ (GYZBarButton *)editButtonForController:(UIViewController *)controller
{
    GYZBarButton *b = [self textButtonForText:NSLocalizedString(@"編集", )];
    __block GYZBarButton *__b = b;
    [b addEventHandler:^(id sender) {
        if (!controller.isEditing){
            [__b setTitle:NSLocalizedString(@"完了", ) forState:UIControlStateNormal];
            [controller setEditing:YES animated:YES];
        }else{
            [__b setTitle:NSLocalizedString(@"編集", ) forState:UIControlStateNormal];
            [controller setEditing:NO animated:YES];
        }
    } forControlEvents:UIControlEventTouchUpInside];
    return b;
}


@end
