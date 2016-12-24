//
//  ModifyProfileControllerTableViewController.m
//  xiaofu
//
//  Created by HNF's wife on 2016/12/15.
//  Copyright © 2016年 huangningfa@163.com. All rights reserved.
//

#import "ModifyProfileControllerTableViewController.h"
#import "ProfileCell.h"
#import "ProfileImageCell.h"
#import "ProfileTextCell.h"
#import "UINavigationBar+Awesome.h"
#import <Photos/PHPhotoLibrary.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import "STPickerSingle.h"


@interface ModifyProfileControllerTableViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, STPickerSingleDelegate>

@property (nonatomic, strong) NSArray *data;

@property (nonatomic, strong) STPickerSingle *pickerView;

@property (nonatomic, strong) NSArray *arrayRoot;
@property (nonatomic, strong) NSMutableArray *arraySchool;
@property (nonatomic, strong) NSMutableArray *arrayDepart;
@property (nonatomic, strong) NSMutableArray *arrayMajor;

@end

@implementation ModifyProfileControllerTableViewController{
    NSArray *arraySelected;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:(UIBarButtonItemStylePlain) target:self action:@selector(complete)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:(UIBarButtonItemStylePlain) target:self action:@selector(cancle)];
    
    self.title = @"编辑资料";
    [self.tableView registerNib:[UINib nibWithNibName:@"ProfileCell" bundle:nil] forCellReuseIdentifier:@"ProfileCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ProfileImageCell" bundle:nil] forCellReuseIdentifier:@"ProfileImageCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ProfileTextCell" bundle:nil] forCellReuseIdentifier:@"ProfileTextCell"];
    
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    
    self.tableView.separatorColor = self.tableView.backgroundColor;

    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:gestureRecognizer];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    ProfileCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    [cell.textField resignFirstResponder];
    cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    [cell.textField resignFirstResponder];
}

#pragma mark - Target Action

- (void)complete {
    //NSLog(@"complete");
    [self.view endEditing:YES];
    // 昵称
    ProfileCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    NSString *name = cell.textField.text;
    name = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (name == nil || [name isEqualToString:@""]) {
        [XFProgressHUD showInfoMsg:@"昵称不能为空"];
        return;
    }
    // 专业
    cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
    NSString *major = cell.textField.text;
    if (major == nil) {
        [XFProgressHUD showInfoMsg:@"专业不能为空"];
        return;
    }
    // 性别
    cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    NSString *gender = cell.textField.text;
    // 简介
    ProfileTextCell *textCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    NSString *description = textCell.textView.text;
    description = [description stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (description == nil || [description isEqualToString:@""]) {
        description = @"Ta很懒，什么话也没说";
    }
    // 院系
    cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    NSString *department = cell.textField.text;
    // 头像
    ProfileImageCell *imageCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    // 更新用户
    WeakSelf;
    [XFUser updateUserHeadImage:(imageCell.modified ? imageCell.headView.image : nil) name:name gender:gender description:description department:department major:major success:^(BOOL isSuccessful) {
        if (isSuccessful) {
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        }
    }];

}

- (void)cancle {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)hideKeyboard:(UIGestureRecognizer *)gestureRecognizer {
    CGPoint point = [gestureRecognizer locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    if (indexPath != nil && indexPath.section == 0 && (indexPath.row == 1 || indexPath.row == 3) ){
        return;
    }
    [self.tableView endEditing:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [self.data[section] count] + 1;
    }else if (section == 1) {
        return [self.data[section] count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        ProfileImageCell *imageCell = [tableView dequeueReusableCellWithIdentifier:@"ProfileImageCell"];
        return imageCell;
    }else if (indexPath.section == 0 && indexPath.row == 3) {
        NSString *description = [XFUser getUserDescription];
        ProfileTextCell *textCell = [tableView dequeueReusableCellWithIdentifier:@"ProfileTextCell"];
        if (![description isEqualToString:@"Ta很懒，什么话也没说"]) {
            textCell.placeholder.hidden = YES;
            textCell.textView.text = description;
        }
        return textCell;
    }else if (indexPath.section == 0) {
        ProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileCell"];
        [cell setLeftTitle:self.data[indexPath.section][indexPath.row - 1]];
        if (indexPath.row == 1) {
            cell.textField.text = [XFUser getUserName];
            cell.textField.placeholder = @"起个独特的名字吧~";
            cell.maxLength = 10;
        }else if (indexPath.row == 2) {
            cell.textField.text = [XFUser getUserGender];
            cell.textField.enabled = NO;
        }
        return cell;
    }else if (indexPath.section == 1) {
        ProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileCell"];
        [cell setLeftTitle:self.data[indexPath.section][indexPath.row]];
        cell.textField.enabled = NO;
        if (indexPath.row == 0) {
            cell.textField.text = [XFUser getUserDepartment];
        }else if (indexPath.row == 1) {
            cell.textField.text = [XFUser getUserMajor];
            cell.textField.placeholder = @"请选择专业";
        }
        return cell;
    }
    return nil;
}

#pragma mark - TableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        if ([UIImagePickerController isSourceTypeAvailable:(UIImagePickerControllerSourceTypeCamera)]) {
            [self showPhotoMenuWithTitle:nil];
        }else {
            [self choosePhotoFromLibrary];
        }
    } else if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2){
        [self showPickerViewWithTag:indexPath.row];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 80;
    }else {
        return 48;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 15.0f;
}

