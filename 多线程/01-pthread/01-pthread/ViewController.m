//
//  ViewController.m
//  01-pthread
//
//  Created by Mac on 2020/4/15.
//  Copyright © 2020 Mac. All rights reserved.
//

#import "ViewController.h"
#import <pthread.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
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
