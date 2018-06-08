//
//  BaseViewController.h
//  Dangdang
//
//  Created by ZhangXiaofei on 16/9/13.
//  Copyright © 2016年 Yuri. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^LKBaseViewControllerHandle)(void);

@interface LKBaseViewController : UIViewController



- (void)PopGoBack;

- (void)pop;

- (void)popToRootVc;

- (void)popToVc:(UIViewController *)vc;

- (void)dismiss;

- (void)hideLoadingAnimation;

- (void)dismissWithCompletion:(void(^)(void))completion;

- (void)presentVc:(UIViewController *)vc;

- (void)presentVc:(UIViewController *)vc completion:(void (^)(void))completion;

- (void)pushVc:(UIViewController *)vc;

- (void)removeChildVc:(UIViewController *)childVc;

- (void)addChildVc:(UIViewController *)childVc;

/**
 *  标题
 */
@property (nonatomic, copy) NSString *navItemTitle;

/**
 *  设置导航栏右边的item
 *
 *  @param itemTitle  <#itemTitle description#>
 *  @param attributes <#itemTitle description#>
 *  @param handle     <#handle description#>
 */
- (void)LK_setUpNavRightItemTitle:(NSString *)itemTitle attributes:(NSDictionary *)attributes handle:(void(^)(NSString *rightItemTitle))handle;

/**
 *  设置导航栏左边的item
 *
 *  @param itemTitle  <#itemTitle description#>
 *  @param attributes <#itemTitle description#>
 *  @param handle     <#handle description#>
 */
- (void)LK_setUpNavLeftItemTitle:(NSString *)itemTitle attributes:(NSDictionary *)attributes handle:(void(^)(NSString *rightItemTitle))handle;

/**
 *  设置导航栏右边的item
 *
 *  @param itemTitle <#itemTitle description#>
 *  @param handle    <#handle description#>
 */
- (void)LK_setUpNavRightItemTitle:(NSString *)itemTitle handle:(void(^)(NSString *rightItemTitle))handle __deprecated_msg("Use -LK_setUpNavRightItemTitle:attributes:handle:");

/**
 *  设置导航栏左边的item
 *
 *  @param itemTitle <#itemTitle description#>
 *  @param handle    <#handle description#>
 */
- (void)LK_setUpNavLeftItemTitle:(NSString *)itemTitle handle:(void(^)(NSString *rightItemTitle))handle __deprecated_msg("Use -LK_setUpNavLeftItemTitle:attributes:handle:");

/**
 *  设置导航栏右边的item
 *
 *  @param itemImage <#itemTitle description#>
 *  @param handle    <#handle description#>
 */
- (void)LK_setUpNavRightItemImage:(UIImage *)itemImage handle:(void(^)(UIImage *rightItemImage))handle;

/**
 *  设置导航栏左边的item
 *
 *  @param itemImage <#itemTitle description#>
 *  @param handle    <#handle description#>
 */
- (void)LK_setUpNavLeftItemImage:(UIImage *)itemImage handle:(void(^)(UIImage *leftItemImage))handle;

/**
 *  导航右边Item
 */
@property (nonatomic, strong) UIBarButtonItem *navRightItem;
/**
 *  导航左边Item
 */
@property (nonatomic, strong) UIBarButtonItem *navLeftItem;

/**
 *  请求数据，子类实现
 */
- (void)loadData;

/**
 *  设置无网络占位图
 */
@property (nonatomic, assign) BOOL isNetworkReachable;

/**
 *  隐藏导航栏底部线条阴影开关
 */
@property (nonatomic, assign) BOOL hiddenNavigationBarShadowImageView;

@end
