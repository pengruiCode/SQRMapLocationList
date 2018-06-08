//
//  LKBaseTableViewController.m
//  LKBaseController
//
//  Created by 张晓飞 on 16/9/13.
//  Copyright © 2016年 Yuri. All rights reserved.
//

#import "LKBaseTableViewController.h"
#import "LKBaseTableViewCell.h"
#import "LKBaseTableHeaderFooterView.h"
#import <objc/runtime.h>
#import "UIView+Tap.h"
#import "MJRefresh.h"
#import "LKRefreshUtil.h"

#define WeakSelf(weakSelf)  __weak __typeof(&*self)weakSelf = self;
#define kSeperatorColor [UIColor colorWithRed:0.918 green:0.929 blue:0.941 alpha:1.000]
#define kWhiteColor [UIColor whiteColor]

@interface LKBaseTableViewController ()

@property (nonatomic, copy) LKTableVcCellSelectedHandle handle;
@property (nonatomic, weak) UIImageView *refreshImg;

@end

@implementation LKBaseTableViewController

@synthesize needCellSepLine = _needCellSepLine;
@synthesize sepLineColor = _sepLineColor;
@synthesize hiddenStatusBar = _hiddenStatusBar;
@synthesize barStyle = _barStyle;

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}

/**
 *  加载tableview
 */
- (LKBaseTableView *)tableView {
    if(!_tableView){
        UITableViewStyle style = UITableViewStylePlain;
        
        if (self.tableViewType == LKBaseTableViewTypeGroup) {
            style = UITableViewStyleGrouped;
        }
        
        LKBaseTableView *tab = [[LKBaseTableView alloc] initWithFrame:self.view.bounds style:style];
        [self.view addSubview:tab];
        _tableView = tab;
        tab.dataSource = self;
        tab.delegate = self;
        tab.backgroundColor = DEF_COLOR_BankGround;
        tab.separatorColor = kSeperatorColor;
        WeakSelf(weakSelf);
        [tab emptyTableViewTapHandler:^(UIScrollView *scroollView, UIView *tapView) {
            [weakSelf loadData];
        }];
    }
    return _tableView;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

/** 监听通知*/
- (void)LK_observeNotiWithNotiName:(NSString *)notiName action:(SEL)action {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:action name:notiName object:nil];
}

/** 设置刷新类型*/
- (void)setRefreshType:(LKBaseTableVcRefreshType)refreshType refreshAnimationType:(RefreshAnimation)refreshAnimationType{
    _refreshAnimationType = refreshAnimationType;
    switch (refreshAnimationType) {
        case RefreshAnimationDefault:
            self.refreshImageArray = nil;
            break;
        case RefreshAnimationCommon:
            self.refreshImageArray = [self setRefrushImageWithImageName:@"" nums:0];
            break;
        case RefreshAnimationGoods:
            self.refreshImageArray = [self setRefrushImageWithImageName:@"loading_goods" nums:5];
            break;
        case RefreshAnimationShops:
            self.refreshImageArray = [self setRefrushImageWithImageName:@"" nums:0];
            break;
        case RefreshAnimationParcels:
            self.refreshImageArray = [self setRefrushImageWithImageName:@"" nums:0];
            break;
        default:
            break;
    }
    
    _refreshType = refreshType;
    switch (refreshType) {
        case LKBaseTableVcRefreshTypeNone: // 没有刷新
            break ;
        case LKBaseTableVcRefreshTypeOnlyCanRefresh: { // 只有下拉刷新
            [self LK_addRefresh];
        } break ;
        case LKBaseTableVcRefreshTypeOnlyCanLoadMore: { // 只有上拉加载
            [self LK_addLoadMore];
        } break ;
        case LKBaseTableVcRefreshTypeRefreshAndLoadMore: { // 下拉和上拉都有
            [self LK_addRefresh];
            [self LK_addLoadMore];
        } break ;
        default:
            break ;
    }
}



- (NSMutableArray *)setRefrushImageWithImageName:(NSString *)name nums:(NSInteger)nums{
    NSMutableArray *imageArray = [NSMutableArray array];
    for (int i = 0; i < nums; i ++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%d",name,i]];
        [imageArray addObject:image];
    }
    return imageArray;
}


- (NSString *)navItemTitle {
    return self.navigationItem.title;
}

