//
//  ViewController.m
//  02-NSThread
//
//  Created by 李正林 on 2019/3/12.
//  Copyright © 2019 李正林. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)downloadWithUrlString:(NSString *)urlString {
    
    NSLog(@"download---%@---%@", urlString, [NSThread currentThread]);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
//    [self createThread1];
//    [self createThread2];
    [self createThread3];
}

/**
 创建线程的方式1
 */
- (void)createThread1 {
    
    // 创建线程
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(downloadWithUrlString:) object:@"http://b.png"];
    thread.name = @"下载线程";
    
    // 启动线程（调用self的download方法）
    [thread start];
}

/**
 创建线程的方式2
 */
- (void)createThread2 {
    
//    [NSThread detachNewThreadWithBlock:^{
//
//        NSLog(@"---%@---", [NSThread currentThread]);
//    }];
    [NSThread detachNewThreadSelector:@selector(downloadWithUrlString:) toTarget:self withObject:@"http://a.png"];
}

/**
 创建线程的方式3
 */
- (void)createThread3 {
    
    // 这2个不会创建线程，在当前线程中执行
//    [self performSelector:@selector(downloadWithUrlString:) withObject:@"http://c.gif"];
//    [self downloadWithUrlString:@"http://c.gif"];
//
    [self performSelectorInBackground:@selector(downloadWithUrlString:) withObject:@"http://c.gif"];
}



@end
