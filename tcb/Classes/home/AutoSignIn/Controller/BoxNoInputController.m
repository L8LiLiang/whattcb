//
//  BoxNoInputController.m
//  tcb
//
//  Created by Chuanxun on 15/11/23.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import "BoxNoInputController.h"
#import "ELDispatchOrder.h"
#import <MBProgressHUD.h>

#define BOX_NO_INPUT_TEXTFIELD_MAX_CHAR 11

#define BOX_NO_INPUT_MARGIN 16
#define BOX_NO_INPUT_SMALL_MARGIN 8
#define BOX_NO_INPUT_TEXTFIELD_HEIGHT 40
#define BOX_NO_INPUT_SEPARATOR_HEIGHT 16
#define BOX_NO_INPUT_INPUTVIEW_HEIGHT 80
#define BOX_NO_BUTTON_HEIGHT 40

#define BOX_NO_TakePhoto_VoiceRecord_OPENED 1

@interface BoxNoInputController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *shipName;
@property (weak, nonatomic) IBOutlet UILabel *boxNo;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *titleForShipName;
@property (weak, nonatomic) IBOutlet UILabel *titleForBoxNo;
@property (weak, nonatomic) IBOutlet UILabel *titleForTime;
@property (weak, nonatomic) IBOutlet UILabel *titleForAddress;


@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *seperatorView;


@property (strong, nonatomic) UITextField *boxNoTextField;
@property (strong, nonatomic) UITextField *fenghaoTextField;
@property (strong, nonatomic) UITextView *commentTextView;
@property (strong, nonatomic) UIButton *commitButton;

@property (strong, nonatomic) UIView *contentView;

@end

@implementation BoxNoInputController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    if (iPhone4) {
        self.shipName.font = FONT_SMALL;
        self.boxNo.font = FONT_SMALL;
        self.time.font = FONT_SMALL;
        self.address.font = FONT_SMALL;
        self.titleForShipName.font = FONT_SMALL;
        self.titleForBoxNo.font = FONT_SMALL;
        self.titleForTime.font = FONT_SMALL;
        self.titleForAddress.font = FONT_SMALL;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:self.boxNoTextField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:self.boxNoTextField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:self.fenghaoTextField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:self.fenghaoTextField];
}

- (void)keyboardWillShow:(NSNotification *)notify
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UIView *firstResponder = [keyWindow performSelector:@selector(firstResponder)];
    
    NSDictionary *userinfo = notify.userInfo;
    NSValue *endValue = [userinfo valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect endRect = [endValue CGRectValue];
    
    CGRect firstResponderFrame = [self.view convertRect:firstResponder.frame fromView:self.contentView];
    
    if (endRect.origin.y < CGRectGetMaxY(firstResponderFrame)) {
        NSValue *durationValue = [userinfo valueForKey:UIKeyboardAnimationDurationUserInfoKey];
        NSTimeInterval duration;
        [durationValue getValue:&duration];
        
        [UIView animateWithDuration:duration animations:^{
            self.view.transform = CGAffineTransformMakeTranslation(0, -(CGRectGetMaxY(firstResponderFrame) - endRect.origin.y));
        }];
    }
}

- (void)keyboardWillHide:(NSNotification *)notify
{
    if (!CGAffineTransformIsIdentity(self.view.transform)) {
        NSDictionary *userinfo = notify.userInfo;
        NSValue *durationValue = [userinfo valueForKey:UIKeyboardAnimationDurationUserInfoKey];
        NSTimeInterval duration;
        [durationValue getValue:&duration];
        [UIView animateWithDuration:duration animations:^{
            self.view.transform = CGAffineTransformIdentity;
        }];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBarHidden = NO;
    
    self.shipName.text = self.orderItem.ShipVoyage;
    self.boxNo.text = self.orderItem.ContainerType;
    self.time.text = self.orderItem.AppointDate;
    self.address.text = self.orderItem.FactoryShortName;
    
    self.boxNoTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.fenghaoTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    

}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

+(instancetype)controllerWithOrder:(ELDispatchOrderItem *)item
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"BoxNoInputController" bundle:nil];
    BoxNoInputController *controller = [sb instantiateInitialViewController];
    controller.orderItem = item;
    
    UIColor *backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0];
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [controller.view addSubview:scrollView];
    [scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(controller.seperatorView.bottom);
        make.leading.equalTo(controller.view);
        make.trailing.equalTo(controller.view);
        make.bottom.equalTo(controller.view);
    }];
    
    UIView *contentView = [[UIView alloc] init];
    [scrollView addSubview:contentView];
    controller.contentView = contentView;
    [contentView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView).insets(UIEdgeInsetsZero);
