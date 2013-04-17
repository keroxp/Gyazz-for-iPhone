//
//  GYZGyazzesViewController.m
//  GyazzForiPhone
//
//  Created by 桜井雄介 on 2013/03/13.
//  Copyright (c) 2013年 桜井雄介. All rights reserved.
//

#import "GYZGyazzListViewController.h"
#import "GYZUserData.h"
#import "GYZGyazz.h"
#import "GYZPage.h"
#import "NSMutableArray+ReArrage.h"
#import "GYZTabBarController.h"
#import "GYZPageViewController.h"

@interface GYZGyazzListViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;

@end

@implementation GYZGyazzListViewController

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    self.title = NSLocalizedString(@"Gyazzリスト", );
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self configureButton];
    
}

- (void)configureButton
{
    // gyazzが0なら消させない
    if ([[GYZUserData gyazzList] count] == 0) {
        [self.cancelButton setEnabled:NO];
    }else{
        [self.cancelButton setEnabled:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)handleCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch (section) {
        case 0:
            // 登録リスト
            return [[GYZUserData gyazzList] count];
        case 1:
            // 追加
            return 1;
        case 2:
            // Gyazzとは？ + 著作権情報 + フィードバック
            return 3;
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    static NSString *SettingCellIdentifier = @"AddCell";
    UITableViewCell *cell = nil;
    switch (indexPath.section) {
        case 0:{
            GYZGyazz *g = [[GYZUserData gyazzList] objectAtIndex:indexPath.row];
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            cell.textLabel.text = g.name;
            if (g == [GYZUserData currentGyazz]) {
                [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            }else{
                [cell setAccessoryType:UITableViewCellAccessoryNone];
            }
        }
            break;
        case 1:
            cell = [tableView dequeueReusableCellWithIdentifier:SettingCellIdentifier];
            cell.textLabel.text = NSLocalizedString(@"新しいGyazzを追加...", );
            break;
        case 2:
            switch (indexPath.row) {
                case 0:
                    cell = [tableView dequeueReusableCellWithIdentifier:@"AboutCell"];
                    cell.textLabel.text = NSLocalizedString(@"Gyazzとは？", );
                    break;
                case 1:
                    cell = [tableView dequeueReusableCellWithIdentifier:@"LicenceCell"];
                    cell.textLabel.text = NSLocalizedString(@"著作権情報", );
                    break;
                case 2:
                    cell = [tableView dequeueReusableCellWithIdentifier:@"FeedbackCell"];
                    cell.textLabel.text = NSLocalizedString(@"フィードバック", );
                    break;
                default:
                    break;
            }
        default:
            break;
    }
    
    // Configure the cell...
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0 && [[GYZUserData gyazzList] count] == 0) {
        return NSLocalizedString(@"登録してあるGyazzがありません。", );
    }
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if (section == 2) {
        // バージョン
        NSString *versionNum = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        NSString *buildNum = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
        NSString *text = [NSString stringWithFormat:@"%@ Build %@", versionNum, buildNum];
        return [NSString stringWithFormat:@"Gyazz for iPhone %@\n© Yusuke Sakurai & Keio University Masui Toshiyuki Laboratory All Rights Reserved.",text];
    }
    return [super tableView:tableView titleForFooterInSection:section];
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return (indexPath.section == 0) ? YES : NO;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [[GYZUserData gyazzList] removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self configureButton];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    [[GYZUserData gyazzList] moveObjectFromIndex:fromIndexPath.row toIndex:toIndexPath.row];
    [GYZUserData saveGyazzList];
}

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return (indexPath.section == 0) ? YES : NO;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        GYZGyazz *g = [[GYZUserData gyazzList] objectAtIndex:indexPath.row];
        [GYZUserData setCurrentGyazz:g];
        [self dismissViewControllerAnimated:YES completion:NULL];
    }else if(indexPath.section == 2){
        switch (indexPath.row) {
            case 0: {
                // アバウト
                GYZGyazz *gyazz = [[GYZGyazz alloc] initWithName:@"Gyazz"];
                GYZPage *page = [[GYZPage alloc] initWithGyazz:gyazz title:@"目次" modtime:0];
                GYZPageViewController *p = [GYZPageViewController pageViewControllerWithPage:page enableCheckButton:NO];
                [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbg"] forBarMetrics:UIBarMetricsDefault];
                [self.navigationController pushViewController:p animated:YES];
                break;
            }
            case 2:
                // メール
                if ([MFMailComposeViewController canSendMail]) {
                    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
                    [mc setSubject:NSLocalizedString(@"【Gyazz】フィードバック", )];
                    [mc setMailComposeDelegate:self];
                    [mc setToRecipients:@[@"kerokerokerop@gmail.com"]];
                    [self presentViewController:mc animated:YES completion:NULL];
                }
                break;
            default:
                break;
        }
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissViewControllerAnimated:YES completion:NULL];
}

@end
