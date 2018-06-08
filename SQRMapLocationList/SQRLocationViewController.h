//
//  GDLocationViewController.h
//  Merchant
//  地图定位显示附近位置列表
//  Created by PR on 18/6/6.
//  Copyright (c) 2018年 PR. All rights reserved.
//

#import "LKBaseViewController.h"
#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <MapKit/MapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

@class LKBaseViewController;

@interface SQRLocationViewController :LKBaseViewController

@property (nonatomic,strong) void (^returnChickLocationBlock)(NSMutableDictionary *dict);
@property (nonatomic,strong) AMapPOI *poi;
@property (nonatomic,copy)   NSString *mapKey;
@property (nonatomic,copy)   NSString *searchImg;             //搜索按键图片
@property (nonatomic,assign) BOOL isNeedSearchLocation;     //是否需要搜索地址

@end