//        make.centerY.equalTo(scrollView);
//        make.centerX.equalTo(scrollView);
        make.width.equalTo(SCREEN_WIDTH);
        make.height.equalTo([self heightForContentView]);
    }];
    
    UITextField *boxNoTextField = [UITextField new];
    boxNoTextField.placeholder = NSLocalizedString(@"Input Box NO Here.", @"请输入箱号");
    boxNoTextField.font = FONT_MIDDLE;
    boxNoTextField.borderStyle = UITextBorderStyleRoundedRect;
    //boxNoTextField.layer.borderWidth = 1.5;
    //boxNoTextField.layer.borderColor = backgroundColor.CGColor;
//    boxNoTextField.layer.shadowColor = [UIColor grayColor].CGColor;
//    boxNoTextField.layer.shadowOffset = CGSizeMake(0, 0.1);
//    boxNoTextField.layer.shadowOpacity = 0.8;
    [contentView addSubview:boxNoTextField];
    [boxNoTextField makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView.top).offset(BOX_NO_INPUT_MARGIN);
        make.left.equalTo(contentView.left).offset(BOX_NO_INPUT_MARGIN);
        make.right.equalTo(contentView.right).offset(-BOX_NO_INPUT_MARGIN);
        make.height.equalTo(BOX_NO_INPUT_TEXTFIELD_HEIGHT);
    }];
    controller.boxNoTextField = boxNoTextField;
    
    
    
    UIView *separatorView1 = [UIView new];
    separatorView1.backgroundColor = backgroundColor;
    [contentView addSubview:separatorView1];
    [separatorView1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(boxNoTextField.bottom).offset(BOX_NO_INPUT_MARGIN);
        make.leading.equalTo(contentView.leading);
        make.trailing.equalTo(contentView.trailing);
        make.height.equalTo(BOX_NO_INPUT_SEPARATOR_HEIGHT);
    }];
    
    
    UITextField *fenghaoTextField = [UITextField new];
    fenghaoTextField.placeholder = NSLocalizedString(@"Input FengHao Here.", @"请输入封号");
    fenghaoTextField.font = FONT_MIDDLE;
    fenghaoTextField.borderStyle = UITextBorderStyleRoundedRect;
    [contentView addSubview:fenghaoTextField];
    [fenghaoTextField makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(contentView.leading).offset(BOX_NO_INPUT_MARGIN);
        make.trailing.equalTo(contentView.trailing).offset(-BOX_NO_INPUT_MARGIN);
        make.top.equalTo(separatorView1.bottom).offset(BOX_NO_INPUT_MARGIN);
        make.height.equalTo(BOX_NO_INPUT_TEXTFIELD_HEIGHT);
    }];
    controller.fenghaoTextField = fenghaoTextField;
    
    
    UIView *separatorView2 = [UIView new];
    separatorView2.backgroundColor = backgroundColor;
    [contentView addSubview:separatorView2];
    [separatorView2 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(fenghaoTextField.bottom).offset(BOX_NO_INPUT_MARGIN);
        make.leading.equalTo(contentView.leading);
        make.trailing.equalTo(contentView.trailing);
        make.height.equalTo(BOX_NO_INPUT_SEPARATOR_HEIGHT);
    }];
    
    
    UILabel *lable = [UILabel new];
    lable.text = @"备\n注";
    lable.numberOfLines = 2;
    lable.textColor = [UIColor grayColor];
    lable.font = FONT_MIDDLE;
    [contentView addSubview:lable];
    [lable makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(contentView.leading).offset(BOX_NO_INPUT_MARGIN);
//        make.height.equalTo(8);
    }];
    
    UITextView *textView = [[UITextView alloc] init];
    [contentView addSubview:textView];
    textView.font = FONT_MIDDLE;
    textView.layer.cornerRadius = 5;
    textView.layer.borderColor = backgroundColor.CGColor;
    textView.layer.borderWidth = 1;
    [textView makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(lable.trailing).offset(BOX_NO_INPUT_MARGIN);
        make.top.equalTo(separatorView2.bottom).offset(BOX_NO_INPUT_MARGIN);
        make.trailing.equalTo(contentView.trailing).offset(-BOX_NO_INPUT_MARGIN);
        make.height.equalTo(BOX_NO_INPUT_INPUTVIEW_HEIGHT);
        make.centerY.equalTo(lable);
    }];
    controller.commentTextView = textView;
    
    
    UIView *separatorView3 = [UIView new];
    separatorView3.backgroundColor = backgroundColor;
    [contentView addSubview:separatorView3];
    [separatorView3 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textView.bottom).offset(BOX_NO_INPUT_MARGIN);
        make.leading.equalTo(contentView.leading);
        make.trailing.equalTo(contentView.trailing);
        make.height.equalTo(BOX_NO_INPUT_SEPARATOR_HEIGHT);
    }];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    NSString *title = NSLocalizedString(@"commit", @"提交");
    [button setTitle:title forState:UIControlStateNormal];
    button.layer.cornerRadius = 4;
    [contentView addSubview:button];
    //18 141 255
    UIColor *btnBackgroundColor = [UIColor colorWithRed:18/255.0 green:141/255.0 blue:1.0 alpha:1.0];
    [button setBackgroundColor:btnBackgroundColor];
    [button makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(contentView).offset(BOX_NO_INPUT_MARGIN);
        make.trailing.equalTo(contentView).offset(-BOX_NO_INPUT_MARGIN);
        make.height.equalTo(BOX_NO_BUTTON_HEIGHT);
        make.top.equalTo(separatorView3.bottom).offset(BOX_NO_INPUT_MARGIN);
    }];
    controller.commitButton = button;
    button.enabled = NO;
    [button addTarget:controller action:@selector(commit:) forControlEvents:UIControlEventTouchUpInside];
    
    [boxNoTextField addTarget:controller action:@selector(textFieldEndEdit:) forControlEvents:UIControlEventEditingDidEnd];
    boxNoTextField.delegate = controller;
    [fenghaoTextField addTarget:controller action:@selector(textFieldEndEdit:) forControlEvents:UIControlEventEditingDidEnd];
    fenghaoTextField.delegate = controller;
    
    
    
    return controller;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (string.length == 0) return YES;
    
    NSInteger existedLength = textField.text.length;
    NSInteger selectedLength = range.length;
    NSInteger replaceLength = string.length;
    
    int maxLen;
    
    if (textField == self.boxNoTextField) {
        maxLen = BOX_NO_INPUT_TEXTFIELD_MAX_CHAR;
    }else if (textField == self.fenghaoTextField) {
        maxLen = 10;
    }

    if (existedLength - selectedLength + replaceLength > maxLen) {
        return NO;
    }
    
    return YES;
}


