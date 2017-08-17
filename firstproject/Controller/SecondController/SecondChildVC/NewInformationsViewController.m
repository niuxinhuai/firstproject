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
    NSString * poiNameTitle;
    NSString * poiAddressTitle;
}
@property (nonatomic, strong) AMapNaviDriveManager * driveManager;
@property (nonatomic, strong) AMapNaviDriveView    * driveView;
@property (nonatomic, strong) AMapSearchAPI * search;
@property (nonatomic, strong) CLLocation * currentLocation;//获取用户当前定位坐标
@property (nonatomic,retain) MAPointAnnotation *destinationPoint;//目标点
//@property (nonatomic, strong) CLLocation * destinationPoint;//获取用户指定终点定位坐标
@property (nonatomic, strong) NSArray * pathPolylines;
@property (nonatomic, strong) AMapPOI * endPoi;
@property (nonatomic, strong) XHPOIMapView * customPoiView;
@property (nonatomic, strong) AMapPOIAroundSearchRequest * aroundRequest;
@property (nonatomic, strong) NSMutableArray <AMapPOI *>* poiArray;
@property (nonatomic, strong) MAPointAnnotation * pointAnnotation;
@property (nonatomic, strong) UIActivityIndicatorView * indicator;

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

    
    //后台定位
    _mapView.pausesLocationUpdatesAutomatically = NO;
    
    _mapView.allowsBackgroundLocationUpdates = YES;//iOS9以上系统必须配置
    ///把地图添加至view
    [self.view addSubview:_mapView];
 
   // _mapView.userTrackingMode = MAUserTrackingModeFollow;
    _mapView.showsScale= YES;  //设置成NO表示不显示比例尺；YES表示显示比例尺
    [self.view addSubview:self.customPoiView];
  
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    ///如果您需要进入地图就显示定位小蓝点，则需要下面两行代码
    [self.indicator startAnimating];
    _mapView.showsUserLocation = YES;
    //地图跟踪模式
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
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

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id)annotation {
    [self.indicator stopAnimating];
    //大头针标注
    
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {//判断是否是自己的定位气泡，如果是自己的定位气泡，不做任何设置，显示为蓝点，如果不是自己的定位气泡，比如大头针就会进入
        //    判断是不是用户的大头针数据模型
        if ([annotation isKindOfClass:[MAUserLocation class]]) {
//            MAAnnotationView *annotationView = [[MAAnnotationView alloc]init];
//            annotationView.image = [UIImage imageNamed:@"acc"];
//            
//            //        是否允许显示插入视图*********
//            annotationView.canShowCallout = YES;
            
            return nil;
        }
        
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        
        MAAnnotationView*annotationView = (MAAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        
        if (annotationView == nil) {
            
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
            
        }
        
        annotationView.frame = CGRectMake(0, 0, 100, 100);
//        
        annotationView.canShowCallout= YES;//设置气泡可以弹出，默认为NO

        
        //annotationView.animatesDrop = YES;        //设置标注动画显示，默认为NO
        
        annotationView.draggable = YES; //设置标注可以拖动，默认为NO
        
        
        //设置大头针显示的图片
        
        annotationView.image = [UIImage imageNamed:@"endPoint"];
//
        //点击大头针显示的左边的视图
        
        UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"m8.jpg"]];
        UILabel * titleLabel = [[UILabel alloc]init];
        titleLabel.text = poiNameTitle;
        titleLabel.textColor = [UIColor redColor];
        annotationView.leftCalloutAccessoryView = titleLabel;
        
        //点击大头针显示的右边视图
        
        UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 50)];
        
        rightButton.backgroundColor = [UIColor grayColor];
        
        [rightButton setTitle:@"导航" forState:UIControlStateNormal];
        [rightButton setTitleColor:[UIColor uiColorFromString:@"#1997eb"] forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(beginRotes) forControlEvents:UIControlEventTouchUpInside];
        
        annotationView.rightCalloutAccessoryView = rightButton;
        
        
        
        return annotationView;
        
    }
    
    return nil;
    
}


