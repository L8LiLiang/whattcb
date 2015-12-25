//
//  OilCardDetailItemCell.h
//  tcb
//
//  Created by Chuanxun on 15/12/15.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OilCardConsumptionList.h"


@interface OilCardDetailItemCell : UITableViewCell
@property (strong, nonatomic) OilCardConsumptionItem *item;

+ (CGFloat)bestHeight;

@end
