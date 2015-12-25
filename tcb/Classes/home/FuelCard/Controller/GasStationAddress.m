//
//  GasStationAddress.m
//  tcb
//
//  Created by Jax on 15/12/14.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import "GasStationAddress.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "GasStationAnnotation.h"
#import "GasStationInfoModel.h"
#import "GasStationInfoCell.h"
#import "CustomAnnotationView.h"
#import "WGS84ToGCJ02.h"
#import "ImageRightButton.h"

#define MERCATOR_OFFSET 268435456
#define MERCATOR_RADIUS 85445659.44705395

#define kMapViewHeight 300
#define kBottomButtonHeight 50

@interface GasStationAddress () <MKMapViewDelegate, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) MKMapView           *mapView;
@property (nonatomic, strong) CLLocationManager   *locationManger;
@property (nonatomic, strong) CLLocation          *myLocation;
@property (nonatomic, strong) UITableView         *tableView;
@property (nonatomic, strong) UIButton            *showGasInfoButton;
@property (nonatomic, strong) GasStationInfoModel *gasStationInfoModel;
@property (nonatomic, assign) NSInteger           selectRow;

@end

@implementation GasStationAddress

- (GasStationInfoModel *)gasStationInfoModel {
    if (_gasStationInfoModel == nil) {
        _gasStationInfoModel = [[GasStationInfoModel alloc] init];
    }
    return _gasStationInfoModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.selectRow = -1;
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"加油站地址";
    
    [self setUpMapView];
    [self setUpBottomView];

    [self locationMe];
    
    [self setUpTableView];

}

- (void)locationMe {
    if (_locationManger == nil) {
        _locationManger = [[CLLocationManager alloc] init];
        _locationManger.delegate = self;
        _locationManger.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    }
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        [SVProgressHUD showErrorWithStatus:@"船讯网定位功能已被禁用，请到'设置->隐私->定位服务'中开启船讯网定位功能！"];
        return;
    }
    if (iOS9 || iOS8) {
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
            [_locationManger requestAlwaysAuthorization];
        }
    }
    [_locationManger startUpdatingLocation];
}

#pragma mark - locationMangerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
     self.myLocation = newLocation;
    self.mapView.showsUserLocation = YES;
    [self getGasStation];
    [self.locationManger stopUpdatingLocation];
}


