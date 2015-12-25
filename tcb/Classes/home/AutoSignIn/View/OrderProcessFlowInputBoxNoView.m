//
//  OrderProcessFlowInputBoxNoView.m
//  tcb
//
//  Created by Chuanxun on 15/11/20.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import "OrderProcessFlowInputBoxNoView.h"


#define BOX_NO_VIEW_HEIGHT [self viewHeight]
#define BOX_NO_VIEW_ICON_WIDTH 40
#define BOX_NO_VIEW_TEXTFIELD_HEIGHT 40

#define BOX_NO_VIEW_MARGIN 8
#define BOX_NO_VIEW_LEFT_MARGIN 16
#define BOX_NO_VIEW_FONT [UIFont systemFontOfSize:16]

@interface OrderProcessFlowInputBoxNoView ()

@property (weak, nonatomic) UIButton *button;
@property (weak, nonatomic) UIImageView *icon;
@property (weak, nonatomic) UILabel *label;

@property (weak, nonatomic) UILabel *guihao;
@property (weak, nonatomic) UILabel *guihao2;
@property (weak, nonatomic) UILabel *fenghao;
@property (weak, nonatomic) UILabel *fenghao2;
@property (weak, nonatomic) UILabel *date;
@property (weak, nonatomic) UILabel *date2;
@end

@implementation OrderProcessFlowInputBoxNoView

- (CGFloat)viewHeight{
    if (self.status == InputBoxNoViewStatus_DisplayNo) {
        return 80;
    }
    return 50;
}

+(instancetype)boxNoViewWithStatus:(InputBoxNoViewStatus)status
{
    OrderProcessFlowInputBoxNoView *view = [OrderProcessFlowInputBoxNoView new];
    
//    UIImage *image = [UIImage imageNamed:@"signIn_btn_back_gray"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [button setBackgroundImage:image forState:UIControlStateNormal];
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
    label.font = BOX_NO_VIEW_FONT;
    view.label = label;
    [view addSubview:label];
    
    UILabel *guihao = [UILabel new];
    NSString *guihaoText = NSLocalizedString(@"ContainerNo:", @"柜号");
    guihao.text = guihaoText;
    [view addSubview:guihao];
    view.guihao = guihao;
    guihao.font = BOX_NO_VIEW_FONT;
    
    UILabel *guihao2 = [UILabel new];
    [view addSubview:guihao2];
    view.guihao2 = guihao2;
    guihao2.font = BOX_NO_VIEW_FONT;
    
    UILabel *fenghao = [UILabel new];
    NSString *fenghaoText = NSLocalizedString(@"SealNo:", @"封号");
    fenghao.text = fenghaoText;
    [view addSubview:fenghao];
    view.fenghao = fenghao;
    fenghao.font = BOX_NO_VIEW_FONT;
    
    UILabel *fenghao2 = [UILabel new];
    [view addSubview:fenghao2];
    view.fenghao2 = fenghao2;
    fenghao2.font = BOX_NO_VIEW_FONT;
    
    UILabel *date = [UILabel new];
    [view addSubview:date];
    NSString *dateText = NSLocalizedString(@"Date:", @"封号");
    date.text = dateText;
    view.date = date;
    date.font = BOX_NO_VIEW_FONT;
    
    UILabel *date2 = [UILabel new];
    [view addSubview:date2];
    view.date2 = date2;
    date2.font = BOX_NO_VIEW_FONT;
    
    view.status = status;
    
    return view;
}

