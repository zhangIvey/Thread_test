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
    
    //用来检测主线程是否堵塞
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, 50)];
    textView.backgroundColor = [UIColor grayColor];
    textView.editable = NO;
    textView.text = @"adsfasdfjeiowfjaiosdjfeiaow fjiaewoj fioeaj fioadsjfioejioasjfdioafjeioajioejaiofjeaiflejaofjdioasjfioejfaioejaioejfioajfioaejfoiajfoiaejfoaiejfiodsioafjeioafjidjafioejafwfaewfeaffdagteavdtgaefgewarefat4eagvdate4fear3wfdsareawfeasghrjhtouy7lil;giu86jmdm,uyfisbxfawrefzsgdu5uzfzhes45ujzgv∂ƒ≈gerwhyhndfzvdsghzestjuyjmnuyliu9ljvhmhxrfgts3y5rtjmgh,hjylot78iyujsrghfjdsfasdfjeiowfjaiosdjfeiaow fjiaewoj fioeaj fioadsjfioejioasjfdioafjeioajioejaiofjeaiflejaofjdioasjfioejfaioejaioejfioajfioaejfoiajfoiaejfoaiejfiodsioafjeioafjidjafioejafwfaewfeaffdagteavdtgaefgewarefat4eagvdate4fear3wfdsareawfeasghrjhtouy7lil;giu86jmdm,uyfisbxfawrefzsgdu5uzfzhes45ujzgv∂ƒ≈gerwhyhndfzvdsghzestjuyjmnuyliu9ljvhmhxrfgts3y5rtjmgh,hjylot78iyujsrghfjdsfasdfjeiowfjaiosdjfeiaow fjiaewoj fioeaj fioadsjfioejioasjfdioafjeioajioejaiofjeaiflejaofjdioasjfioejfaioejaioejfioajfioaejfoiajfoiaejfoaiejfiodsioafjeioafjidjafioejafwfaewfeaffdagteavdtgaefgewarefat4eagvdate4fear3wfdsareawfeasghrjhtouy7lil;giu86jmdm,uyfisbxfawrefzsgdu5uzfzhes45ujzgv∂ƒ≈gerwhyhndfzvdsghzestjuyjmnuyliu9ljvhmhxrfgts3y5rtjmgh,hjylot78iyujsrghfjdsfasdfjeiowfjaiosdjfeiaow fjiaewoj fioeaj fioadsjfioejioasjfdioafjeioajioejaiofjeaiflejaofjdioasjfioejfaioejaioejfioajfioaejfoiajfoiaejfoaiejfiodsioafjeioafjidjafioejafwfaewfeaffdagteavdtgaefgewarefat4eagvdate4fear3wfdsareawfeasghrjhtouy7lil;giu86jmdm,uyfisbxfawrefzsgdu5uzfzhes45ujzgv∂ƒ≈gerwhyhndfzvdsghzestjuyjmnuyliu9ljvhmhxrfgts3y5rtjmgh,hjylot78iyujsrghfjdsfasdfjeiowfjaiosdjfeiaow fjiaewoj fioeaj fioadsjfioejioasjfdioafjeioajioejaiofjeaiflejaofjdioasjfioejfaioejaioejfioajfioaejfoiajfoiaejfoaiejfiodsioafjeioafjidjafioejafwfaewfeaffdagteavdtgaefgewarefat4eagvdate4fear3wfdsareawfeasghrjhtouy7lil;giu86jmdm,uyfisbxfawrefzsgdu5uzfzhes45ujzgv∂ƒ≈gerwhyhndfzvdsghzestjuyjmnuyliu9ljvhmhxrfgts3y5rtjmgh,hjylot78iyujsrghfjdsfasdfjeiowfjaiosdjfeiaow fjiaewoj fioeaj fioadsjfioejioasjfdioafjeioajioejaiofjeaiflejaofjdioasjfioejfaioejaioejfioajfioaejfoiajfoiaejfoaiejfiodsioafjeioafjidjafioejafwfaewfeaffdagteavdtgaefgewarefat4eagvdate4fear3wfdsareawfeasghrjhtouy7lil;giu86jmdm,uyfisbxfawrefzsgdu5uzfzhes45ujzgv∂ƒ≈gerwhyhndfzvdsghzestjuyjmnuyliu9ljvhmhxrfgts3y5rtjmgh,hjylot78iyujsrghfj";
    [self.view addSubview:textView];
    
    //第一种方式 pThread
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 100, 100, 40);
    [btn setTitle:@"pThread" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor blueColor]];
    [btn addTarget:self action:@selector(click_pThread) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    //第二种方式 NSThread
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(100, 150, 100, 40);
    [btn1 setTitle:@"NSThread" forState:UIControlStateNormal];
    [btn1 setBackgroundColor:[UIColor blueColor]];
    [btn1 addTarget:self action:@selector(click_NSThread) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    //问题 ： 当多个线程执行某一块相同代码，需要线程锁进行保护
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn3.frame = CGRectMake(100, 200, 100, 40);
    [btn3 setTitle:@"线程锁" forState:UIControlStateNormal];
    [btn3 setBackgroundColor:[UIColor blueColor]];
    [btn3 addTarget:self action:@selector(click_lock) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn3];
    
    //第三种方式 GCD
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(100, 250, 100, 40);
    [btn2 setTitle:@"GCD串行" forState:UIControlStateNormal];
    [btn2 setBackgroundColor:[UIColor blueColor]];
    [btn2 addTarget:self action:@selector(click_GCD_serial) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
    UIButton *btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn4.frame = CGRectMake(100, 300, 100, 40);
    [btn4 setTitle:@"GCD并行" forState:UIControlStateNormal];
    [btn4 setBackgroundColor:[UIColor blueColor]];
    [btn4 addTarget:self action:@selector(click_GCD_Parallel) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn4];
    
    UIButton *btn5 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn5.frame = CGRectMake(100, 350, 100, 40);
    [btn5 setTitle:@"GCD_group" forState:UIControlStateNormal];
    [btn5 setBackgroundColor:[UIColor blueColor]];
    [btn5 addTarget:self action:@selector(click_GCD_group) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn5];
    
    _condition = [[NSCondition alloc] init];
    _lock = [[NSLock alloc] init];
    
    
    
}

- (void)click_GCD_group {
    
    
    NSLog(@"开始gcd_group");
    
    //dispatch_group_t
    
    
    //GCD - 解决场景：执行完多个任务之后才执行某一任务
    
//    dispatch_queue_t queue = dispatch_queue_create("queue.group", NULL); //一个串行队列
    dispatch_queue_t queue = dispatch_queue_create("queue.group", DISPATCH_QUEUE_CONCURRENT); //一个并行队列
    dispatch_group_t groupGCD = dispatch_group_create(); //一个线程组
    dispatch_group_async(groupGCD, queue, ^{
        NSLog(@"开始 ：task1");
        for (int i = 10; i <= 20 ; i ++) {
            sleep(1);
            NSLog(@"当前线程名称：%@ ——%d",[NSThread currentThread].name,i);
        }
    });
    
    dispatch_group_async(groupGCD, queue, ^{
        NSLog(@"开始 ：task2");
        for (int i = 20; i <= 30 ; i ++) {
            sleep(1);
            NSLog(@"当前线程名称：%@ ——%d",[NSThread currentThread].name,i);
        }
    });
    
    dispatch_group_notify(groupGCD, queue, ^{  //线程组的监听通知
        
        NSLog(@"回调之后，所在线程还是子线程, 这个子线程是以上group中开辟的线程");
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSLog(@"开始 ：task3");
            for (int i = 30; i <= 40 ; i ++) {
                sleep(1);
                NSLog(@"当前线程名称：%@ ——%d",[NSThread currentThread].name,i);
                if (i == 40) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSLog(@"回到主线程");
                    });
                }
            }
        });
        
    });
    
    
    
    //GCD - 解决场景：执行完多个异步任务之后才执行某一任务
    
    //GCD - dispatch_once 用来实现单例；
    
    //GCD - dispatch_after 执行延时操作；
    
    //NSOperation
    
    //NSOperation - 的两个子类的使用
    
    //NSOperation - NSInvocationOperation
    
    //NSOperation - NSBlockOperation
    
    //NSOperation - 自定义使用实现子线程操作 - 同步任务
    
    //NSOperation - 自定义使用实现子线程操作 - 异步任务
    
    //NSOperation - 控制线程并发数
    
    //NSOperation - 线程依赖
    
}

