//
//  APIClientTool.h
//  tcb
//
//  Created by Jax on 15/11/9.
//  Copyright © 2015年 Jax. All rights reserved.
//  所有客户端对外接口实现

#import <Foundation/Foundation.h>


#define CMD_GET_PROGRESS_TASK_LIST @"GetProgressTaskList"

typedef void (^ApiClientSuccessBlock)(NSDictionary *dict);
typedef void (^ApiClientFailedBlock) (void);

@interface APIClientTool : NSObject

#pragma mark - 1.用户登录接口
+ (id)LoginWithParam:(NSMutableDictionary *)params
                success:(ApiClientSuccessBlock)successBlock
              failed:(ApiClientFailedBlock)failedBlock;

#pragma mark - 2.用户重置密码发送验证码接口
+ (id)SendCaptchaWithParam:(NSMutableDictionary *)params
             success:(ApiClientSuccessBlock)successBlock
              failed:(ApiClientFailedBlock)failedBlock;

#pragma mark - 3.用户重置密码接口
+ (id)ResetPwdWithParam:(NSMutableDictionary *)params
                   success:(ApiClientSuccessBlock)successBlock
                    failed:(ApiClientFailedBlock)failedBlock;

#pragma mark - 4.接单多票接口
+ (id)WantMoreListWithParam:(NSMutableDictionary *)params
                success:(ApiClientSuccessBlock)successBlock
                 failed:(ApiClientFailedBlock)failedBlock;

#pragma mark - 5.接单单票接口
+ (id)WantSingleListWithParam:(NSMutableDictionary *)params
                    success:(ApiClientSuccessBlock)successBlock
                     failed:(ApiClientFailedBlock)failedBlock;

#pragma mark - 6.抢单列表接口
+ (id)GrabListWithParam:(NSMutableDictionary *)params
                      success:(ApiClientSuccessBlock)successBlock
                       failed:(ApiClientFailedBlock)failedBlock;

#pragma mark - 7.单个抢单详情接口
+ (id)GrabListDetailWithParam:(NSMutableDictionary *)params
                      success:(ApiClientSuccessBlock)successBlock
                       failed:(ApiClientFailedBlock)failedBlock;

#pragma mark - 8.抢单接口
+ (id)RobListWithParam:(NSMutableDictionary *)params
                      success:(ApiClientSuccessBlock)successBlock
                       failed:(ApiClientFailedBlock)failedBlock;
#pragma mark - 9.拒绝接单调派接口
+ (id)RefuseOrderDispatchWithParam:(NSMutableDictionary *)params
                           success:(ApiClientSuccessBlock)successBlock
                            failed:(ApiClientFailedBlock)failedBlock;
#pragma mark - 10.接受接单调派接口
+ (id)AcceptOrderDispatchWithParam:(NSMutableDictionary *)params
                           success:(ApiClientSuccessBlock)successBlock
                            failed:(ApiClientFailedBlock)failedBlock;

#pragma mark - 11.进行中任务列表接口
+ (id)myOrderListWithParam:(NSMutableDictionary *)params
                           success:(ApiClientSuccessBlock)successBlock
                            failed:(ApiClientFailedBlock)failedBlock;

#pragma mark - 12.费用确认列表接口
+ (id)GetFeeConfirmListWithParam:(NSMutableDictionary *)params
                   success:(ApiClientSuccessBlock)successBlock
                    failed:(ApiClientFailedBlock)failedBlock;

#pragma mark - 13.派车单详情接口
+ (id)dispatchOrderDetailWithParam:(NSMutableDictionary *)params
                         success:(ApiClientSuccessBlock)successBlock
                          failed:(ApiClientFailedBlock)failedBlock;
#pragma mark - 14.费用确认接口
+ (id)ConductAboutDispatchWithParam:(NSMutableDictionary *)params
                            success:(ApiClientSuccessBlock)successBlock
                             failed:(ApiClientFailedBlock)failedBlock;

