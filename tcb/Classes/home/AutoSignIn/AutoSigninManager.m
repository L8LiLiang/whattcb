//
//  AutoSigninManager.m
//  tcb
//
//  Created by Chuanxun on 15/12/10.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import "AutoSigninManager.h"
#import "L8RegionMonitor.h"
#import "ELAutoSigninDispatch.h"
#import "ConfigTool.h"
#import <NSDate+DateTools.h>
#import "AppDelegate.h"
#import <AFNetworking.h>
#import "JZLocationConverter.h"

#define MaxSigninFailedTimes 3

//#define AutoSignInDebug 1


@interface SignIn : NSObject <NSCoding>

@property (copy, nonatomic) NSString *regionId;
@property (copy, nonatomic) NSString *dispCode;
@property (copy, nonatomic) NSString *nodeCode;
@property (strong, nonatomic) NSNumber *lng;
@property (strong, nonatomic) NSNumber *lat;
@property (copy, nonatomic) NSString *signTime;

@property (assign, nonatomic) NSInteger failedTimes;

@end

@implementation SignIn

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.dispCode = [dict objectForKey:@"dispCode"];
        self.nodeCode = [dict objectForKey:@"nodeCode"];
        self.lng = [dict objectForKey:@"lng"];
        self.lat = [dict objectForKey:@"lat"];
        self.signTime = [dict objectForKey:@"signTime"];
        self.regionId = [dict objectForKey:@"regionId"];
        self.failedTimes = 1;
    }
    
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.dispCode = [aDecoder decodeObjectForKey:@"dispCode"];
        self.nodeCode = [aDecoder decodeObjectForKey:@"nodeCode"];
        self.lng = [aDecoder decodeObjectForKey:@"lng"];
        self.lat = [aDecoder decodeObjectForKey:@"lat"];
        self.signTime = [aDecoder decodeObjectForKey:@"signTime"];
        self.regionId = [aDecoder decodeObjectForKey:@"regionId"];
        self.failedTimes = [aDecoder decodeIntegerForKey:@"failedTimes"];
    }
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.dispCode forKey:@"dispCode"];
    [aCoder encodeObject:self.nodeCode forKey:@"nodeCode"];
    [aCoder encodeObject:self.lng forKey:@"lng"];
    [aCoder encodeObject:self.lat forKey:@"lat"];
    [aCoder encodeObject:self.signTime forKey:@"signTime"];
    [aCoder encodeObject:self.regionId forKey:@"regionId"];
    [aCoder encodeInteger:self.failedTimes forKey:@"failedTimes"];
}

-(BOOL)isEqual:(id)object
{
    if (object == self) {
        return YES;
    }
    
    if (![object isKindOfClass:[self class]]) {
        return NO;
    }
    
    SignIn *signin = (SignIn *)object;
    if ([signin.regionId isEqualToString:self.regionId]) {
        return YES;
    }
    
    return NO;
}

@end



@interface AutoSigninManager () <L8RegionMonitorDelegate,NSURLSessionDelegate>

@property (strong, nonatomic) L8RegionMonitor *regionMonitor;
@property (strong, nonatomic) NSMutableDictionary *userName2RegionIdDict;
@property (strong, nonatomic) dispatch_queue_t queueForProcessRegion;
@property (strong,nonatomic) NSMutableDictionary *userName2FailedSigninDict;
@property (strong, nonatomic) dispatch_queue_t queueForSignin;


@property (strong, nonatomic) NSURLSession *session;
@end



@implementation AutoSigninManager

+(instancetype)sharedManager
{
    static AutoSigninManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!manager) {
            manager = [[AutoSigninManager alloc] init];
        }
    });
    
    return manager;
}