- (void)click_GCD_Parallel{
    NSLog(@"开启GCD");
    //GCD 并行队列 - 全局队列(dispatch_get_global_queue)
    /*
        //GCD - 并行队列中任务的执行优先级
     *  - DISPATCH_QUEUE_PRIORITY_HIGH:         QOS_CLASS_USER_INITIATED
     *  - DISPATCH_QUEUE_PRIORITY_DEFAULT:      QOS_CLASS_DEFAULT
     *  - DISPATCH_QUEUE_PRIORITY_LOW:          QOS_CLASS_UTILITY
     *  - DISPATCH_QUEUE_PRIORITY_BACKGROUND:   QOS_CLASS_BACKGROUND
     */
    
    //组合一 ： 同步任务 + 全局队列  -——堵塞主线程
    /*
        执行结果：
        1：系统不会开启子线程；
        2：所有的任务还是在主线程执行；
        3：所有同步任务依次按照顺序执行；
        4：此时全局队列的优先级起不到作用；
     */
    /*
    dispatch_sync(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"开始子线程 ：task1");
        for (int i = 10; i <= 20 ; i ++) {
            sleep(1);
            NSLog(@"当前线程名称：%@ ——%d",[NSThread currentThread].name,i);
            if (i == 20) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"回到主线程，task1");
                });
            }
        }
    });
    dispatch_sync(dispatch_get_global_queue(-2, 0), ^{
        NSLog(@"开始子线程 ：task2");
        for (int i = 20; i <= 30 ; i ++) {
            sleep(1);
            NSLog(@"当前线程名称：%@ ——%d",[NSThread currentThread].name,i);
            if (i == 30) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"回到主线程，task2");
                });
            }
        }
    });
    dispatch_sync(dispatch_get_global_queue(2, 0), ^{
        NSLog(@"开始子线程 ：task3");
        for (int i = 30; i <= 40 ; i ++) {
            sleep(1);
            NSLog(@"当前线程名称：%@ ——%d",[NSThread currentThread].name,i);
            if (i == 40) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"回到主线程，task3");
                });
            }
        }
    });
    */
    
    //组合二 ： 异步任务 + 全局队列 —— 不会堵塞主线程
    /*
        执行结果：
        1：会为每一个异步任务开启一个子线程；
        2：可以通过设置优先级控制任务的执行优先顺序
        3：充分证明全局队列是并行队列
     */
    /*
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"开始子线程 ：task4");
        for (int i = 10; i <= 20 ; i ++) {
            sleep(1);
            NSLog(@"当前线程名称：%@ ——%d",[NSThread currentThread].name,i);
            if (i == 20) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"回到主线程，task1");
                });
            }
        }
    });
    dispatch_async(dispatch_get_global_queue(-2, 0), ^{
        NSLog(@"开始子线程 ：task5");
        for (int i = 20; i <= 30 ; i ++) {
            sleep(1);
            NSLog(@"当前线程名称：%@ ——%d",[NSThread currentThread].name,i);
            if (i == 30) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"回到主线程，task2");
                });
            }
        }
    });
    dispatch_async(dispatch_get_global_queue(2, 0), ^{
        NSLog(@"开始子线程 ：task6");
        for (int i = 30; i <= 40 ; i ++) {
            sleep(1);
            NSLog(@"当前线程名称：%@ ——%d",[NSThread currentThread].name,i);
            if (i == 40) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"回到主线程，task3");
                });
            }
        }
    });
    */
    
    
    
    //GCD - 应用自创建并行队列
    /*
     执行结果：
     
     
        情况一： 并行队列 + 同步任务 ——堵塞主线程
        1：不会开启子线程；
        2：所有同步任务在主线程中执行；
        3：同步任务按照顺序依次执行；
     
     
     
        情况二：并行队列 + 异步任务 ——不会堵塞线程
        1：系统会为每一个异步任务开始一个子线程；
        2：每个异步任务在自己对应的线程中执行；
        3：各个任务之间是并发执行的；
     */
    dispatch_queue_t queue_concurrent = dispatch_queue_create("queue.concurrent", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue_concurrent, ^{
        NSLog(@"开始子线程 ：task7");
        for (int i = 70; i <= 80 ; i ++) {
            sleep(1);
            NSLog(@"当前线程名称：%@ ——%d",[NSThread currentThread].name,i);
            if (i == 80) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"回到主线程，task7");
                });
            }
        }
    });
    
    dispatch_async(queue_concurrent, ^{
        NSLog(@"开始子线程 ：task8");
        for (int i = 80; i <= 90 ; i ++) {
            sleep(1);
            NSLog(@"当前线程名称：%@ ——%d",[NSThread currentThread].name,i);
            if (i == 90) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"回到主线程，task8");
                });
            }
        }
    });
    
    dispatch_async(queue_concurrent, ^{
        NSLog(@"开始子线程 ：task9");
        for (int i = 90; i <= 100 ; i ++) {
            sleep(1);
            NSLog(@"当前线程名称：%@ ——%d",[NSThread currentThread].name,i);
            if (i == 100) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"回到主线程，task9");
                });
            }
        }
    });
    
}


