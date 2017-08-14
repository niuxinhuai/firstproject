//
//  NewInformationsViewController.m
//  firstproject
//
//  Created by 牛新怀 on 2017/5/24.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#import "NewInformationsViewController.h"
#import <AMapNaviKit/AMapNaviKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>

#import <AMapSearchKit/AMapSearchKit.h>
#import "XHPOIMapView.h"
@interface NewInformationsViewController ()<AMapNaviDriveManagerDelegate,AMapNaviDriveViewDelegate,AMapSearchDelegate,MAMapViewDelegate,UIGestureRecognizerDelegate,POIMapViewDelegate>
{
    MAMapView *_mapView;
    CGFloat viewOrigin_Y;
}
@property (nonatomic, strong) AMapNaviDriveManager * driveManager;
@property (nonatomic, strong) AMapNaviDriveView    * driveView;
@property (nonatomic, strong) AMapSearchAPI * search;
@property (nonatomic, strong) CLLocation * currentLocation;//获取用户当前定位坐标
@property (nonatomic, strong) XHPOIMapView * customPoiView;
@property (nonatomic, strong) AMapPOIAroundSearchRequest * aroundRequest;
@property (nonatomic, strong) NSMutableArray <AMapPOI *>* poiArray;
@end

@implementation NewInformationsViewController
/*
 因使用“后台定位”功能而被AppStore拒绝的解决方法
 
 使用到“后台定位”功能，必须在工程的 Info.plist中添加：Privacy - Location Always Usage Description字段，内容可以根据实际应用场景填写，如：
 必须开启Capabilities下的Background Modes下的Location updates：
 如果应用使用“后台定位”功能的业务场景很容易被苹果审核人员找到，并且理由比较合理那是最好的，一般就能审核通过。如果业务场景比较深，或者理由比较不充分，审核人员在使用App期间没体验到“后台定位”功能，而你又开启了步骤2，那么需要在审核的时候，在“APP审核信息备注”如实写一下理由，或者告诉审核人员如何触发“后台定位”，一般都能审核通过。
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self initDriveManager];
//    [self initDriveView];
//    [self configDriveNavi];
    
    [AMapServices sharedServices].enableHTTPS = YES;
    
    ///初始化地图
    _mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
      [_mapView setZoomLevel:17 animated:NO];
    _mapView.delegate =self;
    //地图跟踪模式
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    
    //后台定位
    _mapView.pausesLocationUpdatesAutomatically = NO;
    
    _mapView.allowsBackgroundLocationUpdates = YES;//iOS9以上系统必须配置
    ///把地图添加至view
    [self.view addSubview:_mapView];
    ///如果您需要进入地图就显示定位小蓝点，则需要下面两行代码
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    _mapView.showsScale= YES;  //设置成NO表示不显示比例尺；YES表示显示比例尺
    [self.view addSubview:self.customPoiView];
  
}
- (void)POISearch{

    if (_currentLocation) {
        AMapReGeocodeSearchRequest * request = [[AMapReGeocodeSearchRequest alloc]init];
        request.location = [AMapGeoPoint locationWithLatitude:_currentLocation.coordinate.latitude longitude:_currentLocation.coordinate.longitude];
        [self.search AMapReGoecodeSearch:request];
    }
  
    
}
#pragma mark - AmapSearchDelegate
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response{
    NSString * str = response.regeocode.addressComponent.city;// addressComponent包含用户当前的地址
    if (str.length ==0) {
        str = response.regeocode.addressComponent.province;
    }
    _mapView.userLocation.title = str;// 定位标注点要显示的标注信息
    _mapView.userLocation.subtitle = response.regeocode.formattedAddress;// 子标题
}
/* POI 搜索回调. */
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    if (response.pois.count == 0)
    {
        return;
    }
    if (self.poiArray.count !=0) {
        [self.poiArray removeAllObjects];
    }
    self.poiArray = [NSMutableArray arrayWithArray:response.pois];
    self.customPoiView.allPoiArray = self.poiArray;
    //解析response获取POI信息，具体解析见 Demo
}
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error{
    NSLog(@"%@",error.description);
}
#pragma mark - MapDelegate
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{
    _currentLocation = [userLocation.location copy];
      [self POISearch];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)initDriveManager
{
    if (self.driveManager == nil)
    {
        self.driveManager = [[AMapNaviDriveManager alloc] init];
        [self.driveManager setDelegate:self];
    }
}

