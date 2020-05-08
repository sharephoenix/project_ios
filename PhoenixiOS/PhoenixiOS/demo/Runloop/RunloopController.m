//
//  RunloopController.m
//  PhoenixiOS
//
//  Created by phoenix on 2020/5/8.
//  Copyright © 2020 apple. All rights reserved.
//

#import "RunloopController.h"

@interface RunloopController ()

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) NSThread *thread;
@property (strong, nonatomic) UIScrollView *scrollView;
@end

@implementation RunloopController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    [self createUI];
//    [self showDemo1];
//    [self showDemo2];
    [self showDemo3];
}

- (void)createUI {
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.scrollView];
    self.imageView.frame = CGRectMake(100, 100, 99, 99);
    self.scrollView.frame = CGRectMake(100, 200, 99, 99);
    self.scrollView.contentSize = CGSizeMake(199, 199);
}

/**
 * 用来展示CFRunLoopObserverRef使用
 */
- (void)showDemo1 {
    // 创建观察者
    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(CFAllocatorGetDefault(), kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        switch (activity) {
            case kCFRunLoopEntry:
                NSLog(@"kCFRunLoopEntry");
                break;
            case kCFRunLoopBeforeTimers:
                NSLog(@"kCFRunLoopBeforeTimers");
                break;
            case kCFRunLoopBeforeSources:
                NSLog(@"kCFRunLoopBeforeSources");
                break;
            case kCFRunLoopBeforeWaiting:
                NSLog(@"kCFRunLoopBeforeWaiting");
                break;
            case kCFRunLoopAfterWaiting:
                NSLog(@"kCFRunLoopAfterWaiting");
                break;
            case kCFRunLoopExit:
                NSLog(@"kCFRunLoopAfterWaiting");
                break;
            case kCFRunLoopAllActivities:
                NSLog(@"kCFRunLoopAfterWaiting");
                break;
            default:
                NSLog(@"监听到RunLoop发生改变:::%zd",activity);
                break;
        }
    });

    // 添加观察者到当前RunLoop中
    CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, kCFRunLoopDefaultMode);

    // 释放observer
    CFRelease(observer);
}

/// 不同 Mode 下运行
- (void)showDemo2 {
    // 定义一个定时器，约定两秒之后调用self的run方法
    NSTimer *timer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(run) userInfo:nil repeats:YES];

    // 将定时器添加到当前RunLoop的NSDefaultRunLoopMode下,一旦RunLoop进入其他模式，定时器timer就不工作了
//    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];

    // 将定时器添加到当前RunLoop的UITrackingRunLoopMode下，只在拖动情况下工作
//    [[NSRunLoop currentRunLoop] addTimer:timer forMode:UITrackingRunLoopMode];

    // 将定时器添加到当前RunLoop的NSRunLoopCommonModes下，定时器就会跑在被标记为Common Modes的模式下
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];

    // 调用了scheduledTimer返回的定时器，已经自动被加入到了RunLoop的NSDefaultRunLoopMode模式下。
//    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(run) userInfo:nil repeats:YES];
}

- (void)run {
    NSLog(@"---run");

}

/**
 * 用来展示UIImageView的延迟显示, UIScrollview 滚动的时(UITrackingRunLoopMode 下) 不加载图片，优化图片加载卡顿
 */
- (void)showDemo3 {
    [self.imageView performSelector:@selector(setImage:) withObject:[UIImage imageNamed:@"face_002"] afterDelay:4.0 inModes:@[NSDefaultRunLoopMode]];
}

- (void)showDemo4 {
    // 创建线程，并调用run1方法执行任务
    self.thread = [[NSThread alloc] initWithTarget:self selector:@selector(run1) object:nil];
    [self.thread start];
}

- (void) run1
{
    // 这里写任务
    NSLog(@"----run1-----%@",[NSThread currentThread]);

    [[NSRunLoop currentRunLoop] addPort:[NSPort port] forMode:NSDefaultRunLoopMode];

    [[NSRunLoop currentRunLoop] run];

    // 测试是否开启了RunLoop，如果开启RunLoop，则来不了这里，因为RunLoop开启了循环。
    NSLog(@"-------------");
}

-(UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.backgroundColor = UIColor.lightGrayColor;
    }
    return _imageView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        _scrollView.backgroundColor = UIColor.yellowColor;
    }
    return _scrollView;
}
@end
