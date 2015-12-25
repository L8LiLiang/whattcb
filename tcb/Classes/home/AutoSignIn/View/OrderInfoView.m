//
//  OrderInfoView.m
//  tcb
//
//  Created by Chuanxun on 15/11/20.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import "OrderInfoView.h"
#import "ELDispatchOrder.h"

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

@property (assign, nonatomic) NSInteger currentIndex;

@property (weak, nonatomic) UILabel *titleLabel;

@end

@implementation OrderInfoView

+(instancetype)viewWithOrder:(ELDispatchOrder *)order selectedIndex:(NSInteger)index
{
    OrderInfoView *view = [[NSBundle mainBundle] loadNibNamed:@"OrderInfoView" owner:nil options:nil].firstObject;
    view.order = order;
    view.currentIndex = index;
    [view.segmentBox setSelectedSegmentIndex:index];
    
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
    
    
    UILabel *label = [UILabel new];
    label.hidden = YES;
    label.text = self.order.item[0].DispCode;
    [self addSubview:label];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self.backBtn);
    }];
    label.font = [UIFont systemFontOfSize:16];
    [label setTextColor:[UIColor whiteColor]];
    self.titleLabel = label;
    
    self.segmentBox.hidden = YES;
    self.segmentBox.tintColor = [UIColor whiteColor];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:FONT_MIDDLE,NSFontAttributeName, nil];
    [self.segmentBox setTitleTextAttributes:dic forState:UIControlStateSelected];
    [self.segmentBox setTitleTextAttributes:dic forState:UIControlStateNormal];
    
    
}


-(void)setOrder:(ELDispatchOrder *)order
{
    _order = order;

    ELDispatchOrderItem *item;
    
    if (self.order.item.count == 1) {
        item = _order.item[0];
        self.segmentBox.hidden = YES;
        self.titleLabel.hidden = NO;
        self.titleLabel.text = item.BusiId;
    }else if(self.order.item.count == 2){
        self.titleLabel.hidden = YES;
        self.segmentBox.hidden = NO;

        if (self.segmentBox.selectedSegmentIndex == 0) {
            item = _order.item[0];
        }else {
            item = _order.item[1];
        }
    }
    
    self.shipName.text = item.ShipVoyage;
    self.orderNo.text = item.BillNo;
    self.beginTime.text = item.AppointDate;
    self.endTime.text = item.CutoffTime;
    self.boxModel.text = item.ContainerType;
    self.weight.text = item.Weight;
    self.kuaiDiGongSi.text = item.LineName;
    self.status3.text = item.CustomsMode;
    self.comment.text = item.FollowRemark;
}

- (CGFloat)bestHeight
{
    if (iPhone4 || iPhone5) {
        return 218 - self.constraintShipTop.constant - self.constraintOrderNoTop.constant -self.constraintBeginTimeTop.constant - self.constraintStatusTop.constant - self.constraintFenGeXianTop.constant - self.constraintXiangXingTop.constant - self.constraintCommentTop.constant - self.constraintEndTimeTop.constant - self.constraintBackTop.constant;
    }
    return 218;
}

- (IBAction)back:(id)sender {
    if ([self.delegate respondsToSelector:@selector(infoViewBackButtonClicked:)]) {
        [self.delegate infoViewBackButtonClicked:self];
    }
}

- (IBAction)choiceBox:(id)sender {
    NSInteger index = self.segmentBox.selectedSegmentIndex;
    
    ELDispatchOrderItem *item;
    if (_order.item.count == 1) {
        item = _order.item[0];
    }else {
        item = _order.item[index];
        
    }
    
    self.shipName.text = item.ShipVoyage;
    self.orderNo.text = item.BillNo;
    self.beginTime.text = item.AppointDate;
    self.endTime.text = item.CutoffTime;
    self.boxModel.text = item.ContainerType;
    self.weight.text = item.Weight;
    self.kuaiDiGongSi.text = item.LineName;
    self.status3.text = item.CustomsMode;
    self.comment.text = item.FollowRemark;
    
    if ([self.delegate respondsToSelector:@selector(infoViewChangeBox:toIndex:)]) {
        [self.delegate infoViewChangeBox:self toIndex:index];
    }
}

- (IBAction)call:(id)sender {
    if ([self.delegate respondsToSelector:@selector(infoViewCallButtonClicked:)]) {
        [self.delegate infoViewCallButtonClicked:self];
    }
}

@end
