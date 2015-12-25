//
//  ListMoreOrderCell.h
//  tcb
//
//  Created by Jax on 15/11/16.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SendCarList.h"

@protocol ListMoreOrderCellDelegate <NSObject>

@optional
- (void)nextViewOnTap:(UITapGestureRecognizer *)tap;

@end


@interface ListMoreOrderCell : UITableViewCell

@property (weak, nonatomic) id<ListMoreOrderCellDelegate> listMoreOrderCellDelegate;

@property (nonatomic, strong) SendCarList *sendCarList;
@property (nonatomic, strong) NSArray *itemArray;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
+ (CGFloat)cellHeightWithItemArray:(NSArray *)itemArray;

@end
