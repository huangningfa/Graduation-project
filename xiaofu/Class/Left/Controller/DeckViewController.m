//
//  DeckViewController.m
//  ShareTribe
//
//  Created by HNF's wife on 16/7/18.
//  Copyright © 2016年 HNF's wife. All rights reserved.
//

#import "DeckViewController.h"
#import "UIView+Extension.h"
#import "XFConfig.h"
#import "UIBarButtonItem+Extension.h"

#define AnimationDuration 0.25              // 开关侧栏动画时间
#define MainViewTransformScale 0.85         // Scale式架构时，主页缩放比例
#define MaskViewAlpha 0.6                   // Cover式架构时，遮罩视图最小透明度


//UITableView
/**
 抽屉式架构状态类型
 - Collapsed:         关闭状态
 - LeftPanelExpanded: 左侧栏打开状态
 */
typedef NS_ENUM(NSInteger, DeckDrawerState) {
    DeckDrawerStateCollapsed,
    DeckDrawerStateLeftPanelExpanded
};


@interface DeckViewController ()

@property (nonatomic, assign) DeckDrawerStyle style;
@property (nonatomic, strong) UIViewController *mainVC;
@property (nonatomic, strong) UIViewController *leftVC;
@property (nonatomic, assign) BOOL panEnabled;
@property (nonatomic, assign) BOOL tapEnabled;
@property (nonatomic, assign) DeckDrawerState currentState;

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIPanGestureRecognizer *coverPanGesture;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;

@property (nonatomic, assign) BOOL isScrolling;
@property (nonatomic, assign) BOOL isLeftBtnTaped;

@property (nonatomic, strong) UIViewController *nextMainVC;

@end

@implementation DeckViewController

-(UIView *)maskView {
    if (!_maskView) {
        UIView *maskView = [[UIView alloc] initWithFrame:CGRectZero];
        maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
        maskView.translatesAutoresizingMaskIntoConstraints = NO;
        // Add tap recognizer
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGestrue:)];
        [maskView addGestureRecognizer:tapGesture];
        _maskView = maskView;
    }
    return _maskView;
}

//无效
-(UIPanGestureRecognizer *)coverPanGesture {
    if (self.style == DeckDrawerStyleCover) {
        // Add pan recognizer
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleMainViewPanGesture:)];
        self.leftVC.view.userInteractionEnabled = YES;
        [self.leftVC.view addGestureRecognizer:panGesture];
        return panGesture;
    }
    return nil;
}

//当侧栏状态改变时设置阴影：侧栏关闭时阴影为0，打开是阴影为0.3
-(void)setCurrentState:(DeckDrawerState)currentState {
    _currentState = currentState;
    if (currentState == DeckDrawerStateCollapsed) {
        self.mainVC.view.layer.shadowOpacity = 0.0;
    }else {
        self.mainVC.view.layer.shadowOpacity = 0.3;
    }
}

//初始化方法
-(instancetype)initWithDrawerStyle:(DeckDrawerStyle)drawerStyle mainViewController:(UIViewController *)mainViewController leftViewController:(UIViewController *)leftViewController {
    if ([super init]) {
        self.style = drawerStyle;
        self.panEnabled = YES;
        self.tapEnabled = YES;
        self.currentState = DeckDrawerStateCollapsed;
        self.mainVC = mainViewController;
        self.leftVC = leftViewController;
        //self.view.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupMainViewController];
    [self setupLeftViewController];
}

- (void)setupMainViewController {
    [self handleMainVC:self.mainVC];
    // Add mainVC
    self.mainVC.view.layer.shadowOffset = CGSizeZero;
    [self addChildViewController:_mainVC];
    [self.view addSubview:_mainVC.view];
    [self.view bringSubviewToFront:_mainVC.view];
    [self.mainVC didMoveToParentViewController:self];
    
    // Add pan recognizer
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleMainViewPanGesture:)];
    UIScreenEdgePanGestureRecognizer *edgeGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleMainViewPanGesture:)];
    edgeGesture.edges = UIRectEdgeLeft;
    self.mainVC.view.userInteractionEnabled = YES;
    [self.mainVC.view addGestureRecognizer:panGesture];
    [self.mainVC.view addGestureRecognizer:edgeGesture];
    panGesture.enabled = NO;
    self.panGesture = panGesture;
}

