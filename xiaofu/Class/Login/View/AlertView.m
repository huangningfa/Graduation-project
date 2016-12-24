//
//  AlertView.m
//  xiaofu
//
//  Created by HNF's wife on 16/7/26.
//  Copyright © 2016年 HNF's wife. All rights reserved.
//

#import "AlertView.h"
#import "XFConfig.h"

#define kButtonHeight 50*SizeScale
//static const CGFloat kButtonHeight = 50*SizeScale;
static const CGFloat kButtonMargin = 5;
@interface AlertView ()

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIButton *buttonTop;

@property (nonatomic, strong) UIButton *buttonMid;

@property (nonatomic, strong) UIButton *buttonCancel;

@property (nonatomic, strong) UIView *lineView;
@end

@implementation AlertView

#pragma mark - --- init 视图初始化 ---

- (instancetype)initWithFirstTitle:(NSString *)first secondTitle:(NSString *)second target:(id)target firstAction:(SEL)firstAction secondAction:(SEL)secondAction {
    if (self = [super init]) {
        [self setupDefault];
        [self.buttonTop setTitle:first forState:(UIControlStateNormal)];
        [self.buttonMid setTitle:second forState:(UIControlStateNormal)];
        [self.buttonTop addTarget:target action:firstAction forControlEvents:(UIControlEventTouchUpInside)];
        [self.buttonMid addTarget:target action:secondAction forControlEvents:(UIControlEventTouchUpInside)];
    }
    return self;
}

- (void)setupDefault {
    // 1.设置数据的默认值
    _font              = [UIFont systemFontOfSize:16];
    _titleColor        = [UIColor grayColor];
    
    // 2.设置自身属性
    self.bounds = [UIScreen mainScreen].bounds;
    self.backgroundColor = RGBA(0, 0, 0, 102.0/255);
    self.layer.opacity = 0.0;
    [self addTarget:self action:@selector(remove) forControlEvents:UIControlEventTouchUpInside];
    
    // 3.添加子视图
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.buttonTop];
    [self.contentView addSubview:self.buttonMid];
    [self.contentView addSubview:self.buttonCancel];
    [self.contentView addSubview:self.lineView];
}

#pragma mark - --- private methods 私有方法 ---

- (void)remove {
    CGRect frameContent =  self.contentView.frame;
    frameContent.origin.y += self.contentView.height;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.layer setOpacity:0.0];
        self.contentView.frame = frameContent;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self setCenter:[UIApplication sharedApplication].keyWindow.center];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self];
    
    CGRect frameContent =  self.contentView.frame;
    frameContent.origin.y -= self.contentView.height;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.layer setOpacity:1.0];
        self.contentView.frame = frameContent;
    } completion:^(BOOL finished) {
    }];
}

#pragma mark - --- Target Action ---

- (void)cancel {
    [self remove];
}

#pragma mark - --- setters 属性 ---

- (void)setFont:(UIFont *)font {
    _font = font;
    
    [self.buttonTop.titleLabel setFont:font];
    [self.buttonMid.titleLabel setFont:font];
    [self.buttonCancel.titleLabel setFont:font];
}

- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    
    [self.buttonCancel setTitleColor:titleColor forState:UIControlStateNormal];
    [self.buttonMid setTitleColor:titleColor forState:UIControlStateNormal];
    [self.buttonTop setTitleColor:titleColor forState:UIControlStateNormal];
}

#pragma mark - --- getters 属性 ---

- (UIView *)contentView {
    if (!_contentView) {
        CGFloat contentX = 0;
        CGFloat contentY = CGRectGetHeight([UIScreen mainScreen].bounds);
        CGFloat contentW = CGRectGetWidth([UIScreen mainScreen].bounds);
        CGFloat contentH = kButtonHeight*3+kButtonMargin;
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(contentX, contentY, contentW, contentH)];
        [_contentView setBackgroundColor:RGB(245, 245, 245)];
    }
    return _contentView;
}

- (UIButton *)buttonTop {
    if (!_buttonTop) {
        CGFloat x = 0;
        CGFloat y = 0;
        CGFloat W = CGRectGetWidth([UIScreen mainScreen].bounds);
        CGFloat H = kButtonHeight;
        _buttonTop = [[UIButton alloc] initWithFrame:CGRectMake(x, y, W, H)];
        [_buttonTop.titleLabel setFont:self.font];
        [_buttonTop setTitleColor:self.titleColor forState:(UIControlStateNormal)];
        _buttonTop.backgroundColor = [UIColor whiteColor];
        [_buttonTop addTarget:self action:@selector(cancel) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _buttonTop;
}

- (UIButton *)buttonMid {
    if (!_buttonMid) {
        CGFloat x = 0;
        CGFloat y = CGRectGetMaxY(self.buttonTop.frame);
        CGFloat W = CGRectGetWidth([UIScreen mainScreen].bounds);
        CGFloat H = kButtonHeight;
        _buttonMid = [[UIButton alloc] initWithFrame:CGRectMake(x, y, W, H)];
        [_buttonMid.titleLabel setFont:self.font];
        [_buttonMid setTitleColor:self.titleColor forState:UIControlStateNormal];
        _buttonMid.backgroundColor = [UIColor whiteColor];
        [_buttonMid addTarget:self action:@selector(cancel) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _buttonMid;
}

- (UIButton *)buttonCancel {
    if (!_buttonCancel) {
        CGFloat x = 0;
        CGFloat y = CGRectGetMaxY(self.buttonMid.frame) + kButtonMargin;
        CGFloat W = CGRectGetWidth([UIScreen mainScreen].bounds);
        CGFloat H = kButtonHeight;
        _buttonCancel = [[UIButton alloc] initWithFrame:CGRectMake(x, y, W, H)];
        [_buttonCancel setTitle:@"取消" forState:UIControlStateNormal];
        [_buttonCancel.titleLabel setFont:self.font];
        [_buttonCancel setTitleColor:self.titleColor forState:UIControlStateNormal];
        [_buttonCancel addTarget:self action:@selector(cancel) forControlEvents:(UIControlEventTouchUpInside)];
        _buttonCancel.backgroundColor = [UIColor whiteColor];
    }
    return _buttonCancel;
}

- (UIView *)lineView
{
    if (!_lineView) {
        CGFloat lineX = 0;
        CGFloat lineY = CGRectGetMaxY(self.buttonTop.frame);;
        CGFloat lineW = self.contentView.width;
        CGFloat lineH = 0.5;
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(lineX, lineY, lineW, lineH)];
        [_lineView setBackgroundColor:RGB(205, 205, 205)];
    }
    return _lineView;
}

@end
