//
//  ViewController.m
//  01-pthread
//
//  Created by 李正林 on 2019/3/12.
//  Copyright © 2019 李正林. All rights reserved.
//

#import "ViewController.h"
#import <pthread.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    // 创建线程
    pthread_t myRestrict;
    pthread_create(&myRestrict, NULL, run, NULL);
}

void *run(void *data) {
    
    for (NSInteger i = 0; i < 10000; i++) {
        NSLog(@"touchesBegan----%ld-----%@", i, [NSThread currentThread]);
    }
    return NULL;
}


@end
