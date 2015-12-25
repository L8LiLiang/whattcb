//
//  InProgressTaskDoubleBoxCell.h
//  tcb
//
//  Created by Chuanxun on 15/11/24.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELInProgressTask.h"

@class InProgressTaskDoubleBoxCell;

@protocol InProgressTaskDoubleBoxCellDelegate <NSObject>

- (void)cellDetailBtn1Clicked:(InProgressTaskDoubleBoxCell *)cell;
- (void)cellDetailBtn2Clicked:(InProgressTaskDoubleBoxCell *)cell;
- (void)cellContactBtnClicked:(InProgressTaskDoubleBoxCell *)cell;

@end



@interface InProgressTaskDoubleBoxCell : UITableViewCell

@property (weak, nonatomic) id<InProgressTaskDoubleBoxCellDelegate>delegate;

@property (strong, nonatomic) ELInProgressTask *task;


+ (instancetype)cellWithTableView:(UITableView *)tableView;


@end
