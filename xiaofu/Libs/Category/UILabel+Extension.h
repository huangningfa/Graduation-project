//
//  UILabel+Extension.h
//  Ligo
//
//  Created by HNF's macbook on 16/5/28.
//  Copyright © 2016年 HNF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Extension)

+ (instancetype)labelWithTitle:(NSString *)title color:(UIColor *)color fontSize:(CGFloat)fontSize;

+ (instancetype)labelWithTitle:(NSString *)title color:(UIColor *)color font:(UIFont *)font;

+ (instancetype)labelWithTitle:(NSString *)title color:(UIColor *)color fontSize:(CGFloat)fontSize alignment:(NSTextAlignment)alignment;

+ (instancetype)labelWithTitle:(NSString *)title color:(UIColor *)color font:(UIFont *)font alignment:(NSTextAlignment)alignment;

+ (instancetype)labelWithTitle:(NSString *)title color:(UIColor *)color fontSize:(CGFloat)fontSize alignment:(NSTextAlignment)alignment lineSpace:(CGFloat)lineSpace;

@end
