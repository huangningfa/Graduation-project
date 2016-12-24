//
//  XFUser.h
//  xiaofu
//
//  Created by HNF's wife on 2016/12/9.
//  Copyright © 2016年 huangningfa@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const XFUserUpdateDidSuccessNotification;

@class BmobUser;
@interface XFUser : NSObject

#pragma mark - 默认获得自己的属性

+ (instancetype)sharedUser;

+ (NSURL *)getUserHeadImageURL;

+ (NSURL *)getBackgroundImageURL;

+ (NSString *)getUserName;

+ (NSString *)getUserEmail;

+ (NSString *)getUserPhoneNumber;

+ (NSString *)getUserSchool;

+ (NSString *)getUserDepartment;

+ (NSString *)getUserMajor;

+ (NSString *)getUserDescription;

+ (NSString *)getUserGender;

#pragma mark - 传入user参数获得用户的属性

+ (NSURL *)getUserHeadImageURL:(BmobUser *)user;

+ (NSURL *)getBackgroundImageURL:(BmobUser *)user;

+ (NSString *)getUserName:(BmobUser *)user;

+ (NSString *)getUserEmail:(BmobUser *)user;

+ (NSString *)getUserPhoneNumber:(BmobUser *)user;

+ (NSString *)getUserSchool:(BmobUser *)user;

+ (NSString *)getUserDepartment:(BmobUser *)user;

+ (NSString *)getUserMajor:(BmobUser *)user;

+ (NSString *)getUserDescription:(BmobUser *)user;

+ (NSString *)getUserGender:(BmobUser *)user;

#pragma mark - 设置用户属性

+ (void)setUserHeadImage:(UIImage *)image success:(void(^)(BOOL isSuccessful))success;

+ (void)setUserBackgroundImage:(UIImage *)image success:(void(^)(BOOL isSuccessful))success;

+ (void)updateUserHeadImage:(UIImage *)image name:(NSString *)name gender:(NSString *)gender description:(NSString *)description department:(NSString *)department major:(NSString *)major success:(void(^)(BOOL isSuccessful))success;

#pragma mark - Common

+ (UIImage *)getplaceholderImage;

+ (UIImage *)getBackgroundPlaceholderImage;

+ (BmobUser *)getLocalUser;

@end
