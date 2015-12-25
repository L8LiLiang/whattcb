//
//  CheckMonthDetailController.h
//  tcb
//
//  Created by Chuanxun on 15/12/4.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELMonthReconciliationList.h"

@interface CheckMonthDetailController : UITableViewController

-(instancetype)initWithCheckNo:(NSString *)checkNo checkStatus:(CheckStatus)checkStatus title:(NSString *)title;

@end
