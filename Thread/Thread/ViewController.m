//
//  ViewController.m
//  Thread
//
//  Created by 张泽 on 2017/4/25.
//  Copyright © 2017年 张泽. All rights reserved.
//

#import "ViewController.h"
#import <pthread.h>
#import "ShareObject.h"
#import "CustomOperation.h"

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
    btn.frame = CGRectMake(40, 100, 100, 40);
    [btn setTitle:@"pThread" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor blueColor]];
    [btn addTarget:self action:@selector(click_pThread) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    //第二种方式 NSThread
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(40, 150, 100, 40);
    [btn1 setTitle:@"NSThread" forState:UIControlStateNormal];
    [btn1 setBackgroundColor:[UIColor blueColor]];
    [btn1 addTarget:self action:@selector(click_NSThread) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    //问题 ： 当多个线程执行某一块相同代码，需要线程锁进行保护
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn3.frame = CGRectMake(40, 200, 100, 40);
    [btn3 setTitle:@"线程锁" forState:UIControlStateNormal];
    [btn3 setBackgroundColor:[UIColor blueColor]];
    [btn3 addTarget:self action:@selector(click_lock) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn3];
    
    //第三种方式 GCD
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(40, 250, 100, 40);
    [btn2 setTitle:@"GCD串行" forState:UIControlStateNormal];
    [btn2 setBackgroundColor:[UIColor blueColor]];
    [btn2 addTarget:self action:@selector(click_GCD_serial) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
    UIButton *btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn4.frame = CGRectMake(40, 300, 100, 40);
    [btn4 setTitle:@"GCD并行" forState:UIControlStateNormal];
    [btn4 setBackgroundColor:[UIColor blueColor]];
    [btn4 addTarget:self action:@selector(click_GCD_Parallel) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn4];
    
    UIButton *btn5 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn5.frame = CGRectMake(40, 350, 100, 40);
    [btn5 setTitle:@"GCD_group" forState:UIControlStateNormal];
    [btn5 setBackgroundColor:[UIColor blueColor]];
    [btn5 addTarget:self action:@selector(click_GCD_group) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn5];
    
    UIButton *btn6 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn6.frame = CGRectMake(40, 400, 100, 40);
    [btn6 setTitle:@"GCD_once" forState:UIControlStateNormal];
    [btn6 setBackgroundColor:[UIColor blueColor]];
    [btn6 addTarget:self action:@selector(click_GCD_once) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn6];
    
    UIButton *btn7 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn7.frame = CGRectMake(40, 450, 100, 40);
    [btn7 setTitle:@"GCD_after" forState:UIControlStateNormal];
    [btn7 setBackgroundColor:[UIColor blueColor]];
    [btn7 addTarget:self action:@selector(click_GCD_after) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn7];
    
    
    //第四种方式 ：NSOperation
    /*
        NSOperation 是抽象类，所以要用子类来进行线程使用；目前是三种方式：
        1：NSInvocationOperation
        2：NSBlockOperation
        3：创建子类继承自 NSOperation
     */
    // NSOperation - NSInvocationOperation
    UIButton *btn8 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn8.frame = CGRectMake(40 + 100 + 20, 100, 150, 40);
    [btn8 setTitle:@"Operation-Invocation" forState:UIControlStateNormal];
    [btn8 setBackgroundColor:[UIColor blueColor]];
    [btn8 addTarget:self action:@selector(click_NSOperation_InvocationOperation) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn8];
    
    // NSOperation - NSBlockOperation
    UIButton *btn9 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn9.frame = CGRectMake(40 + 100 + 20, 150, 150, 40);
    [btn9 setTitle:@"Operation-Block" forState:UIControlStateNormal];
    [btn9 setBackgroundColor:[UIColor blueColor]];
    [btn9 addTarget:self action:@selector(click_NSOperation_blockOperation) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn9];
    
    // NSOperation - 自定义线程使用
    UIButton *btn10 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn10.frame = CGRectMake(40 + 100 + 20, 200, 150, 40);
    [btn10 setTitle:@"Operation-custom" forState:UIControlStateNormal];
    [btn10 setBackgroundColor:[UIColor blueColor]];
    [btn10 addTarget:self action:@selector(click_NSOperation_custom) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn10];
    
    
    _condition = [[NSCondition alloc] init];
    _lock = [[NSLock alloc] init];
    
    
}

- (void) click_NSOperation_custom {
    
    NSLog(@"主线程线程");
    //NSOperation - 自定义线程  - CustomOperation
    /*
        个人解读：
        所谓的自定义线程就是在继承 NSOperation 之后，在类内部设置好该类要执行的特定任务，也就是说自定线程，自定义的部分就是明确该线程要执行的操作是什么。
     */
    CustomOperation *operation = [[CustomOperation alloc] initWithName:@"自定义线程一"];
    [operation start];
    
}

- (void) click_NSOperation_blockOperation {

    NSLog(@"主线程线程");
    
    //NSOperation - NSBlockOperation
    /*
     
     NSBlockOperation 两种方式存放任务代码
        1：类方法 - blockOperationWithBlock
        2：实例方法 - addExecutionBlock
     
     
     注意事项： 
         1：单独使用 NSBlockOperation 设置一个 addExecutionBlock 不会开启新线程，会在主线程中执行，造成主线程堵塞；
         2：单独使用 NSBlockOperation 中的 addExecutionBlock 方式设置任务时候，任务除在主线程执行之外，还会开启新的子线程来执行其他任务。但还是会造成主线程的堵塞；
         2：创建 NSBlockOperation 对象之后需要手动开启 start ；
         3：此时要结合 NSOperationQueue 组合使用；（衍生出一个问题：GCD , operation 都体现出了线程队列的概念，队列对多线程来说为什么如此重要？）
         4：在和 NSOperationQueue 组合使用时，不用再通过 start 进行开启；
     
     
     推荐实现组合两种： 都不会主线程的堵塞
        第一种 ：
        1 ：NSBlockOperation 实例化一个对象；
        2 ：使用 addExecutionBlock 添加要执行的任务代码；可以添加多个；
        3 ：创建 NSOperationQueue 实例
        4 ：在 NSOperationQueue 实例中添加 NSBlockOperation 实例
        
        优缺点：
        （优点）1：不用创建很多 NSBlockOperation 对象，在一个对象添加多个任务的 block 代码；
        （优点）2：会根据 NSBlockOperation 中添加的 block 块数量开启相应多的子线程执行任务；（需要思考的问题：为什么会根据 block 开启子线程？是不是和 block 的实现原理有关，或者和其特殊属性有关？）
        （缺点）3：通过 NSOperationQueue 的函数 setMaxConcurrentOperationCount 控制并发数是不生效的；
     
     
        第二种 ： 
        1 ：NSBlockOperation 实例化多个对象；
        2 ：在每个 NSBlockOperation 实例对象中设置任务的 block 代码；
        3 ：创建 NSOperationQueue 实例
        4 ：在 NSOperationQueue 实例中添加所有要使用的 NSBlockOperation 实例
        5 ：不要再使用 start 进行启动了
     
        优缺点：
        （优点）1：可以通过 NSOperationQueue 的函数 setMaxConcurrentOperationCount 控制并发数；
        （优点）2：会根据 NSBlockOperation 的 setMaxConcurrentOperationCount 设置数量开启相应多的子线程执行任务；
        （缺点）3：需要为每一个任务的 block 块创建一个 NSBlockOperation 实例；
     */
    
    [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i <= 10 ; i ++) {
            sleep(1);
            NSLog(@"类方法 blockOperation - 当前线程名称：%@ ——%d",[NSThread currentThread].name,i);
        }
    }];
    
    
    NSBlockOperation *blockOperation = [[NSBlockOperation alloc] init];
    blockOperation.name = @"blockOperation";
    [blockOperation addExecutionBlock:^{
        for (int i = 0; i <= 10 ; i ++) {
            sleep(1);
            NSLog(@"blockOperation - 当前线程名称：%@ ——%d",[NSThread currentThread].name,i);
        }
    }];
    [blockOperation addExecutionBlock:^{
        for (int i = 20; i <= 30 ; i ++) {
            sleep(1);
            NSLog(@"blockOperation - 当前线程名称：%@ ——%d",[NSThread currentThread].name,i);
        }
    }];
    [blockOperation addExecutionBlock:^{
        for (int i = 30; i <= 40 ; i ++) {
            sleep(1);
            NSLog(@"blockOperation - 当前线程名称：%@ ——%d",[NSThread currentThread].name,i);
        }
    }];
    
//    [blockOperation start];
    
    
    
    
    NSBlockOperation *blockOperationA = [[NSBlockOperation alloc] init];
    blockOperationA.name = @"blockOperationA";
    [blockOperationA addExecutionBlock:^{
        for (int i = 0; i <= 10 ; i ++) {
            sleep(1);
            NSLog(@"blockOperationA - 当前线程名称：%@ ——%d",[NSThread currentThread].name,i);
        }
    }];
    NSBlockOperation *blockOperationB = [[NSBlockOperation alloc] init];
    blockOperationB.name = @"blockOperationB";
    [blockOperationB addExecutionBlock:^{
        for (int i = 0; i <= 10 ; i ++) {
            sleep(1);
            NSLog(@"blockOperationB - 当前线程名称：%@ ——%d",[NSThread currentThread].name,i);
        }
    }];
    NSBlockOperation *blockOperationC = [[NSBlockOperation alloc] init];
    blockOperationC.name = @"blockOperationC";
    [blockOperationC addExecutionBlock:^{
        for (int i = 0; i <= 10 ; i ++) {
            sleep(1);
            NSLog(@"blockOperationC - 当前线程名称：%@ ——%d",[NSThread currentThread].name,i);
        }
    }];
    
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    [operationQueue setMaxConcurrentOperationCount:2];
    //方式一
    [operationQueue addOperation:blockOperation];

    
    
    //方式二
    //    [operationQueue addOperation:blockOperationA];
    //    [operationQueue addOperation:blockOperationB];
    //    [operationQueue addOperation:blockOperationC];
    
}


