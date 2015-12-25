//
//  HttpTool.h
//  tcb
//
//  Created by Jax on 15/11/9.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AFNetworking.h>

@class AFHTTPSessionManager;

typedef void (^successBlock)(id responseObject);
typedef void (^failureBlock)(NSError *error);

@interface HttpTool : NSObject

/**
 *  处理请求管理者对象
 */
+ (AFHTTPSessionManager *)sessionManager;

/**
 *  get请求
 *
 *  @param url     请求地址
 *  @param params  求情参数
 *  @param success 请求成功回调
 *  @param failure 请求失败回调
 *  @return        返回请求任务（NSURLSessionDataTask）
 */
+ (NSURLSessionDataTask *)getWithUrl:(NSString *)url
                              params:(NSDictionary *)params
                             success:(successBlock)success
                             failure:(failureBlock)failure;

/**
 *  post请求
 *
 *  @param url     请求地址
 *  @param params  求情参数
 *  @param success 请求成功回调
 *  @param failure 请求失败回调
 *  @return        返回请求任务（NSURLSessionDataTask）
 */
+ (NSURLSessionDataTask *)postWithUrl:(NSString *)url
                               params:(NSDictionary *)params
                              success:(successBlock)success
                              failure:(failureBlock)failure;
/**
 *  上传头像（单张图片）
 *
 *  @param url     请求地址
 *  @param params  请求参数
 *  @param image   图片数据
 *  @param success 请求成功回调
 *  @param failure 请求失败回调
 *
 *  @return 返回请求任务（NSURLSessionDataTask）
 */
+ (NSURLSessionDataTask *)postWithUrl:(NSString *)url
                               params:(NSDictionary *)params
                            imageDate:(NSData *)imageDate
                              success:(successBlock)success
                              failure:(failureBlock)failure;





//- (AFHTTPRequestOperationManager *)baseHttpRequest;
//
///**
// *  get请求
// *
// *  @param url     请求地址
// *  @param params  求情参数
// *  @param success 请求成功回调
// *  @param failure 请求失败回调
// *  @return        返回请求队列（AFHTTPRequestOperation）
// */
//+ (id)getWithUrl:(NSString *)url
//          params:(NSDictionary *)params
//         success:(successBlock)success
//         failure:(failureBlock)failure;
//
///**
// *  post请求
// *
// *  @param url     请求地址
// *  @param params  求情参数
// *  @param success 请求成功回调
// *  @param failure 请求失败回调
// *  @return        返回请求队列（AFHTTPRequestOperation）
// */
//+ (id)postWithUrl:(NSString *)url
//           params:(NSDictionary *)params
//          success:(successBlock)success
//          failure:(failureBlock)failure;


@end
