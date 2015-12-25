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
    return (itemArray.count == 1) ? 185 : 310;
}

/**
 *  创建cell上的视图
 *
 *  @param 模型中的itemArray
 */
- (void)setUpViews:(NSArray *)itemArray {
    //  箱子个数
    NSInteger itemCount = [itemArray count];
    
    Item *fistItem = itemArray[0];
    
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
    appointDate1.text = fistItem.AppointDate;
    appointDate1.text = @"8月30日";
    
    UILabel *containerType1 = [[UILabel alloc] init];
    [totalView addSubview:containerType1];
    [containerType1 makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(appointDate1.centerY);
        make.left.equalTo(appointDate1.right).offset(kLabelMargin);
    }];
    containerType1.text = fistItem.ContainerType;
    containerType1.text = @"40GP";
    
    UILabel *customsMode1 = [[UILabel alloc] init];
    [totalView addSubview:customsMode1];
    [customsMode1 makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(containerType1.centerY);
        make.left.equalTo(containerType1.right).offset(kLabelMargin);
    }];
    customsMode1.text = fistItem.CustomsMode;
    customsMode1.text = @"出清";
    
    UILabel *nodeStatus1 = [[UILabel alloc] init];
    [totalView addSubview:nodeStatus1];
    [nodeStatus1 makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(customsMode1.centerY);
        make.right.equalTo(totalView.right).offset(-kMargin);
    }];
    nodeStatus1.text = fistItem.NodeStatus;
    nodeStatus1.text = @"暂未开始";
    
    UIView *nextView1 = [[UIView alloc] init];
    [totalView addSubview:nextView1];
    [nextView1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dataImageView1.bottom).offset(kLabelMargin);
        make.left.right.equalTo(0);
        make.height.equalTo(70);
    }];
    nextView1.backgroundColor = kRGB(251, 251, 251);
    [nextView1 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapNextView:)]];
    
    
    UIImageView *locationImg1 = [[UIImageView alloc] init];
    [nextView1 addSubview:locationImg1];
    [locationImg1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nextView1.top).offset(4);
        make.left.equalTo(kMargin);
        make.width.height.equalTo(27);
    }];
    locationImg1.image = [UIImage imageNamed:@"ic_location"];
    
    UILabel *address1 = [[UILabel alloc] init];
    [nextView1 addSubview:address1];
    [address1 makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(locationImg1.centerY);
        make.left.equalTo(locationImg1.right).offset(kLabelMargin);
    }];
    address1.text = fistItem.Address;
    address1.text = @"高老庄 - 花果山";
    
    UIImageView *carImg1 = [[UIImageView alloc] init];
    [nextView1 addSubview:carImg1];
    [carImg1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(locationImg1.bottom).offset(8);
        make.left.equalTo(kMargin);
        make.width.height.equalTo(27);
    }];
    carImg1.image = [UIImage imageNamed:@"ic_car"];
    
    UILabel *teamName1 = [[UILabel alloc] init];
    [nextView1 addSubview:teamName1];
    [teamName1 makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(carImg1.centerY);
        make.left.equalTo(carImg1.right).offset(kLabelMargin);
    }];
    teamName1.text = fistItem.TeamName;
    teamName1.text = @"深圳志诚达";
 
    UIImageView *nextImg = [[UIImageView alloc] init];
    [nextView1 addSubview:nextImg];
    [nextImg makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(nextView1.centerY);
        make.height.width.equalTo(16);
        make.right.equalTo(nextView1.right).offset(-5);
    }];
    nextImg.image = [UIImage imageNamed:@"mine_next"];
    
    itemCount = 2;
    
    if (itemCount == 1) {
        UILabel *fee1 = [[UILabel alloc] init];
        [totalView addSubview:fee1];
        [fee1 makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(nextView1.bottom).offset (0);
            make.left.equalTo(totalView.left).offset(kMargin);
            make.height.equalTo(50);
        }];
        fee1.text = fistItem.Fee;
        fee1.text = @"￥888";
        fee1.textColor = kRGB(252, 57, 8);
        
        
        UIButton *dispatch = [[UIButton alloc] init];
        [totalView addSubview:dispatch];
        [dispatch makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(nextView1.bottom).offset (5);
            make.right.equalTo(totalView.right).offset(-kMargin);
            make.height.equalTo(40);
            make.width.equalTo(90);
        }];
        [dispatch setTitle:@"联系调度" forState:UIControlStateNormal];
        [dispatch setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [dispatch setBackgroundImage:[UIImage resizedImage:@"btn_bg_blue_normal"] forState:UIControlStateNormal];
        dispatch.titleEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);

    }
    
    //  如果有两个箱子
    if (itemCount == 2) {
        //  cell上面还要添加一个箱子
        Item *secondItem = itemArray[1];
        
        DashLineView *dashLineView = [[DashLineView alloc] init];
        [totalView addSubview:dashLineView];
        [dashLineView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(nextView1.bottom).offset(5);
            make.left.right.equalTo(0);
            make.height.equalTo(1);
        }];
        dashLineView.backgroundColor = [UIColor clearColor];
        
        UIImageView *dataImageView2 = [[UIImageView alloc] init];
        [totalView addSubview:dataImageView2];
        [dataImageView2 makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(dashLineView.top).offset(kLabelMargin);
            make.left.equalTo(totalView.left).offset(kMargin);
            make.width.height.equalTo(40);
        }];
        dataImageView2.image = [UIImage imageNamed:@"ic_date_blue"];
        
        UILabel *appointDate2 = [[UILabel alloc] init];
        [totalView addSubview:appointDate2];
        [appointDate2 makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(dataImageView2.centerY);
            make.left.equalTo(dataImageView2.right).offset(kLabelMargin);
        }];
        appointDate2.text = secondItem.AppointDate;
        appointDate2.text = @"8月31日";
        
        UILabel *containerType2 = [[UILabel alloc] init];
        [totalView addSubview:containerType2];
        [containerType2 makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(appointDate2.centerY);
            make.left.equalTo(appointDate2.right).offset(kLabelMargin);
        }];
        containerType2.text = secondItem.ContainerType;
        containerType2.text = @"100GP";
        
        UILabel *customsMode2 = [[UILabel alloc] init];
        [totalView addSubview:customsMode2];
        [customsMode2 makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(containerType2.centerY);
            make.left.equalTo(containerType2.right).offset(kLabelMargin);
        }];
        customsMode2.text = secondItem.CustomsMode;
        customsMode2.text = @"出清";
        
        UILabel *nodeStatus2 = [[UILabel alloc] init];
        [totalView addSubview:nodeStatus2];
        [nodeStatus2 makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(customsMode2.centerY);
            make.right.equalTo(totalView.right).offset(-kMargin);
        }];
        nodeStatus2.text = secondItem.NodeStatus;
        nodeStatus2.text = @"暂未开始";

        UIView *nextView2 = [[UIView alloc] init];
        [totalView addSubview:nextView2];
        [nextView2 makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(dataImageView2.bottom).offset(kLabelMargin);
            make.left.right.equalTo(0);
            make.height.equalTo(70);
        }];
        nextView2.backgroundColor = kRGB(251, 251, 251);
        [nextView2 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapNextView:)]];
        
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
        }];
        address2.text = secondItem.Address;
        address2.text = @"高老庄 - 花果山";
        
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
        }];
        teamName2.text = secondItem.TeamName;
        teamName2.text = @"深圳志诚达";
        
        UIImageView *nextImg2 = [[UIImageView alloc] init];
        [nextView2 addSubview:nextImg2];
        [nextImg2 makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(nextView2.centerY);
            make.height.width.equalTo(16);
            make.right.equalTo(nextView2.right).offset(-5);
        }];
        nextImg2.image = [UIImage imageNamed:@"mine_next"];
        
        UILabel *fee2 = [[UILabel alloc] init];
        [totalView addSubview:fee2];
        [fee2 makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(nextView2.bottom).offset (0);
            make.left.equalTo(totalView.left).offset(kMargin);
            make.height.equalTo(50);
        }];
        fee2.text = secondItem.Fee;
        fee2.text = @"￥888.9";
        fee2.textColor = kRGB(252, 57, 8);
        
        UIButton *dispatch2 = [[UIButton alloc] init];
        [totalView addSubview:dispatch2];
        [dispatch2 makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(nextView2.bottom).offset (5);
            make.right.equalTo(totalView.right).offset(-kMargin);
            make.height.equalTo(40);
            make.width.equalTo(90);
        }];
        [dispatch2 setTitle:@"联系调度" forState:UIControlStateNormal];
        [dispatch2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [dispatch2 setBackgroundImage:[UIImage resizedImage:@"btn_bg_blue_normal"] forState:UIControlStateNormal];
        dispatch2.titleEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    }
    
}

#pragma mark - nextView点击手势
- (void)tapNextView:(UITapGestureRecognizer *)tap {
    if ([self.listMoreOrderCellDelegate respondsToSelector:@selector(nextViewOnTap:)]) {
        [self.listMoreOrderCellDelegate nextViewOnTap:tap];
    }
}

@end
