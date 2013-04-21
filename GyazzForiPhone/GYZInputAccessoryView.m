//
//  GYZInputAccessoryView.m
//  GyazzForiPhone
//
//  Created by 桜井雄介 on 2013/04/21.
//  Copyright (c) 2013年 Masui Lab. All rights reserved.
//

#import "GYZInputAccessoryView.h"
#import <UDBarTrackballItem.h>

@implementation GYZInputAccessoryView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithTextView:(UITextView *)textView
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        self = [super initWithFrame:CGRectMake(0, 0, 320, 44)];
    }else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        self = [super initWithFrame:CGRectMake(0, 0, 768, 44)];
    }
    if (self) {
        // 背景
        [self setBackgroundImage:[UIImage imageNamed:@"whitebg"] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
        // スペース
        UIBarButtonItem *sp = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace handler:NULL];
        // トラックボール
        UDBarTrackballItem *track = [[UDBarTrackballItem alloc] initForTextView:textView];
        // undo
        CGRect f = CGRectMake(0, 0, 40, 38);
        UIButton *undo = [[UIButton alloc] initWithFrame:f];
        [undo setImage:[UIImage imageNamed:@"inputundoicon"] forState:UIControlStateNormal];
        [undo addEventHandler:^(id sender) {
            [textView.undoManager undo];
        } forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *undoitem = [[UIBarButtonItem alloc] initWithCustomView:undo];
        // redo
        UIButton *redo = [[UIButton alloc] initWithFrame:f];
        [redo setImage:[UIImage imageNamed:@"inputredoicon"] forState:UIControlStateNormal];
        [redo addEventHandler:^(id sender) {
            [textView.undoManager redo];
        } forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *redoitem = [[UIBarButtonItem alloc] initWithCustomView:redo];
        // bold
        UIButton *bold = [[UIButton alloc] initWithFrame:f];
        [bold setImage:[UIImage imageNamed:@"inputboldicon"] forState:UIControlStateNormal];
        [bold addEventHandler:^(id sender) {
            UITextRange *r = [textView selectedTextRange];
            if(!r.isEmpty){
                // からでなければ包む
                NSString *s = [textView textInRange:r];
                [textView insertText:[NSString stringWithFormat:@"[[[%@]]",s]];
            }else{
                // 空なら挿入
                [textView insertText:@"[[[]]"];
                [textView setSelectedRange:NSMakeRange(textView.selectedRange.location - 2, 0)];
            }
        } forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *bolditem = [[UIBarButtonItem alloc] initWithCustomView:bold];
        // link
        UIButton *link = [[UIButton alloc] initWithFrame:f];
        [link setImage:[UIImage imageNamed:@"inputlinkicon"] forState:UIControlStateNormal];
        [link addEventHandler:^(id sender) {
            UITextRange *r = [textView selectedTextRange];
            if(!r.isEmpty){
                // からでなければ包む
                NSString *s = [textView textInRange:r];
                [textView insertText:[NSString stringWithFormat:@"[[%@]]",s]];
            }else{
                // 空なら挿入
                [textView insertText:@"[[]]"];
                [textView setSelectedRange:NSMakeRange(textView.selectedRange.location - 2, 0)];
            }
        } forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *linkitem = [[UIBarButtonItem alloc] initWithCustomView:link];
        [self setItems:@[undoitem,sp,redoitem,sp,track,sp,bolditem,sp,linkitem]];
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
