//
//  ShowRobListOrderCell.m
//  tcb
//
//  Created by Jax on 15/11/16.
//  Copyright © 2015年 Jax. All rights reserved.
//

#define kTopViewHeight 165
#define kRightLabelWith 30
#define kGrayHeight 4
#define kDateImgW 35
#define kDateImgW 35

#import "ShowRobListOrderCell.h"
#import "NSString+Extension.h"
#import "DashLineView.h"

@interface ShowRobListOrderCell()

@property (nonatomic, strong) UILabel *factoryTruckingTime1;
@property (nonatomic, strong) UILabel *dispatchTypeLabel1;
@property (nonatomic, strong) UILabel *containerType1;
@property (nonatomic, strong) UILabel *lineName1;
@property (nonatomic, strong) UILabel *address1;
@property (nonatomic, strong) UILabel *followRemark1;

@property (nonatomic, strong) UILabel *factoryTruckingTime2;
@property (nonatomic, strong) UILabel *dispatchTypeLabel2;
@property (nonatomic, strong) UILabel *containerType2;
@property (nonatomic, strong) UILabel *lineName2;
@property (nonatomic, strong) UILabel *address2;
@property (nonatomic, strong) UILabel *followRemark2;

@property (nonatomic, strong) UIImageView *dateImg2;
@property (nonatomic, strong) UIImageView *locationImg2;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIView *topView2;

@property (nonatomic, strong) UILabel *totalCost;
@property (nonatomic, strong) UILabel *grabStatus;

@end

@implementation ShowRobListOrderCell

/**
 *  提供一个快速返回cell的方法
 *
 *  @param tableView tableView
 *
 *  @return return RobListOrderCell
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *CellIdentifier = @"ShowRobListOrderCell";
    ShowRobListOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ShowRobListOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
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

- (void)setGrabOrder:(GrabOrder *)grabOrder {
    _grabOrder = grabOrder;
}

/**
 *  重写模型，设置cell子视图
 *
 *  @param grabList grabList
 */
- (void)setGrabList:(GrabList *)grabList {
    _grabList = grabList;
    [self setupViews:grabList];
}

/**
 *  在这里根据模型数据返回cell的行高
 *
 *  @param 模型中的itemArray
 *
 *  @return cell行高
 */
+ (CGFloat)cellHeightWithItemArray:(NSArray *)grabItemArray {
    //  动态的 + 定死的 计算出来
    return (grabItemArray.count == 1) ? 165 : 300;
}


/**
 *  后于cellHeightWithItemArray调用
 *
 *  @param grabItemArray 视图需要的模型数组
 */
- (void)setupViews:(GrabList *)grabList {
    
    NSArray *grabItemArray = grabList.items;
    NSInteger grabItemCount = [grabItemArray count];
    
    if (grabItemCount == 1) {
        GrabItem *firstGrabItem = grabItemArray[0];
        
        self.factoryTruckingTime1.text = firstGrabItem.AppointDate;
        
        NSInteger dispatchType1 = firstGrabItem.DispatchType;
        NSString *dispatchTypeString1 = ((dispatchType1 == 1) ? @"装货" : @"送货");
        self.dispatchTypeLabel1.text = dispatchTypeString1;
        self.containerType1.text = firstGrabItem.ContainerType;
    
        NSString *addressString1 = [NSString stringWithFormat:@"地址:%@", firstGrabItem.Address];
        //    CGSize addressStringSize1 = [addressString1 sizeWithFont:[UIFont systemFontOfSize:17] andMaxSize:CGSizeMake(SCREEN_WIDTH - 5 * 2 - 27, CGFLOAT_MAX)];
        self.address1.text = addressString1;
        
        NSString *lineNameString1 = [NSString stringWithFormat:@"箱属:%@", firstGrabItem.LineName];
        self.lineName1.text = lineNameString1;
        
        NSString *followRemarkString1 = [NSString stringWithFormat:@"备注:%@", firstGrabItem.FollowRemark];
        self.followRemark1.text = followRemarkString1;
        
        NSString *totalCostString = [NSString stringWithFormat:@"￥%zd", firstGrabItem.TotalCosts];
        self.totalCost.text = totalCostString;
        
        NSInteger grabStatusNum = firstGrabItem.GrabStatus;
        NSString *grabStatusString;
        switch (grabStatusNum) {
            case 0:
                grabStatusString = @"未开始";
                break;
            case 1:
                grabStatusString = @"竞价中";
                break;
            case 2:
                grabStatusString = @"已派车";
                break;
            case 3:
                grabStatusString = @"已取消";
                break;
            case 4:
                grabStatusString = @"无人竞价结束";
                break;
            default:
                break;
        }
        self.grabStatus.text = grabStatusString;
        
        [self.topView2 updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(0);
        }];
        self.lineView.hidden = YES;
        self.dateImg2.hidden = YES;
        self.locationImg2.hidden = YES;
        

    }
    
    if (grabItemCount == 2) {
        
        GrabItem *firstGrabItem = grabItemArray[0];
        
        self.factoryTruckingTime1.text = firstGrabItem.AppointDate;
        
        NSInteger dispatchType1 = firstGrabItem.DispatchType;
        NSString *dispatchTypeString1 = ((dispatchType1 == 1) ? @"装货" : @"送货");
        self.dispatchTypeLabel1.text = dispatchTypeString1;
        self.containerType1.text = firstGrabItem.ContainerType;
        
        NSString *addressString1 = [NSString stringWithFormat:@"地址:%@", firstGrabItem.Address];
        //    CGSize addressStringSize1 = [addressString1 sizeWithFont:[UIFont systemFontOfSize:17] andMaxSize:CGSizeMake(SCREEN_WIDTH - 5 * 2 - 27, CGFLOAT_MAX)];
        self.address1.text = addressString1;
        
        NSString *lineNameString1 = [NSString stringWithFormat:@"箱属:%@", firstGrabItem.LineName];
        self.lineName1.text = lineNameString1;
        
        NSString *followRemarkString1 = [NSString stringWithFormat:@"备注:%@", firstGrabItem.FollowRemark];
        self.followRemark1.text = followRemarkString1;
        
        
        GrabItem *secondGrabItem = grabItemArray[1];
        self.factoryTruckingTime2.text = secondGrabItem.AppointDate;
        
        NSInteger dispatchType2 = secondGrabItem.DispatchType;
        NSString *dispatchTypeString2 = ((dispatchType2 == 1) ? @"装货" : @"送货");
        self.dispatchTypeLabel2.text = dispatchTypeString2;
        
        self.containerType2.text = secondGrabItem.ContainerType;
        
        NSString *addressString2 = [NSString stringWithFormat:@"地址:%@", secondGrabItem.Address];
        //    CGSize addressStringSize1 = [addressString1 sizeWithFont:[UIFont systemFontOfSize:17] andMaxSize:CGSizeMake(SCREEN_WIDTH - 5 * 2 - 27, CGFLOAT_MAX)];
        self.address2.text = addressString2;
        
        NSString *lineNameString2 = [NSString stringWithFormat:@"箱属:%@", secondGrabItem.LineName];
        self.lineName2.text = lineNameString2;
        
        NSString *followRemarkString2 = [NSString stringWithFormat:@"备注:%@", secondGrabItem.FollowRemark];
        self.followRemark1.text = followRemarkString2;
        
        NSString *totalCostString = [NSString stringWithFormat:@"￥%zd", firstGrabItem.TotalCosts];
        self.totalCost.text = totalCostString;
        
    }
    
}

