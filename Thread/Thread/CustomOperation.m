//
//  CustomOperation.m
//  Thread
//
//  Created by yaoln on 2017/5/3.
//  Copyright © 2017年 张泽. All rights reserved.
//

#import "CustomOperation.h"


@implementation CustomOperation

- (instancetype) initWithName:(NSString *)stringName
{
    self = [super init];
    if (self) {
        self.name = stringName;
    }
    return self;
}

// 重写 main 方法 （需要思考的问题 ：为什么要重新 main 方法而不是其他的方法？）
- (void) main {
    
    
    
}

@end
