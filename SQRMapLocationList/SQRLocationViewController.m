//
//  SQRLocationViewController.m
//  Merchant
//
//  Created by PR on 18/6/6.
//  Copyright (c) 2018年 PR. All rights reserved.
//

#import "SQRLocationViewController.h"
#import "SQRMapLocationList.h"

#define RightCallOutTag 1
#define LeftCallOutTag 2

@interface SQRLocationViewController ()<MAMapViewDelegate,AMapSearchDelegate,UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet MAMapView *mapView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) AMapSearchAPI *search;

@property (nonatomic, assign) BOOL isDragging;
@property (nonatomic, assign) BOOL isSearchFromDragging;
@property (nonatomic, strong) ReGeocodeAnnotation *annotation;
@property (weak, nonatomic) IBOutlet UIButton *locationButton;

@property(nonatomic,strong) NSMutableArray *poiArray;
@property(nonatomic,strong) NSMutableArray *returnLocationArray;
@property(nonatomic,assign) int currentIndex;
@property(nonatomic,strong) NSMutableDictionary *locationDict;

@end


@implementation SQRLocationViewController

- (void)viewWillAppear:(BOOL)animated {
    if (_poi) {
        AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
        regeo.location = _poi.location;
        regeo.requireExtension = YES;
        [self.search AMapReGoecodeSearch:regeo];
    }
}

- (void)viewDidLoad {
    self.navItemTitle = @"选择地址";
    if (_isNeedSearchLocation) {
        DEF_WeakSelf(self);
        [self LK_setUpNavRightItemImage:[UIImage imageNamed:_searchImg ? _searchImg : @"ic_search_white"] handle:^(UIImage *rightItemImage) {
            LocationSearchVC *locaSearch = [[LocationSearchVC alloc]init];
            locaSearch.mapKey = weakself.mapKey;
            [self pushVc:locaSearch];
        }];
    }
    
    [super viewDidLoad];
    _currentIndex = -1;
    [self initSearch];
    [self initMap];
}

- (void)initMap {
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    [AMapServices sharedServices].enableHTTPS = YES;
    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
    [self.mapView setZoomLevel:16.1 animated:YES];
    [self.locationButton bringSubviewToFront:self.mapView];
    [self.view bringSubviewToFront: self.locationButton];
}

/* 初始化search. */
- (void)initSearch {
    [AMapServices sharedServices].apiKey = _mapKey;
    self.search = [[AMapSearchAPI alloc]init];
    self.search.delegate = self;
}


- (IBAction)touchLocaitonButton {
    self.mapView.showsUserLocation = YES;
    [self.mapView removeOverlays:self.mapView.overlays];
    [self.mapView removeAnnotations:self.mapView.annotations];
    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
}


#pragma mark - 高德地图代理方法
- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    MAAnnotationView *view = views[0];
    // 放到该方法中用以保证userlocation的annotationView已经添加到地图上了。
    if ([view.annotation isKindOfClass:[MAUserLocation class]])
    {
        MAUserLocationRepresentation *pre = [[MAUserLocationRepresentation alloc] init];
        pre.image = [UIImage imageNamed:@"location.png"];
        pre.lineWidth = 3;
        [self.mapView updateUserLocationRepresentation:pre];
        view.calloutOffset = CGPointMake(0, 0);
    } 
}

-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
    
    if(updatingLocation) {
        //取出当前位置的坐标
        NSLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
        [self.mapView removeOverlays:self.mapView.overlays];
        [self.mapView removeAnnotations:self.mapView.annotations];

        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude);
        [self searchReGeocodeWithCoordinate:coordinate];
        self.mapView.showsUserLocation = NO;
    }
}


- (void)searchReGeocodeWithCoordinate:(CLLocationCoordinate2D)coordinate {
    //关键字和类型检索不生效，不走回调，暂时只用经纬度检索，然后在回调里做筛选
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    regeo.location                    = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    regeo.requireExtension            = YES;
    [self.search AMapReGoecodeSearch:regeo];
}


- (void)mapView:(MAMapView *)mapView didSingleTappedAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    [self.mapView removeOverlays:mapView.overlays];
    [self.mapView removeAnnotations:mapView.annotations];
    _isSearchFromDragging = NO;
    [self searchReGeocodeWithCoordinate:coordinate];
}

#pragma mark - AMapSearchDelegate

