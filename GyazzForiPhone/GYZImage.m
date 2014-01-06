//
//  GYZImage.m
//  GyazzForiPhone
//
//  Created by 桜井雄介 on 2013/12/28.
//  Copyright (c) 2013年 Masui Lab. All rights reserved.
//

#import "GYZImage.h"
#import "NSString+Hash.h"
#include <sys/types.h>
#include <sys/stat.h>
#include <fts.h>
#import <QuartzCore/QuartzCore.h>
#import <ImageIO/ImageIO.h>

static NSCache *imageCache;
static GYZImage *shared;
static NSOperationQueue *queue;

@implementation GYZImage

+ (instancetype)sharedInstance
{
    if (!shared) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            shared = [[self alloc] init];
            queue = [[NSOperationQueue alloc] init];
            imageCache = [[NSCache alloc] init];
            imageCache.countLimit = 10;
        });
    }
    return shared;
}

- (AFHTTPRequestOperation*)downloadImageWithURL:(NSURL *)url completion:(void (^)(AFHTTPRequestOperation *, UIImage *, NSError *))completion
{
    if (!completion) {
        return nil;
    }
    // キャッシュがあればすぐに返す
    UIImage *i = [self imageForURL:url];
    if (i) {
        completion(nil,i,nil);
        return nil;
    }
    // download
    NSURLRequest *req =  [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:req];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        UIImage *i = nil;
        if ([url.absoluteString rangeOfString:@".gif"].location != NSNotFound) {
            // GIF画像の場合最初のフレームを取り出す
            CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)responseObject, NULL);
            CGImageRef ref = CGImageSourceCreateImageAtIndex(source, 1, NULL);
            i = [UIImage imageWithCGImage:ref];
            CGImageRelease(ref);
        }else{
            i = [[UIImage alloc] initWithData:responseObject];
        }
        // キャッシュ
//        [self archiveImage:i forURL:url atomically:YES];
        completion(operation, i, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(operation,nil,error);
    }];
    [queue addOperation:op];
    return op;
}

- (unsigned long long)imageCachesSize
{
    unsigned long long size = 0;
    FTS* fts;
    FTSENT *entry;
    char* paths[] = {
        (char*)[[self imageCachesPath] cStringUsingEncoding:NSUTF8StringEncoding], NULL
    };
    fts = fts_open(paths, 0, NULL);
    while ((entry = fts_read(fts))) {
        if (entry->fts_info & FTS_DP || entry->fts_level == 0) {
            // ignore post-order
            continue;
        }
        if (entry->fts_info & FTS_F) {
            size += entry->fts_statp->st_size;
        }
    }
    fts_close(fts);
    return size;
}

- (BOOL)archiveImage:(UIImage *)image forURL:(NSURL *)URL atomically:(BOOL)atomically
{
    // メモリにキャッシュ
    [imageCache setObject:image forKey:URL];
    // ディスクに書き込み
    NSData *data = UIImagePNGRepresentation(image);
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *key = [[URL absoluteString] MD5Hash];
    NSString *dp = [NSString stringWithFormat:@"%@/%@",[self imageCachesPath], [key substringToIndex:2]];
    // ディレクトリがなければ作る
    if (![fm fileExistsAtPath:dp]){
        NSError *e = nil;
        [fm createDirectoryAtPath:dp withIntermediateDirectories:NO attributes:nil error:&e];
    }
    BOOL b = [data writeToFile:[self pathForImageURL:URL] atomically:atomically];
    return b;
}

- (void)removeImageForURL:(NSURL *)url error:(NSError *__autoreleasing *)error
{
    [imageCache removeObjectForKey:url];
    NSString *path = [self pathForImageURL:url];
    NSFileManager *fm = [NSFileManager defaultManager];
    [fm removeItemAtPath:path error:error];
}

- (void)removeAllImageArchivesWithCompletion:(void (^)(NSError *))completion
{
    [imageCache removeAllObjects];
    NSFileManager* fm = [NSFileManager defaultManager];
    NSString *path = [self imageCachesPath];
    NSDirectoryEnumerator* en = [fm enumeratorAtPath:path];
    NSError* err = nil;
    BOOL res;
    
    NSString* file;
    while (file = [en nextObject]) {
        res = [fm removeItemAtPath:[path stringByAppendingPathComponent:file] error:&err];
        if (!res && err) {
            TFLog(@"oops: %@", err);
        }
    }
    if (err) {
        TFLog(@"failed to delete caches : %@",err);
        if (completion) {
            completion(err);
        }
    }
    TFLog(@"deleted all caches");
    if (completion) {
        completion(err);
    }
}

- (UIImage *)imageForURL:(NSURL *)url
{
    // インメモリキャッシュにあればそれを返す
    if ([imageCache objectForKey:url]) {
        return [imageCache objectForKey:url];
    }
    // キャッシュディレクトリに存在すればそれを返す
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL isDir = NO;
    NSString *path = [self pathForImageURL:url];
    if ([fm fileExistsAtPath:path isDirectory:&isDir]) {
        NSError *e = nil;
        NSDictionary *attrs = [fm attributesOfItemAtPath:path error:&e];
        NSDate *created = [attrs objectForKey:NSFileCreationDate];
        NSTimeInterval ti = [created timeIntervalSinceNow];
        // 三日以上経過していたら削除してnilを返す
        if (ti > 3*60*60*24) {
            NSError *e = nil;
            [fm removeItemAtPath:path error:&e];
            return nil;
        }else{
            UIImage *i =[[UIImage alloc] initWithContentsOfFile:path];
            [imageCache setObject:i forKey:url];
            return i;
        }
    }
    return nil;
}

#pragma mark - Path

- (NSString*)pathForImageURL:(NSURL*)url
{
    NSString *key = url.absoluteString.MD5Hash;
    NSString *path = [NSString stringWithFormat:@"%@/%@/%@.png", [self imageCachesPath], [key substringToIndex:2], key];
    return path;
}


- (NSString*)imageCachesPath
{
    // ~/Applications/fan/Library/Caches/tv.loilo.fan/images
    NSString *imgcachesdir = [[self archiveDirectoryPath] stringByAppendingPathComponent:@"images"];
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:imgcachesdir]) {
        NSError *e = nil;
        [fm createDirectoryAtPath:imgcachesdir withIntermediateDirectories:YES attributes:nil error:&e];
    }
    return imgcachesdir;
}

- (NSString*)archiveDirectoryPath
{
    // ~/Applications/fan/Library/Caches
    NSString *basedir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    // me.keroxp.app.GyazzForiPhone
    NSString *bid = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleIdentifierKey];
    NSString *cachedir = [basedir stringByAppendingPathComponent:bid];
    return cachedir;
}

@end
