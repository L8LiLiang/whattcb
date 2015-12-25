//
//  GasStationInfoCell.m
//  tcb
//
//  Created by Jax on 15/12/14.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import "GasStationInfoCell.h"

@interface GasStationInfoCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *telLabel;

@end

@implementation GasStationInfoCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *CellIdentifier = @"GasStationInfoCell";
    GasStationInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil]lastObject];
    }
    
    return cell;
}

- (void)setGasStationInfo:(GasStationInfo *)gasStationInfo {
    _gasStationInfo = gasStationInfo;
    self.nameLabel.text = gasStationInfo.Name;
    self.distanceLabel.text = [NSString stringWithFormat:@"%0.1f km", (gasStationInfo.distance / 1000.0)];
    self.addressLabel.text = gasStationInfo.Addr;
    self.telLabel.text = [NSString stringWithFormat:@"电话: %@", gasStationInfo.Tel];
//    self.nameLabel.text = [NSString stringWithFormat:@"花果山 %ld", self.tag];
//    self.distanceLabel.text = @"1Km";
//    self.addressLabel.text = @"符文圣地";
//    self.telLabel.text = @"短话：12345678901";
}

@end