// 开始规划路线
- (void)beginRotes{
    UIAlertController * controller = [UIAlertController alertControllerWithTitle:@"高德地图导航" message:@"请先选择类型" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * confirmAction = [UIAlertAction actionWithTitle:@"驾车出行路线规划" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self carRote];
    }];
    UIAlertAction * confirmActions = [UIAlertAction actionWithTitle:@"步行出行路线规划" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self walkingRoute];
    }];
    UIAlertAction * confirmAction1 = [UIAlertAction actionWithTitle:@"公交出行路线规划" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self busRote];
    }];
    UIAlertAction * confirmAction2 = [UIAlertAction actionWithTitle:@"骑行出行路线规划" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self ridingRote];
    }];
    UIAlertAction * cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
        
        
    }];
    [cancleAction setValue:[UIColor redColor] forKey:@"titleTextColor"];
    
    [controller addAction:cancleAction];
    [controller addAction:confirmAction];
    [controller addAction:confirmActions];
    [controller addAction:confirmAction1];
    [controller addAction:confirmAction2];
    [self presentViewController:controller animated:YES completion:nil];
    
}
#pragma mark - 路径规划查询
- (void)carRote{
    [self.indicator startAnimating];
    AMapDrivingRouteSearchRequest *request = [[AMapDrivingRouteSearchRequest alloc] init];
    
    request.requireExtension = YES;
    request.strategy = 5;
    /* 出发点. */
    request.origin = [AMapGeoPoint locationWithLatitude:_currentLocation.coordinate.latitude longitude:_currentLocation.coordinate.longitude];
    /* 目的地. */
      request.destination = [AMapGeoPoint locationWithLatitude:_endPoi.location.latitude longitude:_endPoi.location.longitude];
    [self.search AMapDrivingRouteSearch:request];
}
- (void)walkingRoute{
    [self.indicator startAnimating];

    /*
     origin：起点坐标，必设。
     、destination：终点坐标，必设。
     waypoints：途经点，最多支持16个途经点。
     avoidpolygons：避让区域，最多支持100个避让区域，每个区域16个点。
     avoidroad：避让道路，设置避让道路后，避让区域失效。
     strategy：驾车导航策略，0-速度优先（时间）；1-费用优先（不走收费路段的最快道路）；2-距离优先；3-不走快速路；4-结合实时交通（躲避拥堵）；5-多策略（同时使用速度优先、费用优先、距离优先三个策略）；6-不走高速；7-不走高速且避免收费；8-躲避收费和拥堵；9-不走高速且躲避收费和拥堵。
     */
    AMapWalkingRouteSearchRequest *request = [[AMapWalkingRouteSearchRequest alloc] init];
    //设置起点，我选择了当前位置，mapView有这个属性
    request.origin = [AMapGeoPoint locationWithLatitude:_currentLocation.coordinate.latitude longitude:_currentLocation.coordinate.longitude];
    //设置终点，可以选择手点
    request.destination = [AMapGeoPoint locationWithLatitude:_endPoi.location.latitude longitude:_endPoi.location.longitude];
    
//        request.strategy = 5;
//        request.requireExtension = YES;
    
    //发起路径搜索，发起后会执行代理方法
    //这里使用的是步行路径
    [_search AMapWalkingRouteSearch: request];

}
- (void)busRote{
    [self.indicator startAnimating];

    AMapTransitRouteSearchRequest *request = [[AMapTransitRouteSearchRequest alloc] init];
    
    request.requireExtension = YES;
    request.city             = @"hangzhou";
    //  //终点城市
    //  navi.destinationCity  = @"wuhan";
    
    /* 出发点. */
   request.origin = [AMapGeoPoint locationWithLatitude:_currentLocation.coordinate.latitude longitude:_currentLocation.coordinate.longitude];
    /* 目的地. */
     request.destination = [AMapGeoPoint locationWithLatitude:_endPoi.location.latitude longitude:_endPoi.location.longitude];
    [_search AMapTransitRouteSearch:request];
}
- (void)ridingRote{
    [self.indicator startAnimating];

    AMapRidingRouteSearchRequest *request = [[AMapRidingRouteSearchRequest alloc] init];
    /* 出发点. */
    request.origin = [AMapGeoPoint locationWithLatitude:_currentLocation.coordinate.latitude longitude:_currentLocation.coordinate.longitude];
    /* 目的地. */
    request.destination = [AMapGeoPoint locationWithLatitude:_endPoi.location.latitude longitude:_endPoi.location.longitude];
    [_search AMapRidingRouteSearch:request];
}

