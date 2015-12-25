//
//  GasStationInfoCell.h
//  tcb
//
//  Created by Jax on 15/12/14.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GasStationInfoModel.h"

@interface GasStationInfoCell : UITableViewCell

@property (nonatomic, strong) GasStationInfo *gasStationInfo;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
