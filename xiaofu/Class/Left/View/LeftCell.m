//
//  LeftCell.m
//  xiaofu
//
//  Created by HNF's wife on 2016/11/20.
//  Copyright © 2016年 huangningfa@163.com. All rights reserved.
//

#import "LeftCell.h"

@interface LeftCell ()

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation LeftCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"LeftCell";
    id cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[self alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:ID];
    }
    return cell;
}

-(void)setImageName:(NSString *)imageName {
    _imageName = imageName;
    self.image.image = [UIImage imageNamed:imageName];
}

-(void)setText:(NSString *)text {
    _text = text;
    self.label.text = text;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectedBackgroundView = [[UIView alloc] init];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
