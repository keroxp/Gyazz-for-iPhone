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

- (BOOL)isEqual:(id)object
{
    if (object == self) {
        return YES;
    }
    if ([object isKindOfClass:[self class]]) {
        if ([[(GYZGyazz*)object name] isEqualToString:self.name]) {
            return YES;
        }
    }
    return [super isEqual:object];
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

- (void)getPageListWithWithSuccess:(GYZNetworkSuccessBlock)success failure:(GYZNetworkFailureBlock)failure
{
    NSString *path = [NSString stringWithFormat:@"%@/__list",[self absoluteURLPath]];
    [self accessToURL:path success:success failure:failure];
}

- (NSString *)absoluteURLPath
{
    return [NSString stringWithFormat:@"http://gyazz.com/%@",_name];
}

- (NSURL *)absoluteURL
{
    return [NSURL URLWithString:self.absoluteURLPath];
}

- (void)save
{
    // 保存
    [GYZUserData saveGyazzList];
}

@end
