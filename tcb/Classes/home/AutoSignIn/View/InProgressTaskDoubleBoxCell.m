//
//  InProgressTaskDoubleBoxCell.m
//  tcb
//
//  Created by Chuanxun on 15/11/24.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import "InProgressTaskDoubleBoxCell.h"
#import <DateTools.h>



@interface InProgressTaskDoubleBoxCell ()

@property (weak, nonatomic) IBOutlet UILabel *lblDate1;
@property (weak, nonatomic) IBOutlet UILabel *lblBoxModel1;
@property (weak, nonatomic) IBOutlet UILabel *lblEntryStatus1;
@property (weak, nonatomic) IBOutlet UILabel *lblTaskStatus1;
@property (weak, nonatomic) IBOutlet UILabel *lblFrom1;
@property (weak, nonatomic) IBOutlet UILabel *lblFleet1;
@property (weak, nonatomic) IBOutlet UILabel *lblContackPerson1;
@property (weak, nonatomic) IBOutlet UIButton *btnDetail1;
@property (weak, nonatomic) IBOutlet UIImageView *imageNext1;
@property (weak, nonatomic) IBOutlet UIImageView *imageDate1;
@property (weak, nonatomic) IBOutlet UIImageView *imageLocation1;
@property (weak, nonatomic) IBOutlet UIImageView *imageCar1;


@property (strong, nonatomic) IBOutlet UILabel *lblDate2;
@property (strong, nonatomic) IBOutlet UILabel *lblBoxModel2;
@property (strong, nonatomic) IBOutlet UILabel *lblEntryStatus2;
@property (strong, nonatomic) IBOutlet UILabel *lblTaskStatus2;
@property (strong, nonatomic) IBOutlet UILabel *lblFrom2;
@property (strong, nonatomic) IBOutlet UILabel *lblFleet2;
@property (strong, nonatomic) IBOutlet UILabel *lblContackPerson2;
@property (strong, nonatomic) IBOutlet UIButton *btnDetail2;
@property (strong, nonatomic) IBOutlet UIImageView *imageDate2;
@property (strong, nonatomic) IBOutlet UIImageView *imageLocation2;
@property (strong, nonatomic) IBOutlet UIImageView *imageCar2;
@property (strong, nonatomic) IBOutlet UILabel *lblSeparator;
@property (strong, nonatomic) IBOutlet UIImageView *imageNext2;


@property (weak, nonatomic) IBOutlet UILabel *lblTotalPrice;
@property (weak, nonatomic) IBOutlet UIButton *btnContact;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;


@property (weak, nonatomic) IBOutlet UIView *wrapView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *warpViewHeight;

@property (strong, nonatomic) NSLayoutConstraint *btnContactToBtnDetailconstraint;

@end

@implementation InProgressTaskDoubleBoxCell

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    NSString *identifier = @"InProgressTaskDoubleBoxCell";
    InProgressTaskDoubleBoxCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"InProgressTaskDoubleBoxCell" owner:nil options:nil].firstObject;
    }
//    cell.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    return cell;
}

