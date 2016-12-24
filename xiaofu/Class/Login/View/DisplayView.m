//
//  DisplayView.m
//  xiaofu
//
//  Created by HNF's wife on 2016/11/30.
//  Copyright © 2016年 huangningfa@163.com. All rights reserved.
//

#import "DisplayView.h"
#import "UILabel+Extension.h"

@interface DisplayView ()

@property (nonatomic, copy) NSString *placeholder;

@end

@implementation DisplayView

- (instancetype)initWithText:(NSString *)text font:(UIFont *)font {
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        
//        UILabel *label = [UILabel labelWithTitle:text color:[[UIColor grayColor] colorWithAlphaComponent:0.5] font:font alignment:(NSTextAlignmentLeft)];
//        self.titleLabel = label;
//        [self addSubview:label];
        self.placeholder = text;
        self.backgroundColor = [UIColor clearColor];
        [self setTitle:text forState:(UIControlStateNormal)];
        [self setTitleColor:[[UIColor grayColor] colorWithAlphaComponent:0.5] forState:(UIControlStateNormal)];
        self.titleLabel.font = font;
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    return self;
}

- (void)setText:(NSString *)text {
    _text = text;
    [self setTitle:text forState:(UIControlStateNormal)];
    [self setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    return contentRect;
}

- (void)backToOriginal {
    self.text = nil;
    [self setTitle:self.placeholder forState:(UIControlStateNormal)];
    [self setTitleColor:[[UIColor grayColor] colorWithAlphaComponent:0.5] forState:(UIControlStateNormal)];
}

//- (void)layoutSubviews {
//    self.titleLabel.frame = self.bounds;
//}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextMoveToPoint(context, 0, self.height);
    CGContextAddLineToPoint(context, self.width, self.height);
    
    [[[UIColor grayColor] colorWithAlphaComponent:0.5] set];
    
    CGContextSetLineWidth(context, 1.0);
    
    CGContextStrokePath(context);
}


@end