#pragma mark - 15.记账账户详情接口
+ (id)GetAcountDetailWithParam:(NSMutableDictionary *)params
                            success:(ApiClientSuccessBlock)successBlock
                             failed:(ApiClientFailedBlock)failedBlock;

#pragma mark - 16.上传图片接口
+ (NSURLSessionDataTask *)uploadImageWithParam:(NSMutableDictionary *)params
                                       success:(ApiClientSuccessBlock)successBlock
                                        failed:(ApiClientFailedBlock)failedBlock;

#pragma mark - 17.上传图片路径接口
+ (NSURLSessionDataTask *)saveDispatchOrderImageWithParam:(NSMutableDictionary *)params
                                                  success:(ApiClientSuccessBlock)successBlock
                                                   failed:(ApiClientFailedBlock)failedBlock;

#pragma mark - 18.费用保存接口
+ (NSURLSessionDataTask *)saveFeeWithParam:(NSMutableDictionary *)params
                                       success:(ApiClientSuccessBlock)successBlock
                                        failed:(ApiClientFailedBlock)failedBlock;

#pragma mark - 18.我的资料接口
+ (NSURLSessionDataTask *)getUserProfileWithParam:(NSMutableDictionary *)params
                                   success:(ApiClientSuccessBlock)successBlock
                                    failed:(ApiClientFailedBlock)failedBlock;

#pragma mark - 19.删除图片接口
+ (NSURLSessionDataTask *)deleteDispatchOrderImageWithParam:(NSMutableDictionary *)params success:(ApiClientSuccessBlock)successBlock
                                                   failed:(ApiClientFailedBlock)failedBlock;

#pragma mark - 20.箱号封号录入
+ (NSURLSessionDataTask *)saveContainerNoAndSealNoWithParam:(NSMutableDictionary *)params
                                                    success:(ApiClientSuccessBlock)successBlock
                                                     failed:(ApiClientFailedBlock)failedBlock;

#pragma mark - 21.签到
+ (NSURLSessionDataTask *)signNodeWithParam:(NSMutableDictionary *)params
                                                    success:(ApiClientSuccessBlock)successBlock
                                                     failed:(ApiClientFailedBlock)failedBlock;

#pragma mark - 22.获取对账单列表
+ (NSURLSessionDataTask *)getReconciliationListWithParam:(NSMutableDictionary *)params
                                    success:(ApiClientSuccessBlock)successBlock
                                     failed:(ApiClientFailedBlock)failedBlock;
#pragma mark - 23.获取对账单详细列表
+ (NSURLSessionDataTask *)getReconciliationDetailListWithParam:(NSMutableDictionary *)params
                                                 success:(ApiClientSuccessBlock)successBlock
                                                  failed:(ApiClientFailedBlock)failedBlock;
#pragma mark - 24.获取银行列表接口
+ (NSURLSessionDataTask *)GetBankNameListWithParam:(NSMutableDictionary *)params
                                                       success:(ApiClientSuccessBlock)successBlock
                                                        failed:(ApiClientFailedBlock)failedBlock;

#pragma mark - 25.银行验证码接口
+ (NSURLSessionDataTask *)SendBankVerifyCodeWithParam:(NSMutableDictionary *)params
                                           success:(ApiClientSuccessBlock)successBlock
                                            failed:(ApiClientFailedBlock)failedBlock;

#pragma mark - 26.保存银行验接口
+ (NSURLSessionDataTask *)SaveBankAccountWithParam:(NSMutableDictionary *)params
                                              success:(ApiClientSuccessBlock)successBlock
                                               failed:(ApiClientFailedBlock)failedBlock;

#pragma mark - 27.获取银行账户列表接口
+ (NSURLSessionDataTask *)GetBankAccountListWithParam:(NSMutableDictionary *)params
                                           success:(ApiClientSuccessBlock)successBlock
                                            failed:(ApiClientFailedBlock)failedBlock;

