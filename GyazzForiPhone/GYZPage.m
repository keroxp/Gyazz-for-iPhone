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


- (BOOL)isEqual:(id)object
{
    if (object == self) {
        return YES;
    }else if ([object isKindOfClass:[GYZPage class]]){
        if ([[(GYZPage*)object title] isEqualToString:self.title]) {
            return YES;
        }
    }
    return [super isEqual:object];
}

#pragma mark - API

- (void)getTextWithSuccess:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    NSString *path = [NSString stringWithFormat:@"%@/%@/text",self.gyazz.absoluteURLPath,self.title];
    [self accessToURL:path success:success failure:failure];
}

- (void)getRelatedWithSuccess:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    NSString *path = [NSString stringWithFormat:@"%@/%@/related",self.gyazz.absoluteURLPath, self.title];
    [self accessToURL:path success:success failure:failure];
}

- (void)getHTMLWithSuccess:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    NSString *path = [NSString stringWithFormat:@"%@/%@",self.gyazz.absoluteURLPath,self.title];
    [self accessToURL:path success:success failure:failure];
}

- (void)saveWithText:(NSString *)text success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:@"http://gyazz.com"]];
    [client setAuthorizationHeaderWithUsername:self.username password:self.password];
    NSString *data = [NSString stringWithFormat:@"%@\n%@\n%@",self.gyazz.name,self.title,text];
    TFLog(@"%@",data);
    [client postPath:@"__write__" parameters:@{@"data":data} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        if (success) {
            success(operation,responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        if (failure) {
            failure(operation,error);
        }
    }];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:_gyazz forKey:@"gyazz"];
    [aCoder encodeObject:_title forKey:@"title"];
    [aCoder encodeObject:_modifiedDate forKey:@"modtime"];

}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    _gyazz = [aDecoder decodeObjectForKey:@"gyazz"];
    _title = [aDecoder decodeObjectForKey:@"title"];
    _modifiedDate = [aDecoder decodeObjectForKey:@"modtime"];
    return self;
}

- (NSString *)username
{
    return self.gyazz.username;
}

- (NSString *)password
{
    return self.gyazz.password;
}

@end
