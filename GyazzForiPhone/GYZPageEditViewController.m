//
//  GYZPageEditViewController.m
//  GyazzForiPhone
//
//  Created by 桜井雄介 on 2013/04/14.
//  Copyright (c) 2013年 Masui Lab. All rights reserved.
//

#import "GYZPageEditViewController.h"
#import "GYZPage.h"
#import <UDBarTrackballItem.h>

@interface GYZPageEditViewController ()
{
    /* キーボードの開閉通知のオブザーバ */
    NSNotificationCenter *_keyboardObserver;
    /* 編集中のテクスト */
    NSString *_pageText;
    /*  */
    UIToolbar *_inputAccessoryView;
}

- (UIToolbar*)inputAccessoryView;
- (void)keyboardWillShow:(NSNotification*)notification;
- (void)keyboardWillHide:(NSNotification*)notification;
- (void)keyboardWillChangeFrame:(NSNotification*)notification;

@end

@implementation GYZPageEditViewController

+ (GYZPageEditViewController *)controllerWithPage:(GYZPage *)page
{
    GYZPageEditViewController *pec = [[GYZPageEditViewController alloc] initWithNibName:@"GYZPageEditViewController" bundle:nil];
    [pec setPage:page];
    return pec;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (UIToolbar*)inputAccessoryView
{
    if (!_inputAccessoryView) {
        // ツールバー
        UIToolbar *tb = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        // スペース
        UIBarButtonItem *sp = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace handler:NULL];
        // トラックボール
        UDBarTrackballItem *track = [[UDBarTrackballItem alloc] initForTextView:self.textView];
        // UNDO
        UIBarButtonItem *undo = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemUndo handler:^(id sender) {
            [self.textView.undoManager undo];
        }];
        UIBarButtonItem *redo = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRedo handler:^(id sender) {
            [self.textView.undoManager redo];
        }];
        UIBarButtonItem *bold = [[UIBarButtonItem alloc] initWithTitle:@"B" style:UIBarButtonItemStyleBordered handler:^(id sender) {
            UITextRange *r = [self.textView selectedTextRange];
            if(!r.isEmpty){
                // からでなければ包む
                NSString *s = [self.textView textInRange:r];
                [self.textView insertText:[NSString stringWithFormat:@"[[[%@]]",s]];
            }else{
                // 空なら挿入
                [self.textView insertText:@"[[[]]"];
                [self.textView setSelectedRange:NSMakeRange(self.textView.selectedRange.location - 2, 0)];
            }
        }];
        
        UIBarButtonItem *link = [[UIBarButtonItem alloc] initWithTitle:@"<link/>" style:UIBarButtonItemStyleBordered handler:^(id sender) {
            UITextRange *r = [self.textView selectedTextRange];
            if(!r.isEmpty){
                // からでなければ包む
                NSString *s = [self.textView textInRange:r];
                [self.textView insertText:[NSString stringWithFormat:@"[[%@]]",s]];
            }else{
                // 空なら挿入
                [self.textView insertText:@"[[]]"];
                [self.textView setSelectedRange:NSMakeRange(self.textView.selectedRange.location - 2, 0)];
            }
        }];
        [tb setItems:@[undo,sp,redo,sp,track,sp,bold,link]];
        _inputAccessoryView = tb;
    }
    return _inputAccessoryView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];        
    [self.textView setInputAccessoryView:[self inputAccessoryView]];
    [self.page getTextWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        _pageText = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        self.page.text = _pageText;
        [self.textView setText:_pageText];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(error.localizedDescription, )];
    }];

    [self setTitle:[NSString stringWithFormat:@"%@を編集",self.page.title]];
}

- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // キーボードの開閉、フレームの変化を検知するオブザーバを登録
    if(_keyboardObserver == nil){
        _keyboardObserver = [NSNotificationCenter defaultCenter];
        [_keyboardObserver addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [_keyboardObserver addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        [_keyboardObserver addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.textView becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // オブザーバを解除
    if(_keyboardObserver != nil){        
        [_keyboardObserver removeObserver:self name:UIKeyboardWillShowNotification object:nil];
        [_keyboardObserver removeObserver:self name:UIKeyboardWillHideNotification object:nil];
        [_keyboardObserver removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
        _keyboardObserver = nil;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action

- (IBAction)cancelButtonDidTap:(id)sender {
    
    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"編集を中止しますか？", )];
    [as setDestructiveButtonWithTitle:NSLocalizedString(@"編集情報を破棄", ) handler:^{
        [self dismissViewControllerAnimated:YES completion:NULL];
    }];
    [as setCancelButtonWithTitle:NSLocalizedString(@"やめる", ) handler:NULL];
    [as setCancelButtonIndex:1];
    [as showInView:self.view];
}

- (IBAction)doneButtonDidTap:(id)sender {
    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"変更を保存しますか？", )];
    [as addButtonWithTitle:NSLocalizedString(@"保存する", ) handler:^{
        TFLog(@"保存");
        [self.page saveWithText:self.textView.text success:^(AFHTTPRequestOperation *operation, id responseObject) {
            TFLog(@"保存されました");
            [self dismissViewControllerAnimated:YES completion:NULL];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            TFLog(@"%@",error);
        }];
    }];
    [as setCancelButtonWithTitle:NSLocalizedString(@"やめる", ) handler:NULL];
    [as setCancelButtonIndex:1];
    [as showInView:self.view];
}

#pragma mark - Keyboard

//- (void)keyboardWillShow:(NSNotification *)notification
//{
//    NSLog(@"keybord will show");
//    // ユーザーインフォを取得
//    NSDictionary *userInfo = [notification userInfo];
//    
//    // キーボードとTextViewの重なり具合を算出
//    CGFloat overlap;
//    CGRect keyboardFrame;
//    CGRect textViewFrame;
//    keyboardFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    keyboardFrame = [_textView.superview convertRect:keyboardFrame fromView:nil];
//    textViewFrame = _textView.frame;
//    overlap = MAX(0.0, CGRectGetMaxY(textViewFrame) - CGRectGetMinY(keyboardFrame));
//    
//    // Calc textViewFrameEnd
//    CGRect textViewFrameEnd;
//    textViewFrameEnd = _textView.frame;
//    textViewFrameEnd.size.height -= overlap;
//    
//    // Animate frame of _textView
//    NSTimeInterval duration;
//    UIViewAnimationCurve animationCurve;
//    void (^animations)(void);
//    duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//    animationCurve = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
//    animations = ^(void) {
//        _textView.frame = textViewFrameEnd;
//    };
//    [UIView animateWithDuration:duration delay:0.0 options:(animationCurve << 16) animations:animations completion:nil];
//
//}
- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    CGRect keyboardFrame = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    self.bottomConstraint.constant = -keyboardFrame.size.height;
    
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    NSTimeInterval duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    self.bottomConstraint.constant = 0;
    
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
}


//- (void)keyboardWillHide:(NSNotification *)notification
//{
//    // _textView.frame.size.height : view自体の高さ
//    // _textView.contentSize.height: scrollView全体の高さ
//    // _textView.contentOffset     : スクロールしている位置（相対）
//    
//    NSLog(@"keyboard will hide");
//    // Get userInfo
//    NSDictionary *userInfo = [notification userInfo];
//    
//    // Record contentOffset
//    CGPoint contentOffset = _textView.contentOffset;
//    //    NSLog(@"text view height is %f",_textView.contentSize.height);
//    //    NSLog(@"Contents offset is %f",contentOffset.y);
//    
//    // Reset frame and insets keeping appearance
//    [_textView setContentInset:UIEdgeInsetsZero];
//    [_textView setScrollIndicatorInsets:UIEdgeInsetsZero];
//    [_textView setContentOffset:contentOffset];
//    
//    //    NSLog(@"reseted text fram height is %f",_textView.frame.size.height);
//    
//    // Animate contentOffset of _textView if needed
//    CGFloat contentOffsetDeltaY = _textView.contentSize.height - (contentOffset.y + _textView.frame.size.height);
//    
//    NSLog(@"Content offset delta Y is %f",contentOffsetDeltaY);
//    if (contentOffsetDeltaY < 0.0) {
//        // Animate contentOffset of _textView
//        NSTimeInterval duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//        UIViewAnimationCurve animationCurve = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
//        void (^animations)(void);
//        animations = ^(void) {
//            _textView.contentOffset = CGPointMake(contentOffset.x, contentOffset.y + contentOffsetDeltaY);
//        };
//        [UIView animateWithDuration:duration delay:0.0 options:(animationCurve << 16) animations:animations completion:nil];
//    }
//    [_textView setFrame:_textView.superview.bounds];
//    
//}

- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    TFLog(@"will change frame");
}

@end
