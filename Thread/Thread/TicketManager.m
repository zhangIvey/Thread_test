//
//  TicketManager.m
//  Thread
//
//  Created by yaoln on 2017/5/8.
//  Copyright © 2017年 张泽. All rights reserved.
//

#import "TicketManager.h"

#define Total 100   //一共一百张票

@interface TicketManager ()

@property (nonatomic, assign) int whole;        //总票数
@property (nonatomic, assign) int surplus;      //剩余票数

@property (nonatomic, strong) NSThread *thread_SH; //子线程， 上海售票点
@property (nonatomic, strong) NSThread *thread_BJ; //子线程， 北京售票点
@property (nonatomic, strong) NSThread *thread_SZ; //子线程， 深圳售票点

@property (nonatomic, strong) NSCondition *condition ; //线程锁
@property (nonatomic, strong) NSLock *lock; //线程锁

@end

@implementation TicketManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.whole = Total;
        self.surplus = Total;
        
        self.thread_SH = [[NSThread alloc] initWithTarget:self selector:@selector(sale) object:nil];
        self.thread_SH.name = @"上海售票点";
        
        self.thread_BJ = [[NSThread alloc] initWithTarget:self selector:@selector(sale) object:nil];
        self.thread_BJ.name = @"北京售票点";
        
        self.thread_SZ = [[NSThread alloc] initWithTarget:self selector:@selector(sale) object:nil];
        self.thread_SZ.name = @"深圳售票点";
        
        self.condition = [[NSCondition alloc] init];
    }
    return self;
}

//售票方法
- (void) sale {
    
    while (true) {
        
//        //线程锁的第一种方式 ：@synchronized
//        @synchronized (self) {
//            if (self.surplus > 0) {  //当还有余票时，就执行卖票
//                [NSThread sleepForTimeInterval:1];
//                self.surplus = self.surplus - 1;
//                NSLog(@"%@ 卖出一张票，剩余：%d",[NSThread currentThread].name, self.surplus);
//            }
//        }
        
//        //线程锁的第二种方式：NSCondition
//        if (!self.condition) {
//            self.condition = [[NSCondition alloc] init];
//        }
//        [self.condition lock];
//        if (self.surplus > 0) {  //当还有余票时，就执行卖票
//            [NSThread sleepForTimeInterval:1];
//            self.surplus = self.surplus - 1;
//            NSLog(@"%@ 卖出一张票，剩余：%d",[NSThread currentThread].name, self.surplus);
//        }
//        [self.condition unlock];
        
        
        //线程锁的第三种方式：NSLock
        if (!self.lock) {
            self.lock = [[NSLock alloc] init];
        }
        [self.lock lock];
        if (self.surplus > 0) {  //当还有余票时，就执行卖票
            [NSThread sleepForTimeInterval:1];
            self.surplus = self.surplus - 1;
            NSLog(@"%@ 卖出一张票，剩余：%d",[NSThread currentThread].name, self.surplus);
        }
        [self.lock unlock];

        
//        if (self.surplus > 0) {  //当还有余票时，就执行卖票
//            [NSThread sleepForTimeInterval:1];
//            self.surplus = self.surplus - 1;
//            NSLog(@"%@ 卖出一张票，剩余：%d",[NSThread currentThread].name, self.surplus);
//        }
    }
    
    
}

//开始卖票
- (void) startSale {
    [self.thread_SZ start];
    [self.thread_BJ start];
    [self.thread_SH start];
}

@end
