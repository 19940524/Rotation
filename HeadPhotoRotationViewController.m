//
//  HeadPhotoRotationViewController.m
//  HeadPhotoRotation
//
//  Created by Li Pan on 14-1-9.
//  Copyright (c) 2014年 Pan Li. All rights reserved.
//

#import "HeadPhotoRotationViewController.h"
#import "CustomImageView.h"

@interface HeadPhotoRotationViewController () {
    dispatch_source_t _timerSource;
}

@property (strong, nonatomic) UIButton *tapButton;
@property (nonatomic,retain) CustomImageView *headImageView;
@end

@implementation HeadPhotoRotationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view. backgroundColor = [UIColor grayColor];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 头像
    _headImageView = [[CustomImageView alloc] init];
    _headImageView.backgroundColor = [UIColor clearColor];
    _headImageView.frame = CGRectMake(100, 300, 100, 100);
    _headImageView.layer.cornerRadius = 50.0;
    _headImageView.layer.borderWidth = 1.0;
    _headImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    _headImageView.layer.masksToBounds = YES;
//    _headImageView.image = [UIImage imageNamed:@"head1.jpg"];
    [self.view addSubview:_headImageView];
    
	UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(100, 100, 100, 100);
    [btn setTitle:@"点击旋转" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:btn];
    self.tapButton = btn;
    [btn addTarget:self action:@selector(actionRotation:) forControlEvents:UIControlEventTouchUpInside];
    
    
    __block int tempIndex = 0;
    __block BOOL isOnTheBack = NO;
    dispatch_queue_t queue = dispatch_queue_create("timerQueue", 0);
    _timerSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    double interval = 1 * NSEC_PER_SEC;
    dispatch_source_set_timer(_timerSource, dispatch_time(DISPATCH_TIME_NOW, 0), interval, 0);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        
        dispatch_source_set_event_handler(_timerSource, ^{
            NSLog(@"index = %d",tempIndex);
            ++tempIndex;
            if (tempIndex == 2) {
                tempIndex = 0;
                dispatch_async(dispatch_get_main_queue(), ^{
                    _headImageView.isOnTheBack = !isOnTheBack;
                    //    _headImageView.layer.transform = CATransform3DMakeRotation(0, 0, 0, 0);
                    [UIView animateWithDuration:0.5 animations:^{
                        _headImageView.layer.transform = CATransform3DMakeRotation(radians(90), 1, 0, 0);
                    } completion:^(BOOL finished) {
                        [_headImageView setNeedsDisplay];
                        [UIView animateWithDuration:0.4 animations:^{
                            _headImageView.layer.transform = CATransform3DMakeRotation(radians(180), 1, 0, 0);
                        }];
                    }];
                    isOnTheBack = !isOnTheBack;
                });
            }
        });
        dispatch_resume(_timerSource);
    });
}

// 角度转弧度
double radians(float degrees) {
    return ( degrees * M_PI ) / 180.0;
}

- (void)actionRotation:(UIButton *)button
{
    if (button.selected) {
        button.selected = NO;
        dispatch_resume(_timerSource);
    } else {
        button.selected = YES;
        dispatch_suspend(_timerSource);   // 挂起 -> 还在
    }
//    dispatch_source_cancel(_timerSource); // 取消这个事件 -> 销毁它之前必须要恢复
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
