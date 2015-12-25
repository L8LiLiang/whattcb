//
//  CheckListCell.m
//  tcb
//
//  Created by Jax on 15/12/4.
//  Copyright © 2015年 Jax. All rights reserved.
//

#define kLabelMargin 5
#define kMargin 10
#define KFont [UIFont systemFontOfSize:16]

#import "CheckListCell.h"
#import "DashLineView.h"
#import "UIImage+JAX.h"

@interface CheckListCell ()

@property (nonatomic, strong) UIView      *totalView;

@property (nonatomic, strong) UILabel     *appointDate1;
@property (nonatomic, strong) UILabel     *containerType1;
@property (nonatomic, strong) UILabel     *customsMode1;
@property (nonatomic, strong) UILabel     *nodeStatus1;
@property (nonatomic, strong) UILabel     *address1;
@property (nonatomic, strong) UILabel     *teamName1;

@property (nonatomic, strong) UIView      *dashLineView;

@property (nonatomic, strong) UILabel     *appointDate2;
@property (nonatomic, strong) UILabel     *containerType2;
@property (nonatomic, strong) UILabel     *customsMode2;
@property (nonatomic, strong) UILabel     *nodeStatus2;
@property (nonatomic, strong) UILabel     *address2;
@property (nonatomic, strong) UILabel     *teamName2;
@property (nonatomic, strong) UIImageView *dataImageView2;


@property (nonatomic, strong) UIView      *nextView1;
@property (nonatomic, strong) UIView      *nextView2;
@property (nonatomic, strong) UIView      *bottomView;

@property (nonatomic, strong) UILabel     *fee2;
@property (nonatomic, strong) UIButton    *feeConfirmButton;
@property (nonatomic, strong) UIButton    *fleetPhoneButton;

@end


@implementation CheckListCell

/**
 *  快速创建cell的方法
 *
 *  @param tableView cell所在的tableview
 *
 *  @return ListMoreOrderCell
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *CellIdentifier = @"CheckListCell";
    CheckListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[CheckListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = kRGB(235, 234, 234);
        [self setUpViews];
    }
    return self;
}

/**
 *  重写cell 模型中的feeConfirmItemArray的set方法，在这里创建cell的子视图
 *
 *  @param feeConfirmItemArray 模型中的feeConfirmItemArray
 */
- (void)setFeeConfirmItemArray:(NSArray *)feeConfirmItemArray {
    _feeConfirmItemArray = feeConfirmItemArray;
    [self setUpViews:feeConfirmItemArray];
}

/**
 *  在这里根据模型数据返回cell的行高
 *
 *  @param 模型中的itemArray
 *
 *  @return cell行高
 */
+ (CGFloat)cellHeightWithFeeConfirmItemArray:(NSArray *)feeConfirmItemArray {
    return (feeConfirmItemArray.count == 1) ? 200 : 325;
}

/**
 *  创建cell上的视图
 *
 *  @param 模型中的feeConfirmItemArray
 */
