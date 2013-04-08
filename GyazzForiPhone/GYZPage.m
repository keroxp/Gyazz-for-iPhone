//
//  GYZPage.m
//  GyazzForiPhone
//
//  Created by 桜井雄介 on 2013/03/13.
//  Copyright (c) 2013年 桜井雄介. All rights reserved.
//

#import "GYZPage.h"

@implementation GYZPage

#pragma mark - Static

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

#pragma mark - Public

- (id)initWithGyazz:(GYZGyazz *)gyazz title:(NSString *)title modtime:(NSInteger)modtime
{
    if (self = [super init]) {
        _gyazz = gyazz;
        _title = title;
        _modifiedDate = [NSDate dateWithTimeIntervalSince1970:modtime];
    }
    return self;
}

- (NSString *)absoluteString
{
    return [NSString stringWithFormat:@"%@/%@",self.gyazz.absoluteURLPath,self.title];
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_gyazz forKey:@"gyazz"];
    [aCoder encodeObject:_title forKey:@"title"];
    [aCoder encodeObject:_modifiedDate forKey:@"modtime"];

}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    _gyazz = [aDecoder decodeObjectForKey:@"gyazz"];
    _title = [aDecoder decodeObjectForKey:@"title"];
    _modifiedDate = [aDecoder decodeObjectForKey:@"modtime"];
    return self;
}

@end
