//
//  LKScrollViewRefresh.h
//  SQRCommonToolsProject
//
//  Created by macMini on 2018/6/4.
//  Copyright © 2018年 PR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKBaseTableViewController.h"

@interface LKScrollViewRefresh : NSObject

+ (instancetype)sharedInstance;

/**
 *  执行刷新之后的回调
 */
@property (nonatomic,strong) id scrollView;

/**
 *  执行下拉刷新之后的回调
 */
@property (nonatomic,strong) void (^refreshBlock)(void);

/**
 *  执行上拉加载之后的回调
 */
@property (nonatomic,strong) void (^loadMoreBlock)(void);

/**
 *  刷新动画动图数组
 */
@property (nonatomic, strong) NSMutableArray *refreshImageArray;              

/**
 *  刷新动画类型
 */
@property (nonatomic, assign) RefreshAnimation refreshAnimationType;

/**
 *  加载刷新类型(枚举类型)
 */
@property (nonatomic, assign) LKBaseTableVcRefreshType refreshType;


/**
 *  刚才执行的是刷新
 */
@property (nonatomic, assign) NSInteger isRefresh;

/**
 *  刚才执行的是上拉加载
 */
@property (nonatomic, assign) NSInteger isLoadMore;


/**
 *  设置刷新加载类型及动画
 *  @parms  refreshType              刷新类型
 *  @parms  refreshAnimationType     刷新动画类型
 *  @parms  refreshImageArray        自定义刷新动画数组
 */
- (void)setRefreshType:(LKBaseTableVcRefreshType)refreshType
  refreshAnimationType:(RefreshAnimation)refreshAnimationType
     refreshImageArray:(NSMutableArray *)refreshImageArray;

/**
 *  开始下拉
 */
- (void)LK_beginRefresh;

/**
 *  停止刷新
 */
- (void)LK_endRefresh;

/**
 *  停止上拉加载
 */
- (void)LK_endLoadMore;

/**
 *  隐藏刷新
 */
- (void)LK_hiddenRrefresh;

/**
 *  隐藏上拉加载
 */
- (void)LK_hiddenLoadMore;

/**
 *  显示上拉加载
 */
- (void)LK_showRrefresh;

/**
 *  显示上拉加载
 */
- (void)LK_showLoadMore;

/**
 *  提示没有更多信息
 */
- (void)LK_noticeNoMoreData;

/**
 *  是否在下拉刷新
 */
@property (nonatomic, assign, readonly) BOOL isHeaderRefreshing;

/**
 *  是否在上拉加载
 */
@property (nonatomic, assign, readonly) BOOL isFooterRefreshing;


#pragma mark - 子类去继承

/**
 *  刷新方法
 */
- (void)LK_refresh;

/**
 *  上拉加载方法
 */
- (void)LK_loadMore;

/**
 *  结束刷新加载状态
 */
- (void)endLoadingStatus;

@property (nonatomic, assign) BOOL showRefreshIcon;

@property (nonatomic, weak, readonly) UIView *refreshHeader;



@end