-(instancetype)init
{
    if (self = [super init]) {
        self.regionMonitor = [L8RegionMonitor sharedMonitor];
        self.regionMonitor.delegate = self;
#ifdef AutoSignInDebug
        [self.regionMonitor addRegions:[self regions]];
#endif
        
        [self.regionMonitor startMonitor];
        self.queueForProcessRegion = dispatch_queue_create("AutoSigninManagerQueueForProcessRegion", DISPATCH_QUEUE_CONCURRENT);
        NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithFile:[self filePathForSaveUserName2DispatchRegionId]];
        if (dict) {
            self.userName2RegionIdDict = [NSMutableDictionary dictionaryWithDictionary:dict];
        }else {
            self.userName2RegionIdDict = [NSMutableDictionary new];
        }
        
        self.queueForSignin = dispatch_queue_create("AutoSigninManagerQueueForSignin", DISPATCH_QUEUE_CONCURRENT);
        dict = [NSKeyedUnarchiver unarchiveObjectWithFile:[self filePathForSaveUserName2FailedSignIn]];
        if (dict) {
            self.userName2FailedSigninDict = [NSMutableDictionary dictionaryWithDictionary:dict];
        }else {
            self.userName2FailedSigninDict = [NSMutableDictionary new];
        }

//        SignIn *s1 = [[SignIn alloc] initWithDict:@{@"dispCode":@"dd",
//                                                    @"nodeCode":@"nn",
//                                                    @"lng":@(1),
//                                                    @"lat":@(2),
//                                                    @"signTime":@"ss",
//                                                    @"regionId":@"rre"}];
//        SignIn *s2 = [[SignIn alloc] initWithDict:@{@"dispCode":@"dd",
//                                                    @"nodeCode":@"nn",
//                                                    @"lng":@(1),
//                                                    @"lat":@(2),
//                                                    @"signTime":@"ss",
//                                                    @"regionId":@"rr"}];
//        
//        // s3(内容是0x1234，地址是0x8888)---> SigninObject(地址是0x1234)
//        SignIn *s3 = s1;
//        NSLog(@"%p %p",s1,s3);//%p 打印指针所指向的对象的地址 0x1234
//        // == 不调用isEqual
//        if (s1 == s3) {//==判断所指向对象地址 0x1234
//            NSLog(@"==");
//        }
//        // containObject调用isEqual,removeObject时，不用判断是否containObject，isEqual默认等同于＝＝判断对象地址，可以自定义isEqual
//        if ([s1 isEqual:s3]) {
//            NSLog(@"isEqual");
//        }
//        [self addFailedSignin:s1 forUser:nil];
//        NSMutableArray *failedSigninForUser = [self.userName2FailedSigninDict objectForKey:[ConfigTool accountName]];
//        [failedSigninForUser removeObject:s1];
//        [self addFailedSignin:s2 forUser:nil];
//
//        NSString *str1 = [NSString stringWithFormat:@"liliang"];
//        NSString *str2 = [NSString stringWithFormat:@"liliang"];
//        if (str1 == str2) {
//            NSLog(@"==");
//        }
//        if ([str1 isEqual:str2]) {
//            NSLog(@"isEqual");
//        }
//        if ([str1 isEqualToString:str2]) {
//            NSLog(@"isEqualToString");
//        }
//        NSMutableArray *aaa = [NSMutableArray new];
//        [aaa addObject:str1];
//        [aaa addObject:str2];
//        str1 = @"fuck you";
//        NSString *str3 = [NSString stringWithFormat:@"liliang"];
//        NSLog(@"%@ %p %p %p",aaa,str1,str2,str3);
//        if ([aaa containsObject:str3]) {
//            NSLog(@"con");
//        }
        
    }
    
    return self;
}


#pragma mark SigninFunctions

-(void)refreshAutoSigninDispatcher
{
    if (![ConfigTool isLogin]) {
        return;
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObject:@"GetDispatchForService" forKey:@"cmd"];
    [APIClientTool getDispatchForServiceWithParam:param success:^(NSDictionary *dict) {
        int ret = [[dict objectForKey:@"ret"] intValue];
        if (ret == 0) {
            NSArray *data = [dict objectForKey:@"data"];
            ELAutoSigninDispatchList *dispatchList = [[ELAutoSigninDispatchList alloc] initWithArray:data];
            
            [self monitorRegionForDispatcheList:dispatchList];
            TCBLog(@"refreshAutoSigninDispatcher succeeded");
        }else {
            TCBLog(@"%@",[dict objectForKey:@"msg"]);
        }
    } failed:^{
        TCBLog(@"refreshAutoSigninDispatcher ERROR");
    }];
    
//    NSURL *url = [NSURL URLWithString:@"dd"];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
}

