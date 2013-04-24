//
//  GYZUserData.m
//  GyazzForiPhone
//
//  Created by 桜井雄介 on 2013/03/13.
//  Copyright (c) 2013年 桜井雄介. All rights reserved.
//

#import "GYZUserData.h"
#import "GYZGyazz.h"
#import "GYZPage.h"

#define kKeyForGyazzList @"GYAZZ_LIST"
#define kKeyForWatchList @"WATCH_LIST"

#define kGyazzListDictionryNameKey @"GYAZZ_NAME"
#define kGyazzListDictionaryPasswordKey @"GYAZZ_PASSWORD"
#define kGyazzListDictionaryUserNameKey @"GYAZZ_USERNAME"

#define kPageListDictionaryGyazzNameKey @"PAGE_GYAZZ_NAME"
#define kPageListDictionaryPageTitle @"PAGE_TITLE"

static NSMutableArray *gyazzList;
static NSMutableArray *watchList;
static GYZGyazz *currentGyazz;

NSString *const GYZUserDataDidChangeNotification = @"org.masuilab.sfc.GyazzForiPhone:GYZUserDataDidChangeNotification";

@implementation GYZUserData

+ (void)iCloudStoreDidChange:(NSNotification *)notification
{
    NSDictionary *ui = [notification userInfo];
    // 変更されたデータのキー値
    NSArray *keys = [ui objectForKey:NSUbiquitousKeyValueStoreChangedKeysKey];
    NSUbiquitousKeyValueStore *ukvs = [NSUbiquitousKeyValueStore defaultStore];
    for (NSString *key in keys) {
        if ([key isEqualToString:kKeyForGyazzList]) {
            NSArray *gl = [ukvs arrayForKey:kKeyForGyazzList];
            NSMutableArray *ma = [NSMutableArray arrayWithCapacity:gl.count];
            for (NSDictionary *g in gl) {
                NSString *name = [g objectForKey:kGyazzListDictionryNameKey];
                NSString *un = [g objectForKey:kGyazzListDictionaryUserNameKey];
                NSString *pw = [g objectForKey:kGyazzListDictionaryPasswordKey];
                GYZGyazz *ng = [[GYZGyazz alloc] initWithName:name];
                [ng setUsername:un];
                [ng setPassword:pw];
                [ma addObject:ng];
            }
            gyazzList = ma;
            [self saveObject:ma forKey:kKeyForGyazzList];
        }else if ([key isEqualToString:kKeyForWatchList]){
            NSArray *wl = [ukvs arrayForKey:kKeyForWatchList];
            NSMutableArray *ma = [NSMutableArray arrayWithCapacity:wl.count];
            for (NSDictionary *p in wl) {
                NSString *title = [p objectForKey:kPageListDictionaryPageTitle];
                NSString *gn = [p objectForKey:kPageListDictionaryGyazzNameKey];
                GYZPage *p;
                for (GYZGyazz *g in [self gyazzList]) {
                    if ([g.name isEqualToString:gn]) {
                        p = [[GYZPage alloc] initWithGyazz:g title:title modtime:0];
                        break;
                    }
                }
                if (p) {
                    [ma addObject:p];
                }
            }
            watchList = ma;
            [self saveObject:ma forKey:kKeyForWatchList];
        }
    }
    // 内部通知
    NSNotification *n = [NSNotification notificationWithName:GYZUserDataDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:n];
}

+ (void)saveObject:(id)obj forKey:(NSString*)key
{
    // ローカルのUserDefaults領域に書き込み
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *d = [NSKeyedArchiver archivedDataWithRootObject:obj];
    [defaults setObject:d forKey:key];
    [defaults synchronize];
    // iCloudに保存
    NSArray *objs = (NSArray*)obj;
    NSMutableArray *ma = [NSMutableArray arrayWithCapacity:[objs count]];
    if ([key isEqualToString:kKeyForGyazzList]) {
        for (GYZGyazz *g in objs) {
            NSString *un = (g.username) ? g.username : @"";
            NSString *pw = (g.password) ? g.password : @"";
            NSDictionary *d = @{kGyazzListDictionryNameKey: g.name,
                                kGyazzListDictionaryUserNameKey: un,
                                kGyazzListDictionaryPasswordKey: pw};
            [ma addObject:d];
        }
        [[NSUbiquitousKeyValueStore defaultStore] setArray:ma forKey:kKeyForGyazzList];
    }else if ([key isEqualToString:kKeyForWatchList]){
        for (GYZPage *p in objs) {
            NSDictionary *d = @{kPageListDictionaryGyazzNameKey: p.gyazz.name,
                                kPageListDictionaryPageTitle: p.title
                                };
            [ma addObject:d];
        }
        [[NSUbiquitousKeyValueStore defaultStore] setArray:ma forKey:kKeyForWatchList];
    }
    [[NSUbiquitousKeyValueStore defaultStore] synchronize];
}

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

+ (NSMutableArray*)getDataForKey:(NSString*)key
{
    // ローカルのUserDefaults領域から読み込み
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
