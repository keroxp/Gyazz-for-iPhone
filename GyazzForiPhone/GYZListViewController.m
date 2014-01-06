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
#import <SVProgressHUD.h>
#import "GYZGyazzListViewController.h"
#import "GYZNavigationTitleView.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "GYZImage.h"
#import <QuartzCore/QuartzCore.h>
#import "NSString+Hash.h"

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
    /* title */
    UIButton *_titleButton;
    /* */
}

@property () GYZGyazz *gyazz;
@property (nonatomic) NSMutableDictionary *operationsInProgress;

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
    _operationsInProgress = [NSMutableDictionary new];
    
    UIRefreshControl *rc = [[UIRefreshControl alloc] init];
    [rc addTarget:self action:@selector(refreshList:) forControlEvents:UIControlEventValueChanged];
    [self setRefreshControl:rc];
    _refreshControl = rc;
    [self setGyazz:[GYZUserData currentGyazz]];
    
    GYZNavigationTitleView *title = [[GYZNavigationTitleView alloc] initWithTitle:self.gyazz.name];
    __block __weak typeof (self) __self = self;
    [title addEventHandler:^(id sender) {
        [__self performSegueWithIdentifier:@"showGyazzList" sender:__self];
    } forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setTitleView:title];
    _titleButton = title;
    
#ifdef DEBUG
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction handler:^(id sender) {
       // キャッシュ全削除
        [[GYZImage sharedInstance] removeAllImageArchivesWithCompletion:^(NSError *e) {
            if (!e) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [UIAlertView showAlertViewWithTitle:@"clean finished" message:nil cancelButtonTitle:@"OK" otherButtonTitles:nil handler:NULL];
                });
            }else{
                TFLog(@"%@",e);
            }
        }];
    }];
    [self.navigationItem setRightBarButtonItem:item];
#endif
    
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
        [self refreshList:nil];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    GYZGyazz *gyazz = [GYZUserData currentGyazz];
    if (gyazz && gyazz != _gyazz) {
        [self setGyazz:gyazz];
    }
    [_titleButton setTitle:gyazz.name forState:UIControlStateNormal];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // なければ登録させる
    
//    [self.navigationItem setTitleView:nil];
//    for (UITabBarItem *item in self.tabBarController.tabBar.items) {
//        [item setFinishedSelectedImage:nil withFinishedUnselectedImage:nil];
//        [item setTitle:nil];
//    }
    
    if ([[GYZUserData gyazzList] count] == 0) {
        [self performSegueWithIdentifier:@"showGyazzList" sender:self];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshList:(UIRefreshControl *)sender
{
    if (!sender) {
        [self.refreshControl beginRefreshing];
    }else{
        [sender beginRefreshing];
    }
    UIEdgeInsets is = self.tableView.contentInset;
    [self.tableView setContentOffset:CGPointMake(0, -is.top) animated:YES];
    __block __weak typeof (self) __self = self;
    // 2013/12/28
    // jsonの特定の行に不正な文字列が存在すると全部がparse errorになるので一行ずつparseする
    [_gyazz getPageListWithWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *e = nil;
        NSArray *data = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:&e];
        NSArray *pages = [GYZPage pagesFromJSONArray:data ofGyazz:__self.gyazz];
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
        [__self.tableView reloadData];
        [__self stopRefreshing:sender];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"データの読み込みに失敗しました。ネットワークに接続されていないか、サーバーが応答を停止している可能性があります", )];
        [__self stopRefreshing:sender];
    }];
}

- (void)stopRefreshing:(UIRefreshControl*)sender
{
    if (sender) {
        // 手動での更新
        [sender endRefreshing];
        // オフセットの修正
        [self.tableView setContentOffset:CGPointMake(0, -64.0) animated:YES];
    }else{
        // 自動での更新
        [self.refreshControl endRefreshing];
    }
}

- (GYZPage*)pageForTableView:(UITableView*)tableView atIndexPath:(NSIndexPath*)indexPath
{
    GYZPage *p = nil;
    if (tableView == self.tableView) {
        p = _pageListDividedByModififedDate[indexPath.section][indexPath.row];
    }else if (tableView == self.searchDisplayController.searchResultsTableView){
        p = _filterdContents[indexPath.row];
    }
    return p;
}