/** statusBar是否隐藏*/
- (void)setHiddenStatusBar:(BOOL)hiddenStatusBar {
    _hiddenStatusBar = hiddenStatusBar;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (BOOL)hiddenStatusBar {
    return _hiddenStatusBar;
}

- (void)setBarStyle:(UIStatusBarStyle)barStyle {
    if (_barStyle == barStyle) return ;
    _barStyle = barStyle;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (BOOL)prefersStatusBarHidden {
    return self.hiddenStatusBar;
}

- (void)setShowRefreshIcon:(BOOL)showRefreshIcon {
    _showRefreshIcon = showRefreshIcon;
    self.refreshImg.hidden = !showRefreshIcon;
}

- (UIImageView *)refreshImg {
    if (!_refreshImg) {
        UIImageView *refreshImg = [[UIImageView alloc] init];
        [self.view addSubview:refreshImg];
        _refreshImg = refreshImg;
        [self.view bringSubviewToFront:refreshImg];
        refreshImg.image = [UIImage imageNamed:@"refresh"];
        
        [refreshImg setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        //子view的左边缘离父view的左边缘15个像素
        NSLayoutConstraint *constraintLeft = [NSLayoutConstraint constraintWithItem:refreshImg attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:15.0];
        
        //子view的下边缘离父view的下边缘40个像素
        NSLayoutConstraint *constraintBottom = [NSLayoutConstraint constraintWithItem:refreshImg attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-20.0];
        
        //子view的宽度为300
        NSLayoutConstraint *constraintWidth = [NSLayoutConstraint constraintWithItem:refreshImg attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:44.0];
        
        //子view的高度为200
        NSLayoutConstraint *constraintHeight = [NSLayoutConstraint constraintWithItem:refreshImg attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:44.0];
        //把约束添加到父视图上
        NSArray *array = [NSArray arrayWithObjects:constraintLeft, constraintBottom, constraintWidth, constraintHeight, nil];
        
        [self.view addConstraints:array];
        WeakSelf(weakSelf);
        refreshImg.layer.cornerRadius = 22;
        refreshImg.backgroundColor = kWhiteColor;
        
        [refreshImg setTapActionWithBlock:^{
            [self startAnimation];
            [weakSelf LK_beginRefresh];
        }];
    }
    return _refreshImg;
}

- (void)startAnimation {
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 1.5;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = MAXFLOAT;
    [self.refreshImg.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)endRefreshIconAnimation {
    [self.refreshImg.layer removeAnimationForKey:@"rotationAnimation"];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.barStyle;
}

/** 需要系统分割线*/
- (void)setNeedCellSepLine:(BOOL)needCellSepLine {
    _needCellSepLine = needCellSepLine;
    self.tableView.separatorStyle = needCellSepLine ? UITableViewCellSeparatorStyleSingleLine : UITableViewCellSeparatorStyleNone;
}

- (BOOL)needCellSepLine {
    return self.tableView.separatorStyle == UITableViewCellSeparatorStyleSingleLine;
}

- (void)LK_addRefresh {
    [LKRefreshUtil addPullRefreshForScrollView:self.tableView animationImageArray:_refreshImageArray  pullRefreshCallBack:^{
        [self LK_refresh];
    }];
}

- (void)LK_addLoadMore {
    [LKRefreshUtil addLoadMoreForScrollView:self.tableView loadMoreCallBack:^{
        [self LK_loadMore];
    }];
}

/** 表视图偏移*/
- (void)setTableEdgeInset:(UIEdgeInsets)tableEdgeInset {
    _tableEdgeInset = tableEdgeInset;
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
    [self.view layoutIfNeeded];
    [self.view setNeedsLayout];
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    self.tableView.contentInset = self.tableEdgeInset;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (self.tableViewFarme.size.height != 0 && !CGRectEqualToRect(self.tableViewFarme, CGRectZero)) {
        [self.tableView setFrame:self.tableViewFarme];
    }else{
        self.tableView.frame = self.view.bounds;
    }
    [self.view sendSubviewToBack:self.tableView];
}

/** 分割线颜色*/
- (void)setSepLineColor:(UIColor *)sepLineColor {
    if (!self.needCellSepLine) return;
    _sepLineColor = sepLineColor;
    
    if (sepLineColor) {
        self.tableView.separatorColor = sepLineColor;
    }
}

- (UIColor *)sepLineColor {
    return _sepLineColor ? _sepLineColor : [UIColor whiteColor];
}

/** 刷新数据*/
- (void)LK_reloadData {
    [self.tableView reloadData];
}

/** 开始下拉*/
- (void)LK_beginRefresh {
    if (self.refreshType == LKBaseTableVcRefreshTypeOnlyCanRefresh || self.refreshType == LKBaseTableVcRefreshTypeRefreshAndLoadMore) {
        [LKRefreshUtil beginPullRefreshForScrollView:self.tableView];
    }
}

/** 刷新*/
- (void)LK_refresh {
    if (self.refreshType == LKBaseTableVcRefreshTypeNone || self.refreshType == LKBaseTableVcRefreshTypeOnlyCanLoadMore) {
        return ;
    }
    self.isRefresh = YES; self.isLoadMore = NO;
}

/** 上拉加载*/
- (void)LK_loadMore {
    if (self.refreshType == LKBaseTableVcRefreshTypeNone || self.refreshType == LKBaseTableVcRefreshTypeOnlyCanRefresh) {
        return ;
    }
    if (self.dataArray.count == 0) {
        return ;
    }
    self.isRefresh = NO; self.isLoadMore = YES;
    
}


/** 结束加载状态 */
- (void)endLoadingStatus{
    
    if (self.isHeaderRefreshing) {
        [self LK_endRefresh];
    }
    
    if (self.isFooterRefreshing) {
        [self LK_endLoadMore];
    }
    
    [self LK_showLoadMore];
    [self LK_showRrefresh];
    self.isRefresh = NO;
    self.isLoadMore = NO;
    
    if (!self.isRefresh && !self.isLoadMore) {
        [self hideLoadingAnimation];
    }
}


/** 停止刷新*/
- (void)LK_endRefresh {
    if (self.refreshType == LKBaseTableVcRefreshTypeOnlyCanRefresh || self.refreshType == LKBaseTableVcRefreshTypeRefreshAndLoadMore) {
        [LKRefreshUtil endRefreshForScrollView:self.tableView];
    }
}

/** 停止上拉加载*/
- (void)LK_endLoadMore {
    if (self.refreshType == LKBaseTableVcRefreshTypeOnlyCanLoadMore || self.refreshType == LKBaseTableVcRefreshTypeRefreshAndLoadMore) {
        [LKRefreshUtil endLoadMoreForScrollView:self.tableView];
    }
}

/** 隐藏刷新*/
- (void)LK_hiddenRrefresh {
    if (self.refreshType == LKBaseTableVcRefreshTypeOnlyCanRefresh || self.refreshType == LKBaseTableVcRefreshTypeRefreshAndLoadMore) {
        [LKRefreshUtil hiddenHeaderForScrollView:self.tableView];
    }
}

/** 隐藏上拉加载*/
- (void)LK_hiddenLoadMore {
    if (self.refreshType == LKBaseTableVcRefreshTypeOnlyCanLoadMore || self.refreshType == LKBaseTableVcRefreshTypeRefreshAndLoadMore) {
        [LKRefreshUtil hiddenFooterForScrollView:self.tableView];
    }
}

/** 显示刷新*/
- (void)LK_showRrefresh {
    if (self.refreshType == LKBaseTableVcRefreshTypeOnlyCanRefresh || self.refreshType == LKBaseTableVcRefreshTypeRefreshAndLoadMore) {
        [LKRefreshUtil showHeaderForScrollView:self.tableView];
    }
}

/** 显示上拉加载*/
- (void)LK_showLoadMore {
    if (self.refreshType == LKBaseTableVcRefreshTypeOnlyCanLoadMore || self.refreshType == LKBaseTableVcRefreshTypeRefreshAndLoadMore) {
        [LKRefreshUtil showFooterForScrollView:self.tableView];
    }
}

/** 提示没有更多信息*/
- (void)LK_noticeNoMoreData {
    if (self.refreshType == LKBaseTableVcRefreshTypeOnlyCanLoadMore || self.refreshType == LKBaseTableVcRefreshTypeRefreshAndLoadMore) {
        [LKRefreshUtil noticeNoMoreDataForScrollView:self.tableView];
    }
}

/** 头部正在刷新*/
- (BOOL)isHeaderRefreshing {
    return [LKRefreshUtil headerIsRefreshForScrollView:self.tableView];
}

//* 尾部正在刷新
- (BOOL)isFooterRefreshing {
    return [LKRefreshUtil footerIsLoadingForScrollView:self.tableView];
}

#pragma mark - <UITableViewDataSource, UITableViewDelegate>
// 分组数量
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self respondsToSelector:@selector(LK_numberOfSections)]) {
        return self.LK_numberOfSections;
    }
    return 0;
}

// 指定组返回的cell数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self respondsToSelector:@selector(LK_numberOfRowsInSection:)]) {
        return [self LK_numberOfRowsInSection:section];
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ([self respondsToSelector:@selector(LK_headerAtSection:)]) {
        return [self LK_headerAtSection:section];
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if ([self respondsToSelector:@selector(LK_footerAtSection:)]) {
        return [self LK_footerAtSection:section];
    }
    return nil;
}

// 每一行返回指定的cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self respondsToSelector:@selector(LK_cellAtIndexPath:)]) {
        return [self LK_cellAtIndexPath:indexPath];
    }
    // 1. 创建cell
    LKBaseTableViewCell *cell = [LKBaseTableViewCell cellWithTableView:self.tableView];
    
    // 2. 返回cell
    return cell;
}

