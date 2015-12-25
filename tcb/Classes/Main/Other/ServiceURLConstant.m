//
//  ServiceURLConstant.m
//  tcb
//
//  Created by Jax on 15/11/9.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import "ServiceURLConstant.h"

@implementation ServiceURLConstant

/*
// 拖车宝服务URL
// 外网部署(客户)
//public static final String TCB_BASE_URL = "http://web.tuochebao.com/App/";
// 测试版本
//	public static final String TCB_BASE_URL = "http://182.254.220.77:8092/api/Desktop/App";
//	public static final String TCB_IMAGE_URL = "http://182.254.220.77:8092";

// 美琴
//	public static final String TCB_BASE_URL = "http://192.168.1.27:8088/api/Desktop/App";
// 福建
public static final String TCB_BASE_URL = "http://192.168.1.24:1213/api/Desktop/App";
//	public static final String TCB_BASE_URL = "http://192.168.1.33:8081/api/Desktop/App";

public static final String TCB_IMAGE_URL = "http://192.168.1.24:1213";

// 任延鹏
//	public static final String TCB_BASE_URL = "http://192.168.1.41/api/Desktop/App";
// 秀丽
//public static final String TCB_BASE_URL = "http://192.168.1.23:8080/api/Desktop/App";
*/

//#define api @"http://192.168.1.23:1213/api/Desktop/App"
//#define api @"http://192.168.1.41:80/api/Desktop/App"

#define kJiaYouKa @"http://10.10.9.19:8080/CommAPI/CommAPI"
//#define api @"http://10.10.9.19:8080/CommAPI/CommAPI"
#define api @"http://182.254.220.77:8092/api/Desktop/App"

NSString * BaseAPI                  = api;
NSString * CurrentDomain            = @"http://www.haibuzhidao.com";

NSString * LoginAPI = api;
NSString * SendCaptchaAPI = api;
NSString * ResetPwdAPI =api;
NSString * WantMoreListAPI = api;
NSString * WantSingleListAPI = api;
NSString * GrabListAPI = api;
NSString * GrabListDetailAPI = api;
NSString * RobListAPI = api;
NSString * RefuseOrderDispatchAPI = api;
NSString * AcceptOrderDispatchAPI = api;
NSString * MyOrderListAPI = api;
NSString * GetFeeConfirmListAPI = api;
NSString * ConductAboutDispatchAPI = api;
NSString * GetDispatchOrderDetailAPI = api;
NSString * GetAcountDetailAPI = api;
NSString * UploadPicBase64API = api;
NSString * SaveDispatchOrderImageAPI = api;
NSString * GetPhotosAPI = @"http://182.254.220.77:8092";
NSString * DeleteDispatchOrderImageAPI = api;
NSString * SaveFeeAPI = api;
NSString * GetUserProfileAPI = api;
NSString * SaveContainerNoAndSealNoAPI = api;
NSString * SignNodeAPI = api;
NSString * GetReconciliationListAPI = api;
NSString * GetReconciliationDetailListAPI = api;
NSString * GetBankNameList = api;
NSString * SendBankVerifyCode = api;
NSString * SaveBankAccount = api;
NSString * GetBankAccountList = api;
NSString * GetBankInfo = api;
NSString * DeleteBankInfo = api;
NSString * sendDeviceToken = @"http://push.shipxy.com/regdevice.ashx";
NSString *BackReconciliationAPI = api;
NSString *ConfirmReconciliationAPI = api;
NSString *ConfirmAccountAPI = api;
NSString *GetStatementAttachListAPI = api;
NSString *GetTruckMsgListAPI = api;
NSString *GetSystemMsgListAPI = api;
NSString *GetMsgDetailAPI = api;
NSString *GetDispatchForServiceAPI = api;
NSString *GetFuelCardsAPI = kJiaYouKa;
NSString *GetGasStationsAPI = kJiaYouKa;
NSString *GetConsumptionListAPI = api;
NSString *GetConsumptionDetailAPI = api;
//NSString *GetFuelCardsAPI = api;
//NSString *GetGasStationsAPI = api;

@end
