//
//  LKScrollViewRefresh.m
//  SQRCommonToolsProject
//
//  Created by macMini on 2018/6/4.
//  Copyright © 2018年 PR. All rights reserved.
//

#import "LKScrollViewRefresh.h"
#import "LKRefreshUtil.h"

@implementation LKScrollViewRefresh


static id _instance;

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}


/** 设置刷新类型*/
- (void)setRefreshType:(LKBaseTableVcRefreshType)refreshType refreshAnimationType:(RefreshAnimation)refreshAnimationType refreshImageArray:(NSMutableArray *)refreshImageArray{
    
    if (refreshImageArray.count > 0) {
        _refreshAnimationType = RefreshAnimationDefault;
        _refreshImageArray = refreshImageArray;
    }else{
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


/** 开始下拉*/
- (void)LK_beginRefresh {
    if (self.refreshType == LKBaseTableVcRefreshTypeOnlyCanRefresh || self.refreshType == LKBaseTableVcRefreshTypeRefreshAndLoadMore) {
        [LKRefreshUtil beginPullRefreshForScrollView:self.scrollView];
    }
}

/** 下拉刷新*/
- (void)LK_refresh {
    if (self.refreshType == LKBaseTableVcRefreshTypeNone || self.refreshType == LKBaseTableVcRefreshTypeOnlyCanLoadMore) {
        return ;
    }
    self.isRefresh = YES; self.isLoadMore = NO;
    
    if (self.refreshBlock) {
        self.refreshBlock();
    }
}

/** 上拉加载*/
- (void)LK_loadMore {
    if (self.refreshType == LKBaseTableVcRefreshTypeNone || self.refreshType == LKBaseTableVcRefreshTypeOnlyCanRefresh) {
        return ;
    }
    self.isRefresh = NO; self.isLoadMore = YES;
    if (self.loadMoreBlock) {
        self.loadMoreBlock();
    }
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
        //        [self hideLoadingAnimation];
    }
}



- (void)LK_addRefresh {
    [LKRefreshUtil addPullRefreshForScrollView:self.scrollView animationImageArray:self.refreshImageArray  pullRefreshCallBack:^{
        [self LK_refresh];
    }];
}

- (void)LK_addLoadMore {
    [LKRefreshUtil addLoadMoreForScrollView:self.scrollView loadMoreCallBack:^{
        [self LK_loadMore];
    }];
}


/** 停止刷新*/
- (void)LK_endRefresh {
    if (self.refreshType == LKBaseTableVcRefreshTypeOnlyCanRefresh || self.refreshType == LKBaseTableVcRefreshTypeRefreshAndLoadMore) {
        [LKRefreshUtil endRefreshForScrollView:self.scrollView];
    }
}

/** 停止上拉加载*/
- (void)LK_endLoadMore {
    if (self.refreshType == LKBaseTableVcRefreshTypeOnlyCanLoadMore || self.refreshType == LKBaseTableVcRefreshTypeRefreshAndLoadMore) {
        [LKRefreshUtil endLoadMoreForScrollView:self.scrollView];
    }
}

/** 隐藏刷新*/
- (void)LK_hiddenRrefresh {
    if (self.refreshType == LKBaseTableVcRefreshTypeOnlyCanRefresh || self.refreshType == LKBaseTableVcRefreshTypeRefreshAndLoadMore) {
        [LKRefreshUtil hiddenHeaderForScrollView:self.scrollView];
    }
}

/** 隐藏上拉加载*/
- (void)LK_hiddenLoadMore {
    if (self.refreshType == LKBaseTableVcRefreshTypeOnlyCanLoadMore || self.refreshType == LKBaseTableVcRefreshTypeRefreshAndLoadMore) {
        [LKRefreshUtil hiddenFooterForScrollView:self.scrollView];
    }
}

/** 显示刷新*/
- (void)LK_showRrefresh {
    if (self.refreshType == LKBaseTableVcRefreshTypeOnlyCanRefresh || self.refreshType == LKBaseTableVcRefreshTypeRefreshAndLoadMore) {
        [LKRefreshUtil showHeaderForScrollView:self.scrollView];
    }
}

/** 显示上拉加载*/
- (void)LK_showLoadMore {
    if (self.refreshType == LKBaseTableVcRefreshTypeOnlyCanLoadMore || self.refreshType == LKBaseTableVcRefreshTypeRefreshAndLoadMore) {
        [LKRefreshUtil showFooterForScrollView:self.scrollView];
    }
}

/** 提示没有更多信息*/
- (void)LK_noticeNoMoreData {
    if (self.refreshType == LKBaseTableVcRefreshTypeOnlyCanLoadMore || self.refreshType == LKBaseTableVcRefreshTypeRefreshAndLoadMore) {
        [LKRefreshUtil noticeNoMoreDataForScrollView:self.scrollView];
    }
}

/** 头部正在刷新*/
- (BOOL)isHeaderRefreshing {
    return [LKRefreshUtil headerIsRefreshForScrollView:self.scrollView];
}

//* 尾部正在刷新
- (BOOL)isFooterRefreshing {
    return [LKRefreshUtil footerIsLoadingForScrollView:self.scrollView];
}


@end
