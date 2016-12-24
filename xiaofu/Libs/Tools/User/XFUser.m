//
//  XFUser.m
//  xiaofu
//
//  Created by HNF's wife on 2016/12/9.
//  Copyright © 2016年 huangningfa@163.com. All rights reserved.
//

#import "XFUser.h"
#import <BmobSDK/Bmob.h>
#import "UIImage+Extension.h"

NSString *const XFUserUpdateDidSuccessNotification = @"XFUserUpdateDidSuccessNotification";

typedef void(^Success)(BOOL isSuccessful);
@interface XFUser ()

@property (nonatomic, strong) BmobUser *buser;

@property (nonatomic, copy) Success successBlock;

@end

@implementation XFUser

+ (instancetype)sharedUser {
    static XFUser *xfuser;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        xfuser = [[XFUser alloc] init];
        xfuser.buser = [BmobUser getCurrentUser];
    });
    return xfuser;
}

#pragma mark - 默认获得自己的属性

+ (NSURL *)getUserHeadImageURL {
    XFUser *user = [XFUser sharedUser];
    BmobUser *buser = user.buser;
    BmobFile *file = (BmobFile *)[buser objectForKey:@"headImage"];
    return [NSURL URLWithString:file.url];
}

+ (NSURL *)getBackgroundImageURL {
    XFUser *user = [XFUser sharedUser];
    BmobUser *buser = user.buser;
    BmobFile *file = (BmobFile *)[buser objectForKey:@"backgroundImage"];
    return [NSURL URLWithString:file.url];
}

+ (NSString *)getUserSchool {
    XFUser *user = [XFUser sharedUser];
    BmobUser *buser = user.buser;
    NSString *school = [buser objectForKey:@"school"];
    return school;
}

+ (NSString *)getUserDepartment {
    XFUser *user = [XFUser sharedUser];
    BmobUser *buser = user.buser;
    NSString *department = [buser objectForKey:@"department"];
    return department;
}

+ (NSString *)getUserMajor {
    XFUser *user = [XFUser sharedUser];
    BmobUser *buser = user.buser;
    NSString *major = [buser objectForKey:@"major"];
    return major;
}

+ (NSString *)getUserPhoneNumber {
    XFUser *user = [XFUser sharedUser];
    BmobUser *buser = user.buser;
    return buser.mobilePhoneNumber;
}

+ (NSString *)getUserEmail {
    XFUser *user = [XFUser sharedUser];
    BmobUser *buser = user.buser;
    return buser.email;
}

+ (NSString *)getUserName {
    XFUser *user = [XFUser sharedUser];
    BmobUser *buser = user.buser;
    return [buser objectForKey:@"username"];
}

+ (NSString *)getUserDescription {
    XFUser *user = [XFUser sharedUser];
    BmobUser *buser = user.buser;
    NSString *description = [buser objectForKey:@"description"];
    return description;
}

+ (NSString *)getUserGender {
    XFUser *user = [XFUser sharedUser];
    BmobUser *buser = user.buser;
    NSString *gender = [buser objectForKey:@"gender"];
    return gender;
}

#pragma mark - 传入user参数获得用户的属性

+ (NSURL *)getUserHeadImageURL:(BmobUser *)user {
    BmobFile *file = (BmobFile *)[user objectForKey:@"headImage"];
    return [NSURL URLWithString:file.url];
}

+ (NSURL *)getBackgroundImageURL:(BmobUser *)user {
    BmobFile *file = (BmobFile *)[user objectForKey:@"backgroundImage"];
    return [NSURL URLWithString:file.url];
}

+ (NSString *)getUserSchool:(BmobUser *)user {
    NSString *school = [user objectForKey:@"school"];
    return school;
}

+ (NSString *)getUserPhoneNumber:(BmobUser *)user {
    return user.mobilePhoneNumber;
}

+ (NSString *)getUserEmail:(BmobUser *)user {
    return user.email;
}

+ (NSString *)getUserName:(BmobUser *)user {
    return user.username;
}

+ (NSString *)getUserDepartment:(BmobUser *)user {
    NSString *department = [user objectForKey:@"department"];
    return department;
}

+ (NSString *)getUserMajor:(BmobUser *)user {
    NSString *major = [user objectForKey:@"major"];
    return major;
}

+ (NSString *)getUserDescription:(BmobUser *)user {
    NSString *description = [user objectForKey:@"description"];
    return description;
}

+ (NSString *)getUserGender:(BmobUser *)user {
    NSString *gender = [user objectForKey:@"gender"];
    return gender;
}

#pragma mark - 设置用户属性
+ (void)setUserHeadImage:(UIImage *)image success:(void (^)(BOOL))success {
    XFUser *user = [XFUser sharedUser];
    [user setImage:image withKey:@"headImage"];
    
    user.successBlock = success;
}

+ (void)setUserBackgroundImage:(UIImage *)image success:(void (^)(BOOL))success {
    XFUser *user = [XFUser sharedUser];
    [user setImage:image withKey:@"backgroundImage"];
    
    user.successBlock = success;
}

