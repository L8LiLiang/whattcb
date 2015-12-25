//
//  FeeDetailControllerViewController.h
//  tcb
//
//  Created by Jax on 15/11/27.
//  Copyright © 2015年 Jax. All rights reserved.
//

typedef NS_ENUM(NSInteger, SourceType) {
    SourceTypeTask = 0,
    SourceTypeFeeConfirmList,
    SourceTypeCheck,
};

#import <UIKit/UIKit.h>

@interface FeeDetailController : UIViewController
/**
 *  用于查询记账明细
 */
@property (nonatomic, copy  ) NSString *dispCode;
/**
 *  电话号码数组：用于跳转自动签到界面
 */
@property (nonatomic, strong) NSMutableArray *phoneNumberArray;
@property (nonatomic, strong) NSMutableArray *dispCodeArray;
/**
 *  从哪个控制器跳过来
 */
@property (nonatomic, assign) SourceType           sourceType;

@end