-(void)setTask:(ELInProgressTask *)task
{
    NSInteger oldItemCount = _task.item.count;
    _task = task;

    if (task.item.count == 1) {
        self.lblDate2.hidden = YES;
        self.lblBoxModel2.hidden = YES;
        self.lblEntryStatus2.hidden = YES;
        self.lblTaskStatus2.hidden = YES;
        self.lblFrom2.hidden = YES;
        self.lblFleet2.hidden = YES;
        self.lblContackPerson2.hidden = YES;
        self.btnDetail2.hidden = YES;
        self.imageDate2.hidden = YES;
        self.imageLocation2.hidden = YES;
        self.imageCar2.hidden = YES;
        self.lblSeparator.hidden = YES;
        self.imageNext2.hidden = YES;
        
        [self maekContentForBox:0];
        
        if (oldItemCount != 1) {
//            [self.btnContact remakeConstraints:^(MASConstraintMaker *make) {
//                make.width.equalTo(@120);
//                make.height.equalTo(@40);
//                make.top.equalTo(self.btnDetail1.bottom).offset(8);
//                make.bottom.equalTo(self.wrapView.bottom).offset(-8);
//                make.right.equalTo(self.wrapView.right).offset(-8);
//                make.centerY.equalTo(self.lblTotalPrice);
//            }];
            if (self.btnContactToBtnDetailconstraint) {
                [self.wrapView removeConstraint:self.btnContactToBtnDetailconstraint];
            }
            NSDictionary *dic = @{@"btnDetail1":self.btnDetail1,@"btnContact":self.btnContact};
            NSArray *constraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[btnDetail1]-8@1000-[btnContact]" options:0 metrics:nil views:dic];
            [self.wrapView addConstraints:constraint];
            self.btnContactToBtnDetailconstraint = constraint.firstObject;
        }
        
    }else {
        self.lblDate2.hidden = NO;
        self.lblBoxModel2.hidden = NO;
        self.lblEntryStatus2.hidden = NO;
        self.lblTaskStatus2.hidden = NO;
        self.lblFrom2.hidden = NO;
        self.lblFleet2.hidden = NO;
        self.lblContackPerson2.hidden = NO;
        self.btnDetail2.hidden = NO;
        self.imageDate2.hidden = NO;
        self.imageLocation2.hidden = NO;
        self.imageCar2.hidden = NO;
        self.lblSeparator.hidden = NO;
        self.imageNext2.hidden = NO;
        
        [self maekContentForBox:0];
        [self maekContentForBox:1];
        
        if (oldItemCount != 2) {
//            [self.btnContact remakeConstraints:^(MASConstraintMaker *make) {
//                make.width.equalTo(@120);
//                make.height.equalTo(@40);
//                make.top.equalTo(self.btnDetail2.bottom).offset(8);
//                make.bottom.equalTo(self.wrapView.bottom).offset(-8);
//                make.right.equalTo(self.wrapView.right).offset(-8);
//                make.centerY.equalTo(self.lblTotalPrice);
//            }];
            if (self.btnContactToBtnDetailconstraint) {
                [self.wrapView removeConstraint:self.btnContactToBtnDetailconstraint];
            }
            NSDictionary *dic = @{@"btnDetail2":self.btnDetail2,@"btnContact":self.btnContact};
            NSArray *constraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[btnDetail2]-8@1000-[btnContact]" options:0 metrics:nil views:dic];
            [self.wrapView addConstraints:constraint];
            self.btnContactToBtnDetailconstraint = constraint.firstObject;
        }
    }

//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
//        [self setNeedsLayout];
//        [self layoutIfNeeded];
//    }
    
}

- (void)maekContentForBox:(NSInteger)index
{
    if (index == 0) {
        ELInProgressTaskItem *item = self.task.item[0];

        self.lblDate1.text = item.AppointDate;
        self.lblBoxModel1.text = item.ContainerType;
        self.lblEntryStatus1.text = item.CustomsMode;
        self.lblTaskStatus1.text = item.NodeStatus;
        self.lblFrom1.text = item.Address;
        self.lblTotalPrice.text = [NSString stringWithFormat:@"¥ %@",item.Fee];
        self.lblFleet1.text = item.TeamName;
        self.lblContackPerson1.text = item.Dispatcher;
    }else {
        ELInProgressTaskItem *item = self.task.item[1];

        self.lblDate2.text = item.AppointDate;
        self.lblBoxModel2.text = item.ContainerType;
        self.lblEntryStatus2.text = item.CustomsMode;
        self.lblTaskStatus2.text = item.NodeStatus;
        self.lblFrom2.text = item.Address;
        self.lblFleet2.text = item.TeamName;
        self.lblContackPerson2.text = item.Dispatcher;

    }
}