#pragma mark - Functions

- (void)textFieldEndEdit:(UITextField *)textField
{
    if (textField == self.boxNoTextField) {
        if (textField.text.length > BOX_NO_INPUT_TEXTFIELD_MAX_CHAR) {
            textField.text = [textField.text substringToIndex:BOX_NO_INPUT_TEXTFIELD_MAX_CHAR];
        }
        
        if (![self isBoxNoLegal:textField.text]) {
            if ([self isBoxNoAcceptable:textField.text]) {
                [self showInfo:@"箱号不完全符合规则，但是可以尝试使用"];
            }else {
                [self showInfo:@"箱号格式错误，请重新输入"];
            }
        }
    }
    
    if (textField == self.fenghaoTextField) {
        if (textField.text.length > 10) {
            textField.text = [textField.text substringToIndex:10];
        }
        if (![self isFenghaoLegal:textField.text]) {
            [self showInfo:@"封号格式错误"];
        }
    }
    
    if (([self isBoxNoLegal:self.boxNoTextField.text] || [self isBoxNoAcceptable:self.boxNoTextField.text]) &&
        [self isFenghaoLegal:self.fenghaoTextField.text]) {
        self.commitButton.enabled = YES;
    }else {
        self.commitButton.enabled = NO;
    }
}

- (void)showInfo:(NSString *)msg
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow];
    hud.mode = MBProgressHUDModeText;
    hud.animationType = MBProgressHUDAnimationFade;
    hud.labelText = msg;
    hud.removeFromSuperViewOnHide = YES;
    [[UIApplication sharedApplication].keyWindow addSubview:hud];
    [hud show:YES];
    [hud hide:YES afterDelay:1.5];
}

- (BOOL)isFenghaoLegal:(NSString *)fenghao
{
    if (fenghao.length != 10) {
        return NO;
    }
    
    for (int i = 0; i < 10; i++) {
        unichar c = [fenghao characterAtIndex:i];
        if (!isalnum(c) && ! (c == '_')) {
            return NO;
        }
    }
    
    return YES;
}

