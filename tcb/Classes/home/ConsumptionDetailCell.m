//
//  ConsumptionDetailCell.m
//  tcb
//
//  Created by Chuanxun on 15/12/15.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import "ConsumptionDetailCell.h"


@interface ConsumptionDetailCell ()

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblContent;

@end

@implementation ConsumptionDetailCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setTitle:(NSString *)title
{
    _title = title;
    self.lblTitle.text = title;
}

-(void)setContent:(NSString *)content
{
    _content = content;
    self.lblContent.text = content;
}

+ (CGFloat)bestHeight
{
    return 49;
}

@end