- (void)getGasStation {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"GetGasStations" forKey:@"cmd"];
    //    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    //    [data setValue:@"fuelCardId" forKey:@"fuelCardId"];
    //    [data setValue:@1 forKey:@"pageIndex"];
    //    [data setValue:@50 forKey:@"pageSize"];
    //    [params setValue:data forKey:@"data"];
    [APIClientTool GetGasStationsWithParam:params success:^(NSDictionary *dict) {
        
        /* 添加所有加油站大头针 & 寻找区域 */
        NSArray *list = [[dict objectForKey:@"data"] objectForKey:@"list"];
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        [userInfo setValue:[NSNumber numberWithInteger:list.count] forKey:@"kGasStationNum"];
        NSNotification *noti = [NSNotification notificationWithName:@"kGetGasStationNum" object:self userInfo:userInfo];
        [[NSNotificationCenter defaultCenter] postNotification:noti];
        
        if (list.count == 0) {
            return ;
        }
        
        CLLocationDegrees minLat = [[list[0] objectForKey:@"Lat"] doubleValue]; //   纬度
        CLLocationDegrees maxLat = [[list[0] objectForKey:@"Lat"] doubleValue];
        CLLocationDegrees minLng = [[list[0] objectForKey:@"Lng"] doubleValue]; //   经度
        CLLocationDegrees maxLng = [[list[0] objectForKey:@"Lng"] doubleValue];
        for (int i = 0; i < list.count; i ++) {
            NSDictionary *gasStationInfoDict = list[i];
            double lat = [[gasStationInfoDict objectForKey:@"Lat"] doubleValue];
            double lng = [[gasStationInfoDict objectForKey:@"Lng"] doubleValue];
            
            if (lat > maxLat) {
                maxLat = lat;
            }
            if (lat < minLat) {
                minLat = lat;
            }
            
            if (lng > maxLng) {
                maxLng = lng;
            }
            if (lng < minLng) {
                minLng = lng;
            }
        }
        
        CLLocationDegrees latitudeDelta = maxLat - minLat + 0.01;
        CLLocationDegrees longitudeDelta = maxLng - minLng + 0.01;
        MKCoordinateSpan coordinateSpan = MKCoordinateSpanMake(latitudeDelta, longitudeDelta);
        /* 0.01用于不让边界上的大头针显示在屏幕边缘 */
        CLLocationDegrees centerLat = minLat + (maxLat - minLat) * 0.5 ;
        CLLocationDegrees centerLng = minLng + (maxLng - minLng) * 0.5;
        CLLocationCoordinate2D center = CLLocationCoordinate2DMake(centerLat, centerLng);
        CLLocationCoordinate2D GCJCenter = [WGS84ToGCJ02 transformFromWGSToGCJ:center];
        MKCoordinateRegion region = MKCoordinateRegionMake(GCJCenter, coordinateSpan);
        [self.mapView setRegion:region];
        
        NSMutableDictionary *modelDict = [NSMutableDictionary dictionary];
        
        
        NSMutableArray *mutabList = [list mutableCopy];
        NSMutableArray *lastList = [NSMutableArray array];
        for (NSDictionary *gasStationInfoDict in mutabList) {
            NSMutableDictionary *mutabDict = [gasStationInfoDict mutableCopy];
            double lat1 = self.myLocation.coordinate.latitude;
            double lng1 = self.myLocation.coordinate.longitude;
            double lat2 = [[mutabDict objectForKey:@"Lat"] doubleValue];
            double lng2 = [[mutabDict objectForKey:@"Lng"] doubleValue];
            
            CLLocationCoordinate2D GCJMyLocationCoordinate = [WGS84ToGCJ02 transformFromWGSToGCJ:CLLocationCoordinate2DMake(lat1, lng1)];
            CLLocationCoordinate2D GCJGasStationCoordinate = [WGS84ToGCJ02 transformFromWGSToGCJ:CLLocationCoordinate2DMake(lat2, lng2)];
            
            CLLocation *GCJMyLocation = [[CLLocation alloc] initWithLatitude:GCJMyLocationCoordinate.latitude longitude:GCJMyLocationCoordinate.longitude];
            CLLocation *GCJGasStationLocation = [[CLLocation alloc] initWithLatitude:GCJGasStationCoordinate.latitude longitude:GCJGasStationCoordinate.longitude];
            
            double distance = [GCJMyLocation distanceFromLocation:GCJGasStationLocation];
            [mutabDict setValue:[NSNumber numberWithDouble:distance] forKey:@"distance"];
            [lastList addObject:[mutabDict copy]];
        }
        /* distance排序 */
        NSArray *includeDistanceArray = [lastList copy];
        NSArray *sortArray = [includeDistanceArray sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2) {
            NSNumber *distance1 = [obj1 objectForKey:@"distance"];
            NSNumber *distance2 = [obj2 objectForKey:@"distance"];
            NSComparisonResult result = [distance1 compare:distance2];
            return result;
        }];
        
        for (int i = 0 ; i < sortArray.count ; i ++) {
            NSDictionary *sortDict = sortArray[i];
            double lat = [[sortDict objectForKey:@"Lat"] doubleValue];
            double lng = [[sortDict objectForKey:@"Lng"] doubleValue];
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(lat, lng);
            CLLocationCoordinate2D GCJGasStationCoordinate = [WGS84ToGCJ02 transformFromWGSToGCJ:coordinate];
            GasStationAnnotation *gasStationAnnotation = [[GasStationAnnotation alloc] init];
            gasStationAnnotation.coordinate = GCJGasStationCoordinate;
            gasStationAnnotation.title = [sortDict objectForKey:@"Name"];
            gasStationAnnotation.tag = i;
            [self.mapView addAnnotation:gasStationAnnotation];
        }
        
        [modelDict setValue:sortArray forKey:@"list"];
        NSDictionary *wantDict = [modelDict copy];
        /* wantDict最后需要的结果，转模型 */
        GasStationInfoModel *gasStationInfoModel = [GasStationInfoModel mj_objectWithKeyValues:wantDict];
        self.gasStationInfoModel = gasStationInfoModel;
        [self.tableView reloadData];
    } failed:^{

    }];
}



- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    if ([annotation isKindOfClass:[GasStationAnnotation class]]) {
        CustomAnnotationView *customAnnotationView = (CustomAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"CUSTOM_ANNOTATION"];
        if (customAnnotationView == nil) {
            customAnnotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CUSTOM_ANNOTATION"];
        }
        customAnnotationView.canShowCallout = YES ;
        
        customAnnotationView.image = [UIImage imageNamed:@"gasStationAn@2x"];
        return customAnnotationView;
    } else {
        MKAnnotationView *annotationView = [self.mapView dequeueReusableAnnotationViewWithIdentifier:@"MyLocation_ANNOTATION"];
        if (annotationView == nil) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MyLocation_ANNOTATION"];
        }
        annotationView.canShowCallout = YES ;
        
        annotationView.image = [UIImage imageNamed:@"myLocation"];
        return annotationView;
    }
    
    return nil;
}


