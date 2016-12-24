//
//  UIScreen+Extension.h
//  Ligo
//
//  Created by HNF's macbook on 16/5/28.
//  Copyright © 2016年 HNF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScreen (Extension)

+ (CGSize)screenSize;

+ (BOOL)isRetina;

+ (CGFloat)scale;

@end
