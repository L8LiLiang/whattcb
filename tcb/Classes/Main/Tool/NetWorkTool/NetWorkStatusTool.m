//
//  NetWorkStatusTool.m
//  tcb
//
//  Created by Jax on 15/11/9.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import "NetWorkStatusTool.h"
#import "AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "AFNetworkReachabilityManager.h"



@implementation NetWorkStatusTool

+ (BOOL)networkStatus {
    // 获得网络监控的管理者
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    // 设置网络状态改变后的处理
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态改变了, 就会调用这个block
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                //                [[HRPopView popView] showStatus:@"未知网络"];
                break;
            case AFNetworkReachabilityStatusNotReachable:
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    // 0.5秒之后执行操作
                    //                    [[HRPopView popView] showStatus:@"亲，似乎您已断开与互联网的连接"];
                });
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                break;
        }
    }];
    
    // 开始网络监控
    [manager startMonitoring];
    
    // 显示网络指示器加载状态
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    // 返回当前网络是否可用
    return manager.reachable;
}


@end
