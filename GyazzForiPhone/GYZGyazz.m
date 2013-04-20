//
//  GYZGyazz.m
//  GyazzForiPhone
//
//  Created by 桜井雄介 on 2013/03/13.
//  Copyright (c) 2013年 桜井雄介. All rights reserved.
//

#import "GYZGyazz.h"
#import "GYZPage.h"
#import "GYZUserData.h"
#import <AFNetworking.h>
#import <JSONKit.h>
#import <BlocksKit.h>


@interface GYZGyazz ()

@end

@implementation GYZGyazz

- (id)initWithName:(NSString *)name
{
    if (self = [super init]) {
        _name = name;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:_name forKey:@"name"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _name = [aDecoder decodeObjectForKey:@"name"];
    }
    return self;
}

- (void)getPageListWithWithSuccess:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    NSString *path = [NSString stringWithFormat:@"%@/__list",[self absoluteURLPath]];
    [self accessToURL:path success:success failure:failure];
}

- (NSString *)absoluteURLPath
{
    return [NSString stringWithFormat:@"http://gyazz.com/%@",_name];
}

- (void)save
{
    // 保存
    [GYZUserData saveGyazzList];
}

@end