//实现路径搜索的回调函数
- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response
{
    if(response.route == nil)
    {
        return;
    }
    
    //通过AMapNavigationSearchResponse对象处理搜索结果
    NSString *route = [NSString stringWithFormat:@"Navi: %@", response.route];
     NSLog(@"%@", route);
    AMapPath *path = response.route.paths[0]; //选择一条路径
    AMapStep *step = path.steps[0]; //这个路径上的导航路段数组
    NSLog(@"%@",step.polyline);   //此路段坐标点字符串
    
    if (response.count > 0)
    {
        //移除地图原本的遮盖
        [_mapView removeOverlays:_pathPolylines];
        _pathPolylines = nil;
        
        // 只显⽰示第⼀条 规划的路径
        _pathPolylines = [self polylinesForPath:response.route.paths[0]];
        NSLog(@"%@",response.route.paths[0]);
        //添加新的遮盖，然后会触发代理方法进行绘制
        [_mapView addOverlays:_pathPolylines];
        //        解析第一条返回结果
        //        搜索路线
        MAPointAnnotation *currentAnnotation = [[MAPointAnnotation alloc]init];
        currentAnnotation.coordinate = _mapView.userLocation.coordinate;
        [_mapView showAnnotations:@[_destinationPoint, currentAnnotation] animated:YES];
        [_mapView addAnnotation:currentAnnotation];
    }
}
//路线解析
- (NSArray *)polylinesForPath:(AMapPath *)path
{
    if (path == nil || path.steps.count == 0)
    {
        return nil;
    }
    NSMutableArray *polylines = [NSMutableArray array];
    [path.steps enumerateObjectsUsingBlock:^(AMapStep *step, NSUInteger idx, BOOL *stop) {
        NSUInteger count = 0;
        CLLocationCoordinate2D *coordinates = [self coordinatesForString:step.polyline
                                                         coordinateCount:&count
                                                              parseToken:@";"];
        
        
        MAPolyline *polyline = [MAPolyline polylineWithCoordinates:coordinates count:count];
        
        //          MAPolygon *polygon = [MAPolygon polygonWithCoordinates:coordinates count:count];
        
        [polylines addObject:polyline];
        free(coordinates), coordinates = NULL;
    }];
    return polylines;
}
//解析经纬度
- (CLLocationCoordinate2D *)coordinatesForString:(NSString *)string
                                 coordinateCount:(NSUInteger *)coordinateCount
                                      parseToken:(NSString *)token
{
    if (string == nil)
    {
        return NULL;
    }
    
    if (token == nil)
    {
        token = @",";
    }
    
    NSString *str = @"";
    if (![token isEqualToString:@","])
    {
        str = [string stringByReplacingOccurrencesOfString:token withString:@","];
    }
    
    else
    {
        str = [NSString stringWithString:string];
    }
    
    NSArray *components = [str componentsSeparatedByString:@","];
    NSUInteger count = [components count] / 2;
    if (coordinateCount != NULL)
    {
        *coordinateCount = count;
    }
    CLLocationCoordinate2D *coordinates = (CLLocationCoordinate2D*)malloc(count * sizeof(CLLocationCoordinate2D));
    
    for (int i = 0; i < count; i++)
    {
        coordinates[i].longitude = [[components objectAtIndex:2 * i]     doubleValue];
        coordinates[i].latitude  = [[components objectAtIndex:2 * i + 1] doubleValue];
    }
    
    
    return coordinates;
}
//绘制遮盖时执行的代理方法
- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay
{
    /* 自定义定位精度对应的MACircleView. */
    
    //画路线
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        //初始化一个路线类型的view
        MAPolylineRenderer *polygonView = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
        //设置线宽颜色等
        polygonView.lineWidth = 8.f;
        polygonView.strokeColor = [UIColor colorWithRed:0.015 green:0.658 blue:0.986 alpha:1.000];
        polygonView.fillColor = [UIColor colorWithRed:0.940 green:0.771 blue:0.143 alpha:0.800];
        polygonView.lineJoinType = kMALineJoinRound;//连接类型
        //返回view，就进行了添加
        return polygonView;
    }
    return nil;
    
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

- (void)didSelectRowWithIndexPath:(NSInteger)row{
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.5 animations:^{
        
        self.customPoiView.y = viewOrigin_Y;
    }];
    AMapPOI * poi = self.poiArray[row];
    _endPoi = poi;
    _destinationPoint = [[MAPointAnnotation alloc] init];
   
     _destinationPoint.coordinate = CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude);
    poiNameTitle = poi.name;
    poiAddressTitle = poi.address;
    CLLocationCoordinate2D coor;
    coor.latitude = poi.location.latitude;
    coor.longitude = poi.location.longitude;
   
    _pointAnnotation = [[MAPointAnnotation alloc]init];
  
    self.pointAnnotation.coordinate = coor;
    // 设置定图的定位中心点坐标
    _mapView.centerCoordinate = coor;
    //将点添加到地图上，即所谓的大头针
    [_mapView addAnnotation:_pointAnnotation];
    
    
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
- (NSArray *)pathPolylines
{
    if (!_pathPolylines) {
        _pathPolylines = [NSArray array];
    }
    return _pathPolylines;
}
-(UIActivityIndicatorView *)indicator{
    if (!_indicator) {
        _indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _indicator.center = CGPointMake(self.view.width/2, self.view.height/2);
        _indicator.color = [UIColor redColor];
        [self.view addSubview:_indicator];
        unsigned  int count = 0;
        Ivar *members = class_copyIvarList([UIButton class], &count);
        
        for (int i = 0; i < count; i++)
        {
            Ivar var = members[i];
            const char *memberAddress = ivar_getName(var);
            const char *memberType = ivar_getTypeEncoding(var);
            NSLog(@"address = %s ; type = %s",memberAddress,memberType);
        }
    }
    
    return _indicator;
    
}
//- (MAPointAnnotation *)pointAnnotation{
//    if (!_pointAnnotation) {
//     
//    }
//    return _pointAnnotation;
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
