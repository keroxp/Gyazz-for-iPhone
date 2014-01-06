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
        GYZPage *p = [[self alloc] initWithGyazz:gyazz JSONArray:page];
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

- (id)initWithGyazz:(GYZGyazz *)gyazz JSONArray:(NSArray *)JSONArray
{
    if (self = [super init]) {
        if (JSONArray.count < 4) {
            return nil;
        }
        _gyazz = gyazz;
        _title = JSONArray[0];
        _modifiedDate = [NSDate dateWithTimeIntervalSince1970:[JSONArray[1] integerValue]];
        NSError *e = nil;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"https?:\\/\\/.+?\\.(png|jpe?g|gif)" options:0 error:&e];
        NSString *iconImageURLString = JSONArray[3];
        if (iconImageURLString && ![iconImageURLString isEqual:[NSNull null]]){
            NSRange result = [regex rangeOfFirstMatchInString:iconImageURLString options:0 range:NSMakeRange(0, iconImageURLString.length)];
            if (result.location != NSNotFound) {
                _iconImageURL = [NSURL URLWithString:iconImageURLString];
            }else if(iconImageURLString.length > 0){
                NSString *url = [NSString stringWithFormat:@"http://gyazo.com/%@.png",iconImageURLString];
                _iconImageURL = [NSURL URLWithString:url];
            }
        }
    }
    return self;
}

- (NSString *)absoluteURLPath
{
    return [NSString stringWithFormat:@"%@/%@",self.gyazz.absoluteURLPath,self.title];
}

- (NSURL *)absoluteURL
{
    return [NSURL URLWithString:self.absoluteURLPath];
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

- (void)getTextWithSuccess:(GYZNetworkSuccessBlock)success failure:(GYZNetworkFailureBlock)failure
{
    NSString *path = [NSString stringWithFormat:@"%@/%@/text",self.gyazz.absoluteURLPath,self.title];
    [self accessToURL:path success:success failure:failure];
}

- (void)getRelatedWithSuccess:(GYZNetworkSuccessBlock)success failure:(GYZNetworkFailureBlock)failure
{
    NSString *path = [NSString stringWithFormat:@"%@/%@/related",self.gyazz.absoluteURLPath, self.title];
    [self accessToURL:path success:success failure:failure];
}

- (void)getHTMLWithSuccess:(GYZNetworkSuccessBlock)success failure:(GYZNetworkFailureBlock)failure
{
    NSString *path = [NSString stringWithFormat:@"%@/%@",self.gyazz.absoluteURLPath,self.title];
    [self accessToURL:path success:^(AFHTTPRequestOperation *operation, id responseObj) {
        // クッキーを保存
//        NSLog(@"%@",operation.response.allHeaderFields);
//        NSArray * all = [NSHTTPCookie cookiesWithResponseHeaderFields:[operation.response allHeaderFields]
//                                                               forURL:self.absoluteURL];
//        NSLog(@"How many Cookies: %d", all.count);
//        
//        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookies:all
//                                                           forURL:self.absoluteURL mainDocumentURL:nil];
//        
//        for (NSHTTPCookie *cookie in all)
//            NSLog(@"Name: %@ : Value: %@, Expires: %@", cookie.name, cookie.value, cookie.expiresDate);

        if (success) {
            success(operation,responseObj);
        }
        
    } failure:failure];
}


- (void)saveWithText:(NSString *)text success:(GYZNetworkSuccessBlock)success failure:(GYZNetworkFailureBlock)failure
{
    //クッキーの取得
    NSArray * availableCookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:self.gyazz.absoluteURL];
    NSDictionary * headers = [NSHTTPCookie requestHeaderFieldsWithCookies:availableCookies];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:self.absoluteURL];
    NSString *data = [NSString stringWithFormat:@"%@\n%@\n%@",self.gyazz.name,self.title,text];
    [req setAllHTTPHeaderFields:headers];
    [req setValue:self.username forHTTPHeaderField:@"username"];
    [req setValue:self.password forHTTPHeaderField:@"password"];
    [req setHTTPBody:[[NSString stringWithFormat:@"data=%@",data] dataUsingEncoding:NSUTF8StringEncoding]];
    [self accessWithURLRequest:req success:success failure:failure];
    TFLog(@"%@",data);
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
