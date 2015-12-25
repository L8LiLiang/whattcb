//
//  BankAccountListCell.h
//  tcb
//
//  Created by Jax on 15/12/8.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BankAccountList.h"
#import "IdButton.h"

@protocol BankAccountListCellDelegate <NSObject>

@optional
- (void)deleteButtonClickedOnBankAccountListCell:(IdButton *)sender;

@end

@interface BankAccountListCell : UITableViewCell

@property (nonatomic, strong) UILabel  *username;
@property (nonatomic, strong) UILabel  *cardId;
@property (nonatomic, strong) IdButton *deleteButton;
@property (nonatomic, strong) BankList *bankList;

@property (nonatomic, weak  ) id<BankAccountListCellDelegate> delegate;
+ (instancetype)cellWithTable:(UITableView *)tableView;

@end
