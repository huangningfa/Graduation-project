//
//  XFHeaderView.m
//  xiaofu
//
//  Created by HNF's wife on 2016/12/9.
//  Copyright © 2016年 huangningfa@163.com. All rights reserved.
//

#import "XFHeaderView.h"
#import "XFConfig.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UILabel+Extension.h"
#import "XFUser.h"

@interface XFHeaderView ()

@property (nonatomic, strong) UIImageView *imageView; // 背景
@property (nonatomic, strong) UIView *cover;
@property (nonatomic, strong) UIView *personView;

@property (nonatomic, weak) UIImageView *headView; // 头像
@property (nonatomic, weak) UILabel *descriptionLabel;// 简介
@property (nonatomic, weak) UILabel *solveLabel; // 解决
@property (nonatomic, weak) UILabel *solvedLabel; // 被解决
@property (nonatomic, weak) UILabel *nameLabel; // 昵称

//@property (nonatomic, copy) NSString *username;
//@property (nonatomic, assign) NSUInteger solved;
//@property (nonatomic, assign) NSUInteger solve;
//@property (nonatomic, copy) NSString *userDescription;
//@property (nonatomic, strong) NSURL *backgroundURL;
//@property (nonatomic, strong) NSURL *headImageURL;

@end

@implementation XFHeaderView
{
    NSString *username;
    NSUInteger solved;
    NSUInteger solve;
    NSString *userDescription;
//    NSURL *backgroundURL;
//    NSURL *headImageURL;
}

- (instancetype)init {
    if (self = [super init]) {
        username = @" ";
        solve = 0;
        solved = 0;
        userDescription = @" ";
        
        self.frame = CGRectMake(0, 0, ScreenWidth, ScreenWidth);
        self.imageView.frame = CGRectMake(0, 0, ScreenWidth, ScreenWidth);
        [self.imageView addSubview:self.cover];
        
        [self addSubview:self.personView];
        [self.personView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.offset(0);
            make.top.offset((64+10));
            make.width.mas_equalTo(ScreenWidth-20);
        }];
        
        [self listenForUserUpdateNotification];
        [self addObserver:self forKeyPath:@"contentOffset" options:(NSKeyValueObservingOptionNew) context:nil];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"]){
        CGPoint contentOffset = [[change objectForKey:NSKeyValueChangeNewKey] CGPointValue];
        if (contentOffset.y <= 0) {
            self.imageView.frame = CGRectMake(0,
                                              0 + contentOffset.y,
                                              ScreenWidth,
                                              ScreenWidth + fabs(contentOffset.y));
            self.cover.frame = self.imageView.bounds;
        }
    }
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"contentOffset"];
}

#pragma mark - Public Method

- (void)addTargetForHeadImage:(id)target action:(SEL)action {
    [self.headView addTarget:target action:action];
}

- (void)setBackgroundImage:(UIImage *)image {
    WeakSelf;
    // 上传背景
    [XFUser setUserBackgroundImage:image success:^(BOOL isSuccessful) {
        if (isSuccessful) {
            // 更换背景
            weakSelf.imageView.image = image;
        }
    }];
}

- (void)setHeadImage:(UIImage *)image {
    WeakSelf;
    // 上传头像
    [XFUser setUserHeadImage:image success:^(BOOL isSuccessful) {
        if (isSuccessful) {
            // 更换头像
            weakSelf.headView.image = image;
        }
    }];
}

#pragma mark - Private Method

- (void)listenForUserUpdateNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI) name:XFUserUpdateDidSuccessNotification object:nil];
}

- (void)updateUI {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.headView sd_setImageWithURL:[XFUser getUserHeadImageURL]];
        self.nameLabel.text = [XFUser getUserName];
        self.descriptionLabel.text = [XFUser getUserDescription];
    });
}

#pragma mark - Setter

