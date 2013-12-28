//
//  GYZImageTest.m
//  GyazzForiPhone
//
//  Created by 桜井雄介 on 2013/12/28.
//  Copyright (c) 2013年 Masui Lab. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "GYZImage.h"

static NSString *imageurl1 = @"https://31.media.tumblr.com/eda632bd8b3c7c345d67d27a0281fa1d/tumblr_mxhl6pwj2T1qz8gslo1_500.jpg";
static NSString *imageurl2 = @"https://24.media.tumblr.com/ff1c95750b807dcf9a40646873e9b53e/tumblr_myd7cwlUa71qcpdzho1_500.png";

@interface GYZImageTest : XCTestCase

@property BOOL finished;

@end

@implementation GYZImageTest

- (void)setUp
{
    self.finished = NO;
    // キャッシュを全部削除
    __block BOOL removed = NO;
    [[GYZImage sharedInstance] removeAllImageArchivesWithCompletion:^(NSError *e) {
        XCTAssertNil(e, );
        removed = YES;
    }];
    do {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:.1]];
    } while (!removed);
    
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
    // 非同期テストのセットアップ
    double delayInSeconds = 10;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        XCTFail(@"timed out.");
        self.finished = YES;
    });
    
    do {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:.1]];
    } while (!self.finished);
    [super tearDown];
}

- (void)testSharedInstance
{
    XCTAssert([GYZImage sharedInstance], @"ちゃんとshared instanceがある");
}

- (void)testPath
{
    NSString *archivePath = [[GYZImage sharedInstance] archiveDirectoryPath];
    XCTAssert(archivePath, );
    NSString *cachesPath = [[GYZImage sharedInstance] imageCachesPath];
    XCTAssert(cachesPath, );
    NSString *pathForImage1 = [[GYZImage sharedInstance] pathForImageURL:[NSURL URLWithString:imageurl1]];
    NSString *pathForImage2 = [[GYZImage sharedInstance] pathForImageURL:[NSURL URLWithString:imageurl2]];
    XCTAssertNotEqual(pathForImage1, pathForImage2, );
    XCTAssert([pathForImage1 isEqualToString:[[GYZImage sharedInstance] pathForImageURL:[NSURL URLWithString:imageurl1]]], );
    XCTAssert([pathForImage2 isEqualToString:[[GYZImage sharedInstance] pathForImageURL:[NSURL URLWithString:imageurl2]]], );
}

- (void)testDownload
{
    NSURL *url = [NSURL URLWithString:imageurl1];
    [[GYZImage sharedInstance] downloadImageWithURL:url completion:^(AFHTTPRequestOperation *operation, UIImage *data, NSError *e) {
        XCTAssert(operation, @"operationある");
        XCTAssert(data, @"データある");
        XCTAssertNil(e, @"エラーない");
        NSString *path = [[GYZImage sharedInstance] pathForImageURL:url];
        NSFileManager *fm = [NSFileManager defaultManager];
        XCTAssert([fm fileExistsAtPath:path isDirectory:nil], @"ちゃんとキャッシュされてる");
        XCTAssert([[GYZImage sharedInstance] imageForURL:url], @"キャッシュから取得出来てる");
        [[GYZImage sharedInstance] removeImageForURL:url error:&e];
        XCTAssertNil(e, @"特定の画像を削除できている");
        XCTAssertNil([[GYZImage sharedInstance] imageForURL:url], @"キャッシュから消えている");
        self.finished = YES;
    }];
}

@end
