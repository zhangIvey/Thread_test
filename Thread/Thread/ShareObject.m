//
//  ShareObject.m
//  Thread
//
//  Created by yaoln on 2017/5/3.
//  Copyright © 2017年 张泽. All rights reserved.
//

#import "ShareObject.h"

@interface ShareObject ()

@property(nonatomic, copy) NSString *nameString;

@end

@implementation ShareObject

static ShareObject *object = nil;
+ (instancetype) initWithName:(NSString *)nameString
{
    static dispatch_once_t oncet;
    dispatch_once(&oncet, ^{
        NSLog(@"仅执行一次");
        object = [[ShareObject alloc] init];
        object.nameString = nameString;
    });
    return object;
}

@end
