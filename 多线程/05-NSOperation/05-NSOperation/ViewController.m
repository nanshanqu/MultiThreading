//
//  ViewController.m
//  05-NSOperation
//
//  Created by 李正林 on 2019/3/12.
//  Copyright © 2019 李正林. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
//    [self createNSInvocationOperation];
//    [self createNSBlockOperation1];
    [self createNSBlockOperation2];
}

- (void)createNSInvocationOperation {
    
    // 创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
     // 创建操作
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(download) object:nil];
    // operation直接调用start，是同步执行（在当前线程执行操作）
//    [operation start];
    
    // 添加操作到队列中，会自动异步执行
    [queue addOperation:operation];
}

- (void)download {
    
    NSLog(@"download-----%@", [NSThread currentThread]);
}

- (void)createNSBlockOperation1 {
    
//    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
//
//        NSLog(@"---下载图片----1---%@", [NSThread currentThread]);
//    }];
    
    NSBlockOperation *operation = [[NSBlockOperation alloc] init];
    
    [operation addExecutionBlock:^{
        
        NSLog(@"---下载图片----1---%@", [NSThread currentThread]);
    }];
    
    [operation addExecutionBlock:^{
        
        NSLog(@"---下载图片----2---%@", [NSThread currentThread]);
    }];
    
    [operation addExecutionBlock:^{
        
        NSLog(@"---下载图片----3---%@", [NSThread currentThread]);
    }];
    
    [operation start];
    // 同步执行
}

- (void)createNSBlockOperation2 {
    
    NSBlockOperation *operation1 = [NSBlockOperation blockOperationWithBlock:^{
        
        NSLog(@"---下载图片----11---%@", [NSThread currentThread]);
    }];
    
    [operation1 addExecutionBlock:^{
        
        NSLog(@"---下载图片----12---%@", [NSThread currentThread]);
    }];
    
    NSBlockOperation *operation2 = [NSBlockOperation blockOperationWithBlock:^{
        
        NSLog(@"---下载图片----2---%@", [NSThread currentThread]);
    }];
    
    NSBlockOperation *operation3 = [NSBlockOperation blockOperationWithBlock:^{
        
        NSLog(@"---下载图片----3---%@", [NSThread currentThread]);
    }];
    
    NSBlockOperation *operation4 = [NSBlockOperation blockOperationWithBlock:^{
        
        NSLog(@"---下载图片----4---%@", [NSThread currentThread]);
    }];
    
    // 1.创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    // 主队列
//    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    
    // 2.添加操作到队列中（自动异步执行）
    [queue addOperation:operation1];
    [queue addOperation:operation2];
    [queue addOperation:operation3];
    [queue addOperation:operation4];
}


@end
