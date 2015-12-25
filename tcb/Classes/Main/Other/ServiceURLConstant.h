//
//  ServiceURLConstant.h
//  tcb
//
//  Created by Jax on 15/11/9.
//  Copyright © 2015年 Jax. All rights reserved.
//


#define IMAGE_URL @"http://182.254.220.77:8092"

#import <Foundation/Foundation.h>

@interface ServiceURLConstant : NSObject

#pragma mark - 域名

extern NSString * BaseAPI;
extern NSString * CurrentDomain;

#pragma mark - html网页API



#pragma mark - 接口API
/**
 *  登陆注册
 */
extern NSString * LoginAPI;
extern NSString * SendCaptchaAPI;
extern NSString * ResetPwdAPI;
/**
 *  我要接单
 */
extern NSString * WantMoreListAPI;
extern NSString * WantSingleListAPI;
extern NSString * GrabListAPI;
extern NSString * GrabListDetailAPI;
extern NSString * RobListAPI;
extern NSString * RefuseOrderDispatchAPI;
extern NSString * AcceptOrderDispatchAPI;

extern NSString * MyOrderListAPI;
/**
 *  费用确认
 */
extern NSString * GetFeeConfirmListAPI;
extern NSString * ConductAboutDispatchAPI;
/**
 *  费用明细
 */
extern NSString * SaveFeeAPI;
/**
 *  记账
 */
extern NSString * GetAcountDetailAPI;
/**
 *  通用:上传图片
 */
extern NSString * UploadPicBase64API;
/**
 *  我的
 */
extern NSString * GetUserProfileAPI;
extern NSString * GetBankNameList;
extern NSString * SendBankVerifyCode;
extern NSString * SaveBankAccount;
extern NSString * GetBankAccountList;
extern NSString * GetBankInfo;
extern NSString * DeleteBankInfo;
/**
 *  发送deviceToken
 */
extern NSString * sendDeviceToken;
/**
 *
 */
extern NSString * SaveDispatchOrderImageAPI;

extern NSString * DeleteDispatchOrderImageAPI;

extern NSString * SaveContainerNoAndSealNoAPI;

extern NSString * SignNodeAPI;

extern NSString * GetReconciliationListAPI;

extern NSString * GetDispatchOrderDetailAPI;

extern NSString *GetReconciliationDetailListAPI;

extern NSString *BackReconciliationAPI;

extern NSString *ConfirmReconciliationAPI;

extern NSString *ConfirmAccountAPI;

extern NSString *GetStatementAttachListAPI;

extern NSString *GetTruckMsgListAPI;
extern NSString *GetDispatchForServiceAPI;

extern NSString *GetSystemMsgListAPI;

extern NSString *GetMsgDetailAPI;
extern NSString *GetConsumptionListAPI;
extern NSString *GetConsumptionDetailAPI;

extern NSString *GetFuelCardsAPI;
extern NSString *GetGasStationsAPI;

@end
