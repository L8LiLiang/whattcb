//
//  ConsumptionDetailCell.h
//  tcb
//
//  Created by Chuanxun on 15/12/15.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConsumptionDetailCell : UITableViewCell

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *content;

+ (CGFloat)bestHeight;


@end
