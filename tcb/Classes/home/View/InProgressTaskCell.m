//
//  InProgressTaskCell.m
//  tcb
//
//  Created by Chuanxun on 15/11/16.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import "InProgressTaskCell.h"
#import "ELInProgressTask.h"
#import <DateTools.h>


@interface InProgressTaskCell ()

@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblBoxModel;
@property (weak, nonatomic) IBOutlet UILabel *lblEntryStatus;

@property (weak, nonatomic) IBOutlet UILabel *lblTaskStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblFrom;
@property (weak, nonatomic) IBOutlet UILabel *lblTo;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblFleet;
@property (weak, nonatomic) IBOutlet UILabel *lblContactPersonName;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewDate;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewCar;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewLocation;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewDetail;
@property (weak, nonatomic) IBOutlet UIButton *btnContactPerson;
@property (weak, nonatomic) IBOutlet UIButton *btnDetail;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@end

@implementation InProgressTaskCell


+(instancetype)cellWithTableView:(UITableView *)tableView
{
    NSString *identifier = @"EL_INPROGRESS_TASK_CELL";
    InProgressTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"InProgressTaskCell" owner:nil options:nil].firstObject;
    }
    return cell;
}

-(void)setTask:(ELInProgressTask *)task
{
    _task = task;

    NSDate *date = [NSDate dateWithString:task.date formatString:@"yyyy-MM-dd HH:mm:ss"];
//    NSLog(@"%@",date.timeAgoSinceNow);
//    NSLog(@"%@ current=%@",date,[NSDate date]);
//    NSLog(@"%f,%f,%zd,%zd",[date minutesAgo],[date hoursAgo],[date daysAgo],[date monthsAgo]);
    if (date.yearsAgo > 1) {
        NSString *yearsAgo = NSLocalizedString(@"%d years ago", @"");
        yearsAgo = [NSString stringWithFormat:yearsAgo,date.yearsAgo];
        self.lblDate.text = yearsAgo;
    }else if (date.daysAgo > 1){
        self.lblDate.text = [NSString stringWithFormat:@"%02zd月 %02zd日",date.month,date.day];
    }else if (date.daysAgo == 1) {
        NSString *yesterday = NSLocalizedString(@"Yesterday", @"");
        self.lblDate.text = [NSString stringWithFormat:@"%@ %02zd:%02zd",yesterday,date.hour,date.minute];
    }else if (date.hoursAgo >= 1) {
        NSString *hourAgo = NSLocalizedString(@"%d hours ago", @"");
        hourAgo = [NSString stringWithFormat:hourAgo,date.hoursAgo];
        self.lblDate.text = hourAgo;
    }else if (date.minutesAgo >= 1) {
        NSString *minuteAgo = NSLocalizedString(@"%d minutes ago", @"");
        minuteAgo = [NSString stringWithFormat:minuteAgo,date.minutesAgo];
        self.lblDate.text = minuteAgo;
    }else {
        self.lblDate.text = NSLocalizedString(@"Just now", @"");
    }
    self.lblDate.text = date.timeAgoSinceNow;
    
    self.lblBoxModel.text = task.boxModel;
    self.lblEntryStatus.text = [task stringFromELEntryStatus];
    self.lblTaskStatus.text = [task stringFromELTaskStatus];
    self.lblFrom.text = task.from;
    self.lblTo.text = task.to;
    self.lblPrice.text = [NSString stringWithFormat:@"¥ %.0f",task.price];
    self.lblFleet.text = task.fleetName;
    self.lblContactPersonName.text = task.contactPersonName;
}

+ (CGFloat)rowHeight
{
    return 226;
}

- (IBAction)contactToPerson:(id)sender {
    
}

- (void)awakeFromNib {
    // Initialization code
    self.topView.layer.cornerRadius = 10;
    self.bottomView.layer.cornerRadius = 10;
    
    if (iPhone4 || iPhone5) {
        UIFont *fontToFizeScreenSize = [UIFont systemFontOfSize:12];
        self.lblDate.font = fontToFizeScreenSize;
        self.lblBoxModel.font = fontToFizeScreenSize;
        self.lblEntryStatus.font = fontToFizeScreenSize;
        self.lblTaskStatus.font = fontToFizeScreenSize;
    }

    
    self.lblDate.translatesAutoresizingMaskIntoConstraints = NO;
    self.lblBoxModel.translatesAutoresizingMaskIntoConstraints = NO;
    self.lblEntryStatus.translatesAutoresizingMaskIntoConstraints = NO;
    self.lblTaskStatus.translatesAutoresizingMaskIntoConstraints = NO;
    self.lblFrom.translatesAutoresizingMaskIntoConstraints = NO;
    self.lblTo.translatesAutoresizingMaskIntoConstraints = NO;
    self.lblPrice.translatesAutoresizingMaskIntoConstraints = NO;
    self.lblFleet.translatesAutoresizingMaskIntoConstraints = NO;
    self.lblContactPersonName.translatesAutoresizingMaskIntoConstraints = NO;
    
}
- (IBAction)detailButtonClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(inProgressTaskCellClickDetailButton:)]) {
        [self.delegate inProgressTaskCellClickDetailButton:self];
    }
}
- (IBAction)contactButtonClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(inProgressTaskCellClickContactButton:)]) {
        [self.delegate inProgressTaskCellClickContactButton:self];
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
