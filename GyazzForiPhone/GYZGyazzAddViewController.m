//
//  GYZGyazzEditViewController.m
//  GyazzForiPhone
//
//  Created by 桜井雄介 on 2013/03/13.
//  Copyright (c) 2013年 桜井雄介. All rights reserved.
//

#import "GYZGyazzAddViewController.h"
#import "GYZTextFieldCell.h"
#import <BlocksKit.h>
#import "GYZGyazz.h"
#import "GYZUserData.h"

@interface GYZGyazzAddViewController ()

- (IBAction)handleDone:(id)sender;
- (IBAction)handleCancel:(id)sender;

@end

@implementation GYZGyazzAddViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Gyazzを追加", );
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return NSLocalizedString(@"\"http://gyazz.com/\" に続くGyazzの名前を入力してください。", );
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TextCell";
    GYZTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[GYZTextFieldCell alloc] initWithReuseIdentifier:CellIdentifier];
        [cell.textField setPlaceholder:NSLocalizedString(@"例：UIPedia, レストラン",)];
        [cell.textField setDelegate:self];
    }
    
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[(GYZTextFieldCell*)cell textField] becomeFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self handleDone:nil];
    return YES;
}


- (IBAction)handleDone:(id)sender {
    GYZTextFieldCell *tcell = (GYZTextFieldCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if (tcell.textField.text.length == 0) {
        [UIAlertView showAlertViewWithTitle:NSLocalizedString(@"Gyazzの名前は最低でも一文字以上必要です", ) message:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil handler:NULL];
        return;
    }
    GYZGyazz *newGyazz = [[GYZGyazz alloc] initWithName:tcell.textField.text];
    __block GYZGyazz *__newGyazz = newGyazz;
    __block __weak typeof (self) __self = self;
    [newGyazz getPageListWithWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *jsonstr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        $(@"%@",jsonstr);
        if (!jsonstr || jsonstr.length < 10) {
            // 無い
            NSString *title = NSLocalizedString(@"Gyazzが見つかりませんでした", );
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:title message:nil];
            [av setCancelButtonWithTitle:@"OK" handler:NULL];
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [av show];
            }];
        }else{
            // 登録完了
            [[GYZUserData gyazzList] addObject:__newGyazz];
            [GYZUserData saveGyazzList];
            [GYZUserData setCurrentGyazz:__newGyazz];
            [__self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSString *title = NSLocalizedString(@"エラー", );
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:title message:error.localizedDescription];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [av show];
        }];
    }];
}

- (IBAction)handleCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}
@end
