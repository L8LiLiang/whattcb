//
//  TopAddLineCell.h
//  tcb
//
//  Created by Jax on 15/11/17.
//  Copyright © 2015年 Jax. All rights reserved.
//

typedef NS_ENUM(NSInteger, AddLineCellStyle) {
    AddLineCellStyleTop = 0,
    AddLineCellStyleMiddle = 1,
    AddLineCellStyleBottom = 2,
};

#import <UIKit/UIKit.h>

@interface AddLineCell : UITableViewCell

@property (nonatomic, assign) AddLineCellStyle addLineCellStyle;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
