//
//  LKRefreshUtil.h
//  LKBaseController
//
//  Created by 张晓飞 on 16/9/13.
//  Copyright © 2016年 Yuri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef void(^LKRefreshAndLoadMoreHandle)(void);

@interface LKRefreshUtil : NSObject

/** 开始下拉刷新 */
+ (void)beginPullRefreshForScrollView:(UIScrollView *)scrollView;

/** 判断头部是否在刷新 */
+ (BOOL)headerIsRefreshForScrollView:(UIScrollView *)scrollView;

/** 判断是否尾部在刷新 */
+ (BOOL)footerIsLoadingForScrollView:(UIScrollView *)scrollView;

/** 提示没有更多数据的情况 */
+ (void)noticeNoMoreDataForScrollView:(UIScrollView *)scrollView;

/** 重置footer */
+ (void)resetNoMoreDataForScrollView:(UIScrollView *)scrollView;

/** 停止下拉刷新 */
+ (void)endRefreshForScrollView:(UIScrollView *)scrollView;

/** 停止上拉加载 */
+ (void)endLoadMoreForScrollView:(UIScrollView *)scrollView;

/** 隐藏footer */
+ (void)hiddenFooterForScrollView:(UIScrollView *)scrollView;

/** 隐藏header */
+ (void)hiddenHeaderForScrollView:(UIScrollView *)scrollView;

/** 显示footer*/
+ (void)showFooterForScrollView:(UIScrollView *)scrollView;

/**显示header*/
+ (void)showHeaderForScrollView:(UIScrollView *)scrollView;

/** 下拉刷新 */
+ (void)addLoadMoreForScrollView:(UIScrollView *)scrollView
                loadMoreCallBack:(LKRefreshAndLoadMoreHandle)loadMoreCallBackBlock;

/** 上拉加载 */
+ (void)addPullRefreshForScrollView:(UIScrollView *)scrollView
                animationImageArray:(NSMutableArray *)animationImageArray
                pullRefreshCallBack:(LKRefreshAndLoadMoreHandle)pullRefreshCallBackBlock;
@end
