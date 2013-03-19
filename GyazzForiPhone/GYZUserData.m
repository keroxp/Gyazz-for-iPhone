//
//  GYZUserData.m
//  GyazzForiPhone
//
//  Created by 桜井雄介 on 2013/03/13.
//  Copyright (c) 2013年 桜井雄介. All rights reserved.
//

#import "GYZUserData.h"

static NSMutableArray *gyazzList;
static GYZGyazz *currentGyazz;

@implementation GYZUserData

+ (GYZGyazz *)currentGyazz
{
    if (!currentGyazz) {
        if ([[self gyazzList] count] > 0) {
            return [[self gyazzList] objectAtIndex:0];
        }else{
            return nil;
        }
    }
    return currentGyazz;
}

+ (void)setCurrentGyazz:(GYZGyazz *)gyazz
{
    currentGyazz = gyazz;
}

+ (void)saveGyazzList
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *d = [NSKeyedArchiver archivedDataWithRootObject:gyazzList];
    [defaults setObject:d forKey:@"list"];
}

+ (NSMutableArray *)gyazzList
{
    if (!gyazzList) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *d = [defaults objectForKey:@"list"];
        NSArray *a = [NSKeyedUnarchiver unarchiveObjectWithData:d];
        gyazzList = [a mutableCopy];
        if (!gyazzList) {
            gyazzList = [NSMutableArray array];
            [self saveGyazzList];
        }
    }
    return gyazzList;
}

@end
