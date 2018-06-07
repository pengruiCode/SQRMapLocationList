//
//  MANaviAnnotationView.h
//  OfficialDemo3D
//
//  Created by PR on 18/6/6.
//  Copyright (c) 2018年 PR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <CoreLocation/CLLocation.h>

@interface NaviButton : UIButton

@property (nonatomic, strong) UIImageView *carImageView;
@property (nonatomic, strong) UILabel *naviLabel;

@end

@interface MANaviAnnotationView : MAPinAnnotationView

- (id)initWithAnnotation:(id <MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier;

@end
