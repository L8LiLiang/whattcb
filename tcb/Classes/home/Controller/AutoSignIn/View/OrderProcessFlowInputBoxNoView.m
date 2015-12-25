//
//  OrderProcessFlowInputBoxNoView.m
//  tcb
//
//  Created by Chuanxun on 15/11/20.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import "OrderProcessFlowInputBoxNoView.h"


#define BOX_NO_VIEW_HEIGHT 50
#define BOX_NO_VIEW_ICON_WIDTH 40
#define BOX_NO_VIEW_TEXTFIELD_HEIGHT 40

@interface OrderProcessFlowInputBoxNoView ()

@property (weak, nonatomic) UIButton *button;
@property (weak, nonatomic) UIImageView *icon;
@property (weak, nonatomic) UILabel *label;

@end

@implementation OrderProcessFlowInputBoxNoView

+(instancetype)boxNoView
{
    OrderProcessFlowInputBoxNoView *view = [OrderProcessFlowInputBoxNoView new];
    
    UIImage *image = [UIImage imageNamed:@"signIn_btn_back_green"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [view addSubview:button];
    view.button = button;
    [button addTarget:view action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *iconView = [[UIImageView alloc] init];
    UIImage *iconImage = [UIImage imageNamed:@"ic_date_blue"];
    iconView.image = iconImage;
    view.icon =iconView;
    [view addSubview:iconView];
    
    UILabel *label = [UILabel new];
    NSString *tip = NSLocalizedString(@"click to input box no", @"点击录入封柜号");
    label.text = tip;
    label.font = FONT_MIDDLE;
    view.label = label;
    [view addSubview:label];
    
    
    return view;
}

-(CGFloat)estimatedHeightWithWidth:(CGFloat)width
{
    return BOX_NO_VIEW_HEIGHT;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.button.frame = self.bounds;
    
    CGFloat iconX,iconY,iconW,iconH;
    iconX = 16;
    iconY = (BOX_NO_VIEW_HEIGHT - BOX_NO_VIEW_ICON_WIDTH)/2.0;
    iconW = BOX_NO_VIEW_ICON_WIDTH;
    iconH = BOX_NO_VIEW_ICON_WIDTH;
    self.icon.frame = CGRectMake(iconX, iconY, iconW, iconH);
    
    CGFloat textFieldX,textFieldY,textFieldW,textFieldH;
    textFieldX = iconX + BOX_NO_VIEW_ICON_WIDTH;
    textFieldY = (BOX_NO_VIEW_HEIGHT - BOX_NO_VIEW_TEXTFIELD_HEIGHT)/2.0;
    textFieldW = self.frame.size.width - textFieldX - 8;
    textFieldH = BOX_NO_VIEW_TEXTFIELD_HEIGHT;
    self.label.frame = CGRectMake(textFieldX, textFieldY, textFieldW, textFieldH);
}

- (void)btnClicked:(UIButton *)sender
{
    NSLog(@"fengguihaoluru");
    if ([self.delegate respondsToSelector:@selector(inputBoxNoView:btnClicked:)]) {
        [self.delegate inputBoxNoView:self btnClicked:sender];
    }
}

@end