- (void)setUpViews:(NSArray *)feeConfirmItemArray; {
    //  箱子个数
    NSInteger itemCount = [feeConfirmItemArray count];
    
    if (itemCount == 1) {
        FeeConfirmItem *fistItem = feeConfirmItemArray[0];
        self.appointDate1.text = fistItem.AppointDate;
        self.containerType1.text = fistItem.ContainerType;
        self.customsMode1.text = fistItem.CustomsMode;
        self.nodeStatus1.text = fistItem.FeeStatus;
        self.address1.text = fistItem.Address;
        NSString *dispatcherString = [NSString stringWithFormat:@"%@ %@", fistItem.TeamName, fistItem.Dispatcher];
        self.teamName1.text = dispatcherString;
        NSString *feeString = [NSString stringWithFormat:@"￥%@", fistItem.Fee];
        self.fee2.text = feeString;
        if (![fistItem.FeeStatus isEqualToString:@"已发送"]) {
            self.feeConfirmButton.hidden = YES;
        } else {
            self.feeConfirmButton.hidden = NO;
        }
        
        self.dashLineView.hidden = YES;
        self.dataImageView2.hidden = YES;
        self.appointDate2.hidden = YES;
        self.containerType2.hidden = YES;
        self.customsMode2.hidden = YES;
        self.nodeStatus2.hidden = YES;
        self.nextView2.hidden = YES;
        self.bottomView.hidden = YES;
        [self.bottomView updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nextView1.bottom).offset(0);
            make.left.equalTo(self.totalView.left).offset(0);
            make.right.equalTo(self.totalView.right).offset(0);
            make.height.equalTo(0);
        }];
        
    }
    
    if (itemCount == 2) {
        FeeConfirmItem *fistItem = feeConfirmItemArray[0];
        self.appointDate1.text = fistItem.AppointDate;
        self.containerType1.text = fistItem.ContainerType;
        self.customsMode1.text = fistItem.CustomsMode;
        self.nodeStatus1.text = fistItem.FeeStatus;
        self.address1.text = fistItem.Address;
        NSString *dispatcherString = [NSString stringWithFormat:@"%@ %@", fistItem.TeamName, fistItem.Dispatcher];
        self.teamName1.text = dispatcherString;
        NSString *feeString = [NSString stringWithFormat:@"￥%@", fistItem.Fee];
        self.fee2.text = feeString;
        
        if (![fistItem.FeeStatus isEqualToString:@"已发送"]) {
            self.feeConfirmButton.hidden = YES;
        } else {
            self.feeConfirmButton.hidden = NO;
        }
        
        FeeConfirmItem *secondItem = feeConfirmItemArray[1];
        self.appointDate2.text = secondItem.AppointDate;
        self.containerType2.text = secondItem.ContainerType;
        self.customsMode2.text = secondItem.CustomsMode;
        self.nodeStatus2.text = secondItem.FeeStatus;
        self.address2.text = secondItem.Address;
        NSString *dispatcherString2 = [NSString stringWithFormat:@"%@ %@", fistItem.TeamName, secondItem.Dispatcher];
        self.teamName2.text = dispatcherString2;
        
        
        self.dashLineView.hidden = NO;
        self.dataImageView2.hidden = NO;
        self.appointDate2.hidden = NO;
        self.containerType2.hidden = NO;
        self.customsMode2.hidden = NO;
        self.nodeStatus2.hidden = NO;
        self.nextView2.hidden = NO;
        self.bottomView.hidden = NO;
        [self.bottomView updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nextView1.bottom).offset(0);
            make.left.equalTo(self.totalView.left).offset(0);
            make.right.equalTo(self.totalView.right).offset(0);
            make.height.equalTo(124);
        }];
        [self.feeConfirmButton updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bottomView.bottom).offset (5);
            make.right.equalTo(self.totalView.right).offset(-kMargin);
            make.height.equalTo(40);
            make.width.equalTo(90);
        }];
        
    }
    
}

