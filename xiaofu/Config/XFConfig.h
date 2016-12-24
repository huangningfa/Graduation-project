//
//  XFConfig.h
//  xiaofu
//
//  Created by HNF's wife on 2016/11/20.
//  Copyright © 2016年 huangningfa@163.com. All rights reserved.
//

#ifndef XFConfig_h
#define XFConfig_h

#define OffsetScale 0.7                     // 侧栏偏移比例
#define KeyWindow [UIApplication sharedApplication].keyWindow

/**
 *  1.屏幕尺寸
 */
#define ScreenWidth  CGRectGetWidth([UIScreen mainScreen].bounds)
#define ScreenHeight CGRectGetHeight([UIScreen mainScreen].bounds)

/**
 *  2.返回一个RGBA格式的UIColor对象
 */
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

/**
 *  3.返回一个RGB格式的UIColor对象
 */
#define RGB(r, g, b) RGBA(r, g, b, 1.0f)

/**
 *  4.弱引用
 */
#define WeakSelf __weak typeof(self) weakSelf = self;

/**
 *  5.屏幕比例，适配
 */
#define SizeScale ScreenWidth/375.0
#define SizeMake(width, height) CGSizeMake(width * SizeScale, height * SizeScale)

/**
 *  6.字体适配，6p的字体是其他的1.5倍
 */
#define FontSize(value) [UIFont systemFontOfSize:(ScreenWidth > 375 ? value * 1.5 : value)]
#define BoldFontSize(value) [UIFont boldSystemFontOfSize:(ScreenWidth > 375 ? value * 1.5 : value)]
#define XFFont FontSize(16)                    // 统一字体
#define XFBoldFont BoldFontSize(16)            // 统一加粗字体
#define XFFontSmall FontSize(14)               // 统一较小字体
#define XFFontBig FontSize(18)                 // 统一较大字体
#define XFBoldFontBig BoldFontSize(18)         // 统一加粗较大字体

/**
 *  7.屏幕配色
 */
#define XFColor RGB(255, 89, 89)              // 主题色
#define XFColorDark RGB(242, 148, 148)        // 主题色暗调



#endif /* XFConfig_h */
