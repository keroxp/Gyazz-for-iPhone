//
//  GYZPage.m
//  GyazzForiPhone
//
//  Created by 桜井雄介 on 2013/03/13.
//  Copyright (c) 2013年 Ê°ú‰∫ïÈõÑ‰ªã. All rights reserved.
//

#import "GYZPage.h"

@implementation GYZPage

+ (NSArray *)pagesFromJSONArray:(NSArray *)JSONArray ofGyazz:(GYZGyazz *)gyazz
{
    NSMutableArray *ma = [NSMutableArray arrayWithCapacity:JSONArray.count];
    for (NSArray *page in JSONArray) {
        NSString *title = [page objectAtIndex:0];
        NSInteger unixdate = [[page objectAtIndex:1] integerValue];
        GYZPage *p = [[self alloc] initWithGyazz:gyazz title:title modtime:unixdate];
        [ma addObject:p];
    }
    return ma;
}

- (id)initWithGyazz:(GYZGyazz *)gyazz title:(NSString *)title modtime:(NSInteger)modtime
{
    if (self = [super init]) {
        _gyazz = gyazz;
        _title = title;
        _modifiedDate = [NSDate dateWithTimeIntervalSince1970:modtime];
    }
    return self;
}

- (void)getTextWithCompletion:(void (^)(NSURLRequest *, NSHTTPURLResponse *, id))completion failure:(void (^)(NSURLRequest *, NSHTTPURLResponse *, NSError *, id))failure
{
    
}

@end
