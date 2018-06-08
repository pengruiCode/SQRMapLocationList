//
//  BaseViewController.m
//  Dangdang
//
//  Created by ZhangXiaofei on 16/9/13.
//  Copyright © 2016年 Yuri. All rights reserved.
//

#import "LKBaseViewController.h"
#import "LKCommonNoNetworkingView.h"
#import <objc/runtime.h>

/** 网络请求成功*/
NSString *const kRequestSuccessNotification = @"kRequestSuccessNotification";

const char LKBaseTableVcNavRightItemHandleKey;
const char LKBaseTableVcNavLeftItemHandleKey;

@interface LKBaseViewController ()
{
     UIImageView *_navShadowImageView;
}

@property (nonatomic, strong) UINavigationBar *bar;

@property (nonatomic, weak) LKCommonNoNetworkingView *noNetworkEmptyView;

@end

@implementation LKBaseViewController

@synthesize navItemTitle = _navItemTitle;
@synthesize navRightItem = _navRightItem;
@synthesize navLeftItem = _navLeftItem;

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIView setAnimationsEnabled:YES];
    if (self.hiddenNavigationBarShadowImageView) {
        _navShadowImageView.hidden = YES;
    }
    //
    //    // 在自定义leftBarButtonItem后添加下面代码就可以完美解决返回手势无效的情况
    //    if ([  respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
    //        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    //    }
    NSArray *gestureArray = self.navigationController.view.gestureRecognizers;
    //当是侧滑手势的时候设置scrollview需要此手势失效才生效即可
    for (UIGestureRecognizer *gesture in gestureArray) {
        if ([gesture isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
            for (UIView *sub in self.view.subviews) {
                if ([sub isKindOfClass:[UIScrollView class]]) {
                    UIScrollView *sc = (UIScrollView *)sub;
                    [sc.panGestureRecognizer requireGestureRecognizerToFail:gesture];
                }
            }
        }
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (self.hiddenNavigationBarShadowImageView) {
        _navShadowImageView.hidden = NO;
    }
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self loadData];
    
    [UIView setAnimationsEnabled:YES];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
//    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationController.navigationBar.translucent = NO;
    
    self.navigationController.interactivePopGestureRecognizer.delaysTouchesBegan = NO;

    self.navigationController.navigationBar.barTintColor = [UIColor lightGrayColor];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName :[UIColor whiteColor]}];
    
    self.view.backgroundColor = [UIColor whiteColor];

    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.tabBarController.tabBar.translucent = NO;
    
    _navShadowImageView = [self findShadowImageViewUnder:self.navigationController.navigationBar];
    
    [[UINavigationBar appearance] setBarTintColor: [UIColor whiteColor]];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)pop {
    if (self.navigationController == nil) return ;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)popToRootVc {
    if (self.navigationController == nil) return ;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)popToVc:(UIViewController *)vc {
    if ([vc isKindOfClass:[UIViewController class]] == NO) return ;
    if (self.navigationController == nil) return ;
    [self.navigationController popToViewController:vc animated:YES];
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dismissWithCompletion:(void(^)(void))completion {
    [self dismissViewControllerAnimated:YES completion:completion];
}

- (void)presentVc:(UIViewController *)vc {
    if ([vc isKindOfClass:[UIViewController class]] == NO) return ;
    [self presentVc:vc completion:nil];
}

- (void)presentVc:(UIViewController *)vc completion:(void (^)(void))completion {
    if ([vc isKindOfClass:[UIViewController class]] == NO) return ;
    [self presentViewController:vc animated:YES completion:completion];
}

- (void)pushVc:(UIViewController *)vc {
    if ([vc isKindOfClass:[UIViewController class]] == NO) return ;
    if (self.navigationController == nil) return ;
    if (vc.hidesBottomBarWhenPushed == NO) {
        vc.hidesBottomBarWhenPushed = YES;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)removeChildVc:(UIViewController *)childVc {
    if ([childVc isKindOfClass:[UIViewController class]] == NO) {
        return ;
    }
    [childVc.view removeFromSuperview];
    [childVc willMoveToParentViewController:nil];
    [childVc removeFromParentViewController];
}

- (void)addChildVc:(UIViewController *)childVc {
    if ([childVc isKindOfClass:[UIViewController class]] == NO) {
        return ;
    }
    [childVc willMoveToParentViewController:self];
    [self addChildViewController:childVc];
    [self.view addSubview:childVc.view];
    childVc.view.frame = self.view.bounds;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)PopGoBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)navigationShouldPopOnBackButton {
    return YES;//返回NO 不会执行
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait ;
}

- (BOOL)shouldAutorotate {
    return YES;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)setIsNetworkReachable:(BOOL)isNetworkReachable {
    _isNetworkReachable = isNetworkReachable;
    [self noNetworkEmptyView];
}

- (LKCommonNoNetworkingView *)noNetworkEmptyView {
    if (!_noNetworkEmptyView) {
        LKCommonNoNetworkingView *empty = [[LKCommonNoNetworkingView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:empty];
        _noNetworkEmptyView = empty;
        
        __weak typeof(self)weakSelf = self;

        empty.customNoNetworkEmptyViewDidClickRetryHandle = ^(LKCommonNoNetworkingView *emptyView) {
            [weakSelf loadData];
        };
    }
    return _noNetworkEmptyView;
}

- (void)hideLoadingAnimation {

}

- (void)loadData {
    
}

/** 设置导航栏右边的item*/
- (void)LK_setUpNavRightItemTitle:(NSString *)itemTitle attributes:(NSDictionary *)attributes handle:(void(^)(NSString *rightItemTitle))handle {
    if (attributes) {
        [self LK_setUpNavItemTitle:itemTitle attributes:attributes handle:handle leftFlag:NO];
    } else {
        [self LK_setUpNavItemTitle:itemTitle handle:handle leftFlag:NO];

    }
}

/** 设置导航栏左边的item*/
- (void)LK_setUpNavLeftItemTitle:(NSString *)itemTitle attributes:(NSDictionary *)attributes handle:(void(^)(NSString *leftItemTitle))handle {
    if (attributes) {
        [self LK_setUpNavItemTitle:itemTitle attributes:attributes handle:handle leftFlag:YES];

    } else {
        [self LK_setUpNavItemTitle:itemTitle handle:handle leftFlag:YES];
        
    }
}

- (void)LK_setUpNavRightItemTitle:(NSString *)itemTitle handle:(void(^)(NSString *rightItemTitle))handle {
    [self LK_setUpNavRightItemTitle:itemTitle attributes:nil handle:handle];
}

- (void)LK_setUpNavLeftItemTitle:(NSString *)itemTitle handle:(void(^)(NSString *rightItemTitle))handle {
    [self LK_setUpNavLeftItemTitle:itemTitle attributes:nil handle:handle];
}

/** 设置导航栏右边的item*/
- (void)LK_setUpNavRightItemImage:(UIImage *)itemImage handle:(void(^)(UIImage *rightItemImage))handle {
    [self LK_setUpNavItemImage:itemImage handle:handle leftFlag:NO];
}


/** 设置导航栏左边的item*/
- (void)LK_setUpNavLeftItemImage:(UIImage *)itemImage handle:(void(^)(UIImage *leftItemImage))handle {
    [self LK_setUpNavItemImage:itemImage handle:handle leftFlag:YES];
}

- (void)LK_navItemHandle:(UIBarButtonItem *)item {
    
    void (^handle)(NSString *);
    if ([item isEqual:self.navLeftItem]) {
        handle = objc_getAssociatedObject(self, &LKBaseTableVcNavLeftItemHandleKey);
    } else {
        handle = objc_getAssociatedObject(self, &LKBaseTableVcNavRightItemHandleKey);
    }
    
    if (handle) {
        handle(item.title);
    }
}

- (void)LK_navItemHandleImage:(UIBarButtonItem *)item {
    
    void (^handle)(UIImage *);
    if ([item isEqual:self.navRightItem]) {
        handle = objc_getAssociatedObject(self, &LKBaseTableVcNavRightItemHandleKey);
    } else {
        handle = objc_getAssociatedObject(self, &LKBaseTableVcNavLeftItemHandleKey);
    }
    
    if (handle) {
        handle(item.image);
    }
}
- (void)LK_navItemBtnHandle:(UIButton *)item {
    
    void (^handle)(NSString *);
    if (item.tag == 0) {
        handle = objc_getAssociatedObject(self, &LKBaseTableVcNavLeftItemHandleKey);
    } else {
        handle = objc_getAssociatedObject(self, &LKBaseTableVcNavRightItemHandleKey);
    }
    
    if (handle) {
        handle(item.titleLabel.text);
    }
}


- (void)LK_setUpNavItemTitle:(NSString *)itemTitle handle:(void(^)(NSString *itemTitle))handle leftFlag:(BOOL)leftFlag {
    if (itemTitle.length == 0 || !handle) {
        if (itemTitle == nil) {
            itemTitle = @"";
        } else if ([itemTitle isKindOfClass:[NSNull class]]) {
            itemTitle = @"";
        }
        if (leftFlag) {
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:itemTitle style:UIBarButtonItemStylePlain target:nil action:nil];
        } else {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:itemTitle style:UIBarButtonItemStylePlain target:nil action:nil];
        }

    } else {
        if (leftFlag) {
            objc_setAssociatedObject(self, &LKBaseTableVcNavLeftItemHandleKey, handle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:itemTitle style:UIBarButtonItemStylePlain target:self action:@selector(LK_navItemHandle:)];
        } else {
            objc_setAssociatedObject(self, &LKBaseTableVcNavRightItemHandleKey, handle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:itemTitle style:UIBarButtonItemStylePlain target:self action:@selector(LK_navItemHandle:)];
        }
    }
    
}

