//
//  UIImage+Extension.h
//  Ligo
//
//  Created by HNF's macbook on 16/5/28.
//  Copyright © 2016年 HNF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

/**
 *  返回拉伸图片
 */
+ (UIImage *)resizedImage:(NSString *)imageName;

/**
 *  用颜色返回一张图片
 */
+ (UIImage *)createImageWithColor:(UIColor *)color;

/**
 *  带边框的图片
 *
 *  @param imageName   图片名字
 *  @param borderWidth 边框宽度
 *  @param borderColor 边框颜色
 */
+ (instancetype)circleImageWithName:(NSString *)imageName borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

/**
 *  带边框的图片
 *
 *  @param image        图片
 *  @param borderWidth 边框宽度
 *  @param borderColor 边框颜色
 */
+ (instancetype)circleImageWithImage:(UIImage *)image borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

/**
 *  返回原始图片
 */
+ (instancetype)imageWithOriginalName:(NSString *)name;



@end
