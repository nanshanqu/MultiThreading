//
//  ViewController.m
//  02-NSThread
//
//  Created by Mac on 2020/4/15.
//  Copyright © 2020 Mac. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
//    [self createThread1];
//    [self createThread2];
    [self createThread3];
}

- (void)downloadWithUrlString:(NSString *)urlString {
    
    NSLog(@"download---%@---%@", urlString, [NSThread currentThread]);
}

/// 创建线程的方式1
- (void)createThread1 {
    
    // 创建线程
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(downloadWithUrlString:) object:@"http://a.png"];
    thread.name = @"下载线程";
    
    // 启动线程（调用self的downloadWithUrlString方法）
    [thread start];
}

/// 创建线程的方式2
- (void)createThread2 {
    
//    [NSThread detachNewThreadWithBlock:^{
//
//        NSLog(@"---%@---", [NSThread currentThread]);
//    }];
    [NSThread detachNewThreadSelector:@selector(downloadWithUrlString:) toTarget:self withObject:@"http://b.png"];
}

/// 创建线程的方式3
- (void)createThread3 {
    
    // 这两个不会创建线程，只在当前线程中执行
//    [self performSelector:@selector(downloadWithUrlString:) withObject:@"http://c.gif"];
//    [self downloadWithUrlString:@"http://c.gif"];

    [self performSelectorInBackground:@selector(downloadWithUrlString:) withObject:@"http://c.gif"];
}


@end
