//
//  ResetPasswordCell.h
//  tcb
//
//  Created by Jax on 15/11/23.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResetPasswordView : UIView

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UITextField *textField;

+ (instancetype)resetPasswordView;

@end
