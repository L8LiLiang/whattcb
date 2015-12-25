//
//  ResetPasswordCell.m
//  tcb
//
//  Created by Jax on 15/11/23.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import "ResetPasswordView.h"

@implementation ResetPasswordView

+ (instancetype)resetPasswordView {
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = kRGB(255, 255, 255);
        
        UILabel *label = [[UILabel alloc] init];
        [self addSubview:label];
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.offset(0);
            make.left.equalTo(self.left).offset(5);
            make.width.equalTo(56);
        }];
        self.label = label;
        label.textColor = [UIColor lightGrayColor];
        
        UITextField *textField = [[UITextField alloc] init];
        self.textField = textField;
        [self addSubview:textField];
        [textField makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(label.right).offset(3);
            make.top.right.bottom.equalTo(0);
        }];
    }
    return self;
}

@end
