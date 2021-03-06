//
//  LJMapTrackView.m
//  MKMapDemo
//
//  Created by LiJie on 2017/2/9.
//  Copyright © 2017年 LiJie. All rights reserved.
//

#import "LJMapTrackView.h"

@interface LJMapTrackView ()<MKMapViewDelegate, CLLocationManagerDelegate>

@property(nonatomic, strong)MKMapView*          mapView;
@property(nonatomic, strong)CLLocationManager*  locationManager;

@property(nonatomic, strong)NSMutableArray* locations;
@property(nonatomic, strong)NSMutableArray* mapLocations;
@property(nonatomic, strong)CLLocation*     currentLocation;
@property(nonatomic, assign)CGFloat         currentSpan; //当前的跨度

@property(nonatomic, assign)BOOL isRun;
@property(nonatomic, assign)BOOL isFirst;

@property(nonatomic, strong)MapLocationBlock tempBlock;

@end

@implementation LJMapTrackView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
    }
    return self;
}

-(void)dealloc{
    NSLog(@"View dealloc.......");
    [self removeTrack];
    [self.mapView removeFromSuperview];
    self.mapView.delegate = nil;
    self.mapView = nil;
    [self.locationManager stopUpdatingLocation];
    self.locationManager.delegate = nil;
    self.locationManager = nil;
}

-(UIColor *)fillColor{
    if (!_fillColor) {
        _fillColor = [UIColor greenColor];
    }
    return _fillColor;
}

-(UIColor *)strokeColor{
    if (!_strokeColor) {
        _strokeColor = [UIColor redColor];
    }
    return _strokeColor;
}

-(CGFloat)lineWidth{
    if (_lineWidth<0.01) {
        _lineWidth = 5.0;
    }
    return _lineWidth;
}

-(void)initData{
    
    self.isFirst = YES;
    self.isWatchMode = YES;
    self.currentSpan = 0.001;
    self.locations = [NSMutableArray new];
    self.mapLocations = [NSMutableArray new];
    
    self.mapView = [[MKMapView alloc]initWithFrame:self.bounds];
    self.mapView.showsUserLocation = YES;
    self.mapView.showsScale = YES;
    self.mapView.showsCompass = YES;
    self.mapView.delegate = self;
    
    [self addSubview: self.mapView];
    
    
    self.locationManager = [[CLLocationManager alloc]init];
    if (![CLLocationManager locationServicesEnabled]){
        //NSLog(@"定位服务未打开，请打开");
        return;
    }
    
    //如果没有授权则请求用户授权 ,可以设置为： 只在使用时 和 一直
    if ([CLLocationManager authorizationStatus]!=kCLAuthorizationStatusAuthorizedAlways){
        [self.locationManager requestAlwaysAuthorization];
    }
    
    self.locationManager.allowsBackgroundLocationUpdates = YES;
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 5.0;//5米定位一次
}

-(void)callBackHandler:(MapLocationBlock)handler{
    self.tempBlock = handler;
}

-(void)addTrackPoint:(NSArray<CLLocation *> *)coordinates{
    if (coordinates.count >= 1) {
        
        NSMutableArray<CLLocation *>* tempArray = [NSMutableArray new];
        if (self.locations.count>0) {
            [tempArray addObject:self.locations.lastObject];
        }
        [self.locations addObjectsFromArray:coordinates];
        [tempArray addObjectsFromArray:coordinates];
        if (tempArray.count <= 1) {
            return;
        }
        
        CLLocationCoordinate2D  pointCoords[tempArray.count];
        for (NSInteger i = 0; i<tempArray.count; i++) {
            pointCoords[i] = tempArray[i].coordinate;
        }
        
        MKPolyline* line = [MKPolyline polylineWithCoordinates:pointCoords count:tempArray.count];
        line.subtitle = @"location";
        [self.mapView addOverlay:line];
    }
}

-(void)addTrackMapPoint:(NSArray<CLLocation *> *)coordinates{
    if (coordinates.count >= 1) {
        
        NSMutableArray<CLLocation *>* tempArray = [NSMutableArray new];
        if (self.mapLocations.count>0) {
            [tempArray addObject:self.mapLocations.lastObject];
        }
        [self.mapLocations addObjectsFromArray:coordinates];
        [tempArray addObjectsFromArray:coordinates];
        if (tempArray.count <= 1) {
            return;
        }
        
        CLLocationCoordinate2D  pointCoords[tempArray.count];
        for (NSInteger i = 0; i<tempArray.count; i++) {
            pointCoords[i] = tempArray[i].coordinate;
        }
        
        MKPolyline* line = [MKPolyline polylineWithCoordinates:pointCoords count:tempArray.count];
        line.subtitle = @"map";
        [self.mapView addOverlay:line];
    }
}

