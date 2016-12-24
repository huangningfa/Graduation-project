//
//  Utils.h
//  ShareTribe
//
//  Created by HNF's wife on 16/7/25.
//  Copyright © 2016年 HNF's wife. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject

/**
 *  正则匹配邮箱
 */
+ (BOOL)checkEmail:(NSString *)email;

/**
 *  正则匹配手机号
 */
+ (BOOL)checkTelNumber:(NSString *) telNumber;

/**
 *  正则匹配用户密码6-18位数字和字母组合
 */
+ (BOOL)checkPassword:(NSString *) password;

/**
 *  正则匹配用户ID,1-23位数字和字母组合
 */
+ (BOOL)checkUserId:(NSString *)userId;

/**
 *  正则匹配用户姓名,20位的中文或英文
 */
+ (BOOL)checkUserName : (NSString *) userName;

/**
 *  正则匹配用户身份证号
 */
+ (BOOL)checkUserIdCard: (NSString *) idCard;

/**
 *  正则匹配URL
 */
+ (BOOL)checkURL : (NSString *) url;

@end
