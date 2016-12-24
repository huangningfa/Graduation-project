//
//  RegisterViewController.m
//  xiaofu
//
//  Created by HNF's wife on 2016/11/29.
//  Copyright © 2016年 huangningfa@163.com. All rights reserved.
//

#import "RegisterViewController.h"
#import "AniTextField.h"
#import "GenderView.h"
#import "SelectImageView.h"
#import "DisplayView.h"
#import "STPickerSingle.h"
#import <BmobSDK/Bmob.h>
#import "RootTool.h"

@interface RegisterViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, STPickerSingleDelegate>

@property (nonatomic, weak) SelectImageView *headImageView;

@property (nonatomic, weak) AniTextField *nameView;

@property (nonatomic, weak) GenderView *genderView;

@property (nonatomic, weak) DisplayView *schoolView;
@property (nonatomic, weak) DisplayView *departmentView;
@property (nonatomic, weak) DisplayView *majorView;

@property (nonatomic, strong) STPickerSingle *pickerView;

@property (nonatomic, strong) NSArray *arrayRoot;
@property (nonatomic, strong) NSMutableArray *arraySchool;
@property (nonatomic, strong) NSMutableArray *arrayDepart;
@property (nonatomic, strong) NSMutableArray *arrayMajor;

@end

@implementation RegisterViewController{
    NSArray *arraySelected;
    DisplayView *selectedView;
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

- (NSMutableArray *)arraySchool {
    if (!_arraySchool) {
        NSMutableArray *array = [NSMutableArray array];
        [self.arrayRoot enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [array addObject:obj[@"school"]];
        }];
        _arraySchool = array;
    }
    return _arraySchool;
}

- (NSMutableArray *)arrayDepart {
        __block NSInteger index;
        [self.arrayRoot enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(NSDictionary  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj[@"school"] isEqualToString:self.schoolView.text]) {
                index = idx;
                *stop = YES;
            }
        }];
        arraySelected = self.arrayRoot[index][@"departs"];
        _arrayDepart = [NSMutableArray array];
        [arraySelected enumerateObjectsUsingBlock:^(NSDictionary  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [_arrayDepart addObject:obj[@"depart"]];
            
        }];
    
    return _arrayDepart;
}

- (NSMutableArray *)arrayMajor {

        __block NSInteger index;
        [arraySelected enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(NSDictionary  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj[@"depart"] isEqualToString:self.departmentView.text]) {
                index = idx;
                *stop = YES;
            }
        }];
        _arrayMajor = arraySelected[index][@"majors"];

    return _arrayMajor;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:(UIBarButtonItemStylePlain) target:self action:@selector(registerUser)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    [self setupHeadImageView];
    
    [self setupNameView];
    
    [self setupGenderView];
    
    [self setupSchoolView];
    [self setupDepartmentView];
    [self setupMajorView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)setupMajorView {
    DisplayView *majorView = [[DisplayView alloc] initWithText:@"请选择专业" font:FontSize(14)];
    [self.view addSubview:majorView];
    self.majorView = majorView;
    [majorView addTarget:self action:@selector(showPickerView:) forControlEvents:(UIControlEventTouchUpInside)];
    [majorView addObserver:self forKeyPath:@"text" options:(NSKeyValueObservingOptionNew) context:nil];
    
    [majorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.equalTo(self.departmentView.mas_bottom).offset(15*SizeScale);
        make.size.mas_equalTo(SizeMake(320, 30));
    }];
}

- (void)setupDepartmentView {
    DisplayView *departmentView = [[DisplayView alloc] initWithText:@"请选择院系" font:FontSize(14)];
    [self.view addSubview:departmentView];
    self.departmentView = departmentView;
    departmentView.tag = 10002;
    [departmentView addTarget:self action:@selector(showPickerView:) forControlEvents:(UIControlEventTouchUpInside)];
    [departmentView addObserver:self forKeyPath:@"text" options:(NSKeyValueObservingOptionNew) context:nil];
    
    [departmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.equalTo(self.schoolView.mas_bottom).offset(15*SizeScale);
        make.size.mas_equalTo(SizeMake(320, 30));
    }];
}

