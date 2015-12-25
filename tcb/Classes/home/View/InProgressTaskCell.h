//
//  InProgressTaskCell.h
//  tcb
//
//  Created by Chuanxun on 15/11/16.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELInProgressTask.h"

@class InProgressTaskCell;

@protocol InProgressTaskCellDelegate <NSObject>

- (void)inProgressTaskCellClickDetailButton:(InProgressTaskCell *)cell;
- (void)inProgressTaskCellClickContactButton:(InProgressTaskCell *)cell;

@end


@interface InProgressTaskCell : UITableViewCell

@property (weak, nonatomic) id<InProgressTaskCellDelegate> delegate;
@property (strong, nonatomic) ELInProgressTask *task;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)rowHeight;

@end
