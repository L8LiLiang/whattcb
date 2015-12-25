//
//  ConsumptionDetailController.h
//  tcb
//
//  Created by Chuanxun on 15/12/15.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConsumptionDetailController : UITableViewController

-(instancetype)initWithConsumptionId:(NSString *)consumptionId isRecharge:(BOOL)isRecharge;

@end