- (void)setupSchoolView {
    DisplayView *schoolView = [[DisplayView alloc] initWithText:@"请选择学校" font:FontSize(14)];
    [self.view addSubview:schoolView];
    self.schoolView = schoolView;
    schoolView.tag = 10001;
    [schoolView addTarget:self action:@selector(showPickerView:) forControlEvents:(UIControlEventTouchUpInside)];
    [schoolView addObserver:self forKeyPath:@"text" options:(NSKeyValueObservingOptionNew) context:nil];
    
    [schoolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.equalTo(self.genderView.mas_bottom).offset(15*SizeScale);
        make.size.mas_equalTo(SizeMake(320, 30));
    }];
}

- (void)registerUser {
    [self.view endEditing:YES];
    NSString *name = self.nameView.textInput;
    name = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (name == nil || [name isEqualToString:@""]) {
        [XFProgressHUD showInfoMsg:@"昵称不能为空"];
        return;
    }
    [XFProgressHUD showLoading:@""];
    // 注册
    BmobUser *xfUser = [[BmobUser alloc] init];
    xfUser.mobilePhoneNumber = self.phoneNumber;
    xfUser.password = self.password;
    xfUser.username = name;
    [xfUser setObject:self.genderView.selectedGender forKey:@"gender"];
    [xfUser setObject:self.schoolView.text forKey:@"school"];
    [xfUser setObject:self.departmentView.text forKey:@"department"];
    [xfUser setObject:self.majorView.text forKey:@"major"];
    [xfUser setObject:@"Ta很懒，什么话也没说" forKey:@"description"];
    [xfUser setObject:[NSNumber numberWithBool:YES] forKey:@"mobilePhoneNumberVerified"];
    [xfUser setObject:@0 forKey:@"solve"];
    [xfUser setObject:@0 forKey:@"solved"];

    NSString *headImageName = [NSString stringWithFormat:@"%@headImage.jpg", self.phoneNumber];
    BmobFile *headImage = [[BmobFile alloc] initWithFileName:headImageName withFileData:UIImageJPEGRepresentation(self.headImageView.image, 0.5)];
    [headImage saveInBackground:^(BOOL isSuccessful, NSError *error) {

        if (error == nil && isSuccessful) {
            [xfUser setObject:headImage forKey:@"headImage"];
            [xfUser setObject:headImage forKey:@"backgroundImage"];
            [xfUser signUpInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
                if (isSuccessful && error == nil) {
                    // 注册成功，进入主界面
                    [XFProgressHUD hide];
                    [XFProgressHUD showSuccess:@"成功注册"];
                    [XFProgressHUD sharedHUD].completionBlock = ^ {
                        [RootTool enterMainViewController];
                    };
                } else {
                    [XFProgressHUD hide];
                    [XFProgressHUD showInfoMsg:@"服务器异常/(ㄒoㄒ)/"];
                   
                }
            }];
        }else {
            [XFProgressHUD hide];
            [XFProgressHUD showInfoMsg:@"服务器异常/(ㄒoㄒ)/"];
        }
    }];
}

- (void)showPickerView:(DisplayView *)sender {
    selectedView = sender;
    [self.view endEditing:YES];
    
    if (sender.tag == 10001) {
        // school
        [self showPickerViewWithData:self.arraySchool];
        
    } else if (sender.tag == 10002) {
        // department
        if (self.schoolView.text == nil) {
            [XFProgressHUD showInfoMsg:@"请先选择学校"];
        }else {
            [self showPickerViewWithData:self.arrayDepart];
        }
        
    }else {
        // major
        if (self.schoolView.text == nil) {
            [XFProgressHUD showInfoMsg:@"请先选择学校"];
        } else if (self.departmentView.text == nil) {
            [XFProgressHUD showInfoMsg:@"请先选择院系"];
        }else {
            [self showPickerViewWithData:self.arrayMajor];
        }
        
    }
}