#pragma mark -
- (void)setUpViews {
    
    UIView *totalView = [[UIView alloc] init];
    [self.contentView addSubview:totalView];
    [totalView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsMake(8, 8, 8, 8));
    }];
    totalView.backgroundColor = [UIColor whiteColor];
    totalView.layer.cornerRadius = 5;
    totalView.layer.masksToBounds = YES;
    self.totalView = totalView;
    
    UIImageView *dataImageView1 = [[UIImageView alloc] init];
    [totalView addSubview:dataImageView1];
    [dataImageView1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(totalView.top).offset(kLabelMargin);
        make.left.equalTo(totalView.left).offset(kMargin);
        make.width.height.equalTo(40);
    }];
    dataImageView1.image = [UIImage imageNamed:@"ic_date_blue"];
    
    UILabel *appointDate1 = [[UILabel alloc] init];
    [totalView addSubview:appointDate1];
    [appointDate1 makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(dataImageView1.centerY);
        make.left.equalTo(dataImageView1.right).offset(kLabelMargin);
    }];
    self.appointDate1 = appointDate1;
    appointDate1.font = KFont;
    
    UILabel *containerType1 = [[UILabel alloc] init];
    [totalView addSubview:containerType1];
    [containerType1 makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(appointDate1.centerY);
        make.left.equalTo(appointDate1.right).offset(kLabelMargin);
    }];
    containerType1.textColor = kRGB(111, 181, 42);
    self.containerType1 = containerType1;
    containerType1.font = KFont;
    
    UILabel *customsMode1 = [[UILabel alloc] init];
    [totalView addSubview:customsMode1];
    [customsMode1 makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(containerType1.centerY);
        make.left.equalTo(containerType1.right).offset(kLabelMargin);
    }];
    self.customsMode1 = customsMode1;
    customsMode1.font = KFont;
    
    UILabel *nodeStatus1 = [[UILabel alloc] init];
    [totalView addSubview:nodeStatus1];
    [nodeStatus1 makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(customsMode1.centerY);
        make.right.equalTo(totalView.right).offset(-kMargin);
    }];
    nodeStatus1.textColor = kRGB(19, 150, 242);
    self.nodeStatus1 = nodeStatus1;
    nodeStatus1.font = KFont;
    
    UIView *nextView1 = [[UIView alloc] init];
    [totalView addSubview:nextView1];
    [nextView1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dataImageView1.bottom).offset(kLabelMargin);
        make.left.right.equalTo(0);
        make.height.equalTo(80);
    }];
    nextView1.backgroundColor = kRGB(251, 251, 251);
    [nextView1 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapNextView:)]];
    nextView1.tag = self.tag;
    self.nextView1 = nextView1;
    
    UIImageView *nextImg = [[UIImageView alloc] init];
    [nextView1 addSubview:nextImg];
    [nextImg makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(nextView1.centerY);
        make.height.width.equalTo(16);
        make.right.equalTo(nextView1.right).offset(-5);
    }];
    nextImg.image = [UIImage imageNamed:@"mine_next"];
    
    UIImageView *locationImg1 = [[UIImageView alloc] init];
    [nextView1 addSubview:locationImg1];
    [locationImg1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nextView1.top).offset(7);
        make.left.equalTo(kMargin);
        make.width.height.equalTo(27);
    }];
    locationImg1.image = [UIImage imageNamed:@"ic_location"];
    
    UILabel *address1 = [[UILabel alloc] init];
    [nextView1 addSubview:address1];
    [address1 makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(locationImg1.centerY);
        make.left.equalTo(locationImg1.right).offset(kLabelMargin);
        make.right.equalTo(nextImg.left).offset(-5);
    }];
    address1.numberOfLines = 0;
    self.address1 = address1;
    address1.font = KFont;
    
    UIImageView *carImg1 = [[UIImageView alloc] init];
    [nextView1 addSubview:carImg1];
    [carImg1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(locationImg1.bottom).offset(12);
        make.left.equalTo(kMargin);
        make.width.height.equalTo(27);
    }];
    carImg1.image = [UIImage imageNamed:@"ic_car"];
    
    UILabel *teamName1 = [[UILabel alloc] init];
    [nextView1 addSubview:teamName1];
    [teamName1 makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(carImg1.centerY);
        make.left.equalTo(carImg1.right).offset(kLabelMargin);
        make.right.equalTo(nextImg.left).offset(-5);
    }];
    teamName1.numberOfLines = 0;
    self.teamName1 = teamName1;
    teamName1.font = KFont;
    
    /**************************************************************/
    
    UIView *bottomView = [[UIView alloc] init];
    [totalView addSubview:bottomView];
    [bottomView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nextView1.bottom).offset(0);
        make.left.equalTo(totalView.left).offset(0);
        make.right.equalTo(totalView.right).offset(0);
        make.height.equalTo(200);
    }];
    self.bottomView = bottomView;
    
    DashLineView *dashLineView = [[DashLineView alloc] init];
    [bottomView addSubview:dashLineView];
    [dashLineView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView.top).offset(5);
        make.left.right.equalTo(0);
        make.height.equalTo(1);
    }];
    dashLineView.backgroundColor = [UIColor clearColor];
    self.dashLineView = dashLineView;
    
    UIImageView *dataImageView2 = [[UIImageView alloc] init];
    [bottomView addSubview:dataImageView2];
    [dataImageView2 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dashLineView.top).offset(kLabelMargin);
        make.left.equalTo(bottomView.left).offset(kMargin);
        make.width.height.equalTo(40);
    }];
    dataImageView2.image = [UIImage imageNamed:@"ic_date_blue"];
    self.dataImageView2 = dataImageView2;
    
    UILabel *appointDate2 = [[UILabel alloc] init];
    [bottomView addSubview:appointDate2];
    [appointDate2 makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(dataImageView2.centerY);
        make.left.equalTo(dataImageView2.right).offset(kLabelMargin);
    }];
    self.appointDate2 = appointDate2;
    appointDate2.font = KFont;
    
    UILabel *containerType2 = [[UILabel alloc] init];
    [bottomView addSubview:containerType2];
    [containerType2 makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(appointDate2.centerY);
        make.left.equalTo(appointDate2.right).offset(kLabelMargin);
    }];
    containerType2.textColor = kRGB(111, 181, 42);
    self.containerType2 = containerType2;
    containerType2.font = KFont;
    
    UILabel *customsMode2 = [[UILabel alloc] init];
    [bottomView addSubview:customsMode2];
    [customsMode2 makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(containerType2.centerY);
        make.left.equalTo(containerType2.right).offset(kLabelMargin);
    }];
    self.customsMode2 = customsMode2;
    customsMode2.font = KFont;
    
    UILabel *nodeStatus2 = [[UILabel alloc] init];
    [bottomView addSubview:nodeStatus2];
    [nodeStatus2 makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(customsMode2.centerY);
        make.right.equalTo(bottomView.right).offset(-kMargin);
    }];
    nodeStatus2.textColor = kRGB(19, 150, 242);
    self.nodeStatus2 = nodeStatus2;
    nodeStatus2.font = KFont;
    
    UIView *nextView2 = [[UIView alloc] init];
    [bottomView addSubview:nextView2];
    [nextView2 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dataImageView2.bottom).offset(kLabelMargin);
        make.left.right.equalTo(0);
        make.height.equalTo(70);
    }];
    nextView2.backgroundColor = kRGB(251, 251, 251);
    [nextView2 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapNextView:)]];
    self.nextView2 = nextView2;
    
    
    UIImageView *nextImg2 = [[UIImageView alloc] init];
    [nextView2 addSubview:nextImg2];
    [nextImg2 makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(nextView2.centerY);
        make.height.width.equalTo(16);
        make.right.equalTo(nextView2.right).offset(-5);
    }];
    nextImg2.image = [UIImage imageNamed:@"mine_next"];
    
    
    UIImageView *locationImg2 = [[UIImageView alloc] init];
    [nextView2 addSubview:locationImg2];
    [locationImg2 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nextView2.top).offset(4);
        make.left.equalTo(kMargin);
        make.width.height.equalTo(27);
    }];
    locationImg2.image = [UIImage imageNamed:@"ic_location"];
    
    UILabel *address2 = [[UILabel alloc] init];
    [nextView2 addSubview:address2];
    [address2 makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(locationImg2.centerY);
        make.left.equalTo(locationImg2.right).offset(kLabelMargin);
        make.right.equalTo(nextImg2.left).offset(8);
    }];
    address2.numberOfLines = 0;
    self.address2 = address2;
    address2.font = KFont;
    
    UIImageView *carImg2 = [[UIImageView alloc] init];
    [nextView2 addSubview:carImg2];
    [carImg2 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(locationImg2.bottom).offset(8);
        make.left.equalTo(kMargin);
        make.width.height.equalTo(27);
    }];
    carImg2.image = [UIImage imageNamed:@"ic_car"];
    
    UILabel *teamName2 = [[UILabel alloc] init];
    [nextView2 addSubview:teamName2];
    [teamName2 makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(carImg2.centerY);
        make.left.equalTo(carImg2.right).offset(kLabelMargin);
        make.right.equalTo(nextImg2.left).offset(-5);
    }];
    teamName2.numberOfLines = 0;
    self.teamName2 = teamName2;
    teamName2.font = KFont;
    
    UILabel *fee2 = [[UILabel alloc] init];
    [totalView addSubview:fee2];
    [fee2 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView.bottom).offset (0);
        make.left.equalTo(totalView.left).offset(kMargin);
        make.height.equalTo(50);
    }];
    fee2.textColor = kRGB(252, 57, 8);
    self.fee2 = fee2;
    fee2.font = KFont;
    
    UIButton *feeConfirmButton = [[UIButton alloc] init];
    [totalView addSubview:feeConfirmButton];
    [feeConfirmButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView.bottom).offset (5);
        make.right.equalTo(totalView.right).offset(-kMargin);
        make.height.equalTo(40);
        make.width.equalTo(90);
    }];
    [feeConfirmButton setTitle:@"费用确认" forState:UIControlStateNormal];
    [feeConfirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [feeConfirmButton setBackgroundImage:[UIImage resizedImage:@"btn_bg_blue_normal"] forState:UIControlStateNormal];
    feeConfirmButton.titleEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    [feeConfirmButton addTarget:self action:@selector(feeConfirmButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    feeConfirmButton.tag = self.tag;
    self.feeConfirmButton = feeConfirmButton;
    
    UIButton *fleetPhoneButton = [[UIButton alloc] init];
    [totalView addSubview:fleetPhoneButton];
    [fleetPhoneButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView.bottom).offset (5);
        make.right.equalTo(feeConfirmButton.left).offset(-kMargin);
        make.height.equalTo(40);
        make.width.equalTo(90);
    }];
    [fleetPhoneButton setTitle:@"车队电话" forState:UIControlStateNormal];
    [fleetPhoneButton setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    [fleetPhoneButton setBackgroundImage:[UIImage resizedImage:@"btn_bg_blue_normal"] forState:UIControlStateNormal];
    fleetPhoneButton.titleEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    [fleetPhoneButton addTarget:self action:@selector(fleetPhoneButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    fleetPhoneButton.tag = self.tag;
    self.fleetPhoneButton = fleetPhoneButton;
    
}

#pragma mark - nextView点击手势
- (void)tapNextView:(UITapGestureRecognizer *)tap {
    if ([self.checkListCellDelegate respondsToSelector:@selector(nextViewOnTap:)]) {
        [self.checkListCellDelegate nextViewOnTap:tap];
    }
}

- (void)feeConfirmButtonClicked:(UIButton *)sender {
    if ([self.checkListCellDelegate respondsToSelector:@selector(feeConfirm:)]) {
        [self.checkListCellDelegate feeConfirm:sender];
    }
}

- (void)fleetPhoneButtonClicked:(UIButton *)sender {
    if ([self.checkListCellDelegate respondsToSelector:@selector(contactFleet:)]) {
        [self.checkListCellDelegate contactFleet:sender];
    }
}



@end
