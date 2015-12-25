//
//  CheckMonthDetailFooterView.m
//  tcb
//
//  Created by Chuanxun on 15/12/4.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import "CheckMonthDetailFooterView.h"
#import "ELMonthReconciliationDetailList.h"


@interface CheckMonthDetailFooterView ()

@property (weak, nonatomic) IBOutlet UILabel *totalCost;
@property (weak, nonatomic) IBOutlet UILabel *writeOffTotalCost;
@property (weak, nonatomic) IBOutlet UILabel *cost;

@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UIButton *returnButton;
@property (weak, nonatomic) IBOutlet UIButton *confirmSmallButton;
@property (weak, nonatomic) IBOutlet UIButton *lookButton;

@property (assign, nonatomic) CheckStatus status;

@end

@implementation CheckMonthDetailFooterView

+(instancetype)footerViewWithStatus:(CheckStatus)status
{
    CheckMonthDetailFooterView *view = [[NSBundle mainBundle] loadNibNamed:@"CheckMonthDetailFooterView" owner:nil options:nil].lastObject;
    view.lookButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    view.lookButton.layer.borderWidth = 1;
    
    view.confirmButton.layer.cornerRadius = 8;
    view.returnButton.layer.cornerRadius = 5;
    view.confirmSmallButton.layer.cornerRadius = 5;
    
    view.status = status;
    if (status == CheckStatus_payed) {
        view.confirmButton.hidden = NO;
        view.returnButton.hidden = YES;
        view.confirmSmallButton.hidden = YES;
    }else {
        view.confirmButton.hidden = YES;
        view.returnButton.hidden = NO;
        view.confirmSmallButton.hidden = NO;
    }
    
    return view;
}

+ (CGFloat)bestHeight
{
    return 184;
}

-(void)setDetailList:(ELMonthReconciliationDetailList *)detailList
{
    _detailList = detailList;
    
    self.totalCost.text =  detailList.totalCost;
    self.writeOffTotalCost.text = detailList.writeOffTotalCost;
    self.cost.text = detailList.cost;
}

- (IBAction)look:(id)sender {
    if ([self.delegate respondsToSelector:@selector(lookDetail:)]) {
        [self.delegate lookDetail:self];
    }
}
- (IBAction)allReturn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(allReturn:)]) {
        [self.delegate allReturn:self];
    }
}

- (IBAction)allConfirm:(id)sender {
    if ([self.delegate respondsToSelector:@selector(allConfirm:)]) {
        [self.delegate allConfirm:self];
    }
}
- (IBAction)confirm:(id)sender {
    if ([self.delegate respondsToSelector:@selector(confirmAccount:)]) {
        [self.delegate confirmAccount:self];
    }
}

@end