// 点击某一行 触发的事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LKBaseTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([self respondsToSelector:@selector(LK_didSelectCellAtIndexPath:cell:)]) {
        [self LK_didSelectCellAtIndexPath:indexPath cell:cell];
    }
}

- (UIView *)refreshHeader {
    return self.tableView.mj_header;
}

// 设置分割线偏移间距并适配
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.needCellSepLine) return ;
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    if ([self respondsToSelector:@selector(LK_sepEdgeInsetsAtIndexPath:)]) {
        edgeInsets = [self LK_sepEdgeInsetsAtIndexPath:indexPath];
    }
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) [tableView setSeparatorInset:edgeInsets];
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) [tableView setLayoutMargins:edgeInsets];
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) [cell setSeparatorInset:edgeInsets];
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) [cell setLayoutMargins:edgeInsets];
}

// 每一行的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self respondsToSelector:@selector(LK_cellheightAtIndexPath:)]) {
        return [self LK_cellheightAtIndexPath:indexPath];
    }
    return tableView.rowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([self respondsToSelector:@selector(LK_sectionHeaderHeightAtSection:)]) {
        return [self LK_sectionHeaderHeightAtSection:section];
    }
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if ([self respondsToSelector:@selector(LK_sectionFooterHeightAtSection:)]) {
        return [self LK_sectionFooterHeightAtSection:section];
    }
    return 0.01;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if ([self respondsToSelector:@selector(LK_sectionIndexTitles)]) {
        return [self LK_sectionIndexTitles];
    }
    return @[];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if ([self respondsToSelector:@selector(LK_titleForHeaderInSection:)]) {
        return [self LK_titleForHeaderInSection:section];
    }
    return @"";
    
}
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    if ([self respondsToSelector:@selector(LK_sectionForSectionIndexTitle:atIndex:)]) {
        return [self LK_sectionForSectionIndexTitle:title atIndex:index];
    }
    return 0;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [self LK_editActionsForRowAtIndexPath:indexPath];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self LK_canEditActionForRowAtIndexPath:indexPath];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (NSInteger)LK_numberOfSections {
    return 0;
}

