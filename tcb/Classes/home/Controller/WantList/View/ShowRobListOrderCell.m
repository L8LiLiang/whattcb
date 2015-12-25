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

@property (nonatomic, strong) UILabel *followRemark2;

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

- (void)setGrabOrder:(GrabOrder *)grabOrder {
    _grabOrder = grabOrder;
}

/**
 *  重写模型，设置cell子视图
 *
 *  @param grabList grabList
 */
- (void)setGrabItemArray:(NSArray *)grabItemArray {
    _grabItemArray = grabItemArray;
    [self setupViews:grabItemArray];
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
    return (grabItemArray.count == 1) ? 300 : 165;
}


/**
 *  后于cellHeightWithItemArray调用
 *
 *  @param grabItemArray 视图需要的模型数组
 */
- (void)setupViews:(NSArray *)grabItemArray {
    
    GrabItem *firstGrabItem = grabItemArray[0];
    NSInteger grabItemCount = [grabItemArray count];
    grabItemCount = 2;
    
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
    factoryTruckingTime1.text = firstGrabItem.FactoryTruckingTime;
    factoryTruckingTime1.text = @"2015-08-12 10:10";
    
    NSInteger dispatchType1 = firstGrabItem.DispatchType;
    NSString *dispatchTypeString1 = ((dispatchType1 == 1) ? @"装货" : @"送货");
    dispatchTypeString1 = @"送货";
    UILabel *dispatchTypeLabel1 = [[UILabel alloc] init];
    [topView1 addSubview:dispatchTypeLabel1];
    [dispatchTypeLabel1 makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(factoryTruckingTime1.centerY);
        make.right.equalTo(topView1.right).offset(-5);
    }];
    dispatchTypeLabel1.text = dispatchTypeString1;
    dispatchTypeLabel1.textColor = kRGB(18, 141, 254);
    
    UILabel *containerType1 = [[UILabel alloc] init];
    [topView1 addSubview:containerType1];
    [containerType1 makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(dispatchTypeLabel1.centerY);
        make.right.equalTo(dispatchTypeLabel1.left).offset(-5);
    }];
    containerType1.text = firstGrabItem.ContainerType;
    containerType1.text = @"40PG";
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
    NSString *addressString1 = [NSString stringWithFormat:@"地址是:%@", [firstGrabItem FactoryAddress]];
    addressString1 = @"地址:我饿期末考了我们";
    CGSize addressStringSize1 = [addressString1 sizeWithFont:[UIFont systemFontOfSize:17] andMaxSize:CGSizeMake(SCREEN_WIDTH - 5 * 2 - 27, CGFLOAT_MAX)];
    [address1 makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(locationImg1.centerY);
        make.left.equalTo(locationImg1.right).offset(5);
        make.right.equalTo(topView1.right).offset(0);
    }];
    address1.numberOfLines = 0;
    address1.text = addressString1;
    
    UILabel *lineName1 = [[UILabel alloc] init];
    [topView1 addSubview:lineName1];
    [lineName1 makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(address1);
        make.top.equalTo(address1.bottom).offset(5);
    }];
    lineName1.text = @"箱属:韩进";
    
    UILabel *followRemark1 = [[UILabel alloc] init];
    [topView1 addSubview:followRemark1];
    [followRemark1 makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(lineName1);
        make.top.equalTo(lineName1.bottom).offset(5);
    }];
    followRemark1.text = @"备注:客服";
    
    if (grabItemCount == 2) {
        
        GrabItem *secondGrabItem = grabItemArray[0];
        
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
        
        UIView *topView2 = [[UIView alloc] init];
        [self.contentView addSubview:topView2];
        [topView2 makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lineView.bottom).offset(1);
            make.left.equalTo(self.contentView.left).offset(0);
            make.width.equalTo(SCREEN_WIDTH - kRightLabelWith);
            make.height.equalTo(kTopViewHeight);
        }];

        UIImageView *dateImg2 = [[UIImageView alloc] init];
        [topView2 addSubview:dateImg2];
        [dateImg2 makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(4);
            make.left.equalTo(4);
            make.width.height.equalTo(35);
        }];
        dateImg2.image = [UIImage imageNamed:@"ic_date_blue"];
        
        UILabel *factoryTruckingTime2 = [[UILabel alloc] init];
        [topView2 addSubview:factoryTruckingTime2];
        [factoryTruckingTime2 makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(dateImg2.centerY);
            make.left.equalTo(dateImg2.right).offset(5);
        }];
        factoryTruckingTime2.text = secondGrabItem.FactoryTruckingTime;
        factoryTruckingTime2.text = @"2015-08-12 10:10";
        
        NSInteger dispatchType2 = secondGrabItem.DispatchType;
        NSString *dispatchTypeString2 = ((dispatchType2 == 1) ? @"装货" : @"送货");
        dispatchTypeString2 = @"送货";
        UILabel *dispatchTypeLabel2 = [[UILabel alloc] init];
        [topView2 addSubview:dispatchTypeLabel2];
        [dispatchTypeLabel2 makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(factoryTruckingTime2.centerY);
            make.right.equalTo(topView2.right).offset(-5);
        }];
        dispatchTypeLabel2.text = dispatchTypeString2;
        dispatchTypeLabel2.textColor = kRGB(18, 141, 254);
        
        UILabel *containerType2 = [[UILabel alloc] init];
        [topView2 addSubview:containerType2];
        [containerType2 makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(dispatchTypeLabel2.centerY);
            make.right.equalTo(dispatchTypeLabel2.left).offset(-5);
        }];
        containerType2.text = secondGrabItem.ContainerType;
        containerType2.text = @"40PG";
        containerType2.textColor = kRGB(18, 141, 254);
        
        UIImageView *locationImg2 = [[UIImageView alloc] init];
        [topView2 addSubview:locationImg2];
        [locationImg2 makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(dateImg2.leading);
            make.top.equalTo(dateImg2.bottom).offset(5);
            make.width.height.equalTo(27);
        }];
        locationImg2.image = [UIImage imageNamed:@"ic_location"];
        
        UILabel *address2 = [[UILabel alloc] init];
        [topView2 addSubview:address2];
        NSString *addressString2 = [NSString stringWithFormat:@"地址是:%@", [secondGrabItem FactoryAddress]];
        addressString2 = @"地址:我饿期末考了我们了吗,我饿";
        CGSize addressStringSize2 = [addressString2 sizeWithFont:[UIFont systemFontOfSize:17] andMaxSize:CGSizeMake(SCREEN_WIDTH - 5 * 2 - 27, CGFLOAT_MAX)];
        [address2 makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(locationImg2.centerY);
            make.left.equalTo(locationImg2.right).offset(5);
            make.right.equalTo(topView2.right).offset(0);
        }];
        address2.numberOfLines = 0;
        address2.text = addressString2;

        UILabel *lineName2 = [[UILabel alloc] init];
        [topView2 addSubview:lineName2];
        [lineName2 makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(address2);
            make.top.equalTo(address2.bottom).offset(5);
        }];
        lineName2.text = @"箱属:韩进";
        
        UILabel *followRemark2 = [[UILabel alloc] init];
        [topView2 addSubview:followRemark2];
        [followRemark2 makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(lineName2);
            make.top.equalTo(lineName2.bottom).offset(5);
        }];
        followRemark2.text = @"备注:客服";
        self.followRemark2 = followRemark2;
    }
    
    UILabel *totalCost = [[UILabel alloc] init];
    [self.contentView addSubview:totalCost];
    [totalCost makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(followRemark1);
        if (grabItemCount == 1) {
            make.top.equalTo(followRemark1.bottom).offset(5);
        } else if (grabItemCount == 2) {
            make.top.equalTo(self.followRemark2.bottom).offset(5);
        }
    }];
    NSString *totalCostString = [NSString stringWithFormat:@"￥%zd", firstGrabItem.TotalCosts];
    totalCostString = @"$1000";
    totalCost.text = totalCostString;
    totalCost.textColor = kRGB(250, 172, 66);
    
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
//    "GrabStatus":抢单状态（0未开始/1竞价中/2已派车/3已取消/4无人竞价结束）
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
    grabStatusString = @"无人竞价结束";
    grabStatus.text = grabStatusString;
    grabStatus.backgroundColor = kDefaultBarButtonItemColor;
    
}

@end