- (void)click_GCD_serial {
    NSLog(@"开启GCD");
    //GCD 串行队列 - 主队列(dispatch_get_main_queue()) ： 连续在主线程中开启三个异步任务（为什么不是同步任务呢？看注意事项一）
    
    /*
        执行结果：——堵塞主线程
        1：系统不会开启新的线程来执行异步任务；
        2：所有的异步任务都会在主线程中执行；
        3：所有的异步任务按照顺序依次执行；
        4：充分证明主队列是串行队列；
     */
    
    //注意事项一 ：在主队列中开启任务，任务只能是异步任务，否则系统就会崩溃。也就是说不能使用创建同步任务调用主队列
    
    /* 错误例子如下：
     dispatch_sync(dispatch_get_main_queue(), ^{
        NSLog(@"回到主线程");
     });
     */
    /*
    dispatch_async(dispatch_get_main_queue(), ^(){
        //在主线程队列中开启同步任务
        NSLog(@"开始子线程 ：task1");
        for (int i = 10; i <= 20 ; i ++) {
            sleep(1);
            NSLog(@"当前线程名称：%@ ——%d",[NSThread currentThread].name,i);
        }
        
    });
    
    dispatch_async(dispatch_get_main_queue(), ^(){
        //在主线程队列中开启同步任务
        NSLog(@"开始子线程 ：task2");
        for (int i = 20; i <= 30 ; i ++) {
            sleep(1);
            NSLog(@"当前线程名称：%@ ——%d",[NSThread currentThread].name,i);
            if (i == 30) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"回到主线程，task2");
                });
            }
        }
       
        
    });
    
    dispatch_async(dispatch_get_main_queue(), ^(){
        //在主线程队列中开启同步任务
        NSLog(@"开始子线程 ：task3");
        for (int i = 30; i <= 40 ; i ++) {
            sleep(1);
            NSLog(@"当前线程名称：%@ ——%d",[NSThread currentThread].name,i);
            if (i == 40) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"回到主线程, task3");
                });
            }
        }
        
    });
    */
    
    //GCD - 应用自创建串行队列 ——  解决场景：线程中的任务按照顺序来执行
    /*
        执行结果：
        情况一：如果队列中的任务都是同步任务 ——会堵塞主线程；
        1：不会开启新线程；
        2：在主线程中执行任务，会堵塞主线程；
        3：任务按照顺序依次执行；
        
        情况二：如果队列中的任务都是异步任务 ——不会堵塞主线程
        1：会开启一个子线程，所有的异步任务都在该线程内执行；
        2：不会堵塞主线程；
        3：在子线程中的任务会按照顺序依次执行
     
        情况三：如果队列中的任务有同步任务和异步任务 ——会堵塞主线程；
        1：同步任务会在主线程中执行；且不会开启子线程；
        2：异步任务会在开启的一个子线程中执行；
        3：会造成主线程的堵塞
     
        总结：
        1：串行队列中的任务都是要按照顺序依次执行的；
        2：如果任务是同步任务就会在主线程中直接依次执行；
        3：如果任务是异步任务就会开辟子线程执行，但还是会按照顺序依次执行，执行完成一个任务之后再执行下一项任务；
     
     */
    
    dispatch_queue_t serial = dispatch_queue_create("queue.costom", NULL); //创建串行队列
    dispatch_async(serial, ^{
        //在主线程队列中开启同步任务
        NSLog(@"开始子线程 ：task4");
        for (int i = 40; i <= 50 ; i ++) {
            sleep(1);
            NSLog(@"当前线程名称：%@ ——%d",[NSThread currentThread].name,i);
            if (i == 50) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"回到主线程, task4");
                });
            }
        }
    });
    
    dispatch_async(serial, ^{
        //在主线程队列中开启同步任务
        NSLog(@"开始子线程 ：task5");
        for (int i = 50; i <= 60 ; i ++) {
            sleep(1);
            NSLog(@"当前线程名称：%@ ——%d",[NSThread currentThread].name,i);
            if (i == 60) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"回到主线程, task5");
                });
            }
        }
    });
    
    dispatch_async(serial, ^{
        //在主线程队列中开启同步任务
        NSLog(@"开始子线程 ：task6");
        for (int i = 60; i <= 70 ; i ++) {
            sleep(1);
            NSLog(@"当前线程名称：%@ ——%d",[NSThread currentThread].name,i);
            if (i == 70) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"回到主线程, task6");
                });
            }
        }
    });
    
    
    
    
    
    
    
}


