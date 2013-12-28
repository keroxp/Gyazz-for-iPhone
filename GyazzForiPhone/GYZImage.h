//
//  GYZImage.h
//  GyazzForiPhone
//
//  Created by 桜井雄介 on 2013/12/28.
//  Copyright (c) 2013年 Masui Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYZImage : NSObject

// shared instance
+ (instancetype)sharedInstance;
// 画像をダウンロードしてキャッシュ
- (void)downloadImageWithURL:(NSURL*)url completion:(void (^)(AFHTTPRequestOperation* operation, UIImage *data, NSError *e))completion;
// 画像をキャッシュから読み込み
- (UIImage*)imageForURL:(NSURL*)url;
// 画像を保存
- (BOOL)archiveImage:(UIImage*)image forURL:(NSURL*)URL atomically:(BOOL)atomically;
// 特定の画像をキャッシュから削除
- (void)removeImageForURL:(NSURL*)url error:(NSError**)error;
// 画像をキャッシュから削除
- (void)removeAllImageArchivesWithCompletion:(void (^)(NSError *e))completion;
// キャッシュサイズ
- (unsigned long long)imageCachesSize;

@end

@interface GYZImage (PathUtil)

// キャッシュディレクトリ
- (NSString*)archiveDirectoryPath;
// 画像キャッシュのディレクトリ
- (NSString*)imageCachesPath;
// urlに対応するキャッシュファイルへのパス
- (NSString*)pathForImageURL:(NSURL*)url;

@end