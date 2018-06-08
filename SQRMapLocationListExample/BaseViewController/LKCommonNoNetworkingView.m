//
//  LKCommonNoNetworkingView.m
//  DBKit
//
//  Created by ZhangXiaofei on 16/9/13.
//  Copyright © 2016年 Yuri. All rights reserved.
//

#import "LKCommonNoNetworkingView.h"

#define kCommonBgColor [UIColor colorWithRed:0.86f green:0.85f blue:0.80f alpha:1.00f]
#define kFont(size) [UIFont systemFontOfSize:size]
#define kOrangeColor [UIColor orangeColor]
/***  当前屏幕宽度 */
#define kScreenWidth  [[UIScreen mainScreen] bounds].size.width
/***  当前屏幕高度 */
#define kScreenHeight  [[UIScreen mainScreen] bounds].size.height

@interface LKCommonNoNetworkingView ()

@property (nonatomic, weak) UIImageView *topTipImageView;
@property (nonatomic, weak) UIButton *retryBtn;

@end

@implementation LKCommonNoNetworkingView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}


- (void)createView {
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth/3, (kScreenHeight-kScreenWidth/3)/2-kScreenWidth/3, kScreenWidth/3, kScreenWidth/3)];
    imageView.image = [UIImage imageNamed:@"ic_noticon"];
    [self addSubview:imageView];
    
    UILabel *la = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/3, (kScreenHeight-kScreenWidth/3)/2+15, kScreenWidth/3, 20)];
    la.text = @"马上重试";
    la.textColor = [UIColor grayColor];
    la.textAlignment = YES;
    la.font = [UIFont systemFontOfSize:14];
    [self addSubview:la];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.customNoNetworkEmptyViewDidClickRetryHandle) {
        self.customNoNetworkEmptyViewDidClickRetryHandle(self);
    }
}

@end