- (void) click_NSOperation_InvocationOperation {
    
    NSLog(@"主线程线程");
    
    //NSOperation - NSInvocationOperation
    /*
     NSInvocationOperation ： 可以理解为是一个为 @selector 包装上任务特性，能够在子线程中执行；
     
        注意事项：
        1：单独使用 NSInvocationOperation 不会开启新线程，会在主线程中执行，造成主线程堵塞；
        2：创建 NSInvocationOperation 对象之后需要手动开启 start ；
        3：此时要结合 NSOperationQueue 组合使用；（衍生出一个问题：GCD , operation 都体现出了线程队列的概念，队列对多线程来说为什么如此重要？）
        4：在和 NSOperationQueue 组合使用时，不用再通过 start 进行开启；
     */
    
    NSInvocationOperation *InvocationOperationA = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(run_invocationOperation) object:nil];
    InvocationOperationA.name = @"operation - invocationA";
    
    NSInvocationOperation *InvocationOperationB = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(run_invocationOperation) object:nil];
    InvocationOperationB.name = @"operation - invocationB";
    
    NSInvocationOperation *InvocationOperationC = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(run_invocationOperation) object:nil];
    InvocationOperationC.name = @"operation - invocationC";
    
    NSInvocationOperation *InvocationOperationD = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(run_invocationOperation) object:nil];
    InvocationOperationD.name = @"operation - invocationD";
    
    NSInvocationOperation *InvocationOperationE = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(run_invocationOperation) object:nil];
    InvocationOperationE.name = @"operation - invocationE";
    
    
    //启动任务 ：NSInvocationOperation 在和 NSOperationQueue 组合使用时，不需要使用 start
    //    [InvocationOperationA start];
    //    [InvocationOperationB start];
    //    [InvocationOperationC start];
    //    [InvocationOperationD start];
    
    //NSOperationQueue - 线程队列
    NSOperationQueue *operQueue = [[NSOperationQueue alloc] init];
    
    operQueue.name = @"oper_Queue";   //设置队列名称
    
    [operQueue setMaxConcurrentOperationCount:2]; //设置队列中允许的最大线程并发数
    
    
    //判断任务的执行状态
    if (InvocationOperationA.isExecuting) {
        NSLog(@"InvocationOperationA 是执行");
    }else{
        NSLog(@"InvocationOperationA 还未执行");
    }

    
    /*
     NSOperationQueue - 两种在队列中添加事务的方式；
        1 ： addOperation
        2 ： addOperationWithBlock
     */
    //在队列中添加要执行的操作或者任务；
    [operQueue addOperation:InvocationOperationA];
    [operQueue addOperation:InvocationOperationB];
    [operQueue addOperation:InvocationOperationC];
    [operQueue addOperation:InvocationOperationD];
    [operQueue addOperation:InvocationOperationE];
    
    [operQueue addOperationWithBlock:^{
        for (int i = 0; i <= 10 ; i ++) {
            sleep(1);
            NSLog(@"Block - 当前线程名称：%@ ——%d",[NSThread currentThread].name,i);
        }
    }];
    
}

