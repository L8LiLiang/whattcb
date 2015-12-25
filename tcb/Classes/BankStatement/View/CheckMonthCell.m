//
//  CheckMonthCell.m
//  tcb
//
//  Created by Chuanxun on 15/12/3.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import "CheckMonthCell.h"
#import "ELMonthReconciliationList.h"

@interface CheckMonthCell ()

@property (weak, nonatomic) IBOutlet UILabel *lblFleetName;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblMonth;
@property (weak, nonatomic) IBOutlet UILabel *lblCount;
@property (weak, nonatomic) IBOutlet UIButton *buttonFleetTel;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalNum;
@property (weak, nonatomic) IBOutlet UIButton *buttonReturn;
@property (weak, nonatomic) IBOutlet UIButton *buttonConfirm;

@property (weak, nonatomic) IBOutlet UIView *wrapView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonFleetConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonReturnConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonConfirmConstraint;

@end

@implementation CheckMonthCell

#define Position1 184
#define Position2 96
#define Position3 8
#define Position0 -100

#define CheckMonthCell_Button_Width 80
#define CheckMonthCell_Button_Height 36

#define Frame0 CGRectMake(-1,-1,0,0)
#define Frame1 CGRectMake(151, 122, CheckMonthCell_Button_Width, CheckMonthCell_Button_Height)
#define Frame2 CGRectMake(239, 122, CheckMonthCell_Button_Width, CheckMonthCell_Button_Height)
#define Frame3 CGRectMake(327, 122, CheckMonthCell_Button_Width, CheckMonthCell_Button_Height)

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.wrapView.layer.cornerRadius = 8;
    
    self.buttonConfirm.layer.cornerRadius = 4;
    self.buttonFleetTel.layer.cornerRadius = 4;
    self.buttonReturn.layer.cornerRadius = 4;
    
    [self.buttonFleetTel addTarget:self action:@selector(telephone:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonReturn addTarget:self action:@selector(returnBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonConfirm addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)setReconciliation:(ELMonthReconciliation *)reconciliation
{
    _reconciliation = reconciliation;
    self.lblFleetName.text = reconciliation.Name;
    self.lblStatus.text = [self.reconciliation checkStatusString];;
    self.lblMonth.text = reconciliation.statementName;
    self.lblCount.text = [NSString stringWithFormat:@"共%zd个订单",reconciliation.Num];
    self.lblTotalNum.text = [NSString stringWithFormat:@"¥ %@",reconciliation.TotalMoney];
    
    //18 149 241
    UIColor *myBlue = [UIColor colorWithRed:18/255.0 green:149/255.0 blue:241/255.0 alpha:1.0];
    
    switch (self.reconciliation.statementStatus) {
        case CheckStatus_noCheck:
            self.buttonFleetConstraint.constant = Position1;
            self.buttonReturnConstraint.constant = Position2;
            self.buttonConfirmConstraint.constant = Position3;
            [self.buttonConfirm setTitle:@"确认对账" forState:UIControlStateNormal];
            [self.buttonConfirm setBackgroundColor:myBlue];
            break;
        case CheckStatus_checked:
            self.buttonFleetConstraint.constant = Position3;
            self.buttonReturnConstraint.constant = Position0;
            self.buttonConfirmConstraint.constant = Position0;
            [self.buttonConfirm setBackgroundColor:myBlue];
            break;
        case CheckStatus_payed:
            self.buttonFleetConstraint.constant = Position2;
            self.buttonReturnConstraint.constant = Position0;
            self.buttonConfirmConstraint.constant = Position3;
            [self.buttonConfirm setTitle:@"确认收款" forState:UIControlStateNormal];
            [self.buttonConfirm setBackgroundColor:myBlue];
            break;
        case CheckStatus_finished:
            self.buttonFleetConstraint.constant = Position2;
            self.buttonReturnConstraint.constant = Position0;
            self.buttonConfirmConstraint.constant = Position3;
            [self.buttonConfirm setTitle:@"已收款" forState:UIControlStateNormal];
            [self.buttonConfirm setBackgroundColor:[UIColor lightGrayColor]];
            self.buttonConfirm.enabled = NO;
            break;
        default:
            break;
    }
    
}
- (IBAction)detail:(id)sender {
    if ([self.delegate respondsToSelector:@selector(checkMonthCellDeatilButtonClicked:)]) {
        [self.delegate checkMonthCellDeatilButtonClicked:self];
    }
}

- (void)returnBack:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(checkMonthReturnBack:)]) {
        [self.delegate checkMonthReturnBack:self];
    }
}

- (void)confirm:(UIButton *)sender
{
    if ([[sender titleForState:UIControlStateNormal] isEqualToString:@"确认对账"]) {
        if ([self.delegate respondsToSelector:@selector(checkMonthCellConfirm:)]) {
            [self.delegate checkMonthCellConfirm:self];
        }
    }else if([[sender titleForState:UIControlStateNormal] isEqualToString:@"确认收款"]) {
        if ([self.delegate respondsToSelector:@selector(checkMonthCellConfirmAccount:)]) {
            [self.delegate checkMonthCellConfirmAccount:self];
        }
    }

}

- (void)telephone:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(checkMonthCellTelephone:)]) {
        [self.delegate checkMonthCellTelephone:self];
    }
}

+ (CGFloat)cellHeight
{
    return 182;
}

@end
