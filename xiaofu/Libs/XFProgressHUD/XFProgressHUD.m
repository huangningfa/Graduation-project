//
//  XFProgressHUD.m
//  xiaofu
//
//  Created by HNF's wife on 2016/12/1.
//  Copyright © 2016年 huangningfa@163.com. All rights reserved.
//

#import "XFProgressHUD.h"

// 文字大小
#define TEXT_SIZE    15.0f

@implementation XFProgressHUD



+ (instancetype)sharedHUD {
    
    static XFProgressHUD *hud;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        hud = [[XFProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow];
        hud.color = [UIColor colorWithWhite:0.3 alpha:0.8];
        hud.animationType = MBProgressHUDAnimationZoom;
        hud.margin = 15.0f;
    });
    return hud;
}

+ (void)showStatus:(XFProgressHUDStatus)status text:(NSString *)text {
    
    XFProgressHUD *hud = [XFProgressHUD sharedHUD];
    [hud show:YES];
    [hud setLabelText:text];
    [hud setRemoveFromSuperViewOnHide:YES];
    [hud setLabelFont:[UIFont boldSystemFontOfSize:TEXT_SIZE]];
    //[hud setMinSize:CGSizeMake(BGVIEW_WIDTH, BGVIEW_WIDTH)];
    [[UIApplication sharedApplication].keyWindow addSubview:hud];
    
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"XFProgressHUD" ofType:@"bundle"];
    
    switch (status) {
            
        case XFProgressHUDStatusSuccess: {
            
            NSString *sucPath = [bundlePath stringByAppendingPathComponent:@"hud_success.png"];
            UIImage *sucImage = [UIImage imageWithContentsOfFile:sucPath];
            
            hud.mode = MBProgressHUDModeCustomView;
            UIImageView *sucView = [[UIImageView alloc] initWithImage:sucImage];
            hud.customView = sucView;
            [hud hide:YES afterDelay:2.0f];
        }
            break;
            
        case XFProgressHUDStatusError: {
            
            NSString *errPath = [bundlePath stringByAppendingPathComponent:@"hud_error.png"];
            UIImage *errImage = [UIImage imageWithContentsOfFile:errPath];
            
            hud.mode = MBProgressHUDModeCustomView;
            UIImageView *errView = [[UIImageView alloc] initWithImage:errImage];
            hud.customView = errView;
            [hud hide:YES afterDelay:2.0f];
        }
            break;
            
        case XFProgressHUDStatusWaitting: {
            
            hud.mode = MBProgressHUDModeIndeterminate;
        }
            break;
            
        case XFProgressHUDStatusInfo: {
            
            NSString *infoPath = [bundlePath stringByAppendingPathComponent:@"hud_info.png"];
            UIImage *infoImage = [UIImage imageWithContentsOfFile:infoPath];
            
            hud.mode = MBProgressHUDModeCustomView;
            UIImageView *infoView = [[UIImageView alloc] initWithImage:infoImage];
            hud.customView = infoView;
            [hud hide:YES afterDelay:1.0f];
        }
            break;
            
        default:
            break;
    }
}

+ (void)showMessage:(NSString *)text {
    
    XFProgressHUD *hud = [XFProgressHUD sharedHUD];
    [hud show:YES];
    [hud setLabelText:text];
    [hud setMinSize:CGSizeZero];
    [hud setMode:MBProgressHUDModeText];
    [hud setRemoveFromSuperViewOnHide:YES];
    [hud setLabelFont:[UIFont boldSystemFontOfSize:TEXT_SIZE]];
    [[UIApplication sharedApplication].keyWindow addSubview:hud];
    [hud hide:YES afterDelay:2.0f];
    
//    [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(hide) userInfo:nil repeats:NO];
}

+ (void)showInfoMsg:(NSString *)text {
    
    [self showStatus:XFProgressHUDStatusInfo text:text];
}

+ (void)showFailure:(NSString *)text {
    
    [self showStatus:XFProgressHUDStatusError text:text];
}

+ (void)showSuccess:(NSString *)text {
    
    [self showStatus:XFProgressHUDStatusSuccess text:text];
}

+ (void)showLoading:(NSString *)text {
    
    [self showStatus:XFProgressHUDStatusWaitting text:text];
}

+ (void)hide {
    
    [[XFProgressHUD sharedHUD] hide:NO];
}


@end
