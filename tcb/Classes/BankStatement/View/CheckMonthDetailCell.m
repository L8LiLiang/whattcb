//
//  CheckMonthDetailCell.m
//  tcb
//
//  Created by Chuanxun on 15/12/4.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import "CheckMonthDetailCell.h"
#import "ELMonthReconciliationDetailList.h"


@interface CheckMonthDetailCell ()
@property (weak, nonatomic) IBOutlet UILabel *lblDate1;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus1;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress1;
@property (weak, nonatomic) IBOutlet UILabel *lblFleet1;
@property (weak, nonatomic) IBOutlet UILabel *lblDate2;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus2;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress2;
@property (weak, nonatomic) IBOutlet UILabel *lblFleet2;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalPrice;
@property (weak, nonatomic) IBOutlet UIImageView *imageDate1;
@property (weak, nonatomic) IBOutlet UIImageView *imageLocation1;
@property (weak, nonatomic) IBOutlet UIImageView *imageCar1;
@property (weak, nonatomic) IBOutlet UIImageView *imageNext1;

@property (weak, nonatomic) IBOutlet UIImageView *imageDate2;
@property (weak, nonatomic) IBOutlet UIImageView *imageLocation2;
@property (weak, nonatomic) IBOutlet UIImageView *imageCar2;
@property (weak, nonatomic) IBOutlet UIButton *buttonDetail2;
@property (weak, nonatomic) IBOutlet UIImageView *imageNext2;

@property (weak, nonatomic) IBOutlet UIView *wrapView;
@property (strong, nonatomic) NSLayoutConstraint *constraint;
@property (weak, nonatomic) IBOutlet UILabel *speatorView;
@property (weak, nonatomic) IBOutlet UIButton *btnDetail1;
@property (weak, nonatomic) IBOutlet UILabel *lblTitleForTotalPrice;


@end

@implementation CheckMonthDetailCell


+ (CGFloat)cellHeight
{
    return 188;
}

-(void)setReconciliationDetail:(ELMonthReconciliationDetail *)reconciliationDetail
{
    _reconciliationDetail = reconciliationDetail;
    int oldItemCount = 2;
    int count = 1;
    
    if (count == 1) {
        self.lblDate2.hidden = YES;
        self.imageDate2.hidden = YES;
        self.lblStatus2.hidden = YES;
        self.imageLocation2.hidden = YES;
        self.lblAddress2.hidden = YES;
        self.imageNext2.hidden = YES;
        self.imageCar2.hidden = YES;
        self.lblFleet2.hidden = YES;
        self.buttonDetail2.hidden = YES;
        self.speatorView.hidden = YES;
        
        [self maekContentForBox:0];
        
        if (oldItemCount != 1) {

            if (self.constraint) {
                [self.wrapView removeConstraint:self.constraint];
            }
            NSDictionary *dic = @{@"btnDetail1":self.btnDetail1,@"lblTotalPrice":self.lblTotalPrice};
            NSArray *constraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[btnDetail1]-8-[lblTotalPrice]" options:0 metrics:nil views:dic];
            [self.wrapView addConstraints:constraint];
            self.constraint = constraint.firstObject;
        }
        
    }else {
        self.lblDate2.hidden = NO;
        self.imageDate2.hidden = NO;
        self.lblStatus2.hidden = NO;
        self.imageLocation2.hidden = NO;
        self.lblAddress2.hidden = NO;
        self.imageNext2.hidden = NO;
        self.imageCar2.hidden = NO;
        self.lblFleet2.hidden = NO;
        self.buttonDetail2.hidden = NO;
        self.speatorView.hidden = NO;
        
        [self maekContentForBox:0];
        [self maekContentForBox:1];
        
        if (oldItemCount != 2) {

            if (self.constraint) {
                [self.wrapView removeConstraint:self.constraint];
            }
            NSDictionary *dic = @{@"btnDetail2":self.buttonDetail2,@"lblTotalPrice":self.lblTotalPrice};
            NSArray *constraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[btnDetail2]-8-[lblTotalPrice]" options:0 metrics:nil views:dic];
            [self.wrapView addConstraints:constraint];
            self.constraint = constraint.firstObject;
        }
    }
    
    //    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
    //        [self setNeedsLayout];
    //        [self layoutIfNeeded];
    //    }
    
}