- (void)showPickerViewWithData:(NSMutableArray *)data {
    [self.pickerView setArrayData:data];
    [self.pickerView show];
}

- (void)setupGenderView {
    GenderView *genderView = [[GenderView alloc] initWithTitleFontSize:14];
    self.genderView = genderView;
    [self.view addSubview:genderView];
    [genderView addObserver:self forKeyPath:@"selectedGender" options:(NSKeyValueObservingOptionNew) context:nil];
    
    [genderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.size.mas_equalTo(SizeMake(320, 30));
        make.top.equalTo(self.nameView.mas_bottom).offset(15*SizeScale);
    }];
}

- (void)setupNameView {
    AniTextField *nameView = [[AniTextField alloc] initWithLeftTitle:@"" titleFontSize:16 placeholder:@"昵称" placeholderFontSize:14];
    self.nameView = nameView;
    [self.view addSubview:nameView];
    [nameView addObserver:self forKeyPath:@"textInput" options:(NSKeyValueObservingOptionNew) context:nil];
    
    [nameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.equalTo(self.headImageView.mas_bottom).offset(15*SizeScale);
        make.size.mas_equalTo(SizeMake(320, 30));
    }];
}

- (void)setupHeadImageView {
    SelectImageView *headImageView = [[SelectImageView alloc] init];
    self.headImageView = headImageView;
    [self.view addSubview:headImageView];
    [headImageView addTarget:self action:@selector(selectImage)];
    [headImageView addObserver:self forKeyPath:@"image" options:(NSKeyValueObservingOptionNew) context:nil];
    
    [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.offset(20*SizeScale+44+20);
        make.size.mas_equalTo(SizeMake(70, 70));
    }];
}

- (void)selectImage {
    if ([UIImagePickerController isSourceTypeAvailable:(UIImagePickerControllerSourceTypeCamera)]) {
        [self showPhotoMenu];
    }else {
        [self choosePhotoFromLibrary];
    }
}

- (void)showPhotoMenu {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
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
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)takePhotoWithCamera {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate method

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *selectedImage = info[UIImagePickerControllerEditedImage];
    if (selectedImage) {
        self.headImageView.image = selectedImage;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - PickerSingleDelegate
- (void)pickerSingle:(STPickerSingle *)pickerSingle selectedTitle:(NSString *)selectedTitle
{
    if (![selectedView.text isEqualToString:selectedTitle]) {
        selectedView.text = selectedTitle;
    }
}

#pragma mark - Observer
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if ([object isKindOfClass:[GenderView class]]) {
        [self.view endEditing:YES];
    }
    
    if ([object isKindOfClass:[DisplayView class]]) {
        DisplayView *displayView = (DisplayView *)object;
        if (displayView.tag == 10001) { // school
            [self.departmentView backToOriginal];
            [self.majorView backToOriginal];
        }else if (displayView.tag == 10002) { // department
            [self.majorView backToOriginal];
        }
    }
    
    if (self.headImageView.image && self.nameView.textInput != nil && self.genderView.selectedGender != nil && self.schoolView.text != nil && self.departmentView.text != nil && self.majorView.text != nil) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }else {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

- (void)dealloc {
    [self.headImageView removeObserver:self forKeyPath:@"image"];
    [self.nameView removeObserver:self forKeyPath:@"textInput"];
    [self.genderView removeObserver:self forKeyPath:@"selectedGender"];
    [self.schoolView removeObserver:self forKeyPath:@"text"];
    [self.departmentView removeObserver:self forKeyPath:@"text"];
    [self.majorView removeObserver:self forKeyPath:@"text"];
}

@end
