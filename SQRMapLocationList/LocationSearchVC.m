//
//  LocationSearchVC.m
//  CommunityPeople
//
//  Created by PR on 18/6/6.
//  Copyright (c) 2018年 PR. All rights reserved.
//

#import "LocationSearchVC.h"
#import "SQRMapLocationList.h"

static NSString *cellId = @"cellId";

@interface LocationSearchVC () <AMapSearchDelegate,UISearchBarDelegate>

@property (nonatomic,strong) UISearchBar *searchBar;
@property (nonatomic,strong) AMapSearchAPI *search;
@property (nonatomic,assign) BOOL isShowToastBool;

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

-(NSInteger)LK_numberOfSections {
    return self.dataArray.count;
}

- (NSInteger)LK_numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)LK_cellheightAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (CGFloat)LK_sectionHeaderHeightAtSection:(NSInteger)section {
    return 5;
}

- (LKBaseTableViewCell *)LK_cellAtIndexPath:(NSIndexPath *)indexPath {
    LKBaseTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[LKBaseTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    
    AMapPOI *poi = self.dataArray[indexPath.section];
    cell.textLabel.text = poi.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@ %@", poi.province ? poi.province : @"",
                                                                        poi.city ? poi.city : @"",
                                                                        poi.address ? poi.address : @""];
    return cell;
}


- (void)LK_didSelectCellAtIndexPath:(NSIndexPath *)indexPath cell:(LKBaseTableViewCell *)cell {
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