- (void)setupLeftViewController {
    // Add LeftVC
    [self addChildViewController:_leftVC];
    [self.leftVC didMoveToParentViewController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (BOOL)prefersStatusBarHidden {
//    if (self.currentState == DeckDrawerStateLeftPanelExpanded) {
//        return YES;
//    }else if (self.isScrolling && self.currentState == DeckDrawerStateCollapsed) {
//        return YES;
//    }else if (self.isLeftBtnTaped) {
//        return YES;
//    }
//    
//    return NO;
//}

//- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
//    return UIStatusBarAnimationSlide;
//}

// MARK: - Target actions

- (void)leftBarItemWasTaped {
    self.isLeftBtnTaped = YES;
    if ([self isCollapsed]) {
        [self expandLeftPanel];
    }else {
        [self collapsePanel];
    }
}

- (void)handleTapGestrue:(UITapGestureRecognizer *)tapGesture {
    if (!(self.currentState == DeckDrawerStateLeftPanelExpanded && self.tapEnabled == YES)) {
        return;
    }
    //
    [self animateLeftPanelShouldExpand:NO];
}

- (void)handleMainViewPanGesture:(UIPanGestureRecognizer *)panGesture {
    if (!self.panEnabled) {
        return;
    }
    CGFloat position = [panGesture translationInView:self.view].x;
    
    //CGFloat locationX = [panGesture locationInView:self.view].x;
//    NSLog(@"%f", locationX);
//    if (self.currentState == DeckDrawerStateCollapsed && panGesture.state == UIGestureRecognizerStateBegan && locationX>30) {
//        return;
//    }
    
    // 该移动的视图
    UIView *offsetView = self.style == DeckDrawerStyleCover ? self.leftVC.view : self.mainVC.view;
    CGFloat offsetCenterX = self.style == DeckDrawerStyleCover ? -[self mainViewWidth] : 0;
    
    // 设置目标中心位置
    CGFloat targetOffsetCenterX = 0;
    CGFloat defaultTypeLeftViewTargetPosition = 0;
    CGFloat scaleTypeMainViewTransformScale = 1.0;
    CGFloat coverTypeMaskAlphaScale = 0.0;
    
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
            self.isScrolling = YES;
            [self updateStatusBar];
            // 如果初始为闭合状态，则把响应的视图添加上去
            if (self.currentState == DeckDrawerStateCollapsed) {
                switch (self.style) {
                    case DeckDrawerStyleCover:
                        // Add maskView
                        self.maskView.frame = self.view.bounds;
                        [self.view insertSubview:self.maskView aboveSubview:self.mainVC.view];
                        [self.view addConstraints:[self maskHConstraints]];
                        [self.view addConstraints:[self maskVConstraints]];
                        
                        // Add leftView
                        self.leftVC.view.frame = self.view.bounds;
                        [self.view insertSubview:_leftVC.view aboveSubview:self.maskView];
                        self.leftVC.view.centerX = -[self mainViewWidth] / 2;
                        break;
                    case DeckDrawerStyleDefault:
                    case DeckDrawerStyleScale:
                        // Add leftView
                        //self.leftVC.view.frame = self.view.bounds;
                        self.leftVC.view.frame = CGRectMake(0, 0, self.view.width * (OffsetScale+0.001), self.view.height);//111111111111
                        [self.view insertSubview:_leftVC.view belowSubview:_mainVC.view];
                        
                        _maskView.frame = _mainVC.view.bounds;
                        [_mainVC.view addSubview:self.maskView];
                        [_mainVC.view addConstraints:[self maskHConstraints]];
                        [_mainVC.view addConstraints:[self maskVConstraints]];
                        break;
                    default:
                        break;
                }
            }else {
                [self setTapGestureEnabled:NO];//???
            }
            break;
           
        case UIGestureRecognizerStateChanged:
            
            switch (self.currentState) {
                case DeckDrawerStateCollapsed:
                    targetOffsetCenterX = self.view.center.x + offsetCenterX + position;
                    defaultTypeLeftViewTargetPosition = self.view.center.x - [self mainViewWidth] * (1 - OffsetScale) * (1 - position / ([self mainViewWidth] * OffsetScale));
                    scaleTypeMainViewTransformScale = MainViewTransformScale + (1 - MainViewTransformScale) * (1 - position / ([self mainViewWidth ] * OffsetScale));
                    coverTypeMaskAlphaScale = position / ([self mainViewWidth ] * OffsetScale);
                    break;
                case DeckDrawerStateLeftPanelExpanded:
                    targetOffsetCenterX = self.view.center.x + offsetCenterX + ([self mainViewWidth ] * OffsetScale) + position;
                    defaultTypeLeftViewTargetPosition = self.view.center.x + position * (1 - OffsetScale) * [self mainViewWidth] / ([self mainViewWidth] * OffsetScale);
                    scaleTypeMainViewTransformScale = MainViewTransformScale + (1 - MainViewTransformScale) * (-position / ([self mainViewWidth] * OffsetScale));
                    coverTypeMaskAlphaScale = 1 + position / ([self mainViewWidth] * OffsetScale);
                    break;
                default:
                    break;
            }
            
            // 超出范围时处理
            if (targetOffsetCenterX > self.view.center.x + offsetCenterX + ([self mainViewWidth] * OffsetScale)) {
                targetOffsetCenterX = self.view.center.x + offsetCenterX + ([self mainViewWidth] * OffsetScale);
            } else if (targetOffsetCenterX < self.view.center.x + offsetCenterX) {
                targetOffsetCenterX = self.view.center.x + offsetCenterX;
            }
            if (defaultTypeLeftViewTargetPosition > self.view.center.x) {
                defaultTypeLeftViewTargetPosition = self.view.center.x;
            } else if (defaultTypeLeftViewTargetPosition < self.view.center.x - [self mainViewWidth] * (1 - OffsetScale)) {
                defaultTypeLeftViewTargetPosition = self.view.center.x - [self mainViewWidth] * (1 - OffsetScale);
            }
            if (scaleTypeMainViewTransformScale > 1.0) {
                scaleTypeMainViewTransformScale = 1.0;
            } else if (scaleTypeMainViewTransformScale < MainViewTransformScale) {
                scaleTypeMainViewTransformScale = MainViewTransformScale;
            }
            if (coverTypeMaskAlphaScale > 1) {
                coverTypeMaskAlphaScale = 1;
            } else if (coverTypeMaskAlphaScale < 0) {
                coverTypeMaskAlphaScale = 0;
            }
            
            // 进行视图偏移
            offsetView.centerX = targetOffsetCenterX;
            [self defaultTypeLeftView].centerX = defaultTypeLeftViewTargetPosition * (OffsetScale+0.001);//11111111111111
            [self scaleTypeMainView].transform = CGAffineTransformTranslate(CGAffineTransformMakeScale(scaleTypeMainViewTransformScale, scaleTypeMainViewTransformScale), -[self mainViewWidth] * (1 - scaleTypeMainViewTransformScale) / 2, 0);
            [self coverMaskView].backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:MaskViewAlpha * coverTypeMaskAlphaScale];
            break;
            
        case UIGestureRecognizerStateEnded:
            self.isScrolling = NO;
            // 确定展开、闭合
            [self animateLeftPanelShouldExpand:(offsetView.center.x >= self.view.center.x + offsetCenterX + ([self mainViewWidth] * OffsetScale) / 2)];
            break;
            
        default:
            break;
    }
}

// MARK: - Animation

/**动画开关侧栏*/
- (void)animateLeftPanelShouldExpand:(BOOL)shouldExpand {
    if (shouldExpand) {
        // 显示侧栏
        CGFloat targetPosition;
        switch (self.style) {
            case DeckDrawerStyleDefault:
            case DeckDrawerStyleScale:
                targetPosition = [self mainViewWidth] * OffsetScale;
                break;
                
            case DeckDrawerStyleCover:
                targetPosition = [self mainViewWidth] * OffsetScale;
                break;
                
            default:
                break;
        }
        // 动画将偏移视图进行移动
        [self animateOffsetViewXPosition:targetPosition finished:^(BOOL finished) {
            self.currentState = DeckDrawerStateLeftPanelExpanded;
            
            if (self.style == DeckDrawerStyleCover) {
                self.coverPanGesture.enabled = YES;
            }
            [self setTapGestureEnabled:YES];
            self.isLeftBtnTaped = NO;
            self.panGesture.enabled = YES;
            [self updateStatusBar];
        }];
    }else {
        // 关闭侧栏
        [self animateOffsetViewXPosition:0 finished:^(BOOL finished) {
            self.currentState = DeckDrawerStateCollapsed;
            [self.leftVC.view removeFromSuperview];
            if (self.style == DeckDrawerStyleCover) {
                self.coverPanGesture.enabled = NO;
            }
            [self.maskView removeFromSuperview];
            
            if (self.nextMainVC != nil) {
                [self.mainVC willMoveToParentViewController:nil];
                [self.mainVC.view removeFromSuperview];
                [self.mainVC removeFromParentViewController];
#warning NSLOG
                NSLog(@"%ld", [self childViewControllers].count);
                self.mainVC = self.nextMainVC;
                [self setupMainViewController];
                NSLog(@"%ld", [self childViewControllers].count);
                self.nextMainVC = nil;
            }
            
            self.isLeftBtnTaped = NO;
            self.panGesture.enabled = NO;
            [self updateStatusBar];
        }];
    }
}

/**动画将偏移视图进行移动*/
- (void)animateOffsetViewXPosition:(CGFloat)position finished:(void(^)(BOOL))finish {
    UIView *offsetView = self.style == DeckDrawerStyleCover ? self.leftVC.view : self.mainVC.view;
    CGFloat offsetCenterX = self.style == DeckDrawerStyleCover? -[self mainViewWidth] : 0;
    
    // .Scale式，主视图添加缩放动画
    CGAffineTransform scaleTypeMainViewTargetTransform = position == 0 ? CGAffineTransformIdentity : CGAffineTransformMakeScale(MainViewTransformScale, MainViewTransformScale);
    if (position != 0) {
        CGFloat offset = -[self mainViewWidth] * (1 - MainViewTransformScale) / 2;
        scaleTypeMainViewTargetTransform = CGAffineTransformTranslate(scaleTypeMainViewTargetTransform, offset, 0);
    }

    
    // 动画显示
    [UIView animateWithDuration:AnimationDuration delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        offsetView.centerX = self.view.center.x + offsetCenterX + position;
        // .Default式架构，侧栏添加位移动画
        [self defaultTypeLeftView].centerX = (self.view.center.x - (position == 0 ? [self mainViewWidth] * (1 - OffsetScale) : 0)) * (OffsetScale+0.001);//111111111111
        
        // .Scale式，主视图添加缩放动画
        [self scaleTypeMainView].transform = scaleTypeMainViewTargetTransform;
        
        // .Cover式，遮罩视图动画更改透明度
        [self coverMaskView].backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:position == 0 ? 0.0 : MaskViewAlpha];

        
    } completion:^(BOOL finished) {
        if (finished) {
            finish(finished);
        }
    }];

}

