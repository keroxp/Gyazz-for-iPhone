//
//  GYZPageEditViewController.m
//  GyazzForiPhone
//
//  Created by 桜井雄介 on 2013/04/14.
//  Copyright (c) 2013年 Masui Lab. All rights reserved.
//

#import "GYZPageEditViewController.h"
#import "GYZPageViewController.h"
#import "GYZPage.h"
#import "GYZInputAccessoryView.h"
#import <UDBarTrackballItem.h>

@interface GYZPageEditViewController ()
{
    /* キーボードの開閉通知のオブザーバ */
    NSNotificationCenter *_keyboardObserver;
    /* 編集中のテクスト */
    NSString *_pageText;
    /*  */
    UIToolbar *_inputAccessoryView;
    /*  */
    UISwipeGestureRecognizer *_leftSwypeHander;
    /*  */
    UISwipeGestureRecognizer *_rightSwypeHandler;
}

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;


- (void)handleSwype:(UISwipeGestureRecognizer*)sender;
- (UIToolbar*)inputAccessoryView;
- (void)setButtonsEnabled:(BOOL)enabled;
- (void)keyboardWillShow:(NSNotification*)notification;
- (void)keyboardWillHide:(NSNotification*)notification;
- (void)keyboardWillChangeFrame:(NSNotification*)notification;

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

//- (UIToolbar*)inputAccessoryView
//{
//    if (!_inputAccessoryView) {
//        // ツールバー
//        UIToolbar *tb = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
//        [tb setBackgroundColor:[UIColor whiteColor]];
//        // スペース
//        UIBarButtonItem *sp = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace handler:NULL];
//        // トラックボール
//        UDBarTrackballItem *track = [[UDBarTrackballItem alloc] initForTextView:self.textView];
//        // UNDO
//        UIButton *undo = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 38)];
//
//        UIBarButtonItem *undo = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemUndo handler:^(id sender) {
//            [self.textView.undoManager undo];
//        }];
//        [undo setStyle:UIBarButtonItemStylePlain];
//        UIBarButtonItem *redo = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRedo handler:^(id sender) {
//            [self.textView.undoManager redo];
//        }];
//        [redo setStyle:UIBarButtonItemStylePlain];
//        UIBarButtonItem *bold = [[UIBarButtonItem alloc] initWithTitle:@"B" style:UIBarButtonItemStyleBordered handler:^(id sender) {
//            UITextRange *r = [self.textView selectedTextRange];
//            if(!r.isEmpty){
//                // からでなければ包む
//                NSString *s = [self.textView textInRange:r];
//                [self.textView insertText:[NSString stringWithFormat:@"[[[%@]]",s]];
//            }else{
//                // 空なら挿入
//                [self.textView insertText:@"[[[]]"];
//                [self.textView setSelectedRange:NSMakeRange(self.textView.selectedRange.location - 2, 0)];
//            }
//        }];
//        [bold setStyle:UIBarButtonItemStylePlain];
//        
//        UIBarButtonItem *link = [[UIBarButtonItem alloc] initWithTitle:@"<link/>" style:UIBarButtonItemStyleBordered handler:^(id sender) {
//            UITextRange *r = [self.textView selectedTextRange];
//            if(!r.isEmpty){
//                // からでなければ包む
//                NSString *s = [self.textView textInRange:r];
//                [self.textView insertText:[NSString stringWithFormat:@"[[%@]]",s]];
//            }else{
//                // 空なら挿入
//                [self.textView insertText:@"[[]]"];
//                [self.textView setSelectedRange:NSMakeRange(self.textView.selectedRange.location - 2, 0)];
//            }
//        }];
//        [link setStyle:UIBarButtonItemStylePlain];
//        [tb setItems:@[undo,sp,redo,sp,track,sp,bold,link]];
//        _inputAccessoryView = tb;
//    }
//    return _inputAccessoryView;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _inputAccessoryView = [[GYZInputAccessoryView alloc] initWithTextView:self.textView];
    [self.textView setInputAccessoryView:_inputAccessoryView];

    _leftSwypeHander = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwype:)];
    
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

- (void)setButtonsEnabled:(BOOL)enabled
{
    [self.navigationItem.rightBarButtonItem setEnabled:enabled];
    [self.navigationItem.leftBarButtonItem setEnabled:enabled];
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

- (void)handleSwype:(UISwipeGestureRecognizer *)sender
{
    NSRange r = [self.textView selectedRange];
    NSInteger i = r.location;
    char c = [self.textView.text characterAtIndex:i];
    while (c != '\n') {
        i--;
        c = [self.textView.text characterAtIndex:i];
    } 
    NSRange nr = NSMakeRange(i, 0);

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
        [self setButtonsEnabled:NO];
        [self.page saveWithText:self.textView.text success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self setButtonsEnabled:YES];;
            [self dismissViewControllerAnimated:YES completion:NULL];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self setButtonsEnabled:YES];
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            TFLog(@"%@",error);
        }];
    }];
    [as setCancelButtonWithTitle:NSLocalizedString(@"やめる", ) handler:NULL];
    [as setCancelButtonIndex:1];
    [as showInView:self.view];
}

#pragma mark - Keyboard

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

- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    TFLog(@"will change frame");
}

@end
