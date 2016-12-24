//
//  SMSCodeView.m
//  xiaofu
//
//  Created by HNF's wife on 2016/12/2.
//  Copyright © 2016年 huangningfa@163.com. All rights reserved.
//

#import "SMSCodeView.h"
#import "UIView+Extension.h"
#import "XFConfig.h"

@implementation SMSCodeView
{
    UIActivityIndicatorView * activityView;
}

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = RGB(242, 148, 148);
        //self.layer.masksToBounds=YES;
        self.layer.cornerRadius=5;
        [self addTarget:self action:@selector(setExcuting) forControlEvents:(UIControlEventTouchUpInside)];
        [self setTitle:@"获取验证码" forState:(UIControlStateNormal)];
        self.titleLabel.font = FontSize(14);
        self.layer.anchorPoint = CGPointMake(1, 1);
    }
    return self;
}

// 获取验证码
- (void)setExcuting {
    self.userInteractionEnabled = NO;
    [self setTitle:@"" forState:(UIControlStateNormal)];
    [self initActivityView];
}

// 进入倒计时
- (void)setCounting {
    [activityView stopAnimating];
    activityView.hidden = YES;
    
    [self startAnimation];
    [self startTimer];
}

- (void)backToOriginal {
    [activityView stopAnimating];
    activityView.hidden = YES;
    self.userInteractionEnabled = YES;
    [self setTitle:@"获取验证码" forState:(UIControlStateNormal)];
}

- (void)startAnimation {
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.x += self.width/2;
        self.width -= self.width/2;
    } completion:^(BOOL finished) {
        
    }];
}

-(void)initActivityView
{
    if (!activityView) {
        activityView  = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [self addSubview:activityView];
    }
    [activityView startAnimating];
    activityView.hidden = NO;
    NSLog(@"%ld", self.subviews.count);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat x = self.frame.size.width/2 - self.frame.size.height/2;
    CGFloat y = 0;

    activityView.frame = CGRectMake(x, y, self.frame.size.height, self.frame.size.height);
}

- (void)setupCountingState:(NSString *)timeSec {
    [self setTitle:timeSec forState:(UIControlStateNormal)];
}

- (void)settupNormalState {
    self.userInteractionEnabled = YES;
    [self setTitle:@"获取验证码" forState:(UIControlStateNormal)];
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.x -= self.width;
        self.width += self.width;
        
    } completion:^(BOOL finished) {
        //self.transform = CGAffineTransformIdentity;
    }];
}

- (void)startTimer {
    self.userInteractionEnabled = NO;
    __block int timeout = 60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,DISPATCH_TIME_NOW,1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0)
        { //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 返回正常状态
                [self settupNormalState];
            });
        }
        else
        {   // int minutes = timeout / 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d'", timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 倒计时
                [self setupCountingState:strTime];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

@end
