//
//  GyazzForiPhoneTests.m
//  GyazzForiPhoneTests
//
//  Created by 桜井雄介 on 2013/12/28.
//  Copyright (c) 2013年 Masui Lab. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "GYZPage.h"

@interface GyazzForiPhoneTests : XCTestCase

@end

@implementation GyazzForiPhoneTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"json"];
    NSString *jsonstr = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSArray *jsonarr = [NSJSONSerialization JSONObjectWithData:[jsonstr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    NSArray *pages = [GYZPage pagesFromJSONArray:jsonarr ofGyazz:nil];
    [pages enumerateObjectsUsingBlock:^(GYZPage *obj, NSUInteger idx, BOOL *stop) {
        XCTAssert(obj, );
        XCTAssert([obj isKindOfClass:[GYZPage class]], );
        XCTAssert([obj title], );
        XCTAssert([obj modifiedDate], );
//        XCTAssert([obj iconImageURL], );
    }];
    
}

@end