- (void)monitorRegionForDispatcheList:(ELAutoSigninDispatchList *)dispatchList
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        if (![ConfigTool isLogin]) {
            return;
        }
        
        for (ELAutoSigninDispatch *dispatch in dispatchList.dispatchList) {
            for (ELAutoSigninDispatchNode *node in dispatch.NodeList) {
                if (node.ActionType == 0
                    && node.SignTime.length == 0
                    && node.NodeCode.length > 0
                    && ([node.Action isEqualToString:@"0"] || [node.Action isEqualToString:@"1"]) ) {
                    NSString *regionStr = [node.Region stringByReplacingOccurrencesOfString:@";" withString:@","];
                    NSArray *locationNums = [regionStr componentsSeparatedByString:@","];
                    NSMutableArray *points = [NSMutableArray new];
                    for (int i = 0; i < locationNums.count; i ++) {
                        if (i + 1 >= locationNums.count) {
                            break;
                        }
                        double longitude = [locationNums[i] doubleValue];
                        double latitude = [locationNums[++i] doubleValue];
                        CLLocationCoordinate2D bd_09_pt = CLLocationCoordinate2DMake(latitude, longitude);
                        CLLocationCoordinate2D wgs84_pt = [JZLocationConverter bd09ToWgs84:bd_09_pt];
                        CLLocation *location = [[CLLocation alloc] initWithLatitude:wgs84_pt.latitude longitude:wgs84_pt.longitude];
                        [points addObject:location];
                    }
                    
                    if (points.count > 0) {
                        double latitude = 0;
                        double longitude = 0;
                        for (CLLocation *location in points) {
                            latitude += location.coordinate.latitude;
                            longitude += location.coordinate.longitude;
                        }
                        
                        latitude = latitude / points.count;
                        longitude = longitude / points.count;
                        
#ifdef AutoSignInDebug
                        CLCircularRegion *rrr = [self regions][arc4random() % [[self regions] count]];
                        latitude = rrr.center.latitude;
                        longitude = rrr.center.longitude;
#endif
                        CLLocation *center = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
                        NSString *regionId = [NSString stringWithFormat:@"%@__%@",dispatch.DispCode,node.NodeCode];
                        double radius = 0;
                        if (points.count == 1) {
                            radius = 400;
                            
                        }else {
                            for (CLLocation *location in points) {
                                double distance = [center distanceFromLocation:location];
                                radius = MAX(distance, radius);
                            }
                        }
#ifdef AutoSignInDebug
                        radius = 400;
#endif
                        CLCircularRegion *region = [[CLCircularRegion alloc] initWithCenter:center.coordinate radius:radius identifier:regionId];
                        if ([node.Action isEqualToString:@"0"]) {
                            region.notifyOnEntry = YES;
                            region.notifyOnExit = NO;
                        }else {
                            region.notifyOnEntry = NO;
                            region.notifyOnExit = YES;
                        }
                        [self addRegionId:regionId forUser:nil];
                        [self.regionMonitor addRegion:region];
                    }
                }
            }
        }
        
        [self save];
        
        [self.regionMonitor reloadRegionsAndRestart];
    });
    
}

