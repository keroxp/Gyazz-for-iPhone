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
#import "NSMutableArray+ReArrage.h"
#import "GYZTabBarController.h"

@interface GYZGyazzListViewController ()

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
    
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch (section) {
        case 0:
            // 登録リスト
            return [[GYZUserData gyazzList] count];
        case 1:
            // 設定
            return 1;
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    static NSString *SettingCellIdentifier = @"SettingCell";
    UITableViewCell *cell = nil;
    switch (indexPath.section) {
        case 0:{
            GYZGyazz *g = [[GYZUserData gyazzList] objectAtIndex:indexPath.row];
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            cell.textLabel.text = g.name;
            if (g == [GYZUserData currentGyazz]) {
                [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            }
        }
            break;
        case 1:
            cell = [tableView dequeueReusableCellWithIdentifier:SettingCellIdentifier];
            cell.textLabel.text = NSLocalizedString(@"設定", );
            break;
        default:
            break;
    }
    
    // Configure the cell...
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if (section == 0 && [[GYZUserData gyazzList] count] == 0) {
        return NSLocalizedString(@"登録してあるGyazzがありません。左上の追加ボタンからGyazzを追加しましょう。", );
    }
    return nil;
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
    }
}

@end
