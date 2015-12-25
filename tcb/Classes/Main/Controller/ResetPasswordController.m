//
//  ResetPasswordController.m
//  tcb
//
//  Created by Jax on 15/11/23.
//  Copyright © 2015年 Jax. All rights reserved.
//


/*
 
 user：13810510619
 pwd：0619
 
 */

#import "ResetPasswordController.h"
#import "ResetPasswordView.h"
#import "APIClientTool.h"
#import "SendCaptcha.h"
#import "ResetPassword.h"
#import "VerifyRegexTool.h"

#define kCaptchaSecond 60   //  每次验证码发送时间时间间隔

@interface ResetPasswordController ()

@property (nonatomic, strong) UITextField *phoneField;
@property (nonatomic, strong) UITextField *captchaField;
@property (nonatomic, strong) UITextField *pwdField;
@property (nonatomic, strong) UITextField *verityPwdField;
@property (nonatomic, strong) UIButton *captchaButton;

@end

@implementation ResetPasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"重置密码";
    
    self.navigationController.navigationBar.backgroundColor = kRGB(249, 251, 251);
    self.view.backgroundColor = kRGB(247, 247, 247);
    [self setUpViews];
}

- (void)setUpViews {
    /****************************手机号*****************************/
    ResetPasswordView *phoneCell = [ResetPasswordView resetPasswordView];
    [self.view addSubview:phoneCell];
    [phoneCell makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top).offset(72);
        make.left.right.equalTo(0);
        make.height.equalTo(44);
    }];
    phoneCell.label.text = @"手机号";
    self.phoneField = phoneCell.textField;
    phoneCell.textField.text = @"13810510619";
    
    UILabel *label = [[UILabel alloc] init];
    [self.view addSubview:label];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneCell.bottom).offset(0);
        make.left.equalTo(5);
        make.height.equalTo(25);
    }];
    label.text = @"请输入短信验证码";
    
    /****************************验证码*****************************/
    UIView *captchaCell = [[UIView alloc] init];
    [self.view addSubview:captchaCell];
    [captchaCell makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.equalTo(label.bottom).offset(0);
        make.height.equalTo(44);
    }];
    captchaCell.backgroundColor = kRGB(255, 255, 255);
    
    UILabel *captchaLabel = [[UILabel alloc] init];
    [captchaCell addSubview:captchaLabel];
    [captchaLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(3);
        make.top.bottom.equalTo(0);
        make.width.equalTo(65);
    }];
    captchaLabel.text = @"验证码";
    captchaLabel.textColor = [UIColor lightGrayColor];
    
    UIButton *captchaButton = [[UIButton alloc] init];
    [captchaCell addSubview:captchaButton];
    [captchaButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(0);
        make.right.equalTo(0);
        make.width.equalTo(120);
    }];
    [captchaButton setTitle:@"发送验证码" forState:UIControlStateNormal];
    [captchaButton setTitleColor:kDefaultBarButtonItemColor forState:UIControlStateNormal];
    captchaButton.titleEdgeInsets = UIEdgeInsetsMake(2, 5, 2, 5);
    [captchaButton addTarget:self action:@selector(sendCaptchaButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.captchaButton = captchaButton;
    
    UIView *lineView = [[UIView alloc] init];
    [captchaCell addSubview:lineView];
    [lineView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(12);
        make.bottom.equalTo(-12);
        make.right.equalTo(captchaButton.left).offset(3);
        make.width.equalTo(0.8);
    }];
    lineView.backgroundColor = [UIColor lightGrayColor];
    
    UITextField *captchaTextField = [[UITextField alloc] init];
    [captchaCell addSubview:captchaTextField];
    [captchaTextField makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(0);
        make.right.equalTo(lineView.left).offset(3);
        make.left.equalTo(captchaLabel.right).offset(3);
    }];
    self.captchaField = captchaTextField;
    
    /****************************新密码*****************************/
    ResetPasswordView *newPwdCell = [ResetPasswordView resetPasswordView];
    [self.view addSubview:newPwdCell];
    newPwdCell.label.text = @"新密码";
    [newPwdCell makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(captchaCell.bottom).offset(5);
        make.left.right.equalTo(0);
        make.height.equalTo(44);
    }];
    self.pwdField = newPwdCell.textField;
    
    /****************************确认密码*****************************/
    UIView *verityPwdCell = [[UIView alloc] init];
    verityPwdCell.backgroundColor = kRGB(255, 255, 255);
    [self.view addSubview:verityPwdCell];
    [verityPwdCell makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(newPwdCell.bottom).offset(0);
        make.left.right.equalTo(0);
        make.height.equalTo(44);
    }];
    
    UILabel *verityPwdLabel = [[UILabel alloc] init];
    [verityPwdCell addSubview:verityPwdLabel];
    [verityPwdLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.offset(0);
        make.left.equalTo(verityPwdCell.left).offset(5);
        make.width.equalTo(85);
    }];
    verityPwdLabel.text = @"确认密码";
    verityPwdLabel.textColor = [UIColor lightGrayColor];
    
    UITextField *verityPwdField = [[UITextField alloc] init];
    [verityPwdCell addSubview:verityPwdField];
    [verityPwdField makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(verityPwdLabel.right).offset(3);
        make.top.right.bottom.equalTo(0);
    }];
    self.verityPwdField = verityPwdField;
    
    /****************************下一步按钮*****************************/
    UIButton *nextButtom = [[UIButton alloc] init];
    [self.view addSubview:nextButtom];
    [nextButtom setTitle:@"下一步" forState:UIControlStateNormal];
    [nextButtom setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextButtom makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(verityPwdCell.bottom).offset(5);
        make.left.equalTo(5);
        make.right.equalTo(-5);
        make.height.equalTo(50);
    }];
    nextButtom.layer.cornerRadius = 5;
    nextButtom.backgroundColor = kRGB(166, 166, 166);
    [nextButtom addTarget:self action:@selector(nextButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 发送验证码
- (void)sendCaptchaButtonClicked:(UIButton *)sender {
    NSLog(@"%@", self.phoneField.text);
    if (self.phoneField.text.length == 0) {
        TCBAlertView *tcbAlertView = [[TCBAlertView alloc] initWithTitle:@"拖车宝" contentText:@"亲,你还没有输入手机号哦" leftButtonTitle:@"取消" rightButtonTitle:@"确定"];
        [tcbAlertView show];
    } else if (![VerifyRegexTool isValidateMobile:self.phoneField.text]) {
        TCBAlertView *tcbAlertView = [[TCBAlertView alloc] initWithTitle:@"拖车宝" contentText:@"亲,你输入的手机号有误哦" leftButtonTitle:@"取消" rightButtonTitle:@"确定"];
        [tcbAlertView show];
    } else  {
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setValue:@"SendVerifyCode" forKey:@"cmd"];
        NSMutableDictionary *data = [NSMutableDictionary dictionary];
        [data setValue:self.phoneField.text forKey:@"mobile"];
        [param setValue:data forKey:@"data"];
        
        [SVProgressHUD showWithStatus:@"验证码发送中" maskType:SVProgressHUDMaskTypeBlack];
        [APIClientTool SendCaptchaWithParam:param success:^(NSDictionary *dict) {
            SendCaptcha *sendCaptcha = [SendCaptcha mj_objectWithKeyValues:dict];
            if (sendCaptcha.ret == 0) {
                [SVProgressHUD dismiss];
                [SVProgressHUD showSuccessWithStatus:@"验证码发送成功"];
                
                //  在这里要控制发送验证码按钮
                //  启动倒计时
                self.captchaButton.enabled = NO;
                [self performSelector:@selector(reflashGetKeyBt:) withObject:[NSNumber numberWithInt:kCaptchaSecond] afterDelay:0];
                
            } else if (sendCaptcha.ret == 1) {
                [SVProgressHUD dismiss];
                TCBAlertView *tcbAlertView = [[TCBAlertView alloc] initWithTitle:@"拖车宝" contentText:sendCaptcha.msg leftButtonTitle:@"取消" rightButtonTitle:@"确定"];
                [tcbAlertView show];
            }
        } failed:^{
            
        }];
    }
}

- (void)nextButtonClicked:(UIButton *)sender {
    TCBLog(@"下一步");
    
    if (self.phoneField.text.length == 0) {
        TCBAlertView *tcbAlertView = [[TCBAlertView alloc] initWithTitle:@"拖车宝" contentText:@"亲,你还没有输入手机号哦" leftButtonTitle:@"取消" rightButtonTitle:@"确定"];
        [tcbAlertView show];
    } else if (![VerifyRegexTool isValidateMobile:self.phoneField.text]) {
        TCBAlertView *tcbAlertView = [[TCBAlertView alloc] initWithTitle:@"拖车宝" contentText:@"亲,你输入的手机号有误哦" leftButtonTitle:@"取消" rightButtonTitle:@"确定"];
        [tcbAlertView show];
    } else if (self.captchaField.text.length == 0) {
        TCBAlertView *tcbAlertView = [[TCBAlertView alloc] initWithTitle:@"拖车宝" contentText:@"亲,你还没有输入验证码哦" leftButtonTitle:@"取消" rightButtonTitle:@"确定"];
        [tcbAlertView show];
    } else if (self.pwdField.text.length == 0) {
        TCBAlertView *tcbAlertView = [[TCBAlertView alloc] initWithTitle:@"拖车宝" contentText:@"亲,你还没有输入密码哦" leftButtonTitle:@"取消" rightButtonTitle:@"确定"];
        [tcbAlertView show];
    } else if (self.verityPwdField.text.length == 0) {
        TCBAlertView *tcbAlertView = [[TCBAlertView alloc] initWithTitle:@"拖车宝" contentText:@"亲,你还没有输入确认密码" leftButtonTitle:@"取消" rightButtonTitle:@"确定"];
        [tcbAlertView show];
    } else if (![self.pwdField isEqual:self.verityPwdField.text]) {
        TCBAlertView *tcbAlertView = [[TCBAlertView alloc] initWithTitle:@"拖车宝" contentText:@"亲,密码和确认密码不一致哦" leftButtonTitle:@"取消" rightButtonTitle:@"确定"];
        [tcbAlertView show];
    } else {
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setValue:@"FindPwd" forKey:@"cmd"];
        NSMutableDictionary *data = [NSMutableDictionary dictionary];
        [param setValue:self.pwdField.text forKey:@"pwd"];
        [param setValue:self.phoneField.text forKey:@"mobile"];
        [param setValue:self.captchaField.text forKey:@"verifyCode"];
        [param setValue:data forKey:@"data"];
        [SVProgressHUD showWithStatus:@"重置密码中" maskType:SVProgressHUDMaskTypeBlack];
        [APIClientTool ResetPwdWithParam:param success:^(NSDictionary *dict) {
            [SVProgressHUD dismiss];
            ResetPassword *resetPassword = [ResetPassword mj_objectWithKeyValues:dict];
            if (resetPassword.ret == 0) {
                [SVProgressHUD showSuccessWithStatus:@"密码重置成功"];
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [SVProgressHUD showSuccessWithStatus:resetPassword.msg];
            }
        } failed:^{
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:@"网络连接失败"];
        }];

    }
    
}

#pragma mark - 倒数计时
//倒数
- (void)reflashGetKeyBt:(NSNumber *)second
{
    if ([second integerValue] == 0) {
        [self.captchaButton setTitle:@"发送验证码" forState:UIControlStateNormal];
        self.captchaButton.enabled = YES;
    }
    else {
        int i = [second intValue];
        [self.captchaButton setTitle:[NSString stringWithFormat:@"%i秒后重发",i] forState:UIControlStateNormal];
        [self performSelector:@selector(reflashGetKeyBt:) withObject:[NSNumber numberWithInt:i -1] afterDelay:1];
    }
    
}

@end