/**  快速 切换一遍 地图的类型， 以便释放掉内存 */
- (void)applyMapViewMemoryHotFix{
    
    switch (self.mapView.mapType) {
        case MKMapTypeHybrid:{
            self.mapView.mapType = MKMapTypeStandard;
            break;
        }
        case MKMapTypeStandard:{
            self.mapView.mapType = MKMapTypeHybrid;
            break;
        }
        default:
            break;
    }
    self.mapView.mapType = MKMapTypeStandard;
}

-(void)setMapCurrentLocation:(CLLocationCoordinate2D)coordinate{
    self.currentLocation = [[CLLocation alloc]initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    //经纬度的 跨度
    MKCoordinateSpan span = MKCoordinateSpanMake(0.003, 0.003);
    
    //显示的区域，由一个中心点 和 跨度决定
    MKCoordinateRegion region = MKCoordinateRegionMake(coordinate, span);
    [self.mapView setRegion:region animated:YES];
}

-(void)startRun{
    if (!self.isWatchMode && !self.isRun) {
        self.isRun = YES;
        [self.locationManager startUpdatingLocation];
    }
}

-(void)stopRun{
    if (!self.isWatchMode && self.isRun) {
        self.isRun = NO;
        [self.locationManager stopUpdatingLocation];
    }
}

-(void)removeTrack{
    if (self.mapView.overlays.count>0) {
        [self.mapView removeOverlays:self.mapView.overlays];
        [self.locations removeAllObjects];
        [self.mapLocations removeAllObjects];
    }
}

#pragma mark - ================ Delegate ==================
/**  地图区域改变时调用 */
-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    //    [self.mapView removeFromSuperview];
    //    self.mapView = mapView;
    //    [self.view addSubview:mapView];
    if (fabs(self.currentSpan - mapView.region.span.latitudeDelta) > 0.04) {
        [self applyMapViewMemoryHotFix];
        self.currentSpan = mapView.region.span.latitudeDelta;
    }
}

//-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
//    
//    NSLog(@"...%@", NSStringFromClass([annotation class]));
//    
//    return nil;
//}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    
    self.currentLocation = userLocation.location;
    
    if (self.isFirst) {
        self.isFirst = NO;
        //经纬度的 跨度
        MKCoordinateSpan span = MKCoordinateSpanMake(0.003, 0.003);
        
        //显示的区域，由一个中心点 和 跨度决定
        MKCoordinateRegion region = MKCoordinateRegionMake(userLocation.coordinate, span);
        [mapView setRegion:region animated:YES];
    }
//    if (userLocation && !self.isWatchMode && self.isRun) {
//        [self addTrackMapPoint:@[userLocation.location]];
//    }
    if (self.tempBlock && self.currentLocation) {
        self.tempBlock(YES, @[@(self.currentLocation.coordinate.latitude), @(self.currentLocation.coordinate.longitude)]);
    }
}

-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay{
    
    if ([[overlay class] isSubclassOfClass:[MKPolyline class]]) {
        MKPolylineRenderer* renderer = [[MKPolylineRenderer alloc]initWithPolyline:overlay];
        renderer.fillColor = self.fillColor;
        renderer.strokeColor = self.strokeColor;
        renderer.lineWidth = self.lineWidth;
        renderer.lineCap = kCGLineCapRound;
        renderer.lineJoin = kCGLineJoinRound;
        if ([[(MKPolyline*)overlay subtitle]isEqualToString:@"map"]) {
            renderer.strokeColor = [UIColor greenColor];
        }
        return  renderer;
    }
    
    return nil;
}


#pragma mark - ================ LocationDelegate ==================
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{

    if (locations.count && !self.isWatchMode && self.isRun) {
        CLLocation* location = locations.firstObject;
        
        //系统坐标系 -> 高德坐标系  有偏移
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(location.coordinate.latitude-0.003, location.coordinate.longitude+0.0049);
        location = [[CLLocation alloc]initWithCoordinate:coordinate altitude:location.altitude horizontalAccuracy:location.horizontalAccuracy verticalAccuracy:location.verticalAccuracy course:location.course speed:location.speed timestamp:location.timestamp];
        [self addTrackPoint:@[location]];
        if (self.tempBlock) {
            self.tempBlock(NO, @[@(location.coordinate.latitude), @(location.coordinate.longitude)]);
        }
        return;
    }
    if (self.tempBlock) {
        CLLocation* location = locations.firstObject;
        self.tempBlock(NO, @[@(location.coordinate.latitude), @(location.coordinate.longitude)]);
    }
}








@end
