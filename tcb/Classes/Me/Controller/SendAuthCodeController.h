//
//  SendAuthCodeController.h
//  tcb
//
//  Created by Jax on 15/12/7.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendAuthCodeController : UIViewController

@property (nonatomic, copy) NSString *accountName;
@property (nonatomic, copy) NSString *accountNum;
@property (nonatomic, copy) NSString *bankCode;
@property (nonatomic, copy) NSString *accountType;
@property (nonatomic, copy) NSString *accountAddress;
@property (nonatomic, copy) NSString *accountProvince;
@property (nonatomic, copy) NSString *accountCity;
@property (nonatomic, copy) NSString *phoneNo;

@end
