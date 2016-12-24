//
//  UIButton+Extension.m
//  Ligo
//
//  Created by HNF's macbook on 16/5/29.
//  Copyright © 2016年 HNF. All rights reserved.
//

#import "UIButton+Extension.h"

@implementation UIButton (Extension)

+ (instancetype)buttonWithTitle:(NSString *)title titleColor:(UIColor *)color font:(UIFont *)font imageName:(NSString *)imageName target:(id)target action:(SEL)acion backImageName:(NSString *)backImageName {
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:title forState:(UIControlStateNormal)];
    [button setTitleColor:color forState:(UIControlStateNormal)];
    button.titleLabel.font = font;
    button.adjustsImageWhenHighlighted = NO;
    [button sizeToFit];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    
    if (imageName) {
        [button setImage:[UIImage imageNamed:imageName] forState:(UIControlStateNormal)];
        NSString *highName = [NSString stringWithFormat:@"%@_h", imageName];
        [button setImage:[UIImage imageNamed:highName] forState:(UIControlStateSelected)];
    }
    
    if (backImageName) {
        [button setBackgroundImage:[UIImage imageNamed:backImageName] forState:(UIControlStateNormal)];
        NSString *highBackName = [NSString stringWithFormat:@"%@_h", backImageName];
        [button setBackgroundImage:[UIImage imageNamed:highBackName] forState:(UIControlStateSelected)];
    }
    
    if (target) {
        [button addTarget:target action:acion forControlEvents:(UIControlEventTouchUpInside)];
    }
    
    return button;
}

+(instancetype)buttonWithTitle:(NSString *)title titleColor:(UIColor *)color font:(UIFont *)font imageName:(NSString *)imageName target:(id)target action:(SEL)acion {
    return [self buttonWithTitle:title titleColor:color font:font imageName:imageName target:target action:acion backImageName:nil];
}

+(instancetype)buttonWithTitle:(NSString *)title titleColor:(UIColor *)color font:(UIFont *)font target:(id)target action:(SEL)acion {
    return [self buttonWithTitle:title titleColor:color font:font imageName:nil target:target action:acion backImageName:nil];
}

+(instancetype)buttonWithTitle:(NSString *)title titleColor:(UIColor *)color font:(UIFont *)font target:(id)target action:(SEL)acion backImageName:(NSString *)backImageName {
    return [self buttonWithTitle:title titleColor:color font:font imageName:nil target:target action:acion backImageName:backImageName];
}

+ (instancetype)buttonWithTitle:(NSString *)title titleColor:(UIColor *)color font:(UIFont *)font backgroundColor:(UIColor *)backgroundColor target:(id)target action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [button setTitle:title forState:(UIControlStateNormal)];
    [button setTitleColor:color forState:(UIControlStateNormal)];
    [button setBackgroundColor:backgroundColor];
    button.titleLabel.font = font;
    button.layer.cornerRadius = 4;
    [button addTarget:target action:action forControlEvents:(UIControlEventTouchUpInside)];
    return button;
}

@end
