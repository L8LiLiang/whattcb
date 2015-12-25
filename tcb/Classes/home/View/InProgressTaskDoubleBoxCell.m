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
@property (weak, nonatomic) IBOutlet UILabel *lblTo1;
@property (weak, nonatomic) IBOutlet UILabel *lblFleet1;
@property (weak, nonatomic) IBOutlet UILabel *lblContackPerson1;
@property (weak, nonatomic) IBOutlet UIButton *btnDetail1;
@property (weak, nonatomic) IBOutlet UIImageView *imageNext1;
@property (weak, nonatomic) IBOutlet UIImageView *imageDate1;
@property (weak, nonatomic) IBOutlet UIImageView *imageLocation1;
@property (weak, nonatomic) IBOutlet UIImageView *imageCar1;
@property (weak, nonatomic) IBOutlet UILabel *lblHengGang1;


@property (weak, nonatomic) IBOutlet UILabel *lblDate2;
@property (weak, nonatomic) IBOutlet UILabel *lblBoxModel2;
@property (weak, nonatomic) IBOutlet UILabel *lblEntryStatus2;
@property (weak, nonatomic) IBOutlet UILabel *lblTaskStatus2;
@property (weak, nonatomic) IBOutlet UILabel *lblFrom2;
@property (weak, nonatomic) IBOutlet UILabel *lblTo2;
@property (weak, nonatomic) IBOutlet UILabel *lblFleet2;
@property (weak, nonatomic) IBOutlet UILabel *lblContackPerson2;
@property (weak, nonatomic) IBOutlet UIButton *btnDetail2;
@property (weak, nonatomic) IBOutlet UIImageView *imageDate2;
@property (weak, nonatomic) IBOutlet UIImageView *imageLocation2;
@property (weak, nonatomic) IBOutlet UIImageView *imageCar2;
@property (weak, nonatomic) IBOutlet UILabel *lblHengGang;
@property (weak, nonatomic) IBOutlet UILabel *lblSeparator;
@property (weak, nonatomic) IBOutlet UIImageView *imageNext2;


@property (weak, nonatomic) IBOutlet UILabel *lblTotalPrice;
@property (weak, nonatomic) IBOutlet UIButton *btnContact;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;


@property (weak, nonatomic) IBOutlet UIView *wrapView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *warpViewHeight;

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
    _task = task;

    if (!task.doubleBox) {
        self.lblDate2.hidden = YES;
        self.lblBoxModel2.hidden = YES;
        self.lblEntryStatus2.hidden = YES;
        self.lblTaskStatus2.hidden = YES;
        self.lblFrom2.hidden = YES;
        self.lblTo2.hidden = YES;
        self.lblFleet2.hidden = YES;
        self.lblContackPerson2.hidden = YES;
        self.btnDetail2.hidden = YES;
        self.imageDate2.hidden = YES;
        self.imageLocation2.hidden = YES;
        self.imageCar2.hidden = YES;
        self.lblHengGang.hidden = YES;
        self.lblSeparator.hidden = YES;
        self.imageNext2.hidden = YES;
        
        [self maekContentForBox:1];
        
        self.topConstraint.constant = 8;
        self.warpViewHeight.constant = 207;
    }else {
        self.lblDate2.hidden = NO;
        self.lblBoxModel2.hidden = NO;
        self.lblEntryStatus2.hidden = NO;
        self.lblTaskStatus2.hidden = NO;
        self.lblFrom2.hidden = NO;
        self.lblTo2.hidden = NO;
        self.lblFleet2.hidden = NO;
        self.lblContackPerson2.hidden = NO;
        self.btnDetail2.hidden = NO;
        self.imageDate2.hidden = NO;
        self.imageLocation2.hidden = NO;
        self.imageCar2.hidden = NO;
        self.lblHengGang.hidden = NO;
        self.lblSeparator.hidden = NO;
        self.imageNext2.hidden = NO;
        
        [self maekContentForBox:1];
        [self maekContentForBox:2];
        
        self.topConstraint.constant = 164;
        self.warpViewHeight.constant  = 365;
    }
    
}