- (void)initDriveView
{
    if (self.driveView == nil)
    {
        self.driveView = [[AMapNaviDriveView alloc] initWithFrame:self.view.bounds];
        [self.driveView setDelegate:self];
        //将导航界面的界面元素进行隐藏，然后通过自定义的控件展示导航信息
        [self.driveView setShowUIElements:NO];
    }
}
- (void)configDriveNavi
{
    [self.driveManager addDataRepresentative:self.driveView];
    [self.view addSubview:self.driveView];
    self.driveView.showCompass = YES;
}
- (XHPOIMapView *)customPoiView{
    if (!_customPoiView) {
        _customPoiView = [[XHPOIMapView alloc]init];
        _customPoiView.frame = CGRectMake(0, SCREEN_HEIGHT-250*OffHeight, SCREEN_WIDTH, 280*OffHeight);
        viewOrigin_Y = _customPoiView.frame.origin.y;
        _customPoiView.userInteractionEnabled = YES;
        _customPoiView.delegate = self;
        _customPoiView.backgroundColor = [UIColor clearColor];
        [self addgesture];
    }
    
    return _customPoiView;
}
- (void)addgesture{
    UISwipeGestureRecognizer* recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    recognizer.delegate = self;
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionUp)];
    [self.customPoiView addGestureRecognizer:recognizer];
    UISwipeGestureRecognizer* recognizers = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
    [self.customPoiView addGestureRecognizer:recognizers];
    
 
    

}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    if ([otherGestureRecognizer.view isKindOfClass:[XHPOIMapView class]]) {
        return YES;
    }
    return NO;
}
- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    if(recognizer.direction == UISwipeGestureRecognizerDirectionDown) {
        NSLog(@"swipe down");
    }
    if(recognizer.direction == UISwipeGestureRecognizerDirectionUp) {
        NSLog(@"swipe up");
    }

}
#pragma mark - POIMapViewDelegate
- (void)didSelectPOISearchBar:(XHPOIMapView *)view{
    [UIView animateWithDuration:0.5 animations:^{
        
        self.customPoiView.y = 30;
    }];
}
- (void)didSelectCancleButton:(XHPOIMapView *)view{
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.5 animations:^{
        
        self.customPoiView.y = viewOrigin_Y;
    }];
}
- (void)didSelectSearchBarDidChangeText:(NSString *)searchText{// 根据输入文字，进行距离排序检索
 
    self.aroundRequest.location = [AMapGeoPoint locationWithLatitude:_currentLocation.coordinate.latitude longitude:_currentLocation.coordinate.longitude];
    
    /* 按照距离排序. */
    self.aroundRequest.radius =  5000;
    self.aroundRequest.sortrule            = 0;
    self.aroundRequest.requireExtension    = YES;
    self.aroundRequest.keywords            = searchText;
    self.aroundRequest.requireExtension    = YES;

    [self.search AMapPOIAroundSearch:self.aroundRequest];
}
- (AMapSearchAPI *)search{
    if (!_search) {
        _search = [[AMapSearchAPI alloc]init];
        _search.delegate = self;
    }
    return _search;
}
- (AMapPOIAroundSearchRequest *)aroundRequest{
    if (!_aroundRequest) {
       _aroundRequest = [[AMapPOIAroundSearchRequest alloc] init];
        

    }
    return _aroundRequest;
}
- (NSMutableArray <AMapPOI *>*)poiArray{
    if (!_poiArray) {
        _poiArray = [[NSMutableArray alloc]init];
    }
    return _poiArray;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
