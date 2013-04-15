//
//  GYZWatcingViewController.m
//  GyazzForiPhone
//
//  Created by 桜井雄介 on 2013/03/13.
//  Copyright (c) 2013年 桜井雄介. All rights reserved.
//

#import "GYZWatchListViewController.h"
#import "GYZUserData.h"
#import "GYZPage.h"
#import "GYZPageViewController.h"
#import "NSMutableArray+ReArrage.h"
#import "GYZBarButton.h"

@interface GYZWatchListViewController ()

@end

@implementation GYZWatchListViewController

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
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = NSLocalizedString(@"チェックリスト", );
    GYZBarButton  *b = [[GYZBarButton alloc] initWithFrame:CGRectMake(0, 0, 66, 28)];
    __block GYZBarButton *__b = b;
    [b setTitle:NSLocalizedString(@"編集", ) forState:UIControlStateNormal];
    [b addEventHandler:^(id sender) {
        if (!self.isEditing){
            [__b setTitle:NSLocalizedString(@"完了", ) forState:UIControlStateNormal];
            [self setEditing:YES animated:YES];
        }else{
            [__b setTitle:NSLocalizedString(@"編集", ) forState:UIControlStateNormal];
            [self setEditing:NO animated:YES];
        }
    } forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:b]];
    
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
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
    return [[GYZUserData watchList] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    GYZPage *p = [[GYZUserData watchList] objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@/%@",p.gyazz.name,p.title];
    
    // Configure the cell...
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([[GYZUserData watchList] count] == 0) {
        return @"ページが登録されていません。";
    }
    return nil;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [[GYZUserData watchList] removeObjectAtIndex:indexPath.row];
        [GYZUserData saveWatchList];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}



// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    [[GYZUserData watchList] moveObjectFromIndex:fromIndexPath.row toIndex:toIndexPath.row];
    [GYZUserData saveWatchList];
}
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    GYZPage *page = [[GYZUserData watchList] objectAtIndex:indexPath.row];
    GYZPageViewController *pvc = [GYZPageViewController pageViewControllerWithPage:page enableCheckButton:YES];
    [pvc setHidesBottomBarWhenPushed:YES];
    // ...
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:pvc animated:YES];
}

@end