- (void)maekContentForBox:(NSInteger)index
{
    if (index == 1) {
        NSDate *date = [NSDate dateWithString:self.task.date formatString:@"yyyy-MM-dd HH:mm:ss"];
        
        if (date.yearsAgo > 1) {
            NSString *yearsAgo = NSLocalizedString(@"%d years ago", @"");
            yearsAgo = [NSString stringWithFormat:yearsAgo,date.yearsAgo];
            self.lblDate1.text = yearsAgo;
        }else if (date.daysAgo > 1){
            self.lblDate1.text = [NSString stringWithFormat:@"%02zd月 %02zd日",date.month,date.day];
        }else if (date.daysAgo == 1) {
            NSString *yesterday = NSLocalizedString(@"Yesterday", @"");
            self.lblDate1.text = [NSString stringWithFormat:@"%@ %02zd:%02zd",yesterday,date.hour,date.minute];
        }else if (date.hoursAgo >= 1) {
            NSString *hourAgo = NSLocalizedString(@"%d hours ago", @"");
            hourAgo = [NSString stringWithFormat:hourAgo,date.hoursAgo];
            self.lblDate1.text = hourAgo;
        }else if (date.minutesAgo >= 1) {
            NSString *minuteAgo = NSLocalizedString(@"%d minutes ago", @"");
            minuteAgo = [NSString stringWithFormat:minuteAgo,date.minutesAgo];
            self.lblDate1.text = minuteAgo;
        }else {
            self.lblDate1.text = NSLocalizedString(@"Just now", @"");
        }
        self.lblDate1.text = date.timeAgoSinceNow;
        
        self.lblBoxModel1.text = self.task.boxModel;
        self.lblEntryStatus1.text = [self.task stringFromELEntryStatus];
        self.lblTaskStatus1.text = [self.task stringFromELTaskStatus];
        self.lblFrom1.text = self.task.from;
        self.lblTo1.text = self.task.to;
        self.lblTotalPrice.text = [NSString stringWithFormat:@"¥ %.0f",self.task.price];
        self.lblFleet1.text = self.task.fleetName;
        self.lblContackPerson1.text = self.task.contactPersonName;
    }else {
        NSDate *date = [NSDate dateWithString:self.task.date formatString:@"yyyy-MM-dd HH:mm:ss"];
        
        if (date.yearsAgo > 1) {
            NSString *yearsAgo = NSLocalizedString(@"%d years ago", @"");
            yearsAgo = [NSString stringWithFormat:yearsAgo,date.yearsAgo];
            self.lblDate2.text = yearsAgo;
        }else if (date.daysAgo > 1){
            self.lblDate2.text = [NSString stringWithFormat:@"%02zd月 %02zd日",date.month,date.day];
        }else if (date.daysAgo == 1) {
            NSString *yesterday = NSLocalizedString(@"Yesterday", @"");
            self.lblDate2.text = [NSString stringWithFormat:@"%@ %02zd:%02zd",yesterday,date.hour,date.minute];
        }else if (date.hoursAgo >= 1) {
            NSString *hourAgo = NSLocalizedString(@"%d hours ago", @"");
            hourAgo = [NSString stringWithFormat:hourAgo,date.hoursAgo];
            self.lblDate2.text = hourAgo;
        }else if (date.minutesAgo >= 1) {
            NSString *minuteAgo = NSLocalizedString(@"%d minutes ago", @"");
            minuteAgo = [NSString stringWithFormat:minuteAgo,date.minutesAgo];
            self.lblDate2.text = minuteAgo;
        }else {
            self.lblDate2.text = NSLocalizedString(@"Just now", @"");
        }
        self.lblDate2.text = date.timeAgoSinceNow;
        
        self.lblBoxModel2.text = self.task.boxModel;
        self.lblEntryStatus2.text = [self.task stringFromELEntryStatus];
        self.lblTaskStatus2.text = [self.task stringFromELTaskStatus];
        self.lblFrom2.text = self.task.from;
        self.lblTo2.text = self.task.to;
        self.lblTotalPrice.text = [NSString stringWithFormat:@"¥ %.0f",self.task.price];
        self.lblFleet2.text = self.task.fleetName;
        self.lblContackPerson2.text = self.task.contactPersonName;
    }
}

