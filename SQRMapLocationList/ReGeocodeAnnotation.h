//
//  ReGeocodeAnnotation.h
//  SearchV3Demo
//
//  Created by PR on 18/6/6.
//  Copyright (c) 2018年 PR. All rights reserved.
//

#import "SQRMapLocationList.h"

@interface ReGeocodeAnnotation : NSObject<MAAnnotation>

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate reGeocode:(AMapReGeocode *)reGeocode;

@property (nonatomic, readonly, strong) AMapReGeocode *reGeocode;

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;


- (void)setAMapReGeocode:(AMapReGeocode *)reGerocode;

@end
