//
//  LeftTableViewController.m
//  xiaofu
//
//  Created by HNF's wife on 2016/11/20.
//  Copyright © 2016年 huangningfa@163.com. All rights reserved.
//

#import "LeftTableViewController.h"
#import "DeckViewController.h"
#import "XFConfig.h"
#import "LeftCell.h"
#import "ProfileViewController.h"
#import "UIImage+Extension.h"
#import "XFUser.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define LeftViewBackgroundColor RGB(231, 234, 238)
@interface LeftTableViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, weak) UIImageView *headView;
@property (nonatomic, weak) UILabel *nameLabel;

@end

@implementation LeftTableViewController

-(NSArray *)data {
    if (!_data) {
        _data = @[@"校园",@"广场",@"历史",@"设置"];
    }
    return _data;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = LeftViewBackgroundColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = NO;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"LeftCell" bundle:nil] forCellReuseIdentifier:@"LeftCell"];

    [self.view addSubview:self.headerView];
 
    [self listenForUserUpdateNotification];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tableView.delegate = self;
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.selectedIndexPath];
    cell.selected = YES;
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tableView.delegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    NSLog(@"left view delloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:XFUserUpdateDidSuccessNotification object:nil];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LeftCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LeftCell"];
    cell.imageName = @"ic_menu_subscribe";
    cell.text = self.data[indexPath.row];
    
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row != self.selectedIndexPath.row) {
        [tableView cellForRowAtIndexPath:self.selectedIndexPath].selected = NO;
        self.selectedIndexPath = indexPath;
    }
    
    NSString *title = self.data[indexPath.row];
    NSLog(@"%@", title);
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        cell.selected = YES;
        self.selectedIndexPath = indexPath;
    }
}

#pragma mark - Private Method

- (void)listenForUserUpdateNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI) name:XFUserUpdateDidSuccessNotification object:nil];
}

- (void)updateUI {
    [self.headView sd_setImageWithURL:[XFUser getUserHeadImageURL]];
    self.nameLabel.text = [XFUser getUserName];
}

- (DeckViewController *)parentVC {
    return (DeckViewController *)self.parentViewController;
}

#pragma mark - Target Action

- (void)pushProfileVC {
    if (self.selectedIndexPath.row != -1) {
        [self.tableView cellForRowAtIndexPath:self.selectedIndexPath].selected = NO;

        self.selectedIndexPath = [NSIndexPath indexPathForRow:-1 inSection:0];
        ProfileViewController *profileVC = [[ProfileViewController alloc] init];
        profileVC.user = [XFUser getLocalUser];
        [[self parentVC] setMainViewController:[[UINavigationController alloc] initWithRootViewController:profileVC]];
    }else {
        [[self parentVC] collapsePanel];
    }
    NSLog(@"个人");
}

#pragma mark - Getter 属性

- (UIView *)headerView {
    if (!_headerView) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width * OffsetScale, 110)];
        [view addTarget:self action:@selector(pushProfileVC)];
        view.backgroundColor = LeftViewBackgroundColor;
        
        // 头像
        UIImageView *headView = [[UIImageView alloc] init];
#warning userImage
        [headView sd_setImageWithURL:[XFUser getUserHeadImageURL] placeholderImage:[XFUser getplaceholderImage]];
        self.headView = headView;
        //headView.image = [UIImage imageNamed:@"Anne"];
        headView.layer.cornerRadius = 25*SizeScale;
        headView.layer.masksToBounds = YES;
        [view addSubview:headView];
        [headView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10);
            //make.centerX.equalTo(headView.superview);
            make.top.offset(40);
            make.size.mas_equalTo(SizeMake(50, 50));
        }];
        // 昵称
        UILabel *nameLabel = [[UILabel alloc] init];
#warning userName
        //nameLabel.text = @"允许我发发呆";
        self.nameLabel = nameLabel;
        nameLabel.text = [XFUser getUserName];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.font = XFFontSmall;
        nameLabel.textColor = [UIColor grayColor];
        [view addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headView.mas_right).offset(10);
            make.centerY.equalTo(headView);
            //make.centerX.offset(0);
            //make.top.equalTo(self.headerView.mas_bottom).offset(10);
        }];
        // 简介
//        UILabel *description = [[UILabel alloc] init];
//        description.textColor = [UIColor blackColor];
//        description.text = [self getUserDescription];
//        description.font = XFFontSmall;
//        description.textAlignment = NSTextAlignmentLeft;
//        [view addSubview:description];
//        [description mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.offset(10);
//            make.top.equalTo(headView.mas_bottom).offset(10);
//        }];
        
        _headerView = view;
    }
    return _headerView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 110, self.view.width * OffsetScale, self.view.height) style:(UITableViewStylePlain)];
        _tableView = tableView;
        tableView.dataSource = self;
        [self.view addSubview:tableView];
    }
    return _tableView;
}




@end
