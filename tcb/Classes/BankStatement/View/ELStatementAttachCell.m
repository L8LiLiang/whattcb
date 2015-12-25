//
//  ELStatementAttachCell.m
//  tcb
//
//  Created by Chuanxun on 15/12/7.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import "ELStatementAttachCell.h"
#import "ELStatementAttach.h"

@interface ELStatementAttachCell ()

@property (weak, nonatomic) IBOutlet UILabel *feeName;
@property (weak, nonatomic) IBOutlet UILabel *trackNo;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *money;


@end

@implementation ELStatementAttachCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setAttach:(ELStatementAttach *)attach
{
    _attach = attach;
    self.feeName.text = attach.FeeName;
    self.trackNo.text = attach.TruckNo;
    self.date.text = attach.OperateTime;
    self.money.text = [NSString stringWithFormat:@"¥ %@",attach.Money];
}


+ (CGFloat)cellHeight
{
    return 76;
}



@end
