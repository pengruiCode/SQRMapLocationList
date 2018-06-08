//
//  LKBaseTableViewController.h
//  LKBaseController
//
//  Created by 张晓飞 on 16/9/13.
//  Copyright © 2016年 Yuri. All rights reserved.
//

#import "LKBaseViewController.h"
#import "LKBaseTableViewCell.h"
#import "LKBaseTableView.h"

typedef void(^LKTableVcCellSelectedHandle)(LKBaseTableViewCell *cell, NSIndexPath *indexPath);

//是否需要刷新加载
typedef NS_ENUM(NSUInteger, LKBaseTableVcRefreshType) {
    LKBaseTableVcRefreshTypeNone = 0,               //无刷新
    LKBaseTableVcRefreshTypeOnlyCanRefresh,         //仅刷新
    LKBaseTableVcRefreshTypeOnlyCanLoadMore,        //仅上拉加载
    LKBaseTableVcRefreshTypeRefreshAndLoadMore      //刷新+加载
};

//tableView类型
typedef NS_ENUM(NSUInteger, LKBaseTableViewType) {
    LKBaseTableViewTypeNormal = 0,                  //默认 plain
    LKBaseTableViewTypePlain,                       //plain
    LKBaseTableViewTypeGroup,                       //group
};

//下拉刷新动画类型
typedef NS_ENUM(NSInteger, RefreshAnimation) {
    RefreshAnimationDefault = 0,                    // 默认无动画
    RefreshAnimationCommon,                         // 通用动画
    RefreshAnimationGoods,                          // 商品动画
    RefreshAnimationShops,                          // 店铺动画
    RefreshAnimationParcels                         // 包裹动画
};



@interface LKBaseTableViewController : LKBaseViewController <UITableViewDelegate, UITableViewDataSource>


/**
 *  刷新动画动图数组
 */
@property (nonatomic, strong) NSMutableArray *refreshImageArray;                    //刷新动图数组

/**
 *  刷新动画类型
 */
@property (nonatomic, assign) RefreshAnimation refreshAnimationType;

/**
 *  设置刷新加载类型及动画
 */
- (void)setRefreshType:(LKBaseTableVcRefreshType)refreshType
  refreshAnimationType:(RefreshAnimation)refreshAnimationType;

/**
 *  设置tableview的frame  不设置会取默认
 */
@property (nonatomic, assign) CGRect tableViewFarme;

/**
 *  设置tableview的类型 plain/group
 */
@property (nonatomic, assign) LKBaseTableViewType tableViewType;

/**
 *  刚才执行的是刷新
 */
@property (nonatomic, assign) NSInteger isRefresh;

/**
 *  刚才执行的是上拉加载
 */
@property (nonatomic, assign) NSInteger isLoadMore;

/**
 *  监听通知
 *
 *  @param notiName 通知名
 *  @param action   操作
 */
- (void)LK_observeNotiWithNotiName:(NSString *)notiName action:(SEL)action;

/**
 *  隐藏statusBar
 */
@property (nonatomic, assign) BOOL hiddenStatusBar;

/**
 *  statusBar风格
 */
@property (nonatomic, assign) UIStatusBarStyle barStyle;


/**
 *  表视图
 */
@property (nonatomic, weak) LKBaseTableView *tableView;

/**
 *  表视图偏移
 */
@property (nonatomic, assign) UIEdgeInsets tableEdgeInset;

/**
 *  分割线颜色
 */
@property (nonatomic, assign) UIColor *sepLineColor;

/**
 *  数据源数量
 */
@property (nonatomic, strong) NSMutableArray *dataArray;

/**
 *  加载刷新类型(枚举类型)
 */
@property (nonatomic, assign) LKBaseTableVcRefreshType refreshType;

/**
 *  是否需要系统的cell的分割线
 */
@property (nonatomic, assign) BOOL needCellSepLine;

/**
 *  刷新数据
 */
- (void)LK_reloadData;

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

#pragma mark - 子类去重写
/**
 *  分组数量
 *
 *  @return <#return value description#>
 */
- (NSInteger)LK_numberOfSections;

/**
 *  某个分组的cell数量
 *
 *  @param section <#section description#>
 *
 *  @return <#return value description#>
 */
- (NSInteger)LK_numberOfRowsInSection:(NSInteger)section;

/**
 *  某行的cell
 *
 *  @param indexPath <#indexPath description#>
 *
 *  @return <#return value description#>
 */
- (LKBaseTableViewCell *)LK_cellAtIndexPath:(NSIndexPath *)indexPath;

/**
 *  点击某行
 *
 *  @param indexPath <#indexPath description#>
 *  @param cell      <#cell description#>
 */
- (void)LK_didSelectCellAtIndexPath:(NSIndexPath *)indexPath cell:(LKBaseTableViewCell *)cell;

/**
 *  行高
 *
 *  @param indexPath <#indexPath description#>
 *
 *  @return <#return value description#>
 */
- (CGFloat)LK_cellheightAtIndexPath:(NSIndexPath *)indexPath;

/**
 *  某个组头
 *
 *  @param section <#section description#>
 *
 *  @return <#return value description#>
 */
- (UIView *)LK_headerAtSection:(NSInteger)section;

/**
 *  某个组bottom视图
 *
 *  @param section <#section description#>
 *
 *  @return <#return value description#>
 */
- (UIView *)LK_footerAtSection:(NSInteger)section;

/**
 *  某个组头高度
 *
 *  @param section <#section description#>
 *
 *  @return <#return value description#>
 */
- (CGFloat)LK_sectionHeaderHeightAtSection:(NSInteger)section;

/**
 *  某个组尾高度
 *
 *  @param section <#section description#>
 *
 *  @return <#return value description#>
 */
- (CGFloat)LK_sectionFooterHeightAtSection:(NSInteger)section;

/**
 *  侧边栏数组
 *
 *  @return <#return value description#>
 */
- (NSArray *)LK_sectionIndexTitles;

/**
 *  索引
 *
 *  @param section <#section description#>
 *
 *  @return <#return value description#>
 */
- (NSString *)LK_titleForHeaderInSection:(NSInteger)section;

/**
 *  索引
 *
 *  @param title <#section description#>
 *
 *  @return <#return value description#>
 */
- (NSInteger)LK_sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index;


/**
 *  分割线偏移
 *
 *  @param indexPath <#indexPath description#>
 *
 *  @return <#return value description#>
 */
- (UIEdgeInsets)LK_sepEdgeInsetsAtIndexPath:(NSIndexPath *)indexPath;

/**
 *  自定义侧滑操作
 *
 *  @param indexPath <#indexPath description#>
 *
 *  @return <#return value description#>
 */
-(NSArray<UITableViewRowAction *> *)LK_editActionsForRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 *  自定义侧滑操作开关
 *
 *  @param indexPath <#indexPath description#>
 *
 *  @return <#return value description#>
 */
- (BOOL)LK_canEditActionForRowAtIndexPath:(NSIndexPath *)indexPath;



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

- (void)endRefreshIconAnimation;

@property (nonatomic, weak, readonly) UIView *refreshHeader;


@end