/* 逆地理编码回调. */
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    self.poiArray = [NSMutableArray array];
    if (response.regeocode != nil && _isSearchFromDragging == NO)
    {
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(request.location.latitude, request.location.longitude);
        ReGeocodeAnnotation *reGeocodeAnnotation = [[ReGeocodeAnnotation alloc] initWithCoordinate:coordinate
                                                                                         reGeocode:response.regeocode];
        //回调里做筛选
        for (AMapPOI *poi in response.regeocode.pois) {
            if ([poi.type rangeOfString:@"住宅"].location != NSNotFound ||
                [poi.type rangeOfString:@"科教"].location != NSNotFound ||
                [poi.type rangeOfString:@"住宿"].location != NSNotFound ||
                [poi.type rangeOfString:@"机构"].location != NSNotFound) {
                
                poi.province = response.regeocode.addressComponent.province;
                poi.city = response.regeocode.addressComponent.city;
                poi.citycode = response.regeocode.addressComponent.citycode;
                poi.district = response.regeocode.addressComponent.district;
                poi.adcode = response.regeocode.addressComponent.adcode;
                
                [self.poiArray addObject:poi];
            }
        }
        
        reGeocodeAnnotation.title = reGeocodeAnnotation.reGeocode.formattedAddress;//behring update:改为显示详细地址
        [self.mapView addAnnotation:reGeocodeAnnotation];
        [self.mapView selectAnnotation:reGeocodeAnnotation animated:YES];
    }
    else /* from drag search, update address */
    {
        
        for (AMapPOI *poi in response.regeocode.pois) {
            if ([poi.type rangeOfString:@"住宅"].location != NSNotFound ||
                [poi.type rangeOfString:@"科教"].location != NSNotFound ||
                [poi.type rangeOfString:@"住宿"].location != NSNotFound ||
                [poi.type rangeOfString:@"机构"].location != NSNotFound) {
                [self.poiArray addObject:poi];
            }
        }
        
        [self.annotation setAMapReGeocode:response.regeocode];
        [self.mapView selectAnnotation:self.annotation animated:YES];
    }
    _currentIndex = -1;
    [self.tableView reloadData];
}


- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[ReGeocodeAnnotation class]])
    {
        static NSString *invertGeoIdentifier = @"invertGeoIdentifier";
        
        MANaviAnnotationView *poiAnnotationView = (MANaviAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:invertGeoIdentifier];
        if (poiAnnotationView == nil)
        {
            poiAnnotationView = [[MANaviAnnotationView alloc] initWithAnnotation:annotation
                                                                 reuseIdentifier:invertGeoIdentifier];
        }
        
        poiAnnotationView.animatesDrop = YES;

        return poiAnnotationView;
    }
    
    return nil;
}

#pragma mark - table delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _poiArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"GDPoiCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    
    cell.textLabel.textColor=[UIColor blackColor];
    
    if(indexPath.section==_currentIndex){
        cell.textLabel.textColor = DEF_COLOR_Master;
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else{
        cell.textLabel.textColor=[UIColor blackColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    AMapPOI *poi = self.poiArray[indexPath.section];
    cell.textLabel.text = poi.name;
    cell.detailTextLabel.text = poi.address;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if(indexPath.section==_currentIndex){
        return;
    }
    NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:_currentIndex
                                                   inSection:0];
    UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
    if (newCell.accessoryType == UITableViewCellAccessoryNone) {
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        newCell.textLabel.textColor = DEF_COLOR_Master;
    }
    UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:oldIndexPath];
    if (oldCell.accessoryType == UITableViewCellAccessoryCheckmark) {
        oldCell.accessoryType = UITableViewCellAccessoryNone;
        oldCell.textLabel.textColor=[UIColor blackColor];
    }
    _currentIndex = (int)indexPath.section;
    
    AMapPOI *poi = self.poiArray[_currentIndex];
    [self.mapView removeOverlays:self.mapView.overlays];
    [self.mapView removeAnnotations:self.mapView.annotations];

    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude);
    ReGeocodeAnnotation *reGeocodeAnnotation = [[ReGeocodeAnnotation alloc] initWithCoordinate:coordinate
                                                                                     reGeocode:nil];
    [self.mapView addAnnotation:reGeocodeAnnotation];
    [self.mapView setCenterCoordinate:coordinate animated:YES];
    
    if (!self.locationDict)self.locationDict = [NSMutableDictionary dictionary];
    [_locationDict setValue:[NSString stringWithFormat:@"%f",poi.location.longitude] forKey:@"lon"];
    [_locationDict setValue:[NSString stringWithFormat:@"%f",poi.location.latitude] forKey:@"lat"];
    [_locationDict setValue:poi.name forKey:@"name"];
    [_locationDict setValue:poi.address forKey:@"address"];
    [_locationDict setValue:poi.pcode forKey:@"pcode"];
    [_locationDict setValue:poi.province forKey:@"province"];
    [_locationDict setValue:poi.citycode forKey:@"citycode"];
    [_locationDict setValue:poi.city forKey:@"city"];
    [_locationDict setValue:poi.district forKey:@"district"];
    [_locationDict setValue:poi.adcode forKey:@"adcode"];
    
    if (_currentIndex != -1){
        if (self.returnChickLocationBlock) {
            self.returnChickLocationBlock(_locationDict);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
