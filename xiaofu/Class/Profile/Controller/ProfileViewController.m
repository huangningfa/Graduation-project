//
//  ProfileViewController.m
//  xiaofu
//
//  Created by HNF's wife on 2016/12/9.
//  Copyright © 2016年 huangningfa@163.com. All rights reserved.
//

#import "ProfileViewController.h"
#import "UINavigationBar+Awesome.h"
#import "XFHeaderView.h"
#import "XFUser.h"
#import <BmobSDK/Bmob.h>
#import <Photos/PHPhotoLibrary.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import "ModifyProfileControllerTableViewController.h"
#import "UIBarButtonItem+Extension.h"

@interface ProfileViewController () <UITableViewDelegate, UITableViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) XFHeaderView *headerView;

@property (nonatomic, assign) BOOL headImageTaped;

@property (nonatomic, assign) BOOL isLocalUser;

@end

#define NAVBAR_CHANGE_POINT 50

@implementation ProfileViewController

#pragma mark - view circle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.tableHeaderView = self.headerView;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    if (self.isLocalUser) {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"more1" highImageName:@"more1" target:self action:@selector(modifyProfile)];
        //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"more"] style:(UIBarButtonItemStylePlain) target:self action:@selector(modifyProfile)];
    }
    
    
    //NSLog(@"%@", [XFUser getLocalUser]);
    //self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tableView.delegate = self;
    [self scrollViewDidScroll:self.tableView];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tableView.delegate = nil;
    //[self.navigationController.navigationBar lt_reset];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Target Action

- (void)modifyProfile {
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:[[ModifyProfileControllerTableViewController alloc] initWithStyle:(UITableViewStyleGrouped)]] animated:YES completion:nil];
}

- (void)changeBackground {
    if (!self.isLocalUser) return;
        
    if ([UIImagePickerController isSourceTypeAvailable:(UIImagePickerControllerSourceTypeCamera)]) {
        [self showPhotoMenuWithTitle:@"修改背景"];
    }else {
        [self choosePhotoFromLibrary];
    }
}

- (void)changeHeadImage {
    if (self.user) {
#warning 查看图片
    }
    
    self.headImageTaped = YES;
    if ([UIImagePickerController isSourceTypeAvailable:(UIImagePickerControllerSourceTypeCamera)]) {
        [self showPhotoMenuWithTitle:@"修改头像"];
    }else {
        [self choosePhotoFromLibrary];
    }
}

#pragma mark - Private Method

- (void)showPhotoMenuWithTitle:(NSString *)title {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        self.headImageTaped = NO;
    }];

    [alertController addAction:cancel];
    UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:@"拍照" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [self takePhotoWithCamera];
    }];
    [alertController addAction:takePhotoAction];
    UIAlertAction *chooseFromLibraryAction = [UIAlertAction actionWithTitle:@"从相册中选择" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [self choosePhotoFromLibrary];
    }];
    [alertController addAction:chooseFromLibraryAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)choosePhotoFromLibrary {
    if (![self hasPhotoLibraryPermission]) {
        return;
    }
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)takePhotoWithCamera {
    if (![self hasCameraPermission]) {
        return;
    }
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (BOOL)hasPhotoLibraryPermission {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusAuthorized) {
        return YES;
    }else if (status == PHAuthorizationStatusDenied || status == PHAuthorizationStatusRestricted) {
        // 弹窗提示没有权限
        [self permissionAlertWithTitle:@"照片"];
    }else if (status == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            
        }];
        return [self hasPhotoLibraryPermission];
    }
    return NO;
}

- (BOOL)hasCameraPermission {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusAuthorized) {
        return YES;
    }else if (status == AVAuthorizationStatusDenied || status == AVAuthorizationStatusRestricted) {
        // 弹窗提示没有权限
        [self permissionAlertWithTitle:@"相机"];
    }else if (status == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            
        }];
        return [self hasCameraPermission];
    }
    return NO;
}

- (void)permissionAlertWithTitle:(NSString *)title {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@权限未打开", title] message:[NSString stringWithFormat:@"请到 [设置] > [校服]，打开 [%@] 开关，允许校服使用", title] preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    UIAlertAction *open = [UIAlertAction actionWithTitle:@"开启权限" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }];
    [alert addAction:cancle];
    [alert addAction:open];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - TableView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    UIColor * color = [UIColor whiteColor];
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > NAVBAR_CHANGE_POINT) {
        CGFloat alpha = MIN(1, 1 - ((NAVBAR_CHANGE_POINT + 100 - offsetY) / 100));
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
        //[self.navigationController.navigationBar lt_setElementsAlpha:alpha];
        //NSLog(@"%.3f, %.3f", alpha, offsetY);
        if (alpha > 0.5) {
            self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"more" highImageName:@"more" target:self action:@selector(modifyProfile)];
        }else {
            self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"more1" highImageName:@"more1" target:self action:@selector(modifyProfile)];
        }

    } else {
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
        //[self.navigationController.navigationBar lt_setElementsAlpha:0];
    }
//    NSLog(@"%.3f", scrollView.contentOffset.y);
    self.headerView.contentOffset = scrollView.contentOffset;
}

#pragma mark - TableView DataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"这是第%lu个", indexPath.row + 1];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

#pragma mark - UIImagePickerControllerDelegate method

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *selectedImage = info[UIImagePickerControllerEditedImage];
    if (selectedImage) {
        if (self.headImageTaped) {// 选择头像
            [self.headerView setHeadImage:selectedImage];
        }else {                   // 选择背景
            [self.headerView setBackgroundImage:selectedImage];
        }
    }
    self.headImageTaped = NO;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    self.headImageTaped = NO;
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Setter

- (void)setUser:(BmobUser *)user {
    _user = user;
    
    if (user == [XFUser getLocalUser]) {
        self.isLocalUser = YES;
    }else {
        self.isLocalUser = NO;
    }
}

#pragma mark - Getter

- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *content = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
        _tableView = content;
        //_tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:content];
    }
    return _tableView;
}

- (XFHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[XFHeaderView alloc] init];
        _headerView.user = self.user;
        [_headerView addTarget:self action:@selector(changeBackground)];
        [_headerView addTargetForHeadImage:self action:@selector(changeHeadImage)];
    }
    return _headerView;
}

@end
