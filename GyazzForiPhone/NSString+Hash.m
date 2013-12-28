//
//  NSString+Hash.m
//  fan
//
//  Created by 桜井雄介 on 2013/08/07.
//  Copyright (c) 2013年 LoiLo Inc. All rights reserved.
//

#import "NSString+Hash.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation NSString (Hash)

- (NSString *)MD5Hash
{
    const char *data = [self UTF8String];
    if (self.length == 0) {
        return nil;
    }
    CC_LONG len = self.length;
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(data, len, result);
    NSMutableString *ms = @"".mutableCopy;
    for (int i = 0; i < 16; i++) {
        [ms appendFormat:@"%02X",result[i]];
    }
    return ms;
}

@end