- (void)setUser:(BmobUser *)user {
    _user = user;
    
    self.nameLabel.text = [XFUser getUserName:user];
#warning 解决未填
    self.solveLabel.text = @"15 解决";
    self.solvedLabel.text = @"15 被解决";
    self.descriptionLabel.text = [NSString stringWithFormat:@"简介：%@", [XFUser getUserDescription:user]];
    [self.imageView sd_setImageWithURL:[XFUser getBackgroundImageURL:user] placeholderImage:[XFUser getBackgroundPlaceholderImage]];
    [self.headView sd_setImageWithURL:[XFUser getUserHeadImageURL:user] placeholderImage:[XFUser getplaceholderImage]];
}

#pragma mark - Getter
// 背景图片
- (UIImageView *)imageView {
    if (!_imageView) {
        UIImageView *imageview = [[UIImageView alloc] init];
        //imageview.image = [XFUser getBackgroundPlaceholderImage];
        [imageview sd_setImageWithURL:[XFUser getBackgroundImageURL] placeholderImage:nil];
        _imageView = imageview;
        [self addSubview:imageview];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        
    }
    return _imageView;
}

- (UIView *)cover {
    if (!_cover) {
        _cover = [[UIView alloc] init];
        _cover.frame = self.imageView.bounds;
        _cover.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.2];
    }
    return _cover;
}

- (UIView *)personView {
    if (!_personView) {
        _personView = [[UIView alloc] init];
        
        //头像
        UIImageView *headView = [[UIImageView alloc] init];
        headView.image = [XFUser getplaceholderImage];
        headView.layer.borderWidth = 2;
        headView.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8].CGColor;
        headView.layer.cornerRadius = 40*SizeScale;
        headView.layer.masksToBounds = YES;
        [_personView addSubview:headView];
        self.headView = headView;
        [headView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.offset(0);
            make.top.offset(0);
            make.size.mas_equalTo(SizeMake(80, 80));
        }];
        
        //昵称
        UILabel *nameLabel = [UILabel labelWithTitle:username color:[UIColor whiteColor] font:XFBoldFontBig alignment:(NSTextAlignmentCenter)];
        [_personView addSubview:nameLabel];
        self.nameLabel = nameLabel;
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(headView.mas_bottom).offset(10*SizeScale);
            make.centerX.offset(0);
        }];
        
        //中间 |
        UILabel *mid = [UILabel labelWithTitle:@"|" color:[UIColor whiteColor] font:XFFontSmall alignment:(NSTextAlignmentCenter)];
        [_personView addSubview:mid];
        [mid mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.offset(0);
            make.top.equalTo(nameLabel.mas_bottom).offset(10*SizeScale);
        }];
        
        // 解决
        UILabel *check = [UILabel labelWithTitle:[NSString stringWithFormat:@"%ld 解决", solve] color:[UIColor whiteColor] font:XFFontSmall alignment:(NSTextAlignmentRight)];
        [_personView addSubview:check];
        self.solveLabel = check;
        [check mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(mid);
            make.right.equalTo(mid.mas_left).offset(-10);
        }];
        
        // 被解决
        UILabel *checkd = [UILabel labelWithTitle:[NSString stringWithFormat:@"%ld 被解决", solved] color:[UIColor whiteColor] font:XFFontSmall alignment:(NSTextAlignmentLeft)];
        [_personView addSubview:checkd];
        self.solvedLabel = checkd;
        [checkd mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(mid);
            make.left.equalTo(mid.mas_right).offset(10);
        }];
        
        // 简介
        UILabel *descriptionLabel = [UILabel labelWithTitle:[NSString stringWithFormat:@"简介：%@", userDescription] color:[UIColor whiteColor] font:XFFontSmall alignment:(NSTextAlignmentCenter)];
        self.descriptionLabel = descriptionLabel;
        [_personView addSubview:descriptionLabel];
        [descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(mid.mas_bottom).offset(10*SizeScale);
            make.centerX.offset(0);
            make.bottom.offset(0);
        }];
    }
    return _personView;
}

@end
