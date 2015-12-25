//
//  LoginViewController.m
//  ;
//
//  Created by Jax on 15/11/10.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import "LoginViewController.h"
#import "TCBTabBarController.h"
#import "ResetPasswordController.h"


#import "APIClientTool.h"
#import "LoginData.h"
#import "ConfigTool.h"
#import "AutoSigninManager.h"
#import <AFNetworking.h>
#import "HomeViewController.h"

@interface LoginViewController ()

/**
 *  司机、车队按钮
 */
@property (nonatomic, strong) UIButton *driverButton;
@property (nonatomic, strong) UIButton *fleetButton;

@property (nonatomic, strong) UIButton *loginButton;
/**
 *  用户名、密码输入框
 */
@property (nonatomic, strong) UITextField *userTextField;
@property (nonatomic, strong) UITextField *pwdTextField;
@property (nonatomic, strong) UIButton *rememberPwdBtn;

/**
 *  司机:1, 车队:2
 */
@property (nonatomic, assign) NSInteger role;

@property (nonatomic, strong) TCBTabBarController *tcbTabBarController;

@end

@implementation LoginViewController

#pragma mark - view生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = ThemeColor;
    self.title = @"欢迎回来";
    
    //  创建视图
    [self setUpSubViews];
    
}

- (void)setUpSubViews {
    
//    NSUserDefaults *defaults =  [NSUserDefaults standardUserDefaults];
//    [defaults setValue:@"" forKey:@"Authorization"];
//    //                [defaults setValue:[NSNumber numberWithInteger:data.role] forKey:@"kRole"];
//    [defaults synchronize];
//    

    /** -----------topView----------- **/
    UIView *topView = [[UIView alloc] init];
    [self.view addSubview:topView];
    [topView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top).offset(64);
        make.left.equalTo(self.view.left).offset(0);
        make.right.equalTo(self.view.right).offset(0);
        make.height.equalTo(150);
    }];
    //  头像
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tuoche"]];
    [topView addSubview:imgView];
    [imgView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.top).offset(25);
        make.bottom.equalTo(topView.bottom).offset(-25);
        make.width.equalTo(100);
        make.height.equalTo(100);
        make.left.equalTo((SCREEN_WIDTH - 80) / 2.0);
    }];

    /** -----------middleView----------- **/
    UIView *middleView = [[UIView alloc] init];
    middleView.layer.cornerRadius = 5;
    middleView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:middleView];
    [middleView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.bottom).offset(0);
        make.left.equalTo(self.view.left).offset(15);
        make.right.equalTo(self.view.right).offset(-15);
        make.height.equalTo(91);
    }];
    //  用户名
    UIImageView *userImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"user"]];
    [middleView addSubview:userImg];
    [userImg makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(middleView.top).offset(15);
        make.left.equalTo(middleView.left).offset(8);
        make.height.equalTo(16);
        make.width.equalTo(16);
    }];

    UITextField *userTextField = [[UITextField alloc] init];
    self.userTextField = userTextField;
    [middleView addSubview:userTextField];
    [userTextField makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(middleView.top).offset(0);
        make.left.equalTo(userImg.right).offset(8);
        make.right.equalTo(middleView.right).offset(0);
        make.height.equalTo(45);
    }];
    userTextField.placeholder = @"请输入用户名";
    
    UIView *lineView = [[UIView alloc] init];
    [middleView addSubview:lineView];
    [lineView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(userTextField.bottom).offset(0);
        make.left.equalTo(middleView.left).offset(0);
        make.right.equalTo(middleView.right).offset(0);
        make.height.equalTo(1);
    }];
    lineView.backgroundColor = [UIColor lightGrayColor];
    
    //  密码
    UIImageView *pwdImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"password"]];
    [middleView addSubview:pwdImg];
    [pwdImg makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.bottom).offset(15);
        make.left.equalTo(middleView.left).offset(8);
        make.height.equalTo(16);
        make.width.equalTo(16);
    }];
    
    UITextField *pwdTextField = [[UITextField alloc] init];
    self.pwdTextField = pwdTextField;
    [middleView addSubview:pwdTextField];
    [pwdTextField makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.bottom).offset(0);
        make.left.equalTo(pwdImg.right).offset(8);
        make.right.equalTo(middleView.right).offset(0);
        make.height.equalTo(45);
    }];
    pwdTextField.placeholder = @"请输入密码";
    pwdTextField.secureTextEntry = YES;
    
    /** -----------bottomView----------- **/
    UIView *bottomView = [[UIView alloc] init];
    [self.view addSubview:bottomView];
    [bottomView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(middleView.bottom).offset(0);
        make.left.equalTo(self.view.left).offset(0);
        make.right.equalTo(self.view.right).offset(0);
        make.height.equalTo(200);
    }];
    
    self.role = 1;
    
    //  登陆按钮
    UIButton *loginButton = [[UIButton alloc] init];
    self.loginButton = loginButton;
    [bottomView addSubview:loginButton];
    [loginButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pwdTextField.bottom).offset(15);
        make.left.equalTo(self.view.left).offset(15);
        make.right.equalTo(self.view.right).offset(-15);
        make.height.equalTo(45);
    }];
    [loginButton setTitle:@"登陆" forState:UIControlStateNormal];
    [loginButton setBackgroundColor:kDefaultBarButtonItemColor];
    [loginButton addTarget:self action:@selector(loginBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    //  记住密码，忘记密码
    UIButton *rememberPwdBtn = [[UIButton alloc] init];
    [bottomView addSubview:rememberPwdBtn];
    [rememberPwdBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(loginButton.bottom).offset(10);
        make.left.equalTo(self.view.left).offset(30);
        make.width.equalTo(100);
        make.height.equalTo(40);
    }];
    [rememberPwdBtn setTitle:@" 记住密码" forState:UIControlStateNormal];
    [rememberPwdBtn setImage:[UIImage imageNamed:@"check_normal"] forState:UIControlStateNormal];
    [rememberPwdBtn setImage:[UIImage imageNamed:@"check_selected"] forState:UIControlStateSelected];
    [rememberPwdBtn setTitleColor:kDefaultBarButtonItemColor forState:UIControlStateNormal];
    [rememberPwdBtn addTarget:self action:@selector(rememberPwdBtnOnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.rememberPwdBtn = rememberPwdBtn;
    NSInteger rememberPwd = [[[NSUserDefaults standardUserDefaults] valueForKey:@"rememberPwd"] integerValue];
    if (rememberPwd == 100) {
        self.rememberPwdBtn.selected = YES;
    }
    if (rememberPwd == -100) {
        self.rememberPwdBtn.selected = NO;
    }
    
    UIButton *resetBtn = [[UIButton alloc] init];
    [bottomView addSubview:resetBtn];
    [resetBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(loginButton.bottom).offset(10);
        make.width.equalTo(100);
        make.right.equalTo(self.view.right).offset(-30);
        make.height.equalTo(40);
    }];
    [resetBtn setTitle:@" 忘记密码?" forState:UIControlStateNormal];
    [resetBtn setTitleColor:kDefaultBarButtonItemColor forState:UIControlStateNormal];
    [resetBtn addTarget:self action:@selector(resetBtnClicked:) forControlEvents:UIControlEventTouchUpInside];

  
    NSArray *accountAndPassword =  [ConfigTool getOwnAccountAndPassword];
    if (accountAndPassword.count > 0) {
        self.userTextField.text = [accountAndPassword firstObject];
        self.pwdTextField.text = [accountAndPassword objectAtIndex:1];
    }
    
    if ([self.source isEqualToString:@"自动登入"]) {
        [self login];
    }
    
}

#pragma mark - 登陆，注册，记住密码

- (void)login {
    [self.userTextField resignFirstResponder];
    [self.pwdTextField resignFirstResponder];
    NSLog(@"%@", self.userTextField.text);
    
    
    
    
    
    
    if (self.userTextField.text.length == 0) {
        TCBAlertView *tcbAlertView = [[TCBAlertView alloc] initWithTitle:@"拖车宝" contentText:@"亲,你还没有输入账号哦" leftButtonTitle:@"取消" rightButtonTitle:@"确定"];
        [tcbAlertView show];
    } else if (self.pwdTextField.text.length == 0) {
        TCBAlertView *tcbAlertView = [[TCBAlertView alloc] initWithTitle:@"拖车宝" contentText:@"亲,你还没有输入密码哦" leftButtonTitle:@"取消" rightButtonTitle:@"确定"];
        [tcbAlertView show];
    } else {
        //158 1099 1997
        NSMutableDictionary *loginParam = [NSMutableDictionary dictionary];
        [loginParam setValue:@"Login" forKey:@"cmd"];
        NSMutableDictionary *dataParam = [NSMutableDictionary dictionary];
        [dataParam setValue:self.userTextField.text forKeyPath:@"user"];
        [dataParam setValue:self.pwdTextField.text forKeyPath:@"pwd"];
        //        [dataParam setValue:@"18576472748" forKeyPath:@"user"];
        //        [dataParam setValue:@"111111" forKeyPath:@"pwd"];
        [dataParam setValue:[NSNumber numberWithInteger:self.role] forKeyPath:@"role"];
        [dataParam setValue:@"" forKeyPath:@"deviceId"];
        [loginParam setValue:dataParam forKey:@"data"];
        
        [SVProgressHUD showWithStatus:@"登录中" maskType:SVProgressHUDMaskTypeBlack];
        [APIClientTool LoginWithParam:loginParam success:^(NSDictionary *dict) {
            [SVProgressHUD dismiss];
            LoginData *loginData = [LoginData mj_objectWithKeyValues:dict];
            if (loginData.ret == 0) {
                data *data = loginData.data;
                NSString *token = data.token;
                NSUserDefaults *defaults =  [NSUserDefaults standardUserDefaults];
                [defaults setValue:token forKey:@"Authorization"];
                [defaults synchronize];
                
                if (self.rememberPwdBtn.selected) {
                    //  记住密码用 sskeychain 保存账户和密码
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setValue:@100 forKey:@"rememberPwd"];
                    [defaults synchronize];
                    [ConfigTool saveUserAccount:self.userTextField.text andPassword:self.pwdTextField.text];
                    [ConfigTool setLoginStatus:YES];
                } else {
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setValue:@-100 forKey:@"rememberPwd"];
                    [defaults synchronize];
                    [ConfigTool deletePasswordAndUsername];
                }
                
                /* 登陆成功发送deviceToken给推送服务器 */
                NSString *deviceToken = [defaults objectForKey:@"deviceToken"];
                if ([deviceToken isEqualToString:@""]) {
                    
                } else {
                    
                    NSMutableDictionary *param = [NSMutableDictionary dictionary];
                    [param setValue:self.userTextField.text forKey:@"uid"];
                    [param setValue:[[NSBundle mainBundle] bundleIdentifier] forKey:@"appid"];
                    [param setValue:@0 forKey:@"devicetype"];
                    [param setValue:deviceToken forKey:@"devicetoken"];
                    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                    //  设置超时
                    [manager.requestSerializer setTimeoutInterval:30.0f];
                    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
                    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
                    manager.requestSerializer = [AFJSONRequestSerializer serializer];
                    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"text/html", @"application/json", nil];
                    NSString *url = @"http://push.shipxy.com/regdevice.ashx";
                    
                    [manager GET:url parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
                        
                    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        NSLog(@"responseObject == %@", responseObject);
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        
                    }];
                    
                }
                
                UIWindow *window = [UIApplication sharedApplication].keyWindow;
                TCBTabBarController *tcbTabBarController = [[TCBTabBarController alloc] init];
                self.tcbTabBarController = tcbTabBarController;
                window.rootViewController = [TCBTabBarController new];
                
                [[AutoSigninManager sharedManager] autoSignIn];
                
            } else {
                TCBAlertView *tcbAlertView = [[TCBAlertView alloc] initWithTitle:@"拖车宝" contentText:loginData.msg leftButtonTitle:@"取消" rightButtonTitle:@"确定"];
                [tcbAlertView show];
            }
            
        } failed:^{
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:@"网络接连失败"];
        }];
    }
}



