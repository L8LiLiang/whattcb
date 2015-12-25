//
//  ShowRobListOrderCell.h
//  tcb
//
//  Created by Jax on 15/11/16.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GrabOrder.h"

@interface ShowRobListOrderCell : UITableViewCell

@property (nonatomic, strong) GrabOrder *grabOrder;
@property (nonatomic, strong) GrabList *grabList;
@property (nonatomic, strong) NSArray *grabItemArray;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
+ (CGFloat)cellHeightWithItemArray:(GrabList *)grabItemArray;

@end