/* 点击大头针调用 */
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    
    
    if ([view.annotation isKindOfClass:[MKUserLocation class]]) {
        return;
    }
    
    GasStationAnnotation *annotation = (GasStationAnnotation *)view.annotation;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:annotation.tag inSection:0];
    NSInteger rowForDevice = 0;
    if (iPhone4) {
        rowForDevice = 0;
    } else if (iPhone5) {
        rowForDevice = 2;
    } else if (iPhone6) {
        rowForDevice = 3;
    } else if (iPhone6plus) {
        rowForDevice = 5;
    }
    if (annotation.tag <= rowForDevice) {
        [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
    } else if (annotation.tag > rowForDevice) {
        [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
    }
    
}

#pragma mark -
- (void)setUpMapView {
    MKMapView *mapView = [[MKMapView alloc] init];
    [self.view addSubview:mapView];
    mapView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - kBottomButtonHeight);
    mapView.delegate = self;
    self.mapView = mapView;
    self.mapView.mapType =  MKMapTypeStandard;
}

- (void)setUpBottomView {
    ImageRightButton  *showGasInfoButton = [[ImageRightButton alloc] init];
    [self.view addSubview:showGasInfoButton];
     showGasInfoButton.frame =  CGRectMake(0, SCREEN_HEIGHT - kBottomButtonHeight, SCREEN_WIDTH, kBottomButtonHeight);
    [showGasInfoButton setTitle:@"加油站寻找中" forState:UIControlStateNormal];
    showGasInfoButton.backgroundColor = kRGB(111, 182, 43);
    [showGasInfoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [showGasInfoButton addTarget:self action:@selector(showGasInfoButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [showGasInfoButton setImage:[UIImage imageNamed:@"arrow_up"] forState:UIControlStateNormal];
    [showGasInfoButton setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateSelected];
    self.showGasInfoButton = showGasInfoButton;
    NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
    [notiCenter addObserver:self selector:@selector(changeshowGasInfoButtonTitle:) name:@"kGetGasStationNum" object:nil];
    
}

- (void)changeshowGasInfoButtonTitle:(NSNotification *)noti {
    NSDictionary *userInfo = noti.userInfo;
    NSInteger gasStationNum = [[userInfo objectForKey:@"kGasStationNum"] integerValue];
    [self.showGasInfoButton setTitle:[NSString stringWithFormat:@"一共找到%ld家加油站", gasStationNum] forState:UIControlStateNormal];
}


- (void)showGasInfoButtonClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [UIView animateWithDuration:0.4 animations:^{
            self.mapView.frame = CGRectMake(0, 0, SCREEN_WIDTH, kMapViewHeight);
            sender.frame = CGRectMake(0, kMapViewHeight, SCREEN_WIDTH, kBottomButtonHeight);

        } completion:^(BOOL finished) {

        }];
        
        if (self.gasStationInfoModel.list.count > 0) {
            [UIView animateWithDuration:0.4 animations:^{
                self.tableView.frame = CGRectMake(0, kMapViewHeight + kBottomButtonHeight, SCREEN_WIDTH, SCREEN_HEIGHT - kMapViewHeight - kBottomButtonHeight);
                
            } completion:^(BOOL finished) {
                if (self.selectRow != -1) {
                    NSInteger rowForDevice = 0;
                    if (iPhone4) {
                        rowForDevice = 0;
                    } else if (iPhone5) {
                        rowForDevice = 2;
                    } else if (iPhone6) {
                        rowForDevice = 3;
                    } else if (iPhone6plus) {
                        rowForDevice = 5;
                    }
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.selectRow inSection:0];
                    if (self.selectRow <= rowForDevice) {
                        [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
                    } else {
                        [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionBottom];
                    }
                    
                }

            }];
        }
    } else {
        
        [UIView animateWithDuration:0.4 animations:^{
            self.mapView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - kBottomButtonHeight);
            sender.frame = CGRectMake(0, SCREEN_HEIGHT - kBottomButtonHeight, SCREEN_WIDTH, kBottomButtonHeight);
            self.tableView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - kMapViewHeight);
        } completion:^(BOOL finished) {
            
        }];
        
    }
    
}

- (void)setUpTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - kMapViewHeight) style:UITableViewStylePlain];
    self.tableView = tableView;
    [self.view addSubview:tableView];
    tableView.dataSource = self;
    tableView.delegate = self;
    self.tableView = tableView;
    tableView.tableFooterView = [[UIView alloc] init];
}