- (void) run_invocationOperation {
    
    for (int i = 0; i <= 10 ; i ++) {
        sleep(1);
        NSLog(@"当前线程名称：%@ ——%d",[NSThread currentThread].name,i);
    }
    
}


- (void) click_GCD_after {
    
    //GCD - dispatch_after 执行延时操作；——不会堵塞线程
    /*
        参数：
        DISPATCH_TIME_NOW ： 从什么时间开始延时（从当前时间开始延时）
        (int64_t)(20 * NSEC_PER_SEC) ：延时时长（ NSEC_PER_SEC 以秒为单位）
        dispatch_get_main_queue() ： 指定所在的执行队列
     */
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"执行延迟操作");
    });
    
}


- (void) click_GCD_once {
    
    //GCD - dispatch_once 用来实现单例；
    ShareObject *object = [ShareObject initWithName:@"自定义单例"];
    NSLog(@"object = %@", object);
    
    //GCD - 使用 dispatch_once 控制代码只执行一次
    /*
        注意事项：
        1：必须要用 static 进行修饰；
     */
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLog(@"这段代码只会执行一次");
    
    });
    
}

- (void) click_GCD_group {
    
    
    NSLog(@"开始gcd_group");
    
    // dispatch_group_t ：线程组
    
    
    //GCD - 解决场景：执行完多个任务之后才执行某一任务
    
//    dispatch_queue_t queue = dispatch_queue_create("queue.group", NULL); //一个串行队列
    /*
        执行结果：
     
        情况一：线程组添加到串行队列中；
        1：系统会开辟一条新的线程；
        2：在线程组中异步任务（异步任务中的代码都是同步执行的代码）会在新开辟的线程中 按照顺序依次进行执行；
        3：在dispatch_group_notify监听到回调之后，此时还在子线程中；
        4：不会造成主线程堵塞；
     
        情况二：线程组添加到并行队列中
        1：系统会为每个异步任务开辟一条子线程；
        2：每个任务在开辟的子线程中执行；
        3：在dispatch_group_notify监听到回调之后，此时还在某条子线程中；
        4：不会造成主线程堵塞；
     */
    /*
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
    */
    //GCD - 解决场景：执行完多个异步任务之后才执行某一任务 （举例：在异步任务中发起多个获取网络图片的异步请求，等到图片都获取成功之后再进行UI界面的刷新）
    /*
        这种问题使用 dispatch_group_enter(grpupT);来解决，dispatch_group_enter 和 dispatch_group_leave 必须要成对出现；
        dispatch_group_enter ： 使用一种手动的方式将另外一个 block 以不同于 dispatch_group_async 的方式添加到线程组中。
        dispatch_group_leave ： 手动指示一个 block 块执行完毕。以一种不用于 dispatch_group_async 的方式离开线程组
     */
    dispatch_queue_t queueT = dispatch_queue_create("group.queue", DISPATCH_QUEUE_CONCURRENT);//一个并发队列
    dispatch_group_t grpupT = dispatch_group_create();//一个线程组
    
    dispatch_group_async(grpupT, queueT, ^{
        NSLog(@"group——当前线程一");
        //模仿网络请求代码
        dispatch_group_enter(grpupT);
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            for (int i = 0; i < 10; i++) {
                [NSThread sleepForTimeInterval:1];
                NSLog(@"网络图片请求中 ···%d", i);
            }
            dispatch_group_leave(grpupT);
        });
        
    });
    
    dispatch_group_async(grpupT, queueT, ^{
        NSLog(@"group——当前线程二");
        //模仿网络请求代码
        dispatch_group_enter(grpupT);
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            for (int i = 0; i < 10; i++) {
                [NSThread sleepForTimeInterval:1];
                NSLog(@"网络图片2请求中 ···2_%d", i);
            }
            dispatch_group_leave(grpupT);
        });
        
    });
    
    dispatch_group_async(grpupT, queueT, ^{
        NSLog(@"group——当前线程三");
        //模仿网络请求代码
        dispatch_group_enter(grpupT);
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            for (int i = 0; i < 10; i++) {
                [NSThread sleepForTimeInterval:1];
                NSLog(@"网络图片3请求中 ···3_%d", i);
            }
             dispatch_group_leave(grpupT);
        });
       
    });
    
    
    dispatch_group_notify(grpupT, queueT, ^{
        
        NSLog(@"此时还是在子线程中");
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"回到主线程");
        });
        
    });
    
    
    //NSOperation - 自定义使用实现子线程操作 - 同步任务
    
    //NSOperation - 自定义使用实现子线程操作 - 异步任务
    
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
