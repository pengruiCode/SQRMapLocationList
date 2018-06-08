//
//  LKRefreshUtil.m
//  LKBaseController
//
//  Created by 张晓飞 on 16/9/13.
//  Copyright © 2016年 Yuri. All rights reserved.
//

#import "LKRefreshUtil.h"
#import "MJRefresh.h"
#import "LKBaseTableView.h"

@implementation LKRefreshUtil
+ (NSInteger)totalDataCountForScrollView:(UIScrollView *)scrollView {
    NSInteger totalCount = 0;
    if ([scrollView isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)scrollView;
        
        for (NSInteger section = 0; section<tableView.numberOfSections; section++) {
            totalCount += [tableView numberOfRowsInSection:section];
        }
    } else if ([scrollView isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView = (UICollectionView *)scrollView;
        
        for (NSInteger section = 0; section<collectionView.numberOfSections; section++) {
            totalCount += [collectionView numberOfItemsInSection:section];
        }
    }
    return totalCount;
}


/** 开始下拉刷新*/
+ (void)beginPullRefreshForScrollView:(UIScrollView *)scrollView {
    [scrollView.mj_header beginRefreshing];
}

/**判断头部是否在刷新*/
+ (BOOL)headerIsRefreshForScrollView:(UIScrollView *)scrollView {
    return scrollView.mj_header.isRefreshing;
}

/**判断是否尾部在刷新*/
+ (BOOL)footerIsLoadingForScrollView:(UIScrollView *)scrollView {
    return  scrollView.mj_footer.isRefreshing;
}

/**提示没有更多数据的情况*/
+ (void)noticeNoMoreDataForScrollView:(UIScrollView *)scrollView {
    [scrollView.mj_footer endRefreshingWithNoMoreData];
}

/**重置footer*/
+ (void)resetNoMoreDataForScrollView:(UIScrollView *)scrollView {
    [scrollView.mj_footer resetNoMoreData];
}

/**停止下拉刷新*/
+ (void)endRefreshForScrollView:(UIScrollView *)scrollView {
    [scrollView.mj_header endRefreshing];
}

/**停止上拉加载*/
+ (void)endLoadMoreForScrollView:(UIScrollView *)scrollView {
    [scrollView.mj_footer endRefreshing];
}

/** 隐藏footer*/
+ (void)hiddenFooterForScrollView:(UIScrollView *)scrollView {
    // 不确定是哪个类型的footer
    scrollView.mj_footer.hidden = YES;
}

/**隐藏header*/
+ (void)hiddenHeaderForScrollView:(UIScrollView *)scrollView {
    scrollView.mj_header.hidden = YES;
}

/** 显示footer*/
+ (void)showFooterForScrollView:(UIScrollView *)scrollView {
    // 不确定是哪个类型的footer
    scrollView.mj_footer.hidden = NO;
}

/**显示header*/
+ (void)showHeaderForScrollView:(UIScrollView *)scrollView {
    scrollView.mj_header.hidden = NO;
}

/**上拉*/
+ (void)addLoadMoreForScrollView:(UIScrollView *)scrollView
                loadMoreCallBack:(LKRefreshAndLoadMoreHandle)loadMoreCallBackBlock {
    
    if (scrollView == nil || loadMoreCallBackBlock == nil) {
        return ;
    }
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (loadMoreCallBackBlock) {
            loadMoreCallBackBlock();
        }
    }];
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    [footer setTitle:@"正在加载" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"没有更多了" forState:MJRefreshStateNoMoreData];
    footer.stateLabel.textColor = [UIColor colorWithWhite:0.353 alpha:1.000];
    footer.stateLabel.font = [UIFont systemFontOfSize:13.f];
    scrollView.mj_footer = footer;
    footer.backgroundColor = [UIColor clearColor];
}



/**下拉*/
+ (void)addPullRefreshForScrollView:(UIScrollView *)scrollView animationImageArray:(NSMutableArray *)animationImageArray
                pullRefreshCallBack:(LKRefreshAndLoadMoreHandle)pullRefreshCallBackBlock {
    __weak typeof(UIScrollView *)weakScrollView = scrollView;
    if (scrollView == nil || pullRefreshCallBackBlock == nil) {
        return ;
    }
        
    if (animationImageArray.count > 0) {
            
        MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            if (pullRefreshCallBackBlock) {
                pullRefreshCallBackBlock();
            }
            if (weakScrollView.mj_footer.hidden == NO) {
                [weakScrollView.mj_footer resetNoMoreData];
            }
        }];
        [header setImages:animationImageArray forState:MJRefreshStateIdle];
        [header setImages:animationImageArray forState:MJRefreshStateRefreshing];
        header.stateLabel.hidden = YES;
        header.lastUpdatedTimeLabel.hidden = YES;
        scrollView.mj_header = header;
        
    }else{
        
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            if (pullRefreshCallBackBlock) {
                pullRefreshCallBackBlock();
            }
            if (weakScrollView.mj_footer.hidden == NO) {
                [weakScrollView.mj_footer resetNoMoreData];
            }
        }];
        [header setTitle:@"释放更新" forState:MJRefreshStatePulling];
        [header setTitle:@"正在更新" forState:MJRefreshStateRefreshing];
        [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
        header.stateLabel.font = [UIFont systemFontOfSize:13];
        header.stateLabel.textColor = [UIColor blackColor];
        header.lastUpdatedTimeLabel.hidden = YES;
        scrollView.mj_header = header;
    }
}



@end