-(instancetype)initWithStatus:(InputBoxNoViewStatus)status
{
    if (self = [super init]) {
        //    UIImage *image = [UIImage imageNamed:@"signIn_btn_back_gray"];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        //    [button setBackgroundImage:image forState:UIControlStateNormal];
        [self addSubview:button];
        self.button = button;
        [button addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *iconView = [[UIImageView alloc] init];
        UIImage *iconImage = [UIImage imageNamed:@"ic_date_blue"];
        iconView.image = iconImage;
        self.icon =iconView;
        [self addSubview:iconView];
        
        UILabel *label = [UILabel new];
        NSString *tip = NSLocalizedString(@"click to input box no", @"点击录入封柜号");
        label.text = tip;
        label.font = FONT_MIDDLE;
        self.label = label;
        [self addSubview:label];
        
        UILabel *guihao = [UILabel new];
        NSString *guihaoText = NSLocalizedString(@"ContainerNo:", @"柜号");
        guihao.text = guihaoText;
        [self addSubview:guihao];
        self.guihao = guihao;
        
        UILabel *guihao2 = [UILabel new];
        [self addSubview:guihao2];
        self.guihao2 = guihao2;
        
        UILabel *fenghao = [UILabel new];
        NSString *fenghaoText = NSLocalizedString(@"SealNo:", @"封号");
        fenghao.text = fenghaoText;
        [self addSubview:fenghao];
        self.fenghao = fenghao;
        
        UILabel *fenghao2 = [UILabel new];
        [self addSubview:fenghao2];
        self.fenghao2 = fenghao2;
        
        UILabel *date = [UILabel new];
        NSString *dateText = NSLocalizedString(@"Date:", @"封号");
        date.text = dateText;
        [self addSubview:date];
        self.date = date;
        date.font = BOX_NO_VIEW_FONT;
        
        UILabel *date2 = [UILabel new];
        [self addSubview:date2];
        self.date2 = date2;
        date2.font = BOX_NO_VIEW_FONT;
        
        _status = status;
 
    }
    
    return self;
}


-(CGFloat)estimatedHeightWithWidth:(CGFloat)width
{
    return BOX_NO_VIEW_HEIGHT;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.button.frame = self.bounds;

    if (self.status == InputBoxNoViewStatus_NeedInput) {
        
        CGFloat iconX,iconY,iconW,iconH;
        iconX = BOX_NO_VIEW_LEFT_MARGIN;
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
        
    }else {
        
        CGFloat guihaoX,guihaoY,guihaoW,guihaoH;
        guihaoX = BOX_NO_VIEW_LEFT_MARGIN;
        guihaoY = BOX_NO_VIEW_MARGIN;
        guihaoW = 60;
        guihaoH = (BOX_NO_VIEW_HEIGHT - 4*BOX_NO_VIEW_MARGIN) / 3.0;
        self.guihao.frame = CGRectMake(guihaoX, guihaoY, guihaoW, guihaoH);
        
        CGFloat guihao2X,guihao2Y,guihao2W,guihao2H;
        guihao2X = guihaoX + guihaoW + BOX_NO_VIEW_MARGIN;
        guihao2Y = guihaoY;
        guihao2W = self.frame.size.width - guihaoW - BOX_NO_VIEW_MARGIN * 3;
        guihao2H = guihaoH;
        self.guihao2.frame = CGRectMake(guihao2X, guihao2Y, guihao2W, guihao2H);
        
        
        CGFloat fenghaoX,fenghaoY,fenghaoW,fenghaoH;
        fenghaoX = BOX_NO_VIEW_LEFT_MARGIN;
        fenghaoY = CGRectGetMaxY(self.guihao.frame) + BOX_NO_VIEW_MARGIN;
        fenghaoW = guihaoW;
        fenghaoH = guihaoH;
        self.fenghao.frame = CGRectMake(fenghaoX, fenghaoY, fenghaoW, fenghaoH);
        
        CGFloat fenghao2X,fenghao2Y,fenghao2W,fenghao2H;
        fenghao2X = fenghaoX + fenghaoW + BOX_NO_VIEW_MARGIN;
        fenghao2Y = fenghaoY;
        fenghao2W = self.frame.size.width - fenghaoW - BOX_NO_VIEW_MARGIN * 3;
        fenghao2H = fenghaoH;
        self.fenghao2.frame = CGRectMake(fenghao2X, fenghao2Y, fenghao2W, fenghao2H);
        
        
        CGFloat dateX,dateY,dateW,dateH;
        dateX = BOX_NO_VIEW_LEFT_MARGIN;
        dateY = CGRectGetMaxY(self.fenghao2.frame) + BOX_NO_VIEW_MARGIN;
        dateW = guihaoW;
        dateH = guihaoH;
        self.date.frame = CGRectMake(dateX, dateY, dateW, dateH);
        
        CGFloat date2X,date2Y,date2W,date2H;
        date2X = dateX + dateW + BOX_NO_VIEW_MARGIN;
        date2Y = dateY;
        date2W = self.frame.size.width - dateW - BOX_NO_VIEW_MARGIN * 3;
        date2H = dateH;
        self.date2.frame = CGRectMake(date2X, date2Y, date2W, date2H);
        
    }

}


-(void)setStatus:(InputBoxNoViewStatus)status
{
    _status = status;
    if (_status == InputBoxNoViewStatus_DisplayNo) {
//        self.button.hidden = YES;
        self.icon.hidden = YES;
        self.label.hidden = YES;
        self.guihao.hidden = NO;
        self.guihao2.hidden = NO;
        self.fenghao.hidden = NO;
        self.fenghao2.hidden = NO;
        self.date.hidden = NO;
        self.date2.hidden = NO;
        UIImage *image = [UIImage imageNamed:@"pop_gray"];
        UIImage *resizeImge = [image resizableImageWithCapInsets:UIEdgeInsetsMake(45, 40, 16, 16)];
        [self.button setBackgroundImage:resizeImge forState:UIControlStateNormal];
    }else {
//        self.button.hidden = NO;
        self.icon.hidden = NO;
        self.label.hidden = NO;
        self.guihao.hidden = YES;
        self.guihao2.hidden = YES;
        self.fenghao.hidden = YES;
        self.fenghao2.hidden = YES;
        self.date.hidden = YES;
        self.date2.hidden = YES;
        UIImage *image = [UIImage imageNamed:@"pop_green"];
        UIImage *resizeImge = [image resizableImageWithCapInsets:UIEdgeInsetsMake(45, 40, 16, 16)];
        [self.button setBackgroundImage:resizeImge forState:UIControlStateNormal];
    }
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

-(void)setStrFenghao:(NSString *)strFenghao
{
    _strFenghao = strFenghao;
    self.fenghao2.text = strFenghao;
}

-(void)setStrGuihao:(NSString *)strGuihao
{
    _strGuihao = strGuihao;
    self.guihao2.text = strGuihao;
}

-(void)setStrDate:(NSString *)strDate
{
    _strDate = strDate;
    self.date2.text = strDate;
}

- (void)btnClicked:(UIButton *)sender
{
    if (self.status == InputBoxNoViewStatus_NeedInput) {
        NSLog(@"fengguihaoluru");
        if ([self.delegate respondsToSelector:@selector(inputBoxNoView:btnClicked:)]) {
            [self.delegate inputBoxNoView:self btnClicked:sender];
        }
    }
}

@end