- (void)tryToProcessFailedSignin
{
    if (![ConfigTool isLogin]) {
        return;
    }
    NSAssert([ConfigTool accountName].length > 0, @"user name is null");
    
    dispatch_async(self.queueForSignin, ^{
        NSArray *allFailedSignin = [self.userName2FailedSigninDict objectForKey:[ConfigTool accountName]];
        for (SignIn *signin in allFailedSignin) {
            NSDictionary *signInDict = @{@"dispCode":signin.dispCode,
                                         @"nodeCode":signin.nodeCode,
                                         @"lng":signin.lng,
                                         @"lat":signin.lat,
                                         @"signTime":signin.signTime};
            NSDictionary *dict = @{@"cmd":@"SignNode",
                                   @"data":signInDict};
            
            NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:dict];
            
            [APIClientTool signNodeWithParam:param success:^(NSDictionary *dict) {
                int ret = [[dict objectForKey:@"ret"] intValue];
                if (ret == 0) {
                    TCBLog(@"try to process failed signin succeeded");
                    [self signinFinishedForRegion:signin.regionId];
                }else {
                    TCBLog(@"try to process failed signin failed");
                    signin.failedTimes++;
                    if (signin.failedTimes >= MaxSigninFailedTimes) {
                        TCBLog(@"signin expire maxFailedTimes");
                        [self signinFinishedForRegion:signin.regionId];
                    }
                }
                
            } failed:^{
                signin.failedTimes++;
                if (signin.failedTimes >= MaxSigninFailedTimes) {
                    TCBLog(@"signin expire maxFailedTimes");
                    [self signinFinishedForRegion:signin.regionId];
                }
            }];
            
        }
    });
}

- (void)signinForRegion:(NSString *)regionId
{
//    if (![ConfigTool isLogin]) {
//        return;
//    }
    
    NSArray *info = [regionId componentsSeparatedByString:@"__"];
    NSAssert(info.count == 2, @"RegionId Format Wrong.");
    
    CLLocation *location = self.regionMonitor.locationManager.location;
    CLLocationCoordinate2D bd_09_pt = [JZLocationConverter wgs84ToBd09:location.coordinate];
    NSMutableDictionary *signInDict = [NSMutableDictionary dictionaryWithDictionary:@{@"dispCode":info[0],
                                                                                      @"nodeCode":info[1],
                                                                                      @"lng":@(bd_09_pt.longitude),
                                                                                      @"lat":@(bd_09_pt.latitude),
                                                                                      @"signTime":[[NSDate date] formattedDateWithFormat:@"yyyy-MM-dd HH:mm:ss"]}];
    NSDictionary *dict = @{@"cmd":@"SignNode",
                           @"data":signInDict.copy};
    [signInDict setObject:regionId forKey:@"regionId"];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:dict];
    
    [APIClientTool signNodeWithParam:param success:^(NSDictionary *dict) {
        int ret = [[dict valueForKey:@"ret"] intValue];
#ifdef AutoSignInDebug
        [self makeNotification:[NSString stringWithFormat:@"sign rtn = %d",ret] fireDate:nil];
#endif
        if (ret == 0) {
            [self signinFinishedForRegion:regionId];
        }else {
            TCBLog(@"signInError %@",[dict valueForKey:@"msg"]);
            SignIn *signin = [[SignIn alloc] initWithDict:signInDict];
            [self addFailedSignin:signin forUser:nil];
        }
    } failed:^{
        TCBLog(@"network error");
        SignIn *signin = [[SignIn alloc] initWithDict:signInDict];
        [self addFailedSignin:signin forUser:nil];
    }];
}

- (void)signinFinishedForRegion:(NSString *)regionId
{
    if (regionId.length <= 0) {
        return;
    }
    TCBLog(@"signinFinishedFroRegion %@",regionId);
    [self removeRegionId:regionId forUser:nil];
    [self removeSigninForRegionId:regionId forUser:nil];
    [self.regionMonitor removeRegionUseIdentifier:regionId];
    [self.regionMonitor reloadRegionsAndRestart];
}

- (void)autoSignIn
{
    if ([ConfigTool isLogin]) {
        NSAssert([ConfigTool accountName].length > 0, @"user name null");
        
        NSOperationQueue *serialQueue = [[NSOperationQueue alloc] init];
        serialQueue.maxConcurrentOperationCount = 1;
        
        __weak typeof(self)  weakSelf = self;
        [serialQueue addOperationWithBlock:^{
            [weakSelf tryToProcessFailedSignin];
        }];
        
        [serialQueue addOperationWithBlock:^{
            [weakSelf refreshAutoSigninDispatcher];
        }];
    }
}

#pragma mark DataProcess