- (NSInteger)LK_numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)LK_cellAtIndexPath:(NSIndexPath *)indexPath {
    return [LKBaseTableViewCell cellWithTableView:self.tableView];
}

- (CGFloat)LK_cellheightAtIndexPath:(NSIndexPath *)indexPath {
    return 45.f;
}

- (void)LK_didSelectCellAtIndexPath:(NSIndexPath *)indexPath cell:(LKBaseTableViewCell *)cell {
}

- (UIView *)LK_headerAtSection:(NSInteger)section {
    return [LKBaseTableHeaderFooterView headerFooterViewWithTableView:self.tableView];
}

- (UIView *)LK_footerAtSection:(NSInteger)section {
    return [LKBaseTableHeaderFooterView headerFooterViewWithTableView:self.tableView];
}

- (CGFloat)LK_sectionHeaderHeightAtSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)LK_sectionFooterHeightAtSection:(NSInteger)section {
    return 0.01;
}

- (UIEdgeInsets)LK_sepEdgeInsetsAtIndexPath:(NSIndexPath *)indexPath {
    return UIEdgeInsetsMake(0, 15, 0, 0);
}

- (NSArray *)LK_sectionIndexTitles {
    return @[];
}

- (NSString *)LK_titleForHeaderInSection:(NSInteger)section {
    return @"";
}

- (NSInteger)LK_sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return 0;
}

- (NSArray<UITableViewRowAction *> *)LK_editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @[];
}

- (BOOL)LK_canEditActionForRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}


@end