- (void)loginBtnClicked:(UIButton *)sender {
    
    [self.userTextField resignFirstResponder];
    [self.pwdTextField resignFirstResponder];
    NSLog(@"%@", self.userTextField.text);
    
    
    
    
    
    
    if (self.userTextField.text.length == 0) {
        TCBAlertView *tcbAlertView = [[TCBAlertView alloc] initWithTitle:@"拖车宝" contentText:@"亲,你还没有输入账号哦" leftButtonTitle:@"取消" rightButtonTitle:@"确定"];
        [tcbAlertView show];
    } else if (self.pwdTextField.text.length == 0) {
        TCBAlertView *tcbAlertView = [[TCBAlertView alloc] initWithTitle:@"拖车宝" contentText:@"亲,你还没有输入密码哦" leftButtonTitle:@"取消" rightButtonTitle:@"确定"];
        [tcbAlertView show];
    } else {
   //158 1099 1997
        NSMutableDictionary *loginParam = [NSMutableDictionary dictionary];
        [loginParam setValue:@"Login" forKey:@"cmd"];
        NSMutableDictionary *dataParam = [NSMutableDictionary dictionary];
        [dataParam setValue:self.userTextField.text forKeyPath:@"user"];
        [dataParam setValue:self.pwdTextField.text forKeyPath:@"pwd"];
//        [dataParam setValue:@"18576472748" forKeyPath:@"user"];
//        [dataParam setValue:@"111111" forKeyPath:@"pwd"];
        [dataParam setValue:[NSNumber numberWithInteger:self.role] forKeyPath:@"role"];
        [dataParam setValue:@"" forKeyPath:@"deviceId"];
        [loginParam setValue:dataParam forKey:@"data"];
     
        [SVProgressHUD showWithStatus:@"登录中" maskType:SVProgressHUDMaskTypeBlack];
        [APIClientTool LoginWithParam:loginParam success:^(NSDictionary *dict) {
            [SVProgressHUD dismiss];
            LoginData *loginData = [LoginData mj_objectWithKeyValues:dict];
            if (loginData.ret == 0) {
                data *data = loginData.data;
                NSString *token = data.token;
                NSUserDefaults *defaults =  [NSUserDefaults standardUserDefaults];
                [defaults setValue:token forKey:@"Authorization"];
                [defaults synchronize];
                
                if (self.rememberPwdBtn.selected) {
                    //  记住密码用 sskeychain 保存账户和密码
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setValue:@100 forKey:@"rememberPwd"];
                    [defaults synchronize];
                    [ConfigTool saveUserAccount:self.userTextField.text andPassword:self.pwdTextField.text];
                    [ConfigTool setLoginStatus:YES];
                } else {
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setValue:@-100 forKey:@"rememberPwd"];
                    [defaults synchronize];
                    [ConfigTool deletePasswordAndUsername];
                }
                
                /* 登陆成功发送deviceToken给推送服务器 */
                NSString *deviceToken = [defaults objectForKey:@"deviceToken"];
                if ([deviceToken isEqualToString:@""]) {
                    
                } else {
                    
                    NSMutableDictionary *param = [NSMutableDictionary dictionary];
                    [param setValue:self.userTextField.text forKey:@"uid"];
                    [param setValue:[[NSBundle mainBundle] bundleIdentifier] forKey:@"appid"];
                    [param setValue:@0 forKey:@"devicetype"];
                    [param setValue:deviceToken forKey:@"devicetoken"];
                    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                    //  设置超时
                    [manager.requestSerializer setTimeoutInterval:30.0f];
                    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
                    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
                    manager.requestSerializer = [AFJSONRequestSerializer serializer];
                    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"text/html", @"application/json", nil];
                    NSString *url = @"http://push.shipxy.com/regdevice.ashx";
                    
                    [manager GET:url parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
                        
                    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        NSLog(@"responseObject == %@", responseObject);
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        
                    }];
                    
                }

                UIWindow *window = [UIApplication sharedApplication].keyWindow;
                TCBTabBarController *tcbTabBarController = [[TCBTabBarController alloc] init];
                self.tcbTabBarController = tcbTabBarController;
                window.rootViewController = [TCBTabBarController new];
        
                [[AutoSigninManager sharedManager] autoSignIn];
        
            } else {
                TCBAlertView *tcbAlertView = [[TCBAlertView alloc] initWithTitle:@"拖车宝" contentText:loginData.msg leftButtonTitle:@"取消" rightButtonTitle:@"确定"];
                [tcbAlertView show];
            }
      
        } failed:^{
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:@"网络接连失败"];
        }];
    }
    
}

- (void)rememberPwdBtnOnClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
}

- (void)resetBtnClicked:(UIButton *)sender {
    ResetPasswordController *resetPasswordController = [[ResetPasswordController alloc] init];
    [self.navigationController pushViewController:resetPasswordController animated:YES];
}

@end
