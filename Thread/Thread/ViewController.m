//
//  ViewController.m
//  Thread
//
//  Created by 张泽 on 2017/4/25.
//  Copyright © 2017年 张泽. All rights reserved.
//

#import "ViewController.h"
#import <pthread.h>

@interface ViewController ()

@property(nonatomic, retain) NSCondition *condition; //用于对线程进行加锁保护
@property(nonatomic, retain) NSLock *lock; //用于对线程进行加锁保护

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 100, 100, 40);
    [btn setTitle:@"pThread" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor blueColor]];
    [btn addTarget:self action:@selector(click_pThread) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(100, 150, 100, 40);
    [btn1 setTitle:@"NSThread" forState:UIControlStateNormal];
    [btn1 setBackgroundColor:[UIColor blueColor]];
    [btn1 addTarget:self action:@selector(click_NSThread) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    _condition = [[NSCondition alloc] init];
    _lock = [[NSLock alloc] init];
}




- (void)click_pThread {
    
    [self isMainThread];
    // 1 : pThread 多线程
    pthread_t queue;
    pthread_create(&queue, NULL, runpThread, NULL);
    
}


- (void) click_NSThread {
    NSLog(@"主线程打印");
    // 2 : NSThread 多线程
    // 初始化方法
    NSThread *thread1 = [[NSThread alloc] initWithTarget:self selector:@selector(runThread1) object:nil];
    thread1.name = @"first_NSThread";
    thread1.threadPriority = 1;
    
    
    
//    [NSThread detachNewThreadSelector:@selector(runThread1) toTarget:self withObject:nil];
    
//    [self performSelectorInBackground:@selector(runThread1) withObject:nil];
    
    //设置线程的优先级
    NSThread *thread2 = [[NSThread alloc] initWithTarget:self selector:@selector(runThread1) object:nil];
    thread2.name = @"second_NSThread";
    thread2.threadPriority = 0.5;
    
    
    NSThread *thread3 = [[NSThread alloc] initWithTarget:self selector:@selector(runThread1) object:nil];
    thread3.name = @"third_NSThread";
    thread3.threadPriority = 0.2;
    
    [thread1 start];
    [thread2 start];
    [thread3 start];
}


// 执行子线程
- (void)runThread1 {
    
//    @synchronized (self) { //第一种线程锁 @synchronized
    
//    [_condition lock]; //第二种线程锁 NSCondition
    
    [_lock lock]; //第三种线程锁 NSLock
        for (int i = 0; i <= 10 ; i ++) {
            sleep(1);
            NSLog(@"当前线程名称：%@ ——%d",[NSThread currentThread].name,i);
            if (i == 10) {
                [self performSelectorOnMainThread:@selector(goBackToMain) withObject:nil waitUntilDone:YES];
            }
        }
    [_lock unlock];
//    [_condition unlock];
    
//    }
    
}

// 打印主线程信息
- (void) goBackToMain {
    NSLog(@"回到主线程");
}

// 打印是否为当前线程
- (void)isMainThread {
    if ([[NSThread currentThread] isMainThread]) {
        NSLog(@"当前线程是主线程");
    }else{
        NSLog(@"当前线程是子线程");
    }
    
}

// C 语言 函数
void *runpThread(void *data) {
    for (int i = 0; i < 10 ; i ++) {
        sleep(1);
        NSLog(@"%d",i);
    }
    return NULL;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
