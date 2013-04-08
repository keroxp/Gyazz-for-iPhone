//
//  GYZUserData.m
//  GyazzForiPhone
//
//  Created by 桜井雄介 on 2013/03/13.
//  Copyright (c) 2013年 桜井雄介. All rights reserved.
//

#import "GYZUserData.h"
#define kKeyForGyazzList @"GYAZZ_LIST"
#define kKeyForWatchList @"WATCH_LIST"

static NSMutableArray *gyazzList;
static NSMutableArray *watchList;
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

+ (void)saveObject:(id)obj forKey:(NSString*)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *d = [NSKeyedArchiver archivedDataWithRootObject:obj];
    [defaults setObject:d forKey:key];    
}

+ (NSMutableArray*)getDataForKey:(NSString*)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *d = [defaults objectForKey:key];
    if (d) {
        NSArray *a = [NSKeyedUnarchiver unarchiveObjectWithData:d];
        return [a mutableCopy];
    }else {
        return [NSMutableArray array];
    }
}

+ (void)saveGyazzList
{
    [self saveObject:[self gyazzList] forKey:kKeyForGyazzList];
}

+ (NSMutableArray *)gyazzList
{
    if (!gyazzList) {
        gyazzList = [self getDataForKey:kKeyForGyazzList];
        [self saveGyazzList];
    }
    return gyazzList;
}

+ (void)saveWatchList
{
    [self saveObject:[self watchList] forKey:kKeyForWatchList];
}


+ (NSMutableArray *)watchList
{
    if (!watchList) {
        watchList = [self getDataForKey:kKeyForWatchList];
        [self saveWatchList];
    }
    return watchList;
}
@end
