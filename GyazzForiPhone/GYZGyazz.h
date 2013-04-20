//
//  GYZGyazz.h
//  GyazzForiPhone
//
//  Created by 桜井雄介 on 2013/03/13.
//  Copyright (c) 2013年 桜井雄介. All rights reserved.
//

#import "GYZWebModel.h"

@class GYZPage, AFHTTPRequestOperation;

@interface GYZGyazz : GYZWebModel  <NSCoding>

/* Gyazzの名前 */
@property (readonly) NSString *name;


/* コンストラクタ */
- (id)initWithName:(NSString*)name;

/* 自身のページリストを取得する */
- (void)getPageListWithWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/* URLパス */
- (NSString*)absoluteURLPath;
/* UserDefaultsに保存 */
- (void)save;

@end
