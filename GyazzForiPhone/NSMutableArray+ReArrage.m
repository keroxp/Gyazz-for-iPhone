//
//  NSMutableArray+ReArrage.m
//  GyazzForiPhone
//
//  Created by 桜井雄介 on 2013/03/14.
//  Copyright (c) 2013年 桜井雄介. All rights reserved.
//

#import "NSMutableArray+ReArrage.h"

@implementation NSMutableArray (ReArrage)

- (void)moveObjectFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex {
    
    if (fromIndex != toIndex) {
        id __strong obj = [self objectAtIndex:fromIndex];
        [self removeObjectAtIndex:fromIndex];
        if (toIndex >= [self count]) {
            [self addObject:obj];
        }
        else {
            [self insertObject:obj atIndex:toIndex];
        }
    }
}

@end