#pragma mark - UITableView delegate datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.gasStationInfoModel.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GasStationInfoCell *gasStationInfoCell = [GasStationInfoCell cellWithTableView:tableView];
    gasStationInfoCell.tag = indexPath.row;
    GasStationInfo *gasStationInfo = self.gasStationInfoModel.list[indexPath.row];
    gasStationInfoCell.gasStationInfo = gasStationInfo;
    return gasStationInfoCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
    self.selectRow = indexPath.row;
    for (GasStationAnnotation *anno in self.mapView.annotations) {
        if ([anno isKindOfClass:[MKUserLocation class]]) {
            return;
        }
        if (anno.tag == indexPath.row) {
            [self.mapView setCenterCoordinate:anno.coordinate];
            [self.mapView selectAnnotation:anno animated:YES];
            
            break;
        } else {
            [self.mapView deselectAnnotation:anno animated:YES];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

#pragma mark - 计算/设置 地图的等级
- (int)getZoomLevel:(MKMapView *)mapView {
    
    return 21 - round(log2(self.mapView.region.span.longitudeDelta * MERCATOR_RADIUS * M_PI / (180.0 * self.mapView.bounds.size.width)));
    
}

- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  zoomLevel:(NSUInteger)zoomLevel
                   animated:(BOOL)animated
{
    // clamp large numbers to 28
    zoomLevel = MIN(zoomLevel, 28);
    
    // use the zoom level to compute the region
    MKCoordinateSpan span = [self coordinateSpanWithMapView:self.mapView centerCoordinate:centerCoordinate andZoomLevel:zoomLevel];
    MKCoordinateRegion region = MKCoordinateRegionMake(centerCoordinate, span);
    
    // set the region like normal
    [self.mapView setRegion:region animated:animated];
}

#pragma mark -
#pragma mark Map conversion methods

- (double)longitudeToPixelSpaceX:(double)longitude
{
    return round(MERCATOR_OFFSET + MERCATOR_RADIUS * longitude * M_PI / 180.0);
}

- (double)latitudeToPixelSpaceY:(double)latitude
{
    return round(MERCATOR_OFFSET - MERCATOR_RADIUS * logf((1 + sinf(latitude * M_PI / 180.0)) / (1 - sinf(latitude * M_PI / 180.0))) / 2.0);
}

- (double)pixelSpaceXToLongitude:(double)pixelX
{
    return ((round(pixelX) - MERCATOR_OFFSET) / MERCATOR_RADIUS) * 180.0 / M_PI;
}

- (double)pixelSpaceYToLatitude:(double)pixelY
{
    return (M_PI / 2.0 - 2.0 * atan(exp((round(pixelY) - MERCATOR_OFFSET) / MERCATOR_RADIUS))) * 180.0 / M_PI;
}

#pragma mark -
#pragma mark Helper methods

- (MKCoordinateSpan)coordinateSpanWithMapView:(MKMapView *)mapView
                             centerCoordinate:(CLLocationCoordinate2D)centerCoordinate
                                 andZoomLevel:(NSUInteger)zoomLevel
{
    // convert center coordiate to pixel space
    double centerPixelX = [self longitudeToPixelSpaceX:centerCoordinate.longitude];
    double centerPixelY = [self latitudeToPixelSpaceY:centerCoordinate.latitude];
    
    // determine the scale value from the zoom level
    NSInteger zoomExponent = 20 - zoomLevel;
    double zoomScale = pow(2, zoomExponent);
    
    // scale the map’s size in pixel space
    CGSize mapSizeInPixels = mapView.bounds.size;
    double scaledMapWidth = mapSizeInPixels.width * zoomScale;
    double scaledMapHeight = mapSizeInPixels.height * zoomScale;
    
    // figure out the position of the top-left pixel
    double topLeftPixelX = centerPixelX - (scaledMapWidth / 2);
    double topLeftPixelY = centerPixelY - (scaledMapHeight / 2);
    
    // find delta between left and right longitudes
    CLLocationDegrees minLng = [self pixelSpaceXToLongitude:topLeftPixelX];
    CLLocationDegrees maxLng = [self pixelSpaceXToLongitude:topLeftPixelX + scaledMapWidth];
    CLLocationDegrees longitudeDelta = maxLng - minLng;
    
    // find delta between top and bottom latitudes
    CLLocationDegrees minLat = [self pixelSpaceYToLatitude:topLeftPixelY];
    CLLocationDegrees maxLat = [self pixelSpaceYToLatitude:topLeftPixelY + scaledMapHeight];
    CLLocationDegrees latitudeDelta = -1 * (maxLat - minLat);
    
    // create and return the lat/lng span
    MKCoordinateSpan span = MKCoordinateSpanMake(latitudeDelta, longitudeDelta);
    return span;
}


- (double)distanceBetweenOrderByLat1:(double)lat1 lat2:(double)lat2 lng1:(double)lng1 lng2:(double)lng2{
    
    CLLocation* curLocation = [[CLLocation alloc] initWithLatitude:lat1 longitude:lng1];
    CLLocation* otherLocation = [[CLLocation alloc] initWithLatitude:lat2 longitude:lng2];
    double distance  = [curLocation distanceFromLocation:otherLocation];
    return distance;
}

- (void)dealloc {
    // even though we are using ARC we still need to:
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.locationManger.delegate = nil;
}

@end
