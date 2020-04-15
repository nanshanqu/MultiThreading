//
//  ViewController.m
//  06-NSOperationQueue
//
//  Created by 李正林 on 2019/3/12.
//  Copyright © 2019 李正林. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDelegate>

@end

@implementation ViewController

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
//    [self dependency];
    [self maxCount];
}

- (void)dependency {
    
    /**
     假设有A、B、C三个操作，要求：
     1. 3个操作都异步执行
     2. 操作C依赖于操作B
     3. 操作B依赖于操作A
     */
    
    // 1.创建一个队列（非主队列）
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    // 2.创建3个操作
    NSBlockOperation *operationA = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"A1---%@", [NSThread currentThread]);
    }];
    
//    [operationA addExecutionBlock:^{
//
//        NSLog(@"A2---%@", [NSThread currentThread]);
//    }];
//
//    [operationA setCompletionBlock:^{
//
//        NSLog(@"AAAAA---%@", [NSThread currentThread]);
//    }];
    
    NSBlockOperation *operationB = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"B---%@", [NSThread currentThread]);
    }];
    NSBlockOperation *operationC = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"C---%@", [NSThread currentThread]);
    }];
    
    // 设置依赖
    [operationB addDependency:operationA];
    [operationC addDependency:operationB];
    
    // 3.添加操作到队列中（自动异步执行任务）
    [queue addOperation:operationC];
    [queue addOperation:operationA];
    [queue addOperation:operationB];
}

- (void)maxCount {
    
    // 1.创建一个队列（非主队列）
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    // 2.设置最大并发(最多同时并发执行3个任务)
    queue.maxConcurrentOperationCount = 3;
    
    // 3.添加操作到队列中（自动异步执行任务，并发）
    NSBlockOperation *operation1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"下载图片1---%@", [NSThread currentThread]);
    }];
    NSBlockOperation *operation2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"下载图片2---%@", [NSThread currentThread]);
    }];
    NSBlockOperation *operation3 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"下载图片3---%@", [NSThread currentThread]);
    }];
    NSBlockOperation *operation4 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"下载图片4---%@", [NSThread currentThread]);
    }];
    NSInvocationOperation *operation5 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(download) object:nil];
    
    [queue addOperation:operation1];
    [queue addOperation:operation2];
    [queue addOperation:operation3];
    [queue addOperation:operation4];
    [queue addOperation:operation5];
    [queue addOperationWithBlock:^{
        NSLog(@"下载图片5---%@", [NSThread currentThread]);
    }];
    [queue addOperationWithBlock:^{
        NSLog(@"下载图片6---%@", [NSThread currentThread]);
    }];
    [queue addOperationWithBlock:^{
        NSLog(@"下载图片7---%@", [NSThread currentThread]);
    }];
    [queue addOperationWithBlock:^{
        NSLog(@"下载图片8---%@", [NSThread currentThread]);
    }];
    [queue addOperationWithBlock:^{
        NSLog(@"下载图片9---%@", [NSThread currentThread]);
    }];
    
//    [queue cancelAllOperations];
}

- (void)download
{
    NSLog(@"download---%@", [NSThread currentThread]);
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
//    [queue cancelAllOperations]; // 取消队列中的所有任务（不可恢复）
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
//    [queue setSuspended:YES]; // 暂停队列中的所有任务
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
//    [queue setSuspended:NO]; // 恢复队列中的所有任务
}


@end
