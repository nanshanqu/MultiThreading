//
//  ViewController.m
//  04-队列组
//
//  Created by 李正林 on 2019/3/12.
//  Copyright © 2019 李正林. All rights reserved.
//

// 1.分别下载2张图片：大图片、LOGO
// 2.合并2张图片
// 3.显示到一个imageView身上

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) UIImage *image1;
@property (nonatomic, strong) UIImage *image2;

@end

@implementation ViewController

// 2D绘图  Quartz2D
// 合并图片 -- 水印

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
//    [self mergedImages1];
//    [self mergedImages2];
    [self mergedImages3];
}

- (void)mergedImages1 {
    
    // 异步下载
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // 1.下载第1张
        UIImage *image1 = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://img.zcool.cn/community/016aae57790f8b0000012e7eda8b37.jpg@1280w_1l_2o_100sh.jpg"]]];
        
        // 2.下载第2张
        UIImage *image2 = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1552366746665&di=a998e4ce7e3a78b83e35a2e85ebda2a2&imgtype=0&src=http%3A%2F%2Fe.hiphotos.baidu.com%2Fzhidao%2Fpic%2Fitem%2Fc75c10385343fbf29692a762bb7eca8065388f30.jpg"]]];
        
        // 3.合并图片
        // 开启一个位图上下文
        UIGraphicsBeginImageContextWithOptions(image1.size, NO, 0.0);
        
        // 绘制第1张图片
        CGFloat image1W = image1.size.width;
        CGFloat image1H = image1.size.height;
        [image1 drawInRect:CGRectMake(0, 0, image1W, image1H)];
        
        // 绘制第2张图片
        CGFloat image2W = image2.size.width;
        CGFloat image2H = image2.size.height * 0.5;
        CGFloat image2Y = image1H * 0.5;
        [image2 drawInRect:CGRectMake(0, image2Y, image2W, image2H)];
        
        // 得到上下文中的图片
        UIImage *fullImage = UIGraphicsGetImageFromCurrentImageContext();
        
        // 结束上下文
        UIGraphicsEndImageContext();
        
        // 4.回到主线程显示图片
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = fullImage;
        });
    });
}

- (void)mergedImages2 {
    
    // 异步下载
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // 1.下载第1张
        UIImage *image1 = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://img.zcool.cn/community/016aae57790f8b0000012e7eda8b37.jpg@1280w_1l_2o_100sh.jpg"]]];
        self.image1 = image1;
        
        [self bindImages];
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // 2.下载第2张
        UIImage *image2 = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1552366746665&di=a998e4ce7e3a78b83e35a2e85ebda2a2&imgtype=0&src=http%3A%2F%2Fe.hiphotos.baidu.com%2Fzhidao%2Fpic%2Fitem%2Fc75c10385343fbf29692a762bb7eca8065388f30.jpg"]]];
        self.image2 = image2;
        
        [self bindImages];
    });
}

- (void)bindImages {
    
    if (self.image1 == nil || self.image2 == nil) return;
    
    // 3.合并图片
    // 开启一个位图上下文
    UIGraphicsBeginImageContextWithOptions(self.image1.size, NO, 0.0);
    
    // 绘制第1张图片
    CGFloat image1W = self.image1.size.width;
    CGFloat image1H = self.image1.size.height;
    [self.image1 drawInRect:CGRectMake(0, 0, image1W, image1H)];
    
    // 绘制第2张图片
    CGFloat image2W = self.image2.size.width;
    CGFloat image2H = self.image2.size.height * 0.5;
    CGFloat image2Y = image1H * 0.5;
    [self.image2 drawInRect:CGRectMake(0, image2Y, image2W, image2H)];
    
    // 得到上下文中的图片
    UIImage *fullImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 结束上下文
    UIGraphicsEndImageContext();
    
    // 4.回到主线程显示图片
    dispatch_async(dispatch_get_main_queue(), ^{
        self.imageView.image = fullImage;
    });
}

- (void)mergedImages3 {
    
    // 1.队列组
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    // 2.下载图片1
    __block UIImage *image1 = nil;
    dispatch_group_async(group, queue, ^{
        
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://img.zcool.cn/community/016aae57790f8b0000012e7eda8b37.jpg@1280w_1l_2o_100sh.jpg"]]];
        image1 = image;
    });
    
    // 3.下载图片2
    __block UIImage *image2 = nil;
    dispatch_group_async(group, queue, ^{
        
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1552366746665&di=a998e4ce7e3a78b83e35a2e85ebda2a2&imgtype=0&src=http%3A%2F%2Fe.hiphotos.baidu.com%2Fzhidao%2Fpic%2Fitem%2Fc75c10385343fbf29692a762bb7eca8065388f30.jpg"]]];
        image2 = image;
    });
    
    // 4.合并图片 (保证执行完组里面的所有任务之后，再执行notify函数里面的block)
    dispatch_group_notify(group, queue, ^{
        
        // 开启一个位图上下文
        UIGraphicsBeginImageContextWithOptions(image1.size, NO, 0.0);
        
        // 绘制第1张图片
        CGFloat image1W = image1.size.width;
        CGFloat image1H = image1.size.height;
        [image1 drawInRect:CGRectMake(0, 0, image1W, image1H)];
        
        // 绘制第2张图片
        CGFloat image2W = image2.size.width;
        CGFloat image2H = image2.size.height * 0.5;
        CGFloat image2Y = image1H * 0.5;
        [image2 drawInRect:CGRectMake(0, image2Y, image2W, image2H)];
        
        // 得到上下文中的图片
        UIImage *fullImage = UIGraphicsGetImageFromCurrentImageContext();
        
        // 结束上下文
        UIGraphicsEndImageContext();
        
        // 5.回到主线程显示图片
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = fullImage;
        });
    });
}


@end