- (void)maekContentForBox:(NSInteger)index
{
//    @property (weak, nonatomic) IBOutlet UILabel *lblDate1;
//    @property (weak, nonatomic) IBOutlet UILabel *lblStatus1;
//    @property (weak, nonatomic) IBOutlet UILabel *lblAddress1;
//    @property (weak, nonatomic) IBOutlet UILabel *lblFleet1;
    self.lblDate1.text = self.reconciliationDetail.AppointDate;
    self.lblStatus1.text = self.reconciliationDetail.DispatchType;
    self.lblAddress1.text = self.reconciliationDetail.Address;
    self.lblFleet1.text = self.reconciliationDetail.FromName;
    self.lblTotalPrice.text = self.reconciliationDetail.Cost;
    
}


- (void)awakeFromNib {
    // Initialization code
    
    self.wrapView.layer.cornerRadius = 8;
    [self.btnDetail1 addTarget:self action:@selector(detail:) forControlEvents:UIControlEventTouchUpInside];
    
    self.lblDate1.translatesAutoresizingMaskIntoConstraints = NO;
    self.lblStatus1.translatesAutoresizingMaskIntoConstraints = NO;
    self.lblAddress1.translatesAutoresizingMaskIntoConstraints = NO;
    self.lblFleet1.translatesAutoresizingMaskIntoConstraints = NO;
    self.lblDate2.translatesAutoresizingMaskIntoConstraints = NO;
    self.lblStatus2.translatesAutoresizingMaskIntoConstraints = NO;
    self.lblAddress2.translatesAutoresizingMaskIntoConstraints = NO;
    self.lblFleet2.translatesAutoresizingMaskIntoConstraints = NO;
    self.lblTotalPrice.translatesAutoresizingMaskIntoConstraints = NO;
    self.imageDate1.translatesAutoresizingMaskIntoConstraints = NO;
    self.imageLocation1.translatesAutoresizingMaskIntoConstraints = NO;
    self.imageCar1.translatesAutoresizingMaskIntoConstraints = NO;
    self.imageNext1.translatesAutoresizingMaskIntoConstraints = NO;
    self.imageDate2.translatesAutoresizingMaskIntoConstraints = NO;
    self.imageLocation2.translatesAutoresizingMaskIntoConstraints = NO;
    self.imageCar2.translatesAutoresizingMaskIntoConstraints = NO;
    self.buttonDetail2.translatesAutoresizingMaskIntoConstraints = NO;
    self.imageNext2.translatesAutoresizingMaskIntoConstraints = NO;
    self.wrapView.translatesAutoresizingMaskIntoConstraints = NO;
    self.speatorView.translatesAutoresizingMaskIntoConstraints = NO;
    self.btnDetail1.translatesAutoresizingMaskIntoConstraints = NO;
    self.lblTitleForTotalPrice.translatesAutoresizingMaskIntoConstraints = NO;


}

-(void)detail:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(detailCellDetailBtnClicked:)]) {
        [self.delegate detailCellDetailBtnClicked:self];
    }
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
    
    self.lblAddress1.preferredMaxLayoutWidth = CGRectGetWidth(self.lblAddress1.frame);
//    self.lblFleet1.preferredMaxLayoutWidth = CGRectGetWidth(self.lblFleet1.frame);
//    if (self.task.item.count > 1) {
//        self.lblFrom2.preferredMaxLayoutWidth = CGRectGetWidth(self.lblFrom2.frame);
//        self.lblFleet2.preferredMaxLayoutWidth = CGRectGetWidth(self.lblFleet2.frame);
//    }
}

@end