- (void)LK_setUpNavItemTitle:(NSString *)itemTitle attributes:(NSDictionary *)attributes handle:(void(^)(NSString *itemTitle))handle leftFlag:(BOOL)leftFlag {
    if (itemTitle.length == 0 || !handle) {
        if (itemTitle == nil) {
            itemTitle = @"";
        } else if ([itemTitle isKindOfClass:[NSNull class]]) {
            itemTitle = @"";
        }
        if (leftFlag) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 44)];
            NSAttributedString *str = [[NSAttributedString alloc] initWithString:itemTitle attributes:attributes];
            [btn setAttributedTitle:str forState:UIControlStateNormal];
            [btn sizeToFit];
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
        } else {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 44)];
            NSAttributedString *str = [[NSAttributedString alloc] initWithString:itemTitle attributes:attributes];
            [btn setAttributedTitle:str forState:UIControlStateNormal];
            [btn sizeToFit];
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
        }
        
    } else {
        if (leftFlag) {
            objc_setAssociatedObject(self, &LKBaseTableVcNavLeftItemHandleKey, handle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 44)];
            NSAttributedString *str = [[NSAttributedString alloc] initWithString:itemTitle attributes:attributes];
            [btn setAttributedTitle:str forState:UIControlStateNormal];
            [btn sizeToFit];
            btn.tag = 0;
            [btn addTarget:self action:@selector(LK_navItemBtnHandle:) forControlEvents:UIControlEventTouchUpInside];
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
            
        } else {
            objc_setAssociatedObject(self, &LKBaseTableVcNavRightItemHandleKey, handle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 44)];
            NSAttributedString *str = [[NSAttributedString alloc] initWithString:itemTitle attributes:attributes];
            [btn setAttributedTitle:str forState:UIControlStateNormal];
            [btn sizeToFit];
            btn.tag = 1;
            [btn addTarget:self action:@selector(LK_navItemBtnHandle:) forControlEvents:UIControlEventTouchUpInside];
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
        }
    }
    
}

