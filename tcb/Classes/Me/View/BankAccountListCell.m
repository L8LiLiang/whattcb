//
//  BankAccountListCell.m
//  tcb
//
//  Created by Jax on 15/12/8.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import "BankAccountListCell.h"

@implementation BankAccountListCell

+ (instancetype)cellWithTable:(UITableView *)tableView {
    static NSString *cellID = @"BankAccountListCell";
    BankAccountListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[BankAccountListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpViews];
    }
    return self;
}

- (void)setUpViews {
    UILabel *name = [[UILabel alloc] init];
    [self.contentView addSubview:name];
    [name makeConstraints:^(MASConstraintMaker *make) {
         make.left.equalTo(20);
        make.top.equalTo(10);
        make.width.equalTo(SCREEN_WIDTH);
        make.height.equalTo(self.frame.size.height * 0.5);
    }];
    self.username = name;
    
    UILabel *card = [[UILabel alloc] init];
    [self.contentView addSubview:card];
    [card makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(20);
        make.bottom.equalTo(-10);
        make.width.equalTo(SCREEN_WIDTH);
        make.height.equalTo(self.frame.size.height * 0.5);
    }];
    self.cardId = card;
    
    IdButton *deleteButton = [[IdButton alloc] init];
    [self.contentView addSubview:deleteButton];
    [deleteButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(10);
        make.right.bottom.equalTo(-10);
        make.width.equalTo(80);
    }];
    deleteButton.layer.borderWidth = 1;
    deleteButton.layer.borderColor = kDefaultBarButtonItemColor.CGColor;
    deleteButton.layer.masksToBounds = YES;
    deleteButton.layer.cornerRadius = 4;
    self.deleteButton = deleteButton;
    [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    [deleteButton setTitleColor:kDefaultBarButtonItemColor forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(deleteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setBankList:(BankList *)bankList {
    _bankList = bankList;
    self.username.text = bankList.AccountName;
    self.cardId.text = bankList.AccountNum;
    self.deleteButton.Id = bankList.Id;
    self.tag = self.tag;
}

- (void)deleteButtonClicked:(IdButton *)sender {
    if ([self.delegate respondsToSelector:@selector(deleteButtonClickedOnBankAccountListCell:)]) {
        [self.delegate deleteButtonClickedOnBankAccountListCell:sender];
    }
}

@end