- (void)click_lock{
    
    //创建三个线程线程
    NSThread *thread_1 = [[NSThread alloc] initWithTarget:self selector:@selector(runThreadForUseingLock) object:nil];
    thread_1.name = @"thread_1";
    thread_1.threadPriority = 0.2;
    
    NSThread *thread_2 = [[NSThread alloc] initWithTarget:self selector:@selector(runThreadForUseingLock) object:nil];
    thread_2.name = @"thread_2";
    thread_2.threadPriority = 0.5;
    
    NSThread *thread_3 = [[NSThread alloc] initWithTarget:self selector:@selector(runThreadForUseingLock) object:nil];
    thread_3.name = @"thread_3";
    thread_3.threadPriority = 0.8;
    
    //开启三个线程
    [thread_1 start];
    [thread_2 start];
    [thread_3 start];
    
}


- (void)click_pThread {
    
    [self isMainThread];
    pthread_t queue;
    pthread_create(&queue, NULL, run_pThread, NULL);
    
}


- (void) click_NSThread {
    NSLog(@"主线程打印");
    // 2 : NSThread 多线程
    // 初始化方法一 ： alloc - init 方法，使用该方法创建的线程需要手动开启线程start
    NSThread *thread1 = [[NSThread alloc] initWithTarget:self selector:@selector(runThread1) object:nil];
    thread1.name = @"first_NSThread"; //设置线程的名称
    thread1.threadPriority = 1;       //设置线程的执行优先级
    
    //初始化方法二 ： NSThread类方法创建， 不能指定线程名称和优先级
//    [NSThread detachNewThreadSelector:@selector(runThread1) toTarget:self withObject:nil];
    
    //初始化方法三 ： NSObject的内置方法，不能指定线程名称和优先级
//    [self performSelectorInBackground:@selector(runThread1) withObject:nil];
    
    
    //设置线程的优先级
    NSThread *thread2 = [[NSThread alloc] initWithTarget:self selector:@selector(runThread1) object:nil];
    thread2.name = @"second_NSThread";
    thread2.threadPriority = 0.5;
    
    
    NSThread *thread3 = [[NSThread alloc] initWithTarget:self selector:@selector(runThread1) object:nil];
    thread3.name = @"third_NSThread";
    thread3.threadPriority = 0.2;
    
    [thread1 start]; //手动开启线程
    [thread2 start];
    [thread3 start];
}

