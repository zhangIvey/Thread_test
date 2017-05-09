//
//  CustomOperation.m
//  Thread
//
//  Created by yaoln on 2017/5/3.
//  Copyright © 2017年 张泽. All rights reserved.
//

#import "CustomOperation.h"

@interface CustomOperation ()

@property(nonatomic, assign) BOOL over;

@end

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
    
    //NSOperation - 自定义使用实现子线程操作 - 同步任务
    /*
    NSLog(@"线程名字 = %@",self.name);
    for (int i = 0; i <= 10 ; i ++) {
        sleep(1);
        NSLog(@"自定义线程 %@——%d",self.name,i);
    }
     */
    
    
    //NSOperation - 自定义使用实现子线程操作 - 异步任务
    
    NSLog(@"开始任务");
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        if (self.isCancelled) {
            return ;
        }
        for (int i = 0; i <= 10 ; i ++) {
            sleep(1);
            NSLog(@"自定义线程 ——%d",i);
        }
        NSLog(@"循环结束");
        self.over = YES;
    });
    
    //解决办法 : 使用 NSRunLoop 进行循环执行
    /*
        通过 NSRunLoop 的控制线程，等待异步任务完成之后再让该线程执行完成。
     */
    while (!self.over && !self.isCancelled) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    
    
    NSLog(@"结束任务");
    
}

@end