- (UITableView*)activeTableView
{
    return (self.searchDisplayController.isActive) ? self.searchDisplayController.searchResultsTableView : self.tableView;
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
        NSUInteger c  = _filterdContents.count;
        return c;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    GYZPage *page = [self pageForTableView:tableView atIndexPath:indexPath];
    cell.textLabel.text = [page title];
    if (page.iconImageURL) {
        UIImage *i = [[GYZImage sharedInstance] imageForURL:page.iconImageURL];
        if (i){
            // キャッシュが存在すればそれを貼りつける
            cell.imageView.image = i;
        }else{
            // ドラッグ中でなければダウンロードを始める
            if (self.tableView.dragging == NO && self.tableView.decelerating == NO){
                [self startDownloadWithURL:page.iconImageURL forIndexPath:indexPath];
            }
            cell.imageView.image = [UIImage imageNamed:@"ph"];
        }
    }else{
        cell.imageView.image = [UIImage imageNamed:@"ph"];
    }
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
    GYZPage *page = [self pageForTableView:tableView atIndexPath:indexPath];
    GYZPageViewController *pvc = [GYZPageViewController pageViewControllerWithPage:page enableCheckButton:YES];
//    [pvc setHidesBottomBarWhenPushed:YES];
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

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self loadImagesForOnscreenRows];
    }
}

#pragma mark - Lazy Image Download

- (void)startDownloadWithURL:(NSURL *)URL forIndexPath:(NSIndexPath *)indexPath
{
    __block __weak typeof (self) __self = self;
    AFHTTPRequestOperation *op = [[GYZImage sharedInstance] downloadImageWithURL:URL completion:^(AFHTTPRequestOperation *operation, UIImage *image, NSError *e) {
        if (!e && image) {
            // アスペクト比を維持したままリサイズ
            CGFloat w = image.size.width;
            CGFloat h = image.size.height;
            CGRect r = CGRectZero;
            if (w >= h) {
                r = CGRectMake(0, 0, 88.0f*w/h, 88.0f);
            }else{
                r = CGRectMake(0, 0, 88.0f, 88.0f*h/w);
            }
            UIGraphicsBeginImageContext(r.size);
            [image drawInRect:r];
            UIImage* resizedImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            // 中心にcrop
            CGFloat wh = MIN(resizedImage.size.width, resizedImage.size.height);
            CGSize crop = CGSizeMake(wh,wh);
            CGFloat x = (resizedImage.size.width - crop.width) / 2.0f;
            CGFloat y = (resizedImage.size.height - crop.height) / 2.0f;
            CGRect cropped = CGRectMake(x, y, crop.width, crop.height);
            CGImageRef croppedRef = CGImageCreateWithImageInRect(resizedImage.CGImage, cropped);
            UIImage *croppedImage = [UIImage imageWithCGImage:croppedRef];
            CGImageRelease(croppedRef);
            // 進捗から削除
            [__self.operationsInProgress removeObjectForKey:indexPath];
            // 画像をアサイン
            if ([[__self.tableView indexPathsForVisibleRows] containsObject:indexPath]) {
                UITableViewCell *cell = [__self.tableView cellForRowAtIndexPath:indexPath];
                [cell.imageView setImage:croppedImage];
            }
            // キャッシュに登録
            [[GYZImage sharedInstance] archiveImage:croppedImage forURL:URL atomically:YES];
        }
    }];
    [self.operationsInProgress setObject:op forKey:indexPath];
}

- (void)loadImagesForOnscreenRows
{
    UITableView *tableView = [self activeTableView];
    NSArray *visiblePaths = [tableView indexPathsForVisibleRows];
    for (NSIndexPath *indexPath in visiblePaths){
        GYZPage *p = [self pageForTableView:tableView atIndexPath:indexPath];
        if (![[GYZImage sharedInstance] imageForURL:p.iconImageURL]){
            [self startDownloadWithURL:p.iconImageURL forIndexPath:indexPath];
        }
    }
}

@end