- (void)setUpViews {
   
    UIView *grayView = [[UIView alloc] init];
    [self.contentView addSubview:grayView];
    [grayView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(0);
        make.height.equalTo(kGrayHeight);
    }];
    grayView.backgroundColor = kRGB(213, 213, 213);
    
    UIView *topView1 = [[UIView alloc] init];
    [self.contentView addSubview:topView1];
    [topView1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(grayView.bottom).offset(0);
        make.left.equalTo(self.contentView.left).offset(0);
        make.width.equalTo(SCREEN_WIDTH - kRightLabelWith);
        make.height.equalTo(kTopViewHeight);
    }];
    
    UIImageView *dateImg1 = [[UIImageView alloc] init];
    [topView1 addSubview:dateImg1];
    [dateImg1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(4);
        make.left.equalTo(4);
        make.width.height.equalTo(kDateImgW);
    }];
    dateImg1.image = [UIImage imageNamed:@"ic_date_blue"];
    
    UILabel *factoryTruckingTime1 = [[UILabel alloc] init];
    [topView1 addSubview:factoryTruckingTime1];
    [factoryTruckingTime1 makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(dateImg1.centerY);
        make.left.equalTo(dateImg1.right).offset(5);
    }];
    self.factoryTruckingTime1 = factoryTruckingTime1;
    
    UILabel *dispatchTypeLabel1 = [[UILabel alloc] init];
    [topView1 addSubview:dispatchTypeLabel1];
    [dispatchTypeLabel1 makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(factoryTruckingTime1.centerY);
        make.right.equalTo(topView1.right).offset(-5);
    }];
    dispatchTypeLabel1.textColor = kRGB(18, 141, 254);
    self.dispatchTypeLabel1 = dispatchTypeLabel1;
    
    UILabel *containerType1 = [[UILabel alloc] init];
    [topView1 addSubview:containerType1];
    [containerType1 makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(dispatchTypeLabel1.centerY);
        make.right.equalTo(dispatchTypeLabel1.left).offset(-5);
    }];
    self.containerType1 = containerType1;
    containerType1.textColor = kRGB(18, 141, 254);
    
    UIImageView *locationImg1 = [[UIImageView alloc] init];
    [topView1 addSubview:locationImg1];
    [locationImg1 makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(dateImg1.leading);
        make.top.equalTo(dateImg1.bottom).offset(5);
        make.width.height.equalTo(27);
    }];
    locationImg1.image = [UIImage imageNamed:@"ic_location"];
    
    UILabel *address1 = [[UILabel alloc] init];
    [topView1 addSubview:address1];
    [address1 makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(locationImg1.centerY);
        make.left.equalTo(locationImg1.right).offset(5);
        make.right.equalTo(topView1.right).offset(0);
    }];
    address1.numberOfLines = 0;
    self.address1 = address1;
    
    UILabel *lineName1 = [[UILabel alloc] init];
    [topView1 addSubview:lineName1];
    [lineName1 makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(address1);
        make.top.equalTo(address1.bottom).offset(5);
    }];
    self.lineName1 = lineName1;

    
    UILabel *followRemark1 = [[UILabel alloc] init];
    [topView1 addSubview:followRemark1];
    [followRemark1 makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(lineName1);
        make.top.equalTo(lineName1.bottom).offset(5);
    }];
    self.followRemark1 = followRemark1;
        
        DashLineView *lineView = [[DashLineView alloc] init];
        lineView.lineColor = [UIColor grayColor];
        lineView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:lineView];
        [lineView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(followRemark1.bottom).offset(2);
            make.leading.equalTo(topView1);
            make.trailing.equalTo(topView1);
            make.height.equalTo(1);
        }];
    self.lineView = lineView;
        
        UIView *topView2 = [[UIView alloc] init];
        [self.contentView addSubview:topView2];
        [topView2 makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lineView.bottom).offset(1);
            make.left.equalTo(self.contentView.left).offset(0);
            make.width.equalTo(SCREEN_WIDTH - kRightLabelWith);
            make.height.equalTo(kTopViewHeight);
        }];
    self.topView2 = topView2;
        
        UIImageView *dateImg2 = [[UIImageView alloc] init];
        [topView2 addSubview:dateImg2];
        [dateImg2 makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(4);
            make.left.equalTo(4);
            make.width.height.equalTo(35);
        }];
        dateImg2.image = [UIImage imageNamed:@"ic_date_blue"];
    self.dateImg2 = dateImg2;
        
        UILabel *factoryTruckingTime2 = [[UILabel alloc] init];
        [topView2 addSubview:factoryTruckingTime2];
        [factoryTruckingTime2 makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(dateImg2.centerY);
            make.left.equalTo(dateImg2.right).offset(5);
        }];
    self.factoryTruckingTime2 = factoryTruckingTime2;

        UILabel *dispatchTypeLabel2 = [[UILabel alloc] init];
        [topView2 addSubview:dispatchTypeLabel2];
        [dispatchTypeLabel2 makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(factoryTruckingTime2.centerY);
            make.right.equalTo(topView2.right).offset(-5);
        }];
        dispatchTypeLabel2.textColor = kRGB(18, 141, 254);
        self.dispatchTypeLabel2 = dispatchTypeLabel2;
    
        UILabel *containerType2 = [[UILabel alloc] init];
        [topView2 addSubview:containerType2];
        [containerType2 makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(dispatchTypeLabel2.centerY);
            make.right.equalTo(dispatchTypeLabel2.left).offset(-5);
        }];
        containerType2.textColor = kRGB(18, 141, 254);
    self.containerType2 = containerType2;
        
        UIImageView *locationImg2 = [[UIImageView alloc] init];
        [topView2 addSubview:locationImg2];
        [locationImg2 makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(dateImg2.leading);
            make.top.equalTo(dateImg2.bottom).offset(5);
            make.width.height.equalTo(27);
        }];
        locationImg2.image = [UIImage imageNamed:@"ic_location"];
    self.locationImg2 = locationImg2;

        UILabel *address2 = [[UILabel alloc] init];
        [topView2 addSubview:address2];
        [address2 makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(locationImg2.centerY);
            make.left.equalTo(locationImg2.right).offset(5);
            make.right.equalTo(topView2.right).offset(0);
        }];
        address2.numberOfLines = 0;
    self.address2 = address2;
    
        UILabel *lineName2 = [[UILabel alloc] init];
        [topView2 addSubview:lineName2];
        [lineName2 makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(address2);
            make.top.equalTo(address2.bottom).offset(5);
        }];
    self.lineName2 = lineName2;
        
        UILabel *followRemark2 = [[UILabel alloc] init];
        [topView2 addSubview:followRemark2];
        [followRemark2 makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(lineName2);
            make.top.equalTo(lineName2.bottom).offset(5);
        }];
    self.followRemark2 = followRemark2;
    
    UILabel *totalCost = [[UILabel alloc] init];
    [self.contentView addSubview:totalCost];
    [totalCost makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(followRemark1);
        make.top.equalTo(topView2.bottom).offset(5);
    }];
    totalCost.textColor = kRGB(250, 172, 66);
    self.totalCost = totalCost;
    
    UILabel *grabStatus = [[UILabel alloc] init];
    [self.contentView addSubview:grabStatus];
    [grabStatus makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView1.top).offset(0);
        make.left.equalTo(topView1.right).offset(0);
        make.right.equalTo(self.contentView.right).offset(0);
        make.bottom.equalTo(self.contentView.bottom).offset(0);
    }];
    grabStatus.numberOfLines = 0;
    grabStatus.textAlignment = NSTextAlignmentCenter;
    grabStatus.backgroundColor = kDefaultBarButtonItemColor;
    self.grabStatus = grabStatus;
}

@end
