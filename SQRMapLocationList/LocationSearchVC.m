//
//  LocationSearchVC.m
//  CommunityPeople
//
//  Created by PR on 18/6/6.
//  Copyright (c) 2018年 PR. All rights reserved.
//

#import "LocationSearchVC.h"
#import "SQRBaseDefine.h"
#import "SQRLocationViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <MapKit/MapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

static NSString *cellId = @"cellId";

@interface LocationSearchVC () <AMapSearchDelegate,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UISearchBar *searchBar;
@property (nonatomic,strong) AMapSearchAPI *search;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,assign) BOOL isShowToastBool;
@property (nonatomic,strong) UITableView *tableView;

@end

@implementation LocationSearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(46, 0, DEF_SCREEN_WIDTH - 92, 45)];
    _searchBar.delegate = self;
    _searchBar.placeholder = @"请在此键入您要搜索的内容";

    [_searchBar becomeFirstResponder];
    [self.navigationController.navigationBar addSubview:_searchBar];
    UITextField * searchField = [_searchBar valueForKey:@"_searchField"];
    searchField.font = [UIFont systemFontOfSize:13];
    [searchField setValue:[UIFont systemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
    searchField.backgroundColor = [UIColor whiteColor];
    
    [AMapServices sharedServices].apiKey = _mapKey;
    self.search = [[AMapSearchAPI alloc]init];
    self.search.delegate = self;
    
    [self.view addSubview:self.tableView];
}

- (UITableView *)tableView {
    if (_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}

#pragma mark - UISearchBar delegate 监听者搜索框中的值的变化
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.view endEditing:YES];
    
    if (searchBar.text.length > 0) {
        [self searchPoiByKeyword:searchBar.text];
    }
    _isShowToastBool = YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchBar.text.length > 0) {
        [self searchPoiByKeyword:searchText];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


/* 根据关键字来搜索POI. */
- (void)searchPoiByKeyword:(NSString *)keyword {
    [self.tableView reloadData];
    
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
    request.keywords            = keyword;
    request.types               = @"住宅|科教|住宿|机构";
    request.requireExtension    = YES;
    [self.search AMapPOIKeywordsSearch:request];
}

/* POI 搜索回调. */
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response {
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:response.pois];
    [self.tableView reloadData];
    
    if (response.pois.count == 0) {
        if (_isShowToastBool) {
            DEF_Toast(@"暂无结果");
            _isShowToastBool = NO;
            return;
        }
    }
        
}


#pragma mark - LKBaseTableView Action && Datasource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    
    AMapPOI *poi = self.dataArray[indexPath.section];
    cell.textLabel.text = poi.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@ %@", poi.province ? poi.province : @"",
                                 poi.city ? poi.city : @"",
                                 poi.address ? poi.address : @""];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[GDLocationViewController class]]) {
            GDLocationViewController *gd = (GDLocationViewController *)vc;
            gd.poi = self.dataArray[indexPath.section];
            [self.navigationController popToViewController:gd animated:YES];
        }
    }
}



- (void)viewWillDisappear:(BOOL)animated {
    [_searchBar removeFromSuperview];
}

@end
