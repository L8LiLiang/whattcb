//
//  OilCardDetailItemCell.m
//  tcb
//
//  Created by Chuanxun on 15/12/15.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import "OilCardDetailItemCell.h"


@interface OilCardDetailItemCell ()

@property (weak, nonatomic) IBOutlet UILabel *fleetName;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *cost;
@property (weak, nonatomic) IBOutlet UILabel *last;
@property (weak, nonatomic) IBOutlet UIImageView *icon;

@property (weak, nonatomic) IBOutlet UIView *warpView;

@end


@implementation OilCardDetailItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.warpView.layer.cornerRadius = 6;
}


-(void)setItem:(OilCardConsumptionItem *)item
{
    self.fleetName.text = item.Team;
    self.time.text = item.Time;
    self.cost.text = item.Cost;
    self.last.text = [NSString stringWithFormat:@"余额 %@",item.Balance];
    
    if ([item.Cost characterAtIndex:0] == '-') {
        UIImage *image = [UIImage imageNamed:@"ic_consumption"];
        self.icon.image = image;
    }else {
        UIImage *image = [UIImage imageNamed:@"ic_recharge"];
        self.icon.image = image;
    }
}


+ (CGFloat)bestHeight
{
    return 95;
}

@end
