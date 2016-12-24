//
//  SelectImageView.m
//  xiaofu
//
//  Created by HNF's wife on 2016/11/29.
//  Copyright © 2016年 huangningfa@163.com. All rights reserved.
//

#import "SelectImageView.h"
#import "UIImage+Extension.h"
#import "XFConfig.h"

@interface SelectImageView ()

@property (nonatomic, weak) UIImageView *imageView;

@end

@implementation SelectImageView

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage createImageWithColor:RGB(219, 219, 219)];
        
        [self addSubview:imageView];
        self.imageView = imageView;
        
        UIImageView *cameraView = [[UIImageView alloc] init];
        cameraView.image = [UIImage imageNamed:@"camera"];
        [self addSubview:cameraView];
        
        [cameraView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(SizeMake(25, 25));
            make.bottom.offset(-cameraView.width/2);
            make.right.offset(-cameraView.width/2);
        }];

    }
    return self;
}

- (void)setImage:(UIImage *)image {
    _image = image;
    
    self.imageView.image = image;
}

- (void)layoutSubviews {
    self.imageView.frame = self.bounds;
    self.imageView.layer.cornerRadius = self.imageView.width/2;
    self.imageView.layer.masksToBounds = YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