- (void)addRegionId:(NSString *)regionId forUser:(NSString *)userName
{
    dispatch_barrier_async(self.queueForProcessRegion, ^{
        NSString *user = userName;
        if (user == nil) {
            user = [ConfigTool accountName];
        }
        NSMutableArray *regionIds = [self.userName2RegionIdDict objectForKey:user];
        if (regionIds == nil) {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            [array addObject:regionId];
            [self.userName2RegionIdDict setObject:array forKey:user];
        }else {
            if ([regionIds containsObject:regionId]) {
                [regionIds removeObject:regionId];
            }
            [regionIds addObject:regionId];
        }
        
        [self save];
    });

}

- (void)removeRegionId:(NSString *)regionId forUser:(NSString *)userName
{
    dispatch_barrier_async(self.queueForProcessRegion, ^{
        NSString *user = userName;
        if (user == nil) {
            user = [ConfigTool accountName];
        }
        NSMutableArray *regionIds = [self.userName2RegionIdDict objectForKey:user];
        if (regionIds != nil) {
            if ([regionIds containsObject:regionId]) {
                [regionIds removeObject:regionId];
            }
        }
        
        [self save];
    });
}

- (void)addFailedSignin:(SignIn *)signin forUser:(NSString *)userName
{
    dispatch_barrier_async(self.queueForSignin, ^{
        NSString *user = userName;
        if (user == nil) {
            user = [ConfigTool accountName];
        }
        NSMutableArray *failedSigninForUser = [self.userName2FailedSigninDict objectForKey:user];
        if (failedSigninForUser == nil) {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            [array addObject:signin];
            [self.userName2FailedSigninDict setObject:array forKey:user];
        }else {
            if ([failedSigninForUser containsObject:signin])
            {
                [failedSigninForUser removeObject:signin];
            }
            [failedSigninForUser addObject:signin];
        }
        
        [self save];
    });
}

- (void)removeSignin:(SignIn *)signin forUser:(NSString *)userName
{
    dispatch_barrier_async(self.queueForSignin, ^{
        NSString *user = userName;
        if (user == nil) {
            user = [ConfigTool accountName];
        }
        NSMutableArray *failedSigninForUser = [self.userName2FailedSigninDict objectForKey:user];
        if (failedSigninForUser != nil) {
            if ([failedSigninForUser containsObject:signin]) {
                [failedSigninForUser removeObject:signin];
            }
        }
        
        [self save];
    });
}

- (void)removeSigninForRegionId:(NSString *)regionId forUser:(NSString *)userName
{
    dispatch_barrier_async(self.queueForSignin, ^{
        NSString *user = userName;
        if (user == nil) {
            user = [ConfigTool accountName];
        }
        NSMutableArray *failedSigninForUser = [self.userName2FailedSigninDict objectForKey:user];
        if (failedSigninForUser != nil) {
            for (SignIn *signin in failedSigninForUser) {
                if ([signin.regionId isEqualToString:regionId]) {
                    [failedSigninForUser removeObject:signin];
                    return;
                }
            }
        }
        
        [self save];
    });
}

- (NSString *)filePathForSaveUserName2FailedSignIn
{
#ifdef AutoSignInDebug
    return @"/Users/chuanxun/Desktop/signin";
#endif
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    
    return [path stringByAppendingPathComponent:@"AutoSignin_UserName2Failed"];
}

- (NSString *)filePathForSaveUserName2DispatchRegionId
{
#ifdef AutoSignInDebug
    return @"/Users/chuanxun/Desktop/regionid";
#endif
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    
    return [path stringByAppendingPathComponent:@"AutoSignin_UserName2Dispatch"];
}

- (void)save
{
    dispatch_barrier_async(self.queueForProcessRegion, ^{
        NSString *filePath = [self filePathForSaveUserName2DispatchRegionId];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:filePath]) {
            [fileManager createFileAtPath:filePath contents:nil attributes:NULL];
        }
        [NSKeyedArchiver archiveRootObject:self.userName2RegionIdDict toFile:filePath];
    });
    
    dispatch_barrier_async(self.queueForSignin, ^{
        NSString *filePath = [self filePathForSaveUserName2FailedSignIn];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:filePath]) {
            BOOL success = [fileManager createFileAtPath:filePath contents:nil attributes:NULL];
            if (!success) {
                TCBLog(@"create file failed");
            }
        }
        BOOL success = [NSKeyedArchiver archiveRootObject:self.userName2FailedSigninDict toFile:filePath];
        if (!success) {
            TCBLog(@"write failed");
        }
    });
}

