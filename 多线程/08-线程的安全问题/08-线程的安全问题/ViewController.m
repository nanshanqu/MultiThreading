//
//  ViewController.m
//  08-线程的安全问题
//
//  Created by 李正林 on 2019/3/12.
//  Copyright © 2019 李正林. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) NSThread * thread1;
@property (nonatomic, strong) NSThread * thread2;
@property (nonatomic, strong) NSThread * thread3;

@property (nonatomic, assign) NSInteger totalTicketCount;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.totalTicketCount = 50;
    
    self.thread1 = [[NSThread alloc] initWithTarget:self selector:@selector(saleTicket) object:nil];
    self.thread1.name = @"1号窗口";
    
    self.thread2 = [[NSThread alloc] initWithTarget:self selector:@selector(saleTicket) object:nil];
    self.thread2.name = @"2号窗口";
    
    self.thread3 = [[NSThread alloc] initWithTarget:self selector:@selector(saleTicket) object:nil];
    self.thread3.name = @"3号窗口";
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if (self.totalTicketCount <= 0) return;
    
    [self.thread1 start];
    [self.thread2 start];
    [self.thread3 start];
}

/**
 卖票
 */
- (void)saleTicket {
    
    while (1) {
        
         // ()小括号里面放的是锁对象
        @synchronized (self) {  // 开始加锁
            
            NSInteger leftTicketCount = self.totalTicketCount;
            
            if (leftTicketCount > 0) {
                
                [NSThread sleepForTimeInterval:0.05];
                self.totalTicketCount = leftTicketCount - 1;
                NSLog(@"%@卖了一张票, 剩余%ld张票", [NSThread currentThread].name, self.totalTicketCount);
                
            }else{
                
                return; // 退出循环
            }
        } // 解锁
    }
}


@end