- (CGFloat)rowHeight
{
    if (self.task.doubleBox) {
        return 381;
    }
    return 223;
}


- (void)awakeFromNib {
    // Initialization code

    self.wrapView.layer.cornerRadius = 8;

    
    if (iPhone4 || iPhone5) {
        UIFont *fontToFizeScreenSize = [UIFont systemFontOfSize:14];
        self.lblDate1.font = fontToFizeScreenSize;
        self.lblBoxModel1.font = fontToFizeScreenSize;
        self.lblEntryStatus1.font = fontToFizeScreenSize;
        self.lblTaskStatus1.font = fontToFizeScreenSize;
        self.lblFrom1.font = fontToFizeScreenSize;
        self.lblTo1.font = fontToFizeScreenSize;
        self.lblFleet1.font = fontToFizeScreenSize;
        self.lblContackPerson1.font = fontToFizeScreenSize;
        
        self.lblDate2.font = fontToFizeScreenSize;
        self.lblBoxModel2.font = fontToFizeScreenSize;
        self.lblEntryStatus2.font = fontToFizeScreenSize;
        self.lblTaskStatus2.font = fontToFizeScreenSize;
        self.lblFrom2.font = fontToFizeScreenSize;
        self.lblTo2.font = fontToFizeScreenSize;
        self.lblFleet2.font = fontToFizeScreenSize;
        self.lblContackPerson2.font = fontToFizeScreenSize;
    }
    
    self.lblDate1.translatesAutoresizingMaskIntoConstraints = NO;
    self.lblBoxModel1.translatesAutoresizingMaskIntoConstraints = NO;
    self.lblEntryStatus1.translatesAutoresizingMaskIntoConstraints = NO;
    self.lblTaskStatus1.translatesAutoresizingMaskIntoConstraints = NO;
    self.lblFrom1.translatesAutoresizingMaskIntoConstraints = NO;
    self.lblTo1.translatesAutoresizingMaskIntoConstraints = NO;
    self.lblFleet1.translatesAutoresizingMaskIntoConstraints = NO;
    self.lblContackPerson1.translatesAutoresizingMaskIntoConstraints = NO;
    self.btnDetail1.translatesAutoresizingMaskIntoConstraints = NO;
    self.imageNext1.translatesAutoresizingMaskIntoConstraints = NO;
    self.imageDate1.translatesAutoresizingMaskIntoConstraints = NO;
    self.imageLocation1.translatesAutoresizingMaskIntoConstraints = NO;
    self.imageCar1.translatesAutoresizingMaskIntoConstraints = NO;
    self.lblHengGang1.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.lblDate2.translatesAutoresizingMaskIntoConstraints = NO;
    self.lblBoxModel2.translatesAutoresizingMaskIntoConstraints = NO;
    self.lblEntryStatus2.translatesAutoresizingMaskIntoConstraints = NO;
    self.lblTaskStatus2.translatesAutoresizingMaskIntoConstraints = NO;
    self.lblFrom2.translatesAutoresizingMaskIntoConstraints = NO;
    self.lblTo2.translatesAutoresizingMaskIntoConstraints = NO;
    self.lblFleet2.translatesAutoresizingMaskIntoConstraints = NO;
    self.lblContackPerson2.translatesAutoresizingMaskIntoConstraints = NO;
    self.btnDetail2.translatesAutoresizingMaskIntoConstraints = NO;
    self.imageDate2.translatesAutoresizingMaskIntoConstraints = NO;
    self.imageLocation2.translatesAutoresizingMaskIntoConstraints = NO;
    self.imageCar2.translatesAutoresizingMaskIntoConstraints = NO;
    self.lblHengGang.translatesAutoresizingMaskIntoConstraints = NO;
    self.lblSeparator.translatesAutoresizingMaskIntoConstraints = NO;
    self.imageNext2.translatesAutoresizingMaskIntoConstraints = NO;
    
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

@end
