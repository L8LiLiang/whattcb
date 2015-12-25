//
//  TopAddLineCell.m
//  tcb
//
//  Created by Jax on 15/11/17.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import "AddLineCell.h"

@implementation AddLineCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *CellIdentifier = @"AddLineCell";
    AddLineCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[AddLineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];

    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)setAddLineCellStyle:(AddLineCellStyle)addLineCellStyle {
    _addLineCellStyle = addLineCellStyle;
    if (addLineCellStyle == AddLineCellStyleTop) {
        UIView *whiteViewBottom = [[UIView alloc] init];
        whiteViewBottom.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:whiteViewBottom];
        [whiteViewBottom makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imageView.bottom).offset(-5);
            make.centerX.equalTo(self.imageView.centerX);
            make.bottom.equalTo(self.contentView.bottom).offset(0);
            make.width.equalTo(2);
        }];
    } else if (addLineCellStyle == AddLineCellStyleMiddle) {
        UIView *whiteViewTop = [[UIView alloc] init];
        whiteViewTop.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:whiteViewTop];
        [whiteViewTop makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.top).offset(0);
            make.centerX.equalTo(self.imageView.centerX);
            make.bottom.equalTo(self.imageView.top).offset(3);
            make.width.equalTo(2);
        }];
        
        UIView *whiteViewBottom = [[UIView alloc] init];
        whiteViewBottom.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:whiteViewBottom];
        [whiteViewBottom makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imageView.bottom).offset(-3);
            make.centerX.equalTo(self.imageView.centerX);
            make.bottom.equalTo(self.contentView.bottom).offset(0);
            make.width.equalTo(2);
        }];
        
    } else if (addLineCellStyle == AddLineCellStyleBottom) {
        UIView *whiteViewTop = [[UIView alloc] init];
        whiteViewTop.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:whiteViewTop];
        [whiteViewTop makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.top).offset(0);
            make.centerX.equalTo(self.imageView.centerX);
            make.bottom.equalTo(self.imageView.top).offset(3);
            make.width.equalTo(2);
        }];
        
    }
}

@end
