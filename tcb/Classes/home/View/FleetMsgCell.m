//
//  FleetMsgCell.m
//  tcb
//
//  Created by Jax on 15/12/11.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import "FleetMsgCell.h"

@interface FleetMsgCell ()

@property (weak, nonatomic) IBOutlet UILabel *company;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *title;


@end

@implementation FleetMsgCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *CellIdentifier = @"FleetMsgCell";
    FleetMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil]lastObject];
    }
    
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

//  重写模型
- (void)setFleetMessage:(FleetMessage *)fleetMessage {
    _fleetMessage = fleetMessage;
    self.company.text = fleetMessage.Company;
    self.time.text = fleetMessage.Time;
    self.title.text = fleetMessage.Title;
}

- (void)setSystemMsg:(SystemMsg *)systemMsg {
    _systemMsg = systemMsg;
    self.company.text = systemMsg.Company;
    self.time.text = systemMsg.Time;
    self.title.text = systemMsg.Title;
}

@end
