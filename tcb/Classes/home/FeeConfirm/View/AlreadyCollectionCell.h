//
//  AlreadyCollectionCell.h
//  tcb
//
//  Created by Jax on 15/11/27.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeeDetailModel.h"

@interface AlreadyCollectionCell : UITableViewCell

@property (nonatomic, strong) FeeDetailList *feeDetailList;
+ (instancetype)cellWithTableView:(UITableView *)tableView ;

@end
