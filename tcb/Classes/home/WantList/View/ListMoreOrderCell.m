//
//  ListMoreOrderCell.m
//  tcb
//
//  Created by Jax on 15/11/16.
//  Copyright © 2015年 Jax. All rights reserved.
//

#define kLabelMargin 5
#define kMargin 10

#import "ListMoreOrderCell.h"
#import "DashLineView.h"
#import "UIImage+JAX.h"

@interface ListMoreOrderCell ()

@property (nonatomic, strong) UILabel *appointDate1;
@property (nonatomic, strong) UILabel *containerType1;
@property (nonatomic, strong) UILabel *customsMode1;
@property (nonatomic, strong) UILabel *nodeStatus1;
@property (nonatomic, strong) UILabel *address1;
@property (nonatomic, strong) UILabel *teamName1;

@property (nonatomic, strong) UIView *dashLineView;

@property (nonatomic, strong) UILabel *appointDate2;
@property (nonatomic, strong) UILabel *containerType2;
@property (nonatomic, strong) UILabel *customsMode2;
@property (nonatomic, strong) UILabel *nodeStatus2;
@property (nonatomic, strong) UILabel *address2;
@property (nonatomic, strong) UILabel *teamName2;
@property (nonatomic, strong) UIImageView *dataImageView2;


@property (nonatomic, strong) UIView *nextView1;
@property (nonatomic, strong) UIView *nextView2;
@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UILabel *fee2;

@end

@implementation ListMoreOrderCell
/**
 *  快速创建cell的方法
 *
 *  @param tableView cell所在的tableview
 *
 *  @return ListMoreOrderCell
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *CellIdentifier = @"ListMoreOrderCell";
    ListMoreOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ListMoreOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
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
 *  重写cell SendCarList模型的set方法
 *
 *  @param sendCarList cell拥有SendCarList的模型
 */
- (void)setSendCarList:(SendCarList *)sendCarList {
    //  必须进行赋值
    _sendCarList = sendCarList;
}

/**
 *  重写cell 模型中的itemArray的set方法，在这里创建cell的子视图
 *
 *  @param itemArray 模型中的itemArray
 */
- (void)setItemArray:(NSArray *)itemArray {
    _itemArray = itemArray;
    [self setUpViews:itemArray];
}

/**
 *  在这里根据模型数据返回cell的行高
 *
 *  @param 模型中的itemArray
 *
 *  @return cell行高
 */
+ (CGFloat)cellHeightWithItemArray:(NSArray *)itemArray {
    return (itemArray.count == 1) ? 195 : 320;
}

/**
 *  创建cell上的视图
 *
 *  @param 模型中的itemArray
 */