#pragma mark - Private Method

- (void)showPickerViewWithTag:(NSInteger)tag {
    if (tag == 2) {       // 性别
        NSMutableArray *array = [NSMutableArray arrayWithObjects:@"男", @"女", nil];
        [self showPickerViewWithData:array tag:tag];
    } else if (tag == 0){ // 院系
        [self showPickerViewWithData:self.arrayDepart tag:tag];
    }else if (tag == 1) { // 专业
        [self showPickerViewWithData:self.arrayMajor tag:tag];
    }
}

- (void)showPickerViewWithData:(NSMutableArray *)data tag:(NSInteger)tag {
    self.pickerView.tag = tag;
    [self.pickerView setArrayData:data];
    [self.pickerView show];
    
    ProfileCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:tag inSection:1]];
    
    CGFloat y = CGRectGetMaxY(cell.frame) + 64;
    CGFloat yToBottom = self.view.height - y;
    
    if (yToBottom < self.pickerView.heightPicker) {
        [UIView animateWithDuration:0.3 animations:^{
            self.tableView.contentOffset = CGPointMake(self.tableView.contentOffset.x, self.tableView.contentOffset.y + self.pickerView.heightPicker - yToBottom);
        }];
    }
}

- (void)showPhotoMenuWithTitle:(NSString *)title {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
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

#pragma mark - UIImagePickerControllerDelegate method

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *selectedImage = info[UIImagePickerControllerEditedImage];
    if (selectedImage) {
        ProfileImageCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        cell.headView.image = selectedImage;
        cell.modified = YES;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - PickerSingleDelegate
- (void)pickerSingle:(STPickerSingle *)pickerSingle selectedTitle:(NSString *)selectedTitle
{
    NSIndexPath *indexPath;
    switch (pickerSingle.tag) {
        case 0:
            indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
            break;
        case 1:
            indexPath = [NSIndexPath indexPathForRow:1 inSection:1];
            break;
        case 2:
            indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
            break;
        default:
            break;
    }
    ProfileCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (pickerSingle.tag == 0 && ![cell.textField.text isEqualToString:selectedTitle]) {
        cell.textField.text = selectedTitle;
        cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section]];
        cell.textField.text = nil;
    }else {
        cell.textField.text = selectedTitle;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.contentOffset = CGPointMake(self.tableView.contentOffset.x, -64);
    }];
}

- (void)pickerSingleDidCancel:(STPickerSingle *)pickerSingle {
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.contentOffset = CGPointMake(self.tableView.contentOffset.x, -64);
    }];
}

#pragma mark - Getter

- (NSArray *)data {
    if (!_data) {
        _data = @[@[@"昵称", @"性别", @"简介"], @[@"院系", @"专业"]];
    }
    return _data;
}

- (STPickerSingle *)pickerView {
    if (!_pickerView) {
        _pickerView = [[STPickerSingle alloc] init];
        [_pickerView setContentMode:STPickerContentModeBottom];
        _pickerView.widthPickerComponent = self.view.width;
        
        [_pickerView setDelegate:self];
    }
    return _pickerView;
}

- (NSArray *)arrayRoot
{
    if (!_arrayRoot) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"school" ofType:@"plist"];
        _arrayRoot = [[NSArray alloc] initWithContentsOfFile:path];
    }
    return _arrayRoot;
}

- (NSMutableArray *)arrayDepart {
    if (!_arrayDepart) {
        NSMutableArray *array = [NSMutableArray array];
        [self.arrayRoot enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj[@"school"] isEqualToString:[XFUser getUserSchool]]) {
                arraySelected = obj[@"departs"];
                *stop = YES;
            }
        }];
        [arraySelected enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [array addObject:obj[@"depart"]];
        }];
        _arrayDepart = array;
    }
    return _arrayDepart;
}

- (NSMutableArray *)arrayMajor {
    if (self.arrayDepart) {}
    ProfileCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    [arraySelected enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj[@"depart"] isEqualToString:cell.textField.text]) {
            _arrayMajor = obj[@"majors"];
            *stop = YES;
        }
    }];
    return _arrayMajor;
}


@end