- (BOOL)regionIdBelongCurrentUser:(NSString *)regionId
{
    __block BOOL rtn;
    dispatch_sync(self.queueForProcessRegion, ^{
       
        NSMutableArray *regionIds = [self.userName2RegionIdDict objectForKey:[ConfigTool accountName]];
        if ([regionIds containsObject:regionId]) {
            rtn = YES;
        }else {
            rtn = NO;
        }
    });
    
    return rtn;
}


/*
static NSString *DownloadURLString = @"http://sqdd.myapp.com/myapp/qqteam/AndroidQQ/mobileqq_android.apk";

//- (void)startBackgroundDownload:(id)sender {
//    NSURL *downloadURL = [NSURL URLWithString:DownloadURLString];
//    NSURLRequest *request = [NSURLRequest requestWithURL:downloadURL];
////    NSURLSessionTask *task = [self.backgroundSession downloadTaskWithRequest:request];
//    
//    [task resume];
//}

- (void)startDefaultDownload:(id)sender
{
//    NSURL *downloadURL = [NSURL URLWithString:DownloadURLString];
//    NSURLRequest *request = [NSURLRequest requestWithURL:downloadURL];
//    NSURLSessionTask *task = [self.session downloadTaskWithRequest:request];
//    
//    [task resume];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[manager downloadTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:DownloadURLString]] progress:nil destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [NSURL fileURLWithPath:@"/Users/chuanxun/Desktop"];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        [self makeNotification:[NSString stringWithFormat:@"download finished %@",error] fireDate:nil];
        TCBLog(@"download finished %@",error);
    }] resume];
}

-(NSURLSession *)session
{
    if (!_session) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    }
    return _session;
}
*/
#pragma mark - L8RegionMonitorDelegate

-(void)regionMonitor:(L8RegionMonitor *)regionMonitor enterRegion:(CLRegion *)region
{
    NSArray *info = [region.identifier componentsSeparatedByString:@"__"];
    if (info.count == 2) {
        if ([self regionIdBelongCurrentUser:region.identifier]) {
            [self signinForRegion:region.identifier];
        }
    }
#ifdef AutoSignInDebug
    [self makeNotification:[NSString stringWithFormat:@"enter %@",region.identifier] fireDate:nil];
    TCBLog(@"enter %@",region.identifier);
#endif
//    [self startDefaultDownload:nil];
}

-(void)regionMonitor:(L8RegionMonitor *)regionMonitor exitRegion:(CLRegion *)region
{
    NSArray *info = [region.identifier componentsSeparatedByString:@"__"];
    if (info.count == 2) {
        if ([self regionIdBelongCurrentUser:region.identifier]) {
            [self signinForRegion:region.identifier];
        }
    }
#ifdef AutoSignInDebug
    [self makeNotification:[NSString stringWithFormat:@"exit %@",region.identifier] fireDate:nil];
    TCBLog(@"enter %@",region.identifier);
#endif
}

-(void)regionMonitor:(L8RegionMonitor *)regionMonitor failedWithError:(NSString *)errorMsg
{
#ifdef AutoSignInDebug
    [self makeNotification:errorMsg fireDate:nil];
    TCBLog(@"failedWithError %@",errorMsg);
#endif
}

-(void)regionMonitor:(L8RegionMonitor *)regionMonitor monitorFailedForRegion:(CLRegion *)region withError:(NSString *)errorMsg
{
#ifdef AutoSignInDebug
    [self makeNotification:[NSString stringWithFormat:@"monitorFailedForRegion %@",region.identifier] fireDate:nil];
    TCBLog(@"monitorFailedForRegion %@,%@",region.identifier,errorMsg);
#endif
    [self signinFinishedForRegion:region.identifier];
}