- (void)awakeFromNib {
    // Initialization code

    self.wrapView.layer.cornerRadius = 8;
//    self.contentView.backgroundColor = [UIColor redColor];
    
    if (iPhone4 || iPhone5) {
        UIFont *fontToFizeScreenSize = [UIFont systemFontOfSize:14];
        self.lblDate1.font = fontToFizeScreenSize;
        self.lblBoxModel1.font = fontToFizeScreenSize;
        self.lblEntryStatus1.font = fontToFizeScreenSize;
        self.lblTaskStatus1.font = fontToFizeScreenSize;
        self.lblFrom1.font = fontToFizeScreenSize;
        self.lblFleet1.font = fontToFizeScreenSize;
        self.lblContackPerson1.font = fontToFizeScreenSize;
        
        self.lblDate2.font = fontToFizeScreenSize;
        self.lblBoxModel2.font = fontToFizeScreenSize;
        self.lblEntryStatus2.font = fontToFizeScreenSize;
        self.lblTaskStatus2.font = fontToFizeScreenSize;
        self.lblFrom2.font = fontToFizeScreenSize;
        self.lblFleet2.font = fontToFizeScreenSize;
        self.lblContackPerson2.font = fontToFizeScreenSize;
    }
    
    
    self.wrapView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.lblDate1.translatesAutoresizingMaskIntoConstraints = NO;
    self.lblBoxModel1.translatesAutoresizingMaskIntoConstraints = NO;
    self.lblEntryStatus1.translatesAutoresizingMaskIntoConstraints = NO;
    self.lblTaskStatus1.translatesAutoresizingMaskIntoConstraints = NO;
    self.lblFrom1.translatesAutoresizingMaskIntoConstraints = NO;
    self.lblFleet1.translatesAutoresizingMaskIntoConstraints = NO;
    self.lblContackPerson1.translatesAutoresizingMaskIntoConstraints = NO;
    self.btnDetail1.translatesAutoresizingMaskIntoConstraints = NO;
    self.imageNext1.translatesAutoresizingMaskIntoConstraints = NO;
    self.imageDate1.translatesAutoresizingMaskIntoConstraints = NO;
    self.imageLocation1.translatesAutoresizingMaskIntoConstraints = NO;
    self.imageCar1.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.lblDate2.translatesAutoresizingMaskIntoConstraints = NO;
    self.lblBoxModel2.translatesAutoresizingMaskIntoConstraints = NO;
    self.lblEntryStatus2.translatesAutoresizingMaskIntoConstraints = NO;
    self.lblTaskStatus2.translatesAutoresizingMaskIntoConstraints = NO;
    self.lblFrom2.translatesAutoresizingMaskIntoConstraints = NO;
    self.lblFleet2.translatesAutoresizingMaskIntoConstraints = NO;
    self.lblContackPerson2.translatesAutoresizingMaskIntoConstraints = NO;
    self.btnDetail2.translatesAutoresizingMaskIntoConstraints = NO;
    self.imageNext2.translatesAutoresizingMaskIntoConstraints = NO;
    self.imageDate2.translatesAutoresizingMaskIntoConstraints = NO;
    self.imageLocation2.translatesAutoresizingMaskIntoConstraints = NO;
    self.imageCar2.translatesAutoresizingMaskIntoConstraints = NO;
    self.lblSeparator.translatesAutoresizingMaskIntoConstraints = NO;

    
    self.lblTotalPrice.translatesAutoresizingMaskIntoConstraints = NO;
    self.btnContact.translatesAutoresizingMaskIntoConstraints = NO;
}


- (IBAction)detailBtn1Clicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(cellDetailBtn1Clicked:)]) {
        [self.delegate cellDetailBtn1Clicked:self];
    }
}
- (IBAction)detailBtn2Clocked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(cellDetailBtn2Clicked:)]) {
        [self.delegate cellDetailBtn2Clicked:self];
    }
}
- (IBAction)contact:(id)sender {
    if ([self.delegate respondsToSelector:@selector(cellContactBtnClicked:)]) {
        [self.delegate cellContactBtnClicked:self];
    }
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
    
    self.lblFrom1.preferredMaxLayoutWidth = CGRectGetWidth(self.lblFrom1.frame);
    self.lblFleet1.preferredMaxLayoutWidth = CGRectGetWidth(self.lblFleet1.frame);
    if (self.task.item.count > 1) {
        self.lblFrom2.preferredMaxLayoutWidth = CGRectGetWidth(self.lblFrom2.frame);
        self.lblFleet2.preferredMaxLayoutWidth = CGRectGetWidth(self.lblFleet2.frame);
    }
}

@end