- (void)runThreadForUseingLock{
    /*
    //线程锁一 ： @synchronized : 同步的
    @synchronized (self) {
        for (int i = 0; i <= 10 ; i ++) {
            sleep(1);
            NSLog(@"当前线程名称：%@ ——%d",[NSThread currentThread].name,i);
            if (i == 10) {
                [self performSelectorOnMainThread:@selector(goBackToMain) withObject:nil waitUntilDone:YES];
            }
        }
    }
    */
    
    /*
    //线程锁二 ： NSCondition
    if (_condition == nil) {
        _condition = [[NSCondition alloc] init];
    }
    
    [_condition lock];
    for (int i = 0; i <= 10 ; i ++) {
        sleep(1);
        NSLog(@"当前线程名称：%@ ——%d",[NSThread currentThread].name,i);
        if (i == 10) {
            [self performSelectorOnMainThread:@selector(goBackToMain) withObject:nil waitUntilDone:YES];
        }
    }
    [_condition unlock];
    */
    
    //线程锁三 ： NSLock
    if (_lock == nil) {
        _lock = [[NSLock alloc] init];
    }
    [_lock lock];
    for (int i = 0; i <= 10 ; i ++) {
        sleep(1);
        NSLog(@"当前线程名称：%@ ——%d",[NSThread currentThread].name,i);
        if (i == 10) {
            [self performSelectorOnMainThread:@selector(goBackToMain) withObject:nil waitUntilDone:YES];
        }
    }
    [_lock unlock];
    
}



// 执行子线程
- (void)runThread1 {
    
//    @synchronized (self) { //第一种线程锁 @synchronized
    
//    [_condition lock]; //第二种线程锁 NSCondition
    
//    [_lock lock]; //第三种线程锁 NSLock
        for (int i = 0; i <= 10 ; i ++) {
            sleep(1);
            NSLog(@"当前线程名称：%@ ——%d",[NSThread currentThread].name,i);
            if (i == 10) {
                [self performSelectorOnMainThread:@selector(goBackToMain) withObject:nil waitUntilDone:YES];
            }
        }
//    [_lock unlock];
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
void *run_pThread(void *data) {
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