#pragma mark - NSURLSessionDelegate

-(void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(NSError *)error
{
#ifdef AutoSignInDebug
    NSString *strNot = [NSString stringWithFormat:@"%@,session invalid",[NSDate date]];
    [self makeNotification:strNot fireDate:nil];
    TCBLog(@"%@",strNot);
#endif
}

-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
#ifdef AutoSignInDebug
    if (error) {
        NSString *strNot = [NSString stringWithFormat:@"%@,%@",[NSDate date],error];
        TCBLog(@"%@",strNot);
        [self makeNotification:strNot fireDate:nil];
    }else {
        NSString *strNot = [NSString stringWithFormat:@"%@,session complete without error",[NSDate date]];
        TCBLog(@"%@",strNot);
        [self makeNotification:strNot fireDate:nil];
    }
#endif
}


-(void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session
{
#ifdef AutoSignInDebug
    NSString *strNot = [NSString stringWithFormat:@"%@,URLSessionDidFinishEventsForBackgroundURLSession",[NSDate date]];
    TCBLog(@"%@",strNot);
    [self makeNotification:strNot fireDate:nil];
#endif
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appDelegate.backgroundSessionCompletionHandler) {
        void (^completionHandler)() = appDelegate.backgroundSessionCompletionHandler;
        appDelegate.backgroundSessionCompletionHandler = nil;
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            completionHandler();
        }];
    }
}

#pragma mark - For Test

//-(NSMutableDictionary *)userName2RegionIdDict
//{
//    if (!_userName2RegionIdDict) {
//        _userName2RegionIdDict = [NSMutableDictionary new];
//    }
//    return _userName2RegionIdDict;
//}

-(void)dealloc
{
    [self save];
}

-(void)makeNotification:(NSString *)content fireDate:(NSDate *)date
{
    //1.创建本地通知
    UILocalNotification *local = [[UILocalNotification alloc]init];
    
    // 5秒之后触发一个本地通知
    if (date) {
        
        local.fireDate = date;
    }
    
    local.alertBody = content;
    
    local.soundName = @"UILocalNotificationDefaultSoundName";
    
    local.alertLaunchImage = nil;
    
    //local.applicationIconBadgeNumber = 10;
    
    local.hasAction = YES;
    
    local.alertAction = @"open l8 app";
    
    local.userInfo = @{@"name" : @"李亮" , @"QQ":@"222",@"info":@"信息!"};
    //2.定制通知
    //[[UIApplication sharedApplication]scheduleLocalNotification:local];
    
    //取消所有
    //[[UIApplication sharedApplication]cancelAllLocalNotifications];
    //立即推送通知
    if (date) {
        [[UIApplication sharedApplication]scheduleLocalNotification:local];
    }else {
        [[UIApplication sharedApplication]presentLocalNotificationNow:local];
    }
}

