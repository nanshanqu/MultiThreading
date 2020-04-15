//
//  ViewController.m
//  07-线程间的通信
//
//  Created by 李正林 on 2019/3/12.
//  Copyright © 2019 李正林. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
//    [self useNSThread];
//    [self useGCD];
    [self useNSOperationQueue];
}

- (void)useNSThread {
    
    [self performSelectorInBackground:@selector(download) withObject:nil];
}

/**
 *  下载图片
 */
- (void)download
{
    NSLog(@"download---%@", [NSThread currentThread]);
    // 1.图片地址
    NSString *urlStr = @"http://www.cjguanghua.com/uploadfile/2015/13/14271670023104.jpg";
    NSURL *url = [NSURL URLWithString:urlStr];
    
    // 2.根据地址下载图片的二进制数据(这句代码最耗时)
    NSLog(@"---begin");
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSLog(@"---end");
    
    // 3.设置图片
    UIImage *image = [UIImage imageWithData:data];
    
    // 4.回到主线程，刷新UI界面(为了线程安全)
    [self performSelectorOnMainThread:@selector(downloadFinished:) withObject:image waitUntilDone:NO];
    //    [self performSelector:@selector(downloadFinished:) onThread:[NSThread mainThread] withObject:image waitUntilDone:YES];
    //    [self.imageView performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:YES];
    
    NSLog(@"-----done----");
}

- (void)downloadFinished:(UIImage *)image
{
    self.imageView.image = image;
    
    NSLog(@"downloadFinished---%@", [NSThread currentThread]);
}


- (void)useGCD {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"donwload---%@", [NSThread currentThread]);
        // 1.子线程下载图片
        NSURL *url = [NSURL URLWithString:@"http://www.cjguanghua.com/uploadfile/2015/13/14271670023104.jpg"];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:data];
        
        // 2.回到主线程设置图片
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"setting---%@ %@", [NSThread currentThread], image);
            self.imageView.image = image;
        });
    });
}

- (void)useNSOperationQueue {
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperationWithBlock:^{
        
        // 1.异步下载图片
        NSURL *url = [NSURL URLWithString:@"http://www.cjguanghua.com/uploadfile/2015/13/14271670023104.jpg"];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:data];
        
        // 2.回到主线程，显示图片
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.imageView.image = image;
        }];
    }];
}


@end
