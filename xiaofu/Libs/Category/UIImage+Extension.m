//
//  UIImage+Extension.m
//  Ligo
//
//  Created by HNF's macbook on 16/5/28.
//  Copyright © 2016年 HNF. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)

+(instancetype)imageWithOriginalName:(NSString *)name {
    UIImage *image = [UIImage imageNamed:name];
    return [image imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
}

+(UIImage *)resizedImage:(NSString *)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    return [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
}

+(UIImage *)createImageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+(instancetype)circleImageWithName:(NSString *)imageName borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor {
    UIImage *oldImage = [UIImage imageNamed:imageName];
    return [self circleImageWithImage:oldImage borderWidth:borderWidth borderColor:borderColor];
}

+(instancetype)circleImageWithImage:(UIImage *)image borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor {
    UIImage *oldImage = image;
    
    //1.开启上下文
    CGFloat imageW = oldImage.size.width + 2 * borderWidth;
    CGFloat imageH = oldImage.size.height + 2 * borderWidth;
    CGSize size = CGSizeMake(imageW, imageH);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    
    //2.获取上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //3.画大圆
    [borderColor set];
    CGFloat bigRadius = imageH * 0.5;
    CGFloat centerX = bigRadius;
    CGFloat centerY = bigRadius;
    CGContextAddArc(context, centerX, centerY, bigRadius, 0, M_PI * 2, 0);
    CGContextFillPath(context);
    
    //4.画小圆
    CGFloat smallRadius = bigRadius - borderWidth;
    CGContextAddArc(context, centerX, centerY, smallRadius, 0, M_PI * 2, 0);
    CGContextClip(context);
    
    //5.画图
    [oldImage drawInRect:CGRectMake(borderWidth, borderWidth, oldImage.size.width, oldImage.size.height)];
    
    //6.取图
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();

    //7.结束上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
