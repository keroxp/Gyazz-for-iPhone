//
//  GYZRequestOperation.h
//  GyazzForiPhone
//
//  Created by 桜井雄介 on 2013/04/08.
//  Copyright (c) 2013年 Masui Lab. All rights reserved.
//

#import "AFHTTPRequestOperation.h"

@class GYZPage;

@interface GYZRequestOperation : AFHTTPRequestOperation

- (void)setUsername:(NSString*)username password:(NSString*)password;

@end