// MARK: - Private methods

- (void)updateStatusBar {
//    [UIView animateWithDuration:0.3 animations:^{
//        [self setNeedsStatusBarAppearanceUpdate];
//    }];
}

- (CGFloat)mainViewWidth {
    return [UIScreen mainScreen].bounds.size.width;
}
// .Default式架构，侧栏添加位移动画
- (UIView *)defaultTypeLeftView{
    return self.style == DeckDrawerStyleDefault ? self.leftVC.view : nil;
}

// .Scale式，主视图添加缩放动画
- (UIView *)scaleTypeMainView {
    return self.style == DeckDrawerStyleScale ? self.mainVC.view : nil;
}

// .Cover式，遮罩视图动画更改透明度
- (UIView *)coverMaskView {
    return self.style == DeckDrawerStyleCover ? self.maskView : nil;
}


- (NSArray *)maskHConstraints {
    return [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_maskView]|" options:(NSLayoutFormatDirectionLeadingToTrailing) metrics:nil views:@{@"_maskView" : self.maskView}];
}

- (NSArray *)maskVConstraints {
    return [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_maskView]|" options:(NSLayoutFormatDirectionLeadingToTrailing) metrics:nil views:@{@"_maskView" : self.maskView}];
}

// MARK: - Public methods

- (UIViewController *)mainViewController {
    return self.mainVC;
}