- (NSArray *)regions
{
    CLLocationCoordinate2D center1 = {37.45855399,-122.28964389};
    CLCircularRegion *region1 = [[CLCircularRegion alloc] initWithCenter:center1 radius:400 identifier:@"testRegion1"];
    
    CLLocationCoordinate2D center2 = {37.59064415,-122.41377627};
    CLCircularRegion *region2 = [[CLCircularRegion alloc] initWithCenter:center2 radius:400 identifier:@"testRegion2"];
    
    CLLocationCoordinate2D center3 = {37.59774048,-122.42107188};
    CLCircularRegion *region3 = [[CLCircularRegion alloc] initWithCenter:center3 radius:400 identifier:@"testRegion3"];
    
    CLLocationCoordinate2D center4 = {37.60490126,-122.42782443};
    CLCircularRegion *region4 = [[CLCircularRegion alloc] initWithCenter:center4 radius:400 identifier:@"testRegion4"];
    
    CLLocationCoordinate2D center5 = {37.61359414,-122.42477627};
    CLCircularRegion *region5 = [[CLCircularRegion alloc] initWithCenter:center5 radius:400 identifier:@"testRegion5"];
    
    CLLocationCoordinate2D center6 = {37.62251265,-122.42715597};
    CLCircularRegion *region6 = [[CLCircularRegion alloc] initWithCenter:center6 radius:400 identifier:@"testRegion6"];
    
    CLLocationCoordinate2D center7 = {37.75855399,-122.28964389};
    CLCircularRegion *region7 = [[CLCircularRegion alloc] initWithCenter:center7 radius:400 identifier:@"testRegion7"];
    
    CLLocationCoordinate2D center8 = {37.33525552,-122.03254838};
    CLCircularRegion *region8 = [[CLCircularRegion alloc] initWithCenter:center8 radius:400 identifier:@"testRegion8"];
    
    CLLocationCoordinate2D center9 = {37.38505698,-122.15241395};
    CLCircularRegion *region9 = [[CLCircularRegion alloc] initWithCenter:center9 radius:400 identifier:@"testRegion9"];
    
    CLLocationCoordinate2D center10 = {37.38921159,-122.16173186};
    CLCircularRegion *region10 = [[CLCircularRegion alloc] initWithCenter:center10 radius:400 identifier:@"testRegion10"];
    
    CLLocationCoordinate2D center11 = {37.39236730,-122.17192878};
    CLCircularRegion *region11 = [[CLCircularRegion alloc] initWithCenter:center11 radius:400 identifier:@"testRegion11"];
    
    CLLocationCoordinate2D center12 = {37.39796347,-122.18018889};
    CLCircularRegion *region12 = [[CLCircularRegion alloc] initWithCenter:center12 radius:400 identifier:@"testRegion12"];
    
    CLLocationCoordinate2D center13 = {37.40549529,-122.18774837};
    CLCircularRegion *region13 = [[CLCircularRegion alloc] initWithCenter:center13 radius:400 identifier:@"testRegion13"];
    
    CLLocationCoordinate2D center14 = {37.41002813,-122.19717013};
    CLCircularRegion *region14 = [[CLCircularRegion alloc] initWithCenter:center14 radius:400 identifier:@"testRegion14"];
    
    CLLocationCoordinate2D center15 = {39.41002813,-122.19717013};
    CLCircularRegion *region15 = [[CLCircularRegion alloc] initWithCenter:center15 radius:400 identifier:@"testRegion15"];
    
    CLLocationCoordinate2D center16 = {39.91002813,-122.19717013};
    CLCircularRegion *region16 = [[CLCircularRegion alloc] initWithCenter:center16 radius:400 identifier:@"testRegion16"];
    
    CLLocationCoordinate2D center17 = {38.41002813,-122.19717013};
    CLCircularRegion *region17 = [[CLCircularRegion alloc] initWithCenter:center17 radius:400 identifier:@"testRegion17"];
    
    CLLocationCoordinate2D center18 = {37.34077165,-122.08949679};
    CLCircularRegion *region18 = [[CLCircularRegion alloc] initWithCenter:center18 radius:400 identifier:@"testRegion18"];
    
    CLLocationCoordinate2D center19 = {37.33531428,-122.08054952};
    CLCircularRegion *region19 = [[CLCircularRegion alloc] initWithCenter:center19 radius:400 identifier:@"testRegion19"];
    
    CLLocationCoordinate2D center21 = {37.33424182,-122.07013275};
    CLCircularRegion *region21 = [[CLCircularRegion alloc] initWithCenter:center21 radius:400 identifier:@"testRegion21"];
    
    CLLocationCoordinate2D center20 = {37.33233606,-122.05909629};
    CLCircularRegion *region20 = [[CLCircularRegion alloc] initWithCenter:center20 radius:400 identifier:@"testRegion20"];
    
    CLLocationCoordinate2D center22 = {37.65476181,-122.45716620};
    CLCircularRegion *region22 = [[CLCircularRegion alloc] initWithCenter:center22 radius:400 identifier:@"testRegion22"];
    
    return @[region1,region2,region3,region4,region5,region6,region7,region8,region9,region10,region11,region12,region13,region14,region15,region16,region17,region18,region19,region20,region21,region22];
    
}


@end