#pragma mark - 28.获取指定银行账户详情接口
+ (NSURLSessionDataTask *)GetBankInfoWithParam:(NSMutableDictionary *)params
                                              success:(ApiClientSuccessBlock)successBlock
                                               failed:(ApiClientFailedBlock)failedBlock;

#pragma mark - 29.删除银行账户信息接口
+ (NSURLSessionDataTask *)DeleteBankInfoWithParam:(NSMutableDictionary *)params
                                       success:(ApiClientSuccessBlock)successBlock
                                        failed:(ApiClientFailedBlock)failedBlock;

#pragma mark - 30.发送deviceToken给服务器
+ (NSURLSessionDataTask *)sendDeviceTokenWithParam:(NSMutableDictionary *)params
                                          success:(ApiClientSuccessBlock)successBlock
                                           failed:(ApiClientFailedBlock)failedBlock;

#pragma mark - 28.自动签到节点
+ (NSURLSessionDataTask *)getDispatchForServiceWithParam:(NSMutableDictionary *)params
                                                  success:(ApiClientSuccessBlock)successBlock
                                                   failed:(ApiClientFailedBlock)failedBlock;
+ (NSURLSessionDataTask *)confirmReconciliationWithParam:(NSMutableDictionary *)params
                                           success:(ApiClientSuccessBlock)successBlock
                                            failed:(ApiClientFailedBlock)failedBlock;
+ (NSURLSessionDataTask *)confirmAccountWithParam:(NSMutableDictionary *)params
                                                 success:(ApiClientSuccessBlock)successBlock
                                                  failed:(ApiClientFailedBlock)failedBlock;
+ (NSURLSessionDataTask *)backReconciliationWithParam:(NSMutableDictionary *)params
                                                 success:(ApiClientSuccessBlock)successBlock
                                                  failed:(ApiClientFailedBlock)failedBlock;
+ (NSURLSessionDataTask *)getStatementAttachListWithParam:(NSMutableDictionary *)params
                                              success:(ApiClientSuccessBlock)successBlock
                                               failed:(ApiClientFailedBlock)failedBlock;

#pragma mark - 获取车队通知消息列表
+ (NSURLSessionDataTask *)GetTruckMsgListWithParam:(NSMutableDictionary *)params
                                           success:(ApiClientSuccessBlock)successBlock
                                            failed:(ApiClientFailedBlock)failedBlock;

#pragma mark - 获取系统通知消息列表
+ (NSURLSessionDataTask *)GetSystemMsgListWithParam:(NSMutableDictionary *)params
                                           success:(ApiClientSuccessBlock)successBlock
                                            failed:(ApiClientFailedBlock)failedBlock;

#pragma mark - 车队信息详情
+ (NSURLSessionDataTask *)GetMsgDetailWithParam:(NSMutableDictionary *)params
                                            success:(ApiClientSuccessBlock)successBlock
                                             failed:(ApiClientFailedBlock)failedBlock;
#pragma mark - 获取司机名下加油卡
+ (NSURLSessionDataTask *)GetFuelCardsWithParam:(NSMutableDictionary *)params
                                        success:(ApiClientSuccessBlock)successBlock
                                         failed:(ApiClientFailedBlock)failedBlock;


#pragma mark - 获取油卡可加油的加油站
+ (NSURLSessionDataTask *)GetGasStationsWithParam:(NSMutableDictionary *)params
                                          success:(ApiClientSuccessBlock)successBlock
                                           failed:(ApiClientFailedBlock)failedBlock;



#pragma mark - 加油卡消费列表
+ (NSURLSessionDataTask *)GetConsumptionListWithParam:(NSMutableDictionary *)params
                                        success:(ApiClientSuccessBlock)successBlock
                                         failed:(ApiClientFailedBlock)failedBlock;

#pragma mark - 加油卡消费详情
+ (NSURLSessionDataTask *)GetConsumptionDetailWithParam:(NSMutableDictionary *)params
                                              success:(ApiClientSuccessBlock)successBlock
                                               failed:(ApiClientFailedBlock)failedBlock;

@end
