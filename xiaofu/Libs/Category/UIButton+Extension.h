//
//  UIButton+Extension.h
//  Ligo
//
//  Created by HNF's macbook on 16/5/29.
//  Copyright © 2016年 HNF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Extension)

/**
 *  创建按钮有文字,有颜色,有字体,有图片,有背景
 */
+ (instancetype)buttonWithTitle:(NSString *)title titleColor:(UIColor *)color font:(UIFont *)font imageName:(NSString *)imageName target:(id)target action:(SEL)acion backImageName:(NSString *)backImageName;

/**
 *  创建按钮有文字,有颜色,有字体,有背景
 */
+ (instancetype)buttonWithTitle:(NSString *)title titleColor:(UIColor *)color font:(UIFont *)font target:(id)target action:(SEL)acion backImageName:(NSString *)backImageName;

/**
 *  创建按钮有文字,有颜色,有字体,有图片
 */
+ (instancetype)buttonWithTitle:(NSString *)title titleColor:(UIColor *)color font:(UIFont *)font imageName:(NSString *)imageName target:(id)target action:(SEL)acion;

/**
 *  创建按钮有文字,有颜色,有字体
 */
+ (instancetype)buttonWithTitle:(NSString *)title titleColor:(UIColor *)color font:(UIFont *)font target:(id)target action:(SEL)acion;

/**
 *  创建按钮有文字,文字颜色,有字体大小,背景颜色
 */
+ (instancetype)buttonWithTitle:(NSString *)title titleColor:(UIColor *)color font:(UIFont *)font backgroundColor:(UIColor *)backgroundColor target:(id)target action:(SEL)action;

@end