- (UIViewController *)leftViewController {
    return self.leftVC;
}

- (void)setMainViewController:(UIViewController *)mainVC {
    //[self handleMainVC:mainVC];
    self.nextMainVC = mainVC;
    [self collapsePanel];
}

// 设置控制器左上角的item
- (void)handleMainVC:(UIViewController *)mainVC {
    UINavigationController *navc = (UINavigationController *)mainVC;
    UIViewController *vc = navc.viewControllers[0];
    vc.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"nav_menu_icon" highImageName:@"nav_menu_icon" target:self action:@selector(leftBarItemWasTaped)];
}



/**当前是否已关闭侧栏*/
- (BOOL)isCollapsed {
    return self.currentState == DeckDrawerStateCollapsed;
}

/**
 打开左侧栏
 */
- (void)expandLeftPanel {
    if (!(self.currentState == DeckDrawerStateCollapsed)) {
        return;
    }
    [self updateStatusBar];
    switch (self.style) {
        case DeckDrawerStyleCover:
            // Add maskView
            self.maskView.frame = self.view.bounds;
            [self.view insertSubview:_maskView aboveSubview:_mainVC.view];
            [self.view addConstraints:[self maskHConstraints]];
            [self.view addConstraints:[self maskVConstraints]];
            [self coverMaskView].backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
            
            // Add leftView
            self.leftVC.view.frame = self.view.bounds;
            [self.view insertSubview:_leftVC.view aboveSubview:self.maskView];
            self.leftVC.view.centerX = -[self mainViewWidth] / 2;
            break;
            
        case DeckDrawerStyleDefault:
            // Add leftView
            //self.leftVC.view.frame = self.view.bounds;
            self.leftVC.view.frame = CGRectMake(0, 0, self.view.width * (OffsetScale+0.001), self.view.height);//11111111111
            [self.view insertSubview:_leftVC.view belowSubview:_mainVC.view];
            self.leftVC.view.centerX = self.view.center.x - (1 - OffsetScale) * [self mainViewWidth];
            
            // Add maskView
            self.maskView.frame = _mainVC.view.bounds;
            [_mainVC.view addSubview:self.maskView];
            [_mainVC.view addConstraints:[self maskHConstraints]];
            [_mainVC.view addConstraints:[self maskVConstraints]];
            break;
            
        case DeckDrawerStyleScale:
            // Add leftView
            self.leftVC.view.frame = self.view.bounds;
            [self.view insertSubview:_leftVC.view belowSubview:_mainVC.view];
            _leftVC.view.centerX = self.view.center.x;
            
            // Add maskView
            self.maskView.frame = _mainVC.view.bounds;
            [_mainVC.view addSubview:self.maskView];
            [_mainVC.view addConstraints:[self maskHConstraints]];
            [_mainVC.view addConstraints:[self maskVConstraints]];
            break;
            
        default:
            break;
    }
    
    [self animateLeftPanelShouldExpand:YES];
}

/**
 关闭侧栏
 */
- (void)collapsePanel {
    if (!(_currentState == DeckDrawerStateLeftPanelExpanded)) {
        return;
    }
    [self animateLeftPanelShouldExpand:NO];
}

/**
 设置滑动手势开关
 */
- (void)setPanGestureEnabled:(BOOL)enabled {
    self.panEnabled = enabled;
}

/**
 设置点击手势开关
 */
- (void)setTapGestureEnabled:(BOOL)enabled {
    self.tapEnabled = enabled;
}

- (void)dealloc {
    NSLog(@"%@---------dealloc", NSStringFromClass([self class]));
    
}


@end
