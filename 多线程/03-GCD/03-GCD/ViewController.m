//
//  ViewController.m
//  03-GCD
//
//  Created by Mac on 2020/4/15.
//  Copyright © 2020 Mac. All rights reserved.
//

/*
  dispatch_sync : 同步，不具备开启线程的能力
  dispatch_async : 异步，具备开启线程的能力

  并发队列 ：多个任务可以同时执行
  串行队列 ：一个任务执行完后，再执行下一个任务

  Foundation :  OC
  Core Foundation : C语言
  Foundation和Core Foundation框架的数据类型可以互相转换的

 NSString *str = @"123"; // Foundation
 CFStringRef str2 = (__bridge CFStringRef)str; // Core Foundation
 NSString *str3 = (__bridge NSString *)str2;
     CFArrayRef ---- NSArray
     CFDictionaryRef ---- NSDictionary
     CFNumberRef ---- NSNumber

  Core Foundation中手动创建的数据类型，都需要手动释放
     CFArrayRef array = CFArrayCreate(NULL, NULL, 10, NULL);
     CFRelease(array);


     CGPathRef path = CGPathCreateMutable();
     CGPathRetain(path);

     CGPathRelease(path);
     CGPathRelease(path);
 
 凡是函数名中带有create\copy\new\retain等字眼, 都应该在不需要使用这个数据的时候进行release
 GCD的数据类型在ARC环境下不需要再做release
 CF(Core Foundation)的数据类型在ARC\MRC环境下都需要再做release
 */

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
//    [self asyncGlobalQueue];
//    [self asyncSerialQueue];
//    [self asyncMainQueue];
//    [self syncMainQueue];
//    [self syncGlobalQueue];
    [self syncSerialQueue];
}

/**
 *  async -- 并发队列（最常用）
 *  会不会创建线程：会，一般同时开多条
 *  任务的执行方式：并发执行
 */
- (void)asyncGlobalQueue {
    
    // 获得全局的并发队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    // 将 任务 添加 全局队列 中去 异步 执行
    dispatch_async(queue, ^{
        NSLog(@"-----下载图片1---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"-----下载图片2---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"-----下载图片3---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"-----下载图片4---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"-----下载图片5---%@", [NSThread currentThread]);
    });
}

/**
 *  async -- 串行队列（有时候用）
 *  会不会创建线程：会，一般只开1条线程
 *  任务的执行方式：串行执行（一个任务执行完毕后再执行下一个任务）
 */
- (void)asyncSerialQueue {
    
    // 1.创建一个串行队列
    dispatch_queue_t queue = dispatch_queue_create("com.asliving.queue", NULL);
    
    // 2.将任务添加到串行队列中 异步 执行
    dispatch_async(queue, ^{
        NSLog(@"-----下载图片1---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"-----下载图片2---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"-----下载图片3---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"-----下载图片4---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"-----下载图片5---%@", [NSThread currentThread]);
    });
    
    // 3.非ARC，需要释放创建的队列
    //    dispatch_release(queue);
}

/**
 *  async -- 主队列(很常用)
 */
- (void)asyncMainQueue {
    
    // 1.主队列(添加到主队列中的任务，都会自动放到主线程中去执行)
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    // 2.添加 任务 到主队列中 异步 执行
    dispatch_async(queue, ^{
        NSLog(@"-----下载图片1---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"-----下载图片2---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"-----下载图片3---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"-----下载图片4---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"-----下载图片5---%@", [NSThread currentThread]);
    });
}

/**
 *  sync -- 主队列(不能用---会卡死)
 */
- (void)syncMainQueue {
    
    NSLog(@"syncMainQueue----begin--");
    
    // 1.主队列(添加到主队列中的任务，都会自动放到主线程中去执行)
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    // 2.添加 任务 到主队列中 异步 执行
    dispatch_sync(queue, ^{
        NSLog(@"-----下载图片1---%@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"-----下载图片2---%@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"-----下载图片3---%@", [NSThread currentThread]);
    });
    
    NSLog(@"syncMainQueue----end--");
}


/**----------------------华丽的分割线-------------------------**/


/**
 *  sync -- 并发队列
 *  会不会创建线程：不会
 *  任务的执行方式：串行执行（一个任务执行完毕后再执行下一个任务）
 *  并发队列失去了并发的功能
 */
- (void)syncGlobalQueue {
    
    // 获得全局的并发队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    // 将 任务 添加到 全局并发队列 中 同步 执行
    dispatch_sync(queue, ^{
        NSLog(@"-----下载图片1---%@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"-----下载图片2---%@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"-----下载图片3---%@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"-----下载图片4---%@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"-----下载图片5---%@", [NSThread currentThread]);
    });
}

/**
 *  sync -- 串行队列
 *  会不会创建线程：不会
 *  任务的执行方式：串行执行（一个任务执行完毕后再执行下一个任务）
 */
- (void)syncSerialQueue {
    
    // 创建一个串行队列
    dispatch_queue_t queue = dispatch_queue_create("cn.heima.queue", NULL);
    
    // 将 任务 添加到 串行队列 中 同步 执行
    dispatch_sync(queue, ^{
        NSLog(@"-----下载图片1---%@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"-----下载图片2---%@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"-----下载图片3---%@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"-----下载图片4---%@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"-----下载图片5---%@", [NSThread currentThread]);
    });
}


@end
