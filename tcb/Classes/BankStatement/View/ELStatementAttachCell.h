//
//  ELStatementAttachCell.h
//  tcb
//
//  Created by Chuanxun on 15/12/7.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ELStatementAttach;

@interface ELStatementAttachCell : UITableViewCell

@property (strong, nonatomic) ELStatementAttach *attach;

+ (CGFloat)cellHeight;

@end