- (BOOL)isBoxNoLegal:(NSString *)boxNo
{
    
    if (boxNo.length != BOX_NO_INPUT_TEXTFIELD_MAX_CHAR) {
        return NO;
    }

    NSDictionary *charToWeightDict = @{@"A":@10,
                                       @"B":@12,
                                       @"C":@13,
                                       @"D":@14,
                                       @"E":@15,
                                       @"F":@16,
                                       @"G":@17,
                                       @"H":@18,
                                       @"I":@19,
                                       @"J":@20,
                                       @"K":@21,
                                       @"L":@23,
                                       @"M":@24,
                                       @"N":@25,
                                       @"O":@26,
                                       @"P":@27,
                                       @"Q":@28,
                                       @"R":@29,
                                       @"S":@30,
                                       @"T":@31,
                                       @"U":@32,
                                       @"V":@34,
                                       @"W":@35,
                                       @"X":@36,
                                       @"Y":@37,
                                       @"Z":@38
                                       };
    
    int sum = 0;
    boxNo = [boxNo uppercaseString];NSLog(@"upper %@",boxNo);
    for (NSInteger i = 0; i < 4; i ++) {
        unichar charAtIndex = [boxNo characterAtIndex:i];
        if (charAtIndex < 65 || charAtIndex > 90) {
            return NO;
        }
        NSString *key = [NSString stringWithFormat:@"%c",charAtIndex];
        int value = [[charToWeightDict objectForKey:key] intValue];
        sum += value * pow(2, i);
    }
    
    for (NSInteger i = 4; i < BOX_NO_INPUT_TEXTFIELD_MAX_CHAR - 1; i ++) {
        unichar charAtIndex = [boxNo characterAtIndex:i];
        if (charAtIndex < 48 || charAtIndex > 57) {
            return NO;
        }
        sum += (charAtIndex - '0') * pow(2, i);
    }
    
//    NSLog(@"%d,%d",sum,sum % BOX_NO_INPUT_TEXTFIELD_MAX_CHAR);
    
    NSString *charAtIndex = [boxNo substringFromIndex:BOX_NO_INPUT_TEXTFIELD_MAX_CHAR - 1];
    NSString *sumStr = [NSString stringWithFormat:@"%d",sum % BOX_NO_INPUT_TEXTFIELD_MAX_CHAR];
    
    if ([charAtIndex isEqualToString:sumStr]) {
        return YES;
    }
    
    return NO;
}

- (BOOL)isBoxNoAcceptable:(NSString *)boxNo
{
    if (boxNo.length != BOX_NO_INPUT_TEXTFIELD_MAX_CHAR) {
        return NO;
    }
    
    for (int i = 0; i < 4; i++) {
        unichar charAtIndex = [boxNo characterAtIndex:i];
        if (!isalpha(charAtIndex)) {
            return NO;
        }
    }
    
    for (int i = 4; i < BOX_NO_INPUT_TEXTFIELD_MAX_CHAR; i++) {
        unichar charAtIndex = [boxNo characterAtIndex:i];
        if (!isdigit(charAtIndex)) {
            return NO;
        }
    }
    
    return YES;
}

- (void)commit:(UIButton *)sender
{
        
    NSDictionary *dict = @{@"cmd":@"SaveContainerNoAndSealNo",
                           @"data":@{@"dispCode":self.orderItem.DispCode,
                                     @"containerNo":self.boxNoTextField.text,
                                     @"sealNo":self.fenghaoTextField.text}};
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:dict];
    [APIClientTool saveContainerNoAndSealNoWithParam:params success:^(NSDictionary *dict) {
        NSLog(@"%@",dict);
        int rtn = [[dict valueForKey:@"ret"] intValue];
        if (rtn == 0) {
            [self showInfo:@"succeeded!"];
        }else {
            [self showInfo:[dict objectForKey:@"msg"]];
        }
    } failed:^{
        [self showInfo:@"网络异常"];
    }];
}

+ (CGFloat)heightForContentView
{
    return BOX_NO_INPUT_MARGIN * 8 + BOX_NO_INPUT_TEXTFIELD_HEIGHT * 2 + BOX_NO_INPUT_SEPARATOR_HEIGHT * 3 + BOX_NO_BUTTON_HEIGHT + BOX_NO_INPUT_INPUTVIEW_HEIGHT;
}

@end
