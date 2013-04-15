//
//  GYZListViewController.m
//  GyazzForiPhone
//
//  Created by 桜井雄介 on 2013/03/13.
//  Copyright (c) 2013年 桜井雄介. All rights reserved.
//

#import "GYZListViewController.h"
#import "GYZPageViewController.h"
#import "GYZPage.h"
#import "GYZUserData.h"
#import <JSONKit.h>
#import <SVProgressHUD.h>
#import "GYZGyazzListViewController.h"
#import "GYZNavigationTitleView.h"


@interface GYZListViewController ()
{
    /* ページリスト。 */
    NSArray *_pageList;
    /* 日付順でソートされたリスト */
    NSArray *_pageListDividedByModififedDate;
    /* 日付 */
    NSArray *_sectionNames;
    /* りふれっしゅ */
    UIRefreshControl *_refreshControl;
    /* フィルタ */
    NSMutableArray *_filterdContents;
    /* Popover */
    FPPopoverController *_popover;
    /* title */
    UIButton *_titleButton;
}

@property () GYZGyazz *gyazz;

- (void)refreshList:(UIRefreshControl*)sender;

@end

@implementation GYZListViewController

@synthesize gyazz = _gyazz;

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
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    _filterdContents = [NSMutableArray array];
    _sectionNames = @[@"5分以内",@"15分以内",@"30分以内",@"1時間以内",@"2時間以内",@"6時間以内",@"12時間以内",@"1日以内",@"3日以内",@"4日以前"];
    UIRefreshControl *rc = [[UIRefreshControl alloc] init];
    [rc addTarget:self action:@selector(refreshList:) forControlEvents:UIControlEventValueChanged];
    [self setRefreshControl:rc];
    _refreshControl = rc;
    [self setGyazz:[GYZUserData currentGyazz]];
    
    GYZNavigationTitleView *title = [[GYZNavigationTitleView alloc] initWithTitle:self.gyazz.name];
    [title addEventHandler:^(id sender) {
        [self performSegueWithIdentifier:@"showGyazzList" sender:self];
    } forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setTitleView:title];
    _titleButton = title;
    
}

- (GYZGyazz *)gyazz
{
    return _gyazz;
}

- (void)setGyazz:(GYZGyazz *)gyazz
{
    if (gyazz != _gyazz) {
        // リセット
        _gyazz = gyazz;
        _pageList = nil;
        _pageListDividedByModififedDate = nil;
        [self.tableView reloadData];
        [_refreshControl beginRefreshing];
        [self refreshList:_refreshControl];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    GYZGyazz *gyazz = [GYZUserData currentGyazz];
    if (gyazz && gyazz != _gyazz) {
        [self setGyazz:gyazz];
    }
    self.navigationItem.title = self.gyazz.name;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshList:(UIRefreshControl *)sender
{
    [SVProgressHUD showWithStatus:NSLocalizedString(@"読込中...", )];
    [_gyazz getPageListWithWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        [sender endRefreshing];
        NSString *jsonstr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSError *e = nil;
        id jsonobj = [jsonstr objectFromJSONStringWithParseOptions:JKParseOptionNone error:&e];
        NSArray *pages = [GYZPage pagesFromJSONArray:jsonobj ofGyazz:_gyazz];
        NSMutableArray *ma = [NSMutableArray arrayWithCapacity:10];
        NSDate *now = [NSDate date];
        for (int i = 0 ; i < 10; i++) {
            [ma addObject:[NSMutableArray array]];
        }
        for (GYZPage *page in pages) {
            NSTimeInterval ti = [now timeIntervalSinceDate:page.modifiedDate];
            int dd = (int)ti/(60*60*24);
            int hh = (int)(ti - dd*(60*60*24))/(60*60);
            int mm = (int)(ti - dd*(60*60*24) - hh*(60*60)) / 60;
            if (dd == 0 && hh == 0 && mm <= 5) {
                [[ma objectAtIndex:0] addObject:page];
            }else if (dd == 0 && hh == 0 && mm <= 15){
                [[ma objectAtIndex:1] addObject:page];
            }else if (dd == 0 && hh == 0 && mm <= 30){
                [[ma objectAtIndex:2] addObject:page];
            }else if (dd == 0 && hh <= 1){
                [[ma objectAtIndex:3] addObject:page];
            }else if (dd == 0 && hh <= 2){
                [[ma objectAtIndex:4] addObject:page];
            }else if (dd == 0 && hh <= 6){
                [[ma objectAtIndex:5] addObject:page];
            }else if (dd == 0 && hh <= 12){
                [[ma objectAtIndex:6] addObject:page];
            }else if (dd <= 1){
                [[ma objectAtIndex:7] addObject:page];
            }else if (dd <= 3){
                [[ma objectAtIndex:8] addObject:page];
            }else{
                [[ma objectAtIndex:9] addObject:page];
            }
        }
        _pageList = pages;
        _pageListDividedByModififedDate = ma;
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [sender endRefreshing];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // ソートされていない場合はここで
    if (tableView == self.tableView) {
        return _sectionNames.count;
    }else{
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (tableView == self.tableView) {
        if (_pageListDividedByModififedDate) {
            int cnt = [[_pageListDividedByModififedDate objectAtIndex:section] count];
            return cnt;
        }
        return 0;
    }else{
        return _filterdContents.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    GYZPage *page = nil;
    if (tableView == self.tableView) {
        page = [[_pageListDividedByModififedDate objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    }else{
        page = [_filterdContents objectAtIndex:indexPath.row];
    }

    cell.textLabel.text = [page title];
    
    // Configure the cell...
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    int cnt = [[_pageListDividedByModififedDate objectAtIndex:section] count];
    if (cnt > 0) {
        return [_sectionNames objectAtIndex:section];
    }
    return nil;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    GYZPage *page = nil;
    if (tableView == self.tableView) {
        page = [[_pageListDividedByModififedDate objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    }else{
        page = [_filterdContents objectAtIndex:indexPath.row];
    }

    GYZPageViewController *pvc = [[GYZPageViewController alloc] initWithNibName:@"GYZPageViewController" bundle:nil];
    [pvc setPage:page];
    [pvc setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:pvc animated:YES];
}

#pragma mark - UISearchDisplayDelegate

- (void)filterContentForSearchText:(NSString*)searchText
{
    [_filterdContents removeAllObjects]; // First clear the filtered array.    
    for (GYZPage *page in _pageList){
        NSComparisonResult result = [page.title compare:searchText
                                                options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch)
                                                  range:NSMakeRange(0, [searchText length])];
        if (result == NSOrderedSame){
            [_filterdContents addObject:page];
        }
    }
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    if (searchString.length > 0) {
        [self filterContentForSearchText:searchString];
        return YES;
    }
    return NO;
}

@end
