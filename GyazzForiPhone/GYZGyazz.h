//
//  GYZGyazz.h
//  GyazzForiPhone
//
//  Created by 桜井雄介 on 2013/03/13.
//  Copyright (c) 2013年 桜井雄介. All rights reserved.
//

#import "GYZWebModel.h"

@interface GYZGyazz : GYZWebModel  <NSCoding>

/* Gyazzの名前 */
@property (readonly) NSString *name;

/* コンストラクタ */
- (id)initWithName:(NSString*)name;

/* 自身のページリストを取得する */
- (void)getPageListWithWithSuccess:(GYZNetworkSuccessBlock)success
                           failure:(GYZNetworkFailureBlock)failure;

/* UserDefaultsに保存 */
- (void)save;

@end