+ (void)updateUserHeadImage:(UIImage *)image name:(NSString *)name gender:(NSString *)gender description:(NSString *)description department:(NSString *)department major:(NSString *)major success:(void (^)(BOOL))success {
    XFUser *user = [XFUser sharedUser];
    BmobUser *buser = user.buser;
    [XFProgressHUD showLoading:@"正在上传..."];
    if (image) {
        BmobFile *oldFile = [buser objectForKey:@"headImage"];
        if (![user isHeadImageUrlSameAsBackgroundImage]) {
            [oldFile deleteInBackground];
        }
        NSString *imageName = [NSString stringWithFormat:@"%@headImage.jpg", buser.mobilePhoneNumber];
        BmobFile *fileImage = [[BmobFile alloc] initWithFileName:imageName withFileData:UIImageJPEGRepresentation(image, 0.5)];
        [fileImage saveInBackground:^(BOOL isSuccessful, NSError *error) {
            if (error == nil && isSuccessful) {
                NSDictionary *dic = @{@"username":    name,
                                      @"gender":      gender,
                                      @"description": description,
                                      @"department":  department,
                                      @"major":       major,
                                      @"headImage":   fileImage};
                [buser saveAllWithDictionary:dic];
                [user updateUser];
            }else { // 上传失败
                [XFProgressHUD hide];
                [XFProgressHUD showInfoMsg:@"服务器异常/(ㄒoㄒ)/1"];
            }
        }];
    }else {
        NSDictionary *dic = @{@"username":    name,
                              @"gender":      gender,
                              @"description": description,
                              @"department":  department,
                              @"major":       major};
        [buser saveAllWithDictionary:dic];
        [user updateUser];
    }
    user.successBlock = success;
}

#pragma mark - Private Method

// 设置头像或背景
- (void)setImage:(UIImage *)image withKey:(NSString *)key {
    [XFProgressHUD showLoading:@"正在上传..."];
    BmobFile *oldFile = [self.buser objectForKey:key];
    if (![self isHeadImageUrlSameAsBackgroundImage]) {
        [oldFile deleteInBackground];
    }

    NSString *imageName = [NSString stringWithFormat:@"%@%@.jpg", self.buser.mobilePhoneNumber, key];
    BmobFile *fileImage = [[BmobFile alloc] initWithFileName:imageName withFileData:UIImageJPEGRepresentation(image, 0.5)];
    [fileImage saveInBackground:^(BOOL isSuccessful, NSError *error) {
        if (error == nil && isSuccessful) {
            [self.buser setObject:fileImage forKey:key];
            // 更新操作
            [self updateUser];
        }else { // 上传失败
            [XFProgressHUD hide];
            [XFProgressHUD showInfoMsg:@"服务器异常/(ㄒoㄒ)/1"];
        }
    }];
}

// 更新数据
- (void)updateUser {
    [self.buser updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful && error == nil) {
            //NSLog(@"%@", self.buser);
            [XFProgressHUD hide];
            [XFProgressHUD showSuccess:@"上传成功"];
            if (self.successBlock) {
                self.successBlock(YES);
                self.successBlock = nil;
            }
            // 更新数据成功，发送通知
            [[NSNotificationCenter defaultCenter] postNotificationName:XFUserUpdateDidSuccessNotification object:nil];
            
        }else {
            [XFProgressHUD hide];
            [XFProgressHUD showInfoMsg:@"服务器异常/(ㄒoㄒ)/2"];
            if (self.successBlock) {
                self.successBlock(NO);
                self.successBlock = nil;
            }
        }
    }];
}

// 保存数据
- (void)saveUser {
    [self.buser saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful && error == nil) {
            [XFProgressHUD hide];
            [XFProgressHUD showSuccess:@"上传成功"];
            if (self.successBlock) {
                self.successBlock(YES);
                self.successBlock = nil;
            }
        }else {
            [XFProgressHUD hide];
            [XFProgressHUD showInfoMsg:@"服务器异常/(ㄒoㄒ)/3"];
            if (self.successBlock) {
                self.successBlock(NO);
                self.successBlock = nil;
            }
        }
        
    }];
}

- (BOOL)isHeadImageUrlSameAsBackgroundImage {
    NSString *imageUrl = [XFUser getUserHeadImageURL].absoluteString;
    NSString *backgroundImageUrl = [XFUser getBackgroundImageURL].absoluteString;
    return [imageUrl isEqualToString:backgroundImageUrl];
}

#pragma mark - Common

+ (UIImage *)getplaceholderImage {
    return [UIImage createImageWithColor:RGB(219, 219, 219)];
}

+ (UIImage *)getBackgroundPlaceholderImage {
    return [UIImage createImageWithColor:RGB(171, 171, 171)];
}

+ (BmobUser *)getLocalUser {
    return [XFUser sharedUser].buser;
}

@end
