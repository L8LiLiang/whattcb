//
//  BoxNoInputController.m
//  tcb
//
//  Created by Chuanxun on 15/11/23.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import "BoxNoInputController.h"

#define BOX_NO_INPUT_MARGIN 16
#define BOX_NO_INPUT_SMALL_MARGIN 8
#define BOX_NO_INPUT_TEXTFIELD_HEIGHT 40
#define BOX_NO_INPUT_SEPARATOR_HEIGHT 16
#define BOX_NO_INPUT_INPUTVIEW_HEIGHT 80
#define BOX_NO_BUTTON_HEIGHT 40

#define BOX_NO_TakePhoto_VoiceRecord_OPENED 1

@interface BoxNoInputController ()
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
}

+(instancetype)controllerWithOrder:(Order *)order
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"BoxNoInputController" bundle:nil];
    BoxNoInputController *controller = [sb instantiateInitialViewController];
    controller.order = order;
    
//    BoxNoInputController *controller = [BoxNoInputController new];
    
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
    
    
    return controller;
}

+ (CGFloat)heightForContentView
{
    return BOX_NO_INPUT_MARGIN * 8 + BOX_NO_INPUT_TEXTFIELD_HEIGHT * 2 + BOX_NO_INPUT_SEPARATOR_HEIGHT * 3 + BOX_NO_BUTTON_HEIGHT + BOX_NO_INPUT_INPUTVIEW_HEIGHT;
}

@end
