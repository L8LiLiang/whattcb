//
//  FleetMsgCell.h
//  tcb
//
//  Created by Jax on 15/12/11.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FleetMessageModel.h"
#import "SystemMsgModel.h"

@interface FleetMsgCell : UITableViewCell

@property (nonatomic, strong) FleetMessage *fleetMessage;
@property (nonatomic, strong) SystemMsg *systemMsg;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
