//
//  HttpTool.m
//  tcb
//
//  Created by Jax on 15/11/9.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import "HttpTool.h"
#import "AFNetworking.h"
#import "NetworkStatusTool.h"
#import "ServiceURLConstant.h"
#import "NetWorkStatusTool.h"

static NSString *kTimeoutInterval = @"timeoutInterval";

@implementation HttpTool

+ (AFHTTPSessionManager *)sessionManager
{
    
    static AFHTTPSessionManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!manager) {
            NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
            configuration.HTTPAdditionalHeaders = @{@"Content-Type":@"application/json"};
            manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:BaseAPI] sessionConfiguration:configuration];
            
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/html", nil];
            
            // 请求序列化
            //    session.requestSerializer = ;
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain" ,nil];
            //    NSString *version  = [UIDevice currentDevice].systemVersion;
            //    NSString *idfv = [[UIDevice currentDevice].identifierForVendor UUIDString];
            //    [[NSUserDefaults standardUserDefaults] setObject:idfv forKey:@"identifierForVendor"];
            
            // 设置请求超时时长，超过就会执行失败的block
            manager.requestSerializer.timeoutInterval = 30.f;
            [manager.requestSerializer willChangeValueForKey:kTimeoutInterval];
            [manager.requestSerializer didChangeValueForKey:kTimeoutInterval];
            
            // 设置安全策略
            manager.securityPolicy.allowInvalidCertificates = YES;
            
            // 检测当前网络状况
            [NetWorkStatusTool networkStatus];
        }
    });

    // 设置请求头
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"Authorization"];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];

    return manager;
}

+ (NSURLSessionDataTask *)getWithUrl:(NSString *)url
                              params:(NSDictionary *)params
                             success:(successBlock)success
                             failure:(failureBlock)failure
{
    // 发送GET请求
    return [[self sessionManager] GET:url parameters:params success:^(NSURLSessionTask *task, id responseObject) {
        // 请求成功
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionTask *task, NSError *error) {
        // 解决请求超时和无网络弹出提示一起出来
        if ([NetWorkStatusTool networkStatus]) {
            
        } else {
            [SVProgressHUD dismiss];
        }
        
        if (failure) {
            failure(error);
        }
    }];
}

+ (NSURLSessionDataTask *)postWithUrl:(NSString *)url
                               params:(NSDictionary *)params
                              success:(successBlock)success
                              failure:(failureBlock)failure
{
    return [[self sessionManager] POST:url parameters:params success:^(NSURLSessionTask *task, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionTask *task, NSError *error) {
        NSLog(@"%@",error);
        if ([NetWorkStatusTool networkStatus]) {
           
        } else {
            [SVProgressHUD dismiss];
        }
        
        if (failure) {
            failure(error);
        }
    }];
}

+ (NSURLSessionDataTask *)postWithUrl:(NSString *)url
                               params:(NSDictionary *)params
                                imageDate:(NSData *)imageDate
                              success:(successBlock)success
                              failure:(failureBlock)failure
{
    return [[self sessionManager] POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (imageDate) {
            [formData appendPartWithFileData:imageDate name:@"" fileName:@"" mimeType:@"image/jpeg"];
        }
        
    } success:^(NSURLSessionTask *task, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionTask *task, NSError *error) {
        if ([NetWorkStatusTool networkStatus]) {
         
        } else {
            [SVProgressHUD dismiss];
        }
        
        if (failure) {
            failure(error);
            NSLog(@"%@", error);
        }
    }];
}


//- (AFHTTPRequestOperationManager *)baseHttpRequest{
//    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    
//    //  设置超时
//    [manager.requestSerializer setTimeoutInterval:30.0f];
//    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
//    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
//    
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"text/html", @"application/json", nil];
//    
//    return manager;
//}
//
//+ (id)getWithUrl:(NSString *)url params:(NSDictionary *)params success:(successBlock)success failure:(failureBlock)failure
//{
//    AFHTTPRequestOperationManager *manager = [[self alloc] baseHttpRequest];
//    
//    // GET请求
//    return [manager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        // 请求成功
//        if (success) {
//            success(responseObject);
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        //  请求失败
//        if (failure) {
//            failure(error);
//        }
//    }];
//}

//+ (id)postWithUrl:(NSString *)url params:(NSDictionary *)params success:(successBlock)success failure:(failureBlock)failure
//{
//    AFHTTPRequestOperationManager *manager = [[self alloc] baseHttpRequest];
//    
//    return [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        if (success) {
//            success(responseObject);
//            NSLog(@"%@", responseObject);
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        if (failure) {
//            failure(error);
//            NSLog(@"%@", error);
//        }
//    }];
//}


@end