- (void)LK_setUpNavItemImage:(UIImage *)itemImage handle:(void(^)(UIImage *itemImage))handle leftFlag:(BOOL)leftFlag {
    if (itemImage && !handle) {
        
        if (leftFlag) {
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:itemImage style:UIBarButtonItemStylePlain target:nil action:nil];
        } else {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:itemImage style:UIBarButtonItemStylePlain target:nil action:nil];
        }
    } else if (itemImage && handle) {
        if (leftFlag) {
            objc_setAssociatedObject(self, &LKBaseTableVcNavLeftItemHandleKey, handle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:itemImage style:UIBarButtonItemStylePlain target:self action:@selector(LK_navItemHandleImage:)];
        } else {
            objc_setAssociatedObject(self, &LKBaseTableVcNavRightItemHandleKey, handle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:itemImage style:UIBarButtonItemStylePlain target:self action:@selector(LK_navItemHandleImage:)];
        }
    }
    
}


/** 右边item*/
- (void)setNavRightItem:(UIBarButtonItem *)navRightItem {
    _navRightItem = navRightItem;
    self.navigationItem.rightBarButtonItem = navRightItem;
}


- (UIBarButtonItem *)navRightItem {
    return self.navigationItem.rightBarButtonItem;
}
/** 左边item*/
- (void)setNavLeftItem:(UIBarButtonItem *)navLeftItem {
    
    _navLeftItem = navLeftItem;
    self.navigationItem.leftBarButtonItem = navLeftItem;
}

- (UIBarButtonItem *)navLeftItem {
    return self.navigationItem.leftBarButtonItem;
}

/** 导航栏标题*/
- (void)setNavItemTitle:(NSString *)navItemTitle {
    if ([navItemTitle isKindOfClass:[NSString class]] == NO) return ;
    if ([navItemTitle isEqualToString:_navItemTitle]) return ;
    _navItemTitle = navItemTitle.copy;
    self.navigationItem.title = navItemTitle;
}

/** 导航栏底部的隐形*/
- (UIImageView *)findShadowImageViewUnder:(UIView *)view {
    
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    
    for (UIView *subView in view.subviews) {
        UIImageView *imageView = [self findShadowImageViewUnder:subView];
        if (imageView) {
            return  imageView;
        }
    }
    return nil;
}

- (BOOL)isTranslucent {
    return NO;
}


@end