- (void)setUpViews:(NSArray *)itemArray {
    //  箱子个数
    NSInteger itemCount = [itemArray count];

    if (itemCount == 1) {
        Item *fistItem = itemArray[0];
        self.appointDate1.text = fistItem.AppointDate;
        self.containerType1.text = fistItem.ContainerType;
        self.customsMode1.text = fistItem.CustomsMode;
        self.nodeStatus1.text = fistItem.NodeStatus;
        self.address1.text = fistItem.Address;
        NSString *dispatcherString = [NSString stringWithFormat:@"%@ %@", fistItem.TeamName, fistItem.Dispatcher];
        self.teamName1.text = dispatcherString;
        NSString *feeString = [NSString stringWithFormat:@"￥%@", fistItem.Fee];
        self.fee2.text = feeString;
        
        self.dashLineView.hidden = YES;
        self.dataImageView2.hidden = YES;
        self.appointDate2.hidden = YES;
        self.containerType2.hidden = YES;
        self.nodeStatus2.hidden = YES;
        self.nextView2.hidden = YES;
        [self.bottomView updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(0);
        }];
        
    }
    
    if (itemCount == 2) {
        Item *fistItem = itemArray[0];
        self.appointDate1.text = fistItem.AppointDate;
        self.containerType1.text = fistItem.ContainerType;
        self.customsMode1.text = fistItem.CustomsMode;
        self.nodeStatus1.text = fistItem.NodeStatus;
        self.address1.text = fistItem.Address;
        NSString *dispatcherString = [NSString stringWithFormat:@"%@ %@", fistItem.TeamName, fistItem.Dispatcher];
        self.teamName1.text = dispatcherString;
        NSString *feeString = [NSString stringWithFormat:@"￥%@", fistItem.Fee];
        self.fee2.text = feeString;
        
        Item *secondItem = itemArray[1];
        self.appointDate2.text = secondItem.AppointDate;
        self.containerType2.text = secondItem.ContainerType;
        self.customsMode2.text = secondItem.CustomsMode;
        self.nodeStatus2.text = secondItem.NodeStatus;
        self.address2.text = secondItem.Address;
        NSString *dispatcherString2 = [NSString stringWithFormat:@"%@ %@", fistItem.TeamName, secondItem.Dispatcher];
        self.teamName2.text = dispatcherString2;
       
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
    
    UILabel *containerType1 = [[UILabel alloc] init];
    [totalView addSubview:containerType1];
    [containerType1 makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(appointDate1.centerY);
        make.left.equalTo(appointDate1.right).offset(kLabelMargin);
    }];
    containerType1.textColor = kRGB(111, 181, 42);
    self.containerType1 = containerType1;
    
    UILabel *customsMode1 = [[UILabel alloc] init];
    [totalView addSubview:customsMode1];
    [customsMode1 makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(containerType1.centerY);
        make.left.equalTo(containerType1.right).offset(kLabelMargin);
    }];
    self.customsMode1 = customsMode1;
    
    UILabel *nodeStatus1 = [[UILabel alloc] init];
    [totalView addSubview:nodeStatus1];
    [nodeStatus1 makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(customsMode1.centerY);
        make.right.equalTo(totalView.right).offset(-kMargin);
    }];
    nodeStatus1.textColor = kRGB(19, 150, 242);
    self.nodeStatus1 = nodeStatus1;
    
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
    
        UILabel *containerType2 = [[UILabel alloc] init];
        [bottomView addSubview:containerType2];
        [containerType2 makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(appointDate2.centerY);
            make.left.equalTo(appointDate2.right).offset(kLabelMargin);
        }];
        containerType2.textColor = kRGB(111, 181, 42);
    self.containerType2 = containerType2;
    
        UILabel *customsMode2 = [[UILabel alloc] init];
        [bottomView addSubview:customsMode2];
        [customsMode2 makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(containerType2.centerY);
            make.left.equalTo(containerType2.right).offset(kLabelMargin);
        }];
    self.customsMode2 = customsMode2;
    
        UILabel *nodeStatus2 = [[UILabel alloc] init];
        [bottomView addSubview:nodeStatus2];
        [nodeStatus2 makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(customsMode2.centerY);
            make.right.equalTo(bottomView.right).offset(-kMargin);
        }];
        nodeStatus2.textColor = kRGB(19, 150, 242);
    self.nodeStatus2 = nodeStatus2;
    
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
        
        UILabel *fee2 = [[UILabel alloc] init];
        [totalView addSubview:fee2];
        [fee2 makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bottomView.bottom).offset (0);
            make.left.equalTo(totalView.left).offset(kMargin);
            make.height.equalTo(50);
        }];
        fee2.textColor = kRGB(252, 57, 8);
    self.fee2 = fee2;
    
        UIButton *dispatch2 = [[UIButton alloc] init];
        [totalView addSubview:dispatch2];
        [dispatch2 makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bottomView.bottom).offset (5);
            make.right.equalTo(totalView.right).offset(-kMargin);
            make.height.equalTo(40);
            make.width.equalTo(90);
        }];
        [dispatch2 setTitle:@"联系调度" forState:UIControlStateNormal];
        [dispatch2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [dispatch2 setBackgroundImage:[UIImage resizedImage:@"btn_bg_blue_normal"] forState:UIControlStateNormal];
        dispatch2.titleEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        [dispatch2 addTarget:self action:@selector(dispatchClicked:) forControlEvents:UIControlEventTouchUpInside];
        dispatch2.tag = self.tag;
    
}

#pragma mark - nextView点击手势
- (void)tapNextView:(UITapGestureRecognizer *)tap {
    if ([self.listMoreOrderCellDelegate respondsToSelector:@selector(nextViewOnTap:)]) {
        [self.listMoreOrderCellDelegate nextViewOnTap:tap];
    }
}

- (void)dispatchClicked:(UIButton *)sender {
    if ([self.listMoreOrderCellDelegate respondsToSelector:@selector(contactAndDispatch:)]) {
        [self.listMoreOrderCellDelegate contactAndDispatch:sender];
    }
}

@end
