//
//  UIScreen+Extension.m
//  Ligo
//
//  Created by HNF's macbook on 16/5/28.
//  Copyright © 2016年 HNF. All rights reserved.
//

#import "UIScreen+Extension.h"

@implementation UIScreen (Extension)

+ (CGSize)screenSize {
    return [UIScreen mainScreen].bounds.size;
}

+(CGFloat)scale {
    return [UIScreen mainScreen].scale;
}

+(BOOL)isRetina {
    return [UIScreen scale] >= 2;
}

@end
