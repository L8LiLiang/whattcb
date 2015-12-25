//
//  OrderInfoView.m
//  tcb
//
//  Created by Chuanxun on 15/11/20.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import "OrderInfoView.h"


@interface OrderInfoView ()


@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentBox;

@property (weak, nonatomic) IBOutlet UIButton *backBtn;



@property (weak, nonatomic) IBOutlet UILabel *shipName;
@property (weak, nonatomic) IBOutlet UILabel *orderNo;
@property (weak, nonatomic) IBOutlet UILabel *status1;
@property (weak, nonatomic) IBOutlet UILabel *status2;
@property (weak, nonatomic) IBOutlet UIView *borderView;
@property (weak, nonatomic) IBOutlet UILabel *status3;
@property (weak, nonatomic) IBOutlet UILabel *beginTime;
@property (weak, nonatomic) IBOutlet UILabel *endTime;
@property (weak, nonatomic) IBOutlet UILabel *boxModel;
@property (weak, nonatomic) IBOutlet UILabel *weight;
@property (weak, nonatomic) IBOutlet UILabel *kuaiDiGongSi;
@property (weak, nonatomic) IBOutlet UILabel *comment;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintShipTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintOrderNoTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintBeginTimeTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintStatusTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintFenGeXianTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintXiangXingTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintCommentTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintEndTimeTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintBackTop;


@end

@implementation OrderInfoView

+(instancetype)viewWithOrder:(Order *)order
{
    OrderInfoView *view = [[NSBundle mainBundle] loadNibNamed:@"OrderInfoView" owner:nil options:nil].firstObject;
    view.order = order;
    
    return view;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self.borderView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.borderView.layer.borderWidth = 1;
    
    if (iPhone4 || iPhone5) {
        self.constraintShipTop.constant = self.constraintShipTop.constant / 2.0;
        self.constraintOrderNoTop.constant = self.constraintOrderNoTop.constant / 2.0;
        self.constraintBeginTimeTop.constant = self.constraintBeginTimeTop.constant / 2.0;
        self.constraintStatusTop.constant = self.constraintStatusTop.constant / 2.0;
        self.constraintFenGeXianTop.constant = self.constraintFenGeXianTop.constant / 2.0;
        self.constraintXiangXingTop.constant = self.constraintXiangXingTop.constant / 2.0;
        self.constraintCommentTop.constant = self.constraintCommentTop.constant / 2.0;
        self.constraintEndTimeTop.constant = self.constraintEndTimeTop.constant / 2.0;
        self.constraintBackTop.constant = self.constraintBackTop.constant / 2.0;
    }
    
    
    BOOL isDoubleBox = true;
    if (!isDoubleBox) {
        self.segmentBox.hidden = YES;
        UILabel *label = [UILabel new];
        label.text = @"LL8977733252094442";
        [self addSubview:label];
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self.backBtn);
        }];
    }else {
        self.segmentBox.tintColor = [UIColor whiteColor];
//        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor],UITextAttributeTextColor,  [UIFont fontWithName:Helvetica size:16.f],UITextAttributeFont ,[UIColor whiteColor],UITextAttributeTextShadowColor ,nil];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:FONT_MIDDLE,UITextAttributeFont, nil];
        [self.segmentBox setTitleTextAttributes:dic forState:UIControlStateSelected];
        [self.segmentBox setTitleTextAttributes:dic forState:UIControlStateNormal];
    }
}

-(void)setOrder:(Order *)order
{
    _order = order;
    
}

- (CGFloat)bestHeight
{
    if (iPhone4 || iPhone5) {
        return 254 - self.constraintShipTop.constant - self.constraintOrderNoTop.constant -self.constraintBeginTimeTop.constant - self.constraintStatusTop.constant - self.constraintFenGeXianTop.constant - self.constraintXiangXingTop.constant - self.constraintCommentTop.constant - self.constraintEndTimeTop.constant - self.constraintBackTop.constant;
    }
    return 254;
}

- (IBAction)back:(id)sender {
    if ([self.delegate respondsToSelector:@selector(infoViewBackButtonClicked:)]) {
        [self.delegate infoViewBackButtonClicked:self];
    }
}

- (IBAction)choiceBox:(id)sender {
    if ([self.delegate respondsToSelector:@selector(infoViewChangeBox:)]) {
        [self.delegate infoViewChangeBox:self];
    }
}

- (IBAction)call:(id)sender {
    if ([self.delegate respondsToSelector:@selector(infoViewCallButtonClicked:)]) {
        [self.delegate infoViewCallButtonClicked:self];
    }
}

@end
