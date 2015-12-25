//
//  ListSingleOrderControllerViewController.m
//  tcb
//
//  Created by Jax on 15/11/13.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import "NSString+Extension.h"

#import "ListSingleOrderController.h"

#import "OptionButton.h"
#import "DashLineView.h"
#import "AddLineCell.h"

#define kLabelFont(font)  [UIFont systemFontOfSize:font]
#define kLabelLeftMargin 15
#define kMarginLeft 10
#define kScrollerViewContentSizeH 850
#define kDetailViewHeight (208 + 3 * 38)
#define kWeightFont [UIFont systemFontOfSize:14]
#define kNodeNum 3
#define kNodeCellHeight 38

@interface ListSingleOrderController () <UITableViewDelegate, UITableViewDataSource>

/**
 *  装所有的子视图
 */
@property (nonatomic, strong) UIView *totalView;
/**
 *  箱子个数
 */
@property (nonatomic, assign) NSInteger detailCount;
/**
 *  箱子详情1视图
 */
@property (nonatomic, strong) UIView *detailView1;
/**
 *  箱子详情2视图
 */
@property (nonatomic, strong) UIView *detailView2;
/**
 *  箱子详情1
 */
@property (nonatomic, strong) ItemDetail *firstDetail;
/**
 *  箱子详情2
 */
@property (nonatomic, strong) ItemDetail *secondDetail;
/**
 *  费用视图
 */
@property (nonatomic, strong) UIView *feeView;

@end

@implementation ListSingleOrderController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //  箱子详情信息数组
    NSArray *itemArray = self.orderDetail.item;
    NSInteger detailCount = [itemArray count];
    self.detailCount = detailCount;
    self.detailCount = 2;
    
    self.view.backgroundColor = kRGB(214, 214, 214);
    self.title = @"接定向单";
    
    [self setupViews:itemArray];
    [self setupFee];
    [self setupContact];

}

- (void)setupViews:(NSArray *)itemArray {
    
    ItemDetail *firstDetail = itemArray[0];
    self.firstDetail = firstDetail;
    
    UIScrollView *scrollerView = [[UIScrollView alloc] init];
    [self.view addSubview:scrollerView];
    scrollerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    scrollerView.contentSize = CGSizeMake(SCREEN_WIDTH, kScrollerViewContentSizeH);
    
    UIView *totalView = [[UIView alloc] init];
    self.totalView = totalView;
    [scrollerView addSubview:totalView];
    totalView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 1000);
    
    /*************************第一个箱子的view**************************/
    
    //  车队名+调度姓名+派单时间
    UILabel *dispatcherLabel = [[UILabel alloc] init];
    [totalView addSubview:dispatcherLabel];
    [dispatcherLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(0);
        make.height.equalTo(40);
    }];
    dispatcherLabel.font = kLabelFont(17);
    dispatcherLabel.textColor = [UIColor whiteColor];
    NSString *teamName = firstDetail.TeamName;
    NSString *dispatcher = firstDetail.Dispatcher;
    NSString *DispTime = firstDetail.TeamName;
    teamName = @"凯特物流";
    dispatcher = @"邹艳梅";
    DispTime = @"派单时间";
    NSString *dispatchText = [NSString stringWithFormat:@"   %@  %@  %@", teamName, dispatcher, DispTime];
    dispatcherLabel.text = dispatchText;
    dispatcherLabel.backgroundColor = kRGB(17, 112, 197);
    
   //   进出口字段
    UIView *detailView1 = [[UIView alloc] init];
    [totalView addSubview:detailView1];
    [detailView1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dispatcherLabel.bottom).offset(0);
        make.left.right.equalTo(0);
        make.height.equalTo(kDetailViewHeight);
    }];
    self.detailView1 = detailView1;
    detailView1.backgroundColor = kRGB(17, 141, 254);
    
    /*--------------------------船名航次--------------------------*/
    UILabel *shipVoyage1 = [self labelWithTitle:@"船名航次"];
    [detailView1 addSubview:shipVoyage1];
    [shipVoyage1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(detailView1.top).offset(10);
        make.left.equalTo(detailView1.left).offset(kLabelLeftMargin);
    }];
    UILabel *shipVoyageName1 = [self labelWithTitle:firstDetail.ShipVoyage];
    shipVoyageName1.text = @"OOCL ROTTERFAM 035W";
    shipVoyageName1.font = kLabelFont(17);
    [detailView1 addSubview:shipVoyageName1];
    [shipVoyageName1 makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(shipVoyage1.centerY);
        make.left.equalTo(shipVoyage1.right).equalTo(kLabelLeftMargin);
    }];
    /*--------------------------提单号--------------------------*/
    UILabel *BookingNo1 = [self labelWithTitle:@"提单号"];
    [detailView1 addSubview:BookingNo1];
    [BookingNo1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(shipVoyage1.bottom).offset(10);
        make.left.equalTo(totalView.left).offset(kLabelLeftMargin);
    }];
    UILabel *BookingNoName1 = [self labelWithTitle:firstDetail.BookingNo];
    BookingNoName1.text = @"OOLU3333112456WHL";
    BookingNoName1.font = kLabelFont(17);
    [detailView1 addSubview:BookingNoName1];
    [BookingNoName1 makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(BookingNo1.centerY);
        make.left.equalTo(shipVoyageName1.left).equalTo(0);
    }];
    /*--------------------装箱--------截仓------------------------*/
    NSInteger businessType1 = firstDetail.BusinessType;
    businessType1 = 0;
    NSString *string11 = (businessType1 == 0 ? @"装箱" : @"装货");
    NSString *string21 = (businessType1 == 0 ? @"截关" : @"截仓");
    UILabel *businessType11 = [self labelWithTitle:string11];
    [detailView1 addSubview:businessType11];
    businessType11.textAlignment = NSTextAlignmentCenter;
    [businessType11 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(BookingNo1.bottom).offset(10);
        make.left.equalTo(detailView1.left).offset(0);
        make.width.equalTo(SCREEN_WIDTH * 0.5);
        make.height.equalTo(35);
    }];
    UILabel *businessType21 = [self labelWithTitle:string21];
    [detailView1 addSubview:businessType21];
    businessType21.textAlignment = NSTextAlignmentCenter;
    [businessType21 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(BookingNo1.bottom).offset(10);
        make.right.equalTo(detailView1.right).offset(0);
        make.width.equalTo(SCREEN_WIDTH * 0.5);
        make.height.equalTo(35);
    }];

    /*---------------------------出清-------------------------*/
    UIButton *customsMode1 = [[UIButton alloc] init];
    [detailView1 addSubview:customsMode1];
    [customsMode1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(businessType11.top).offset(12);
        make.centerX.equalTo(detailView1.centerX);
        make.width.equalTo(60);
        make.height.equalTo(40);
    }];
    [customsMode1 setTitle:@"出清" forState:UIControlStateNormal];
    customsMode1.layer.borderColor = [[UIColor whiteColor] CGColor];
    customsMode1.layer.borderWidth = 1;
    
    /*----------------装箱time--------截仓time-------------------*/
    UILabel *beginTime1 = [self labelWithTitle:firstDetail.BeginTime];
    [detailView1 addSubview:beginTime1];
    beginTime1.textAlignment = NSTextAlignmentCenter;
    beginTime1.font = [UIFont systemFontOfSize:13];
    beginTime1.text = @"08月10日16:00";
    
    [beginTime1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(businessType11.bottom).offset(4);
        make.left.equalTo(detailView1.left).offset(0);
        make.right.equalTo(customsMode1.left).offset(0);
    }];
    UILabel *endTime1 = [self labelWithTitle:firstDetail.EndTime];
    [detailView1 addSubview:endTime1];
    endTime1.textAlignment = NSTextAlignmentCenter;
    endTime1.font = [UIFont systemFontOfSize:13];
    endTime1.text = @"08月11日16:00";
    [endTime1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(beginTime1.top).offset(0);
        make.right.equalTo(detailView1.right).offset(0);
        make.left.equalTo(customsMode1.right).offset(0);
    }];

    /*--------------------------毛重--------------------------*/
    UIView *weightView1 = [[UIView alloc] init];
    [detailView1 addSubview:weightView1];
    NSString *pieceOrContainerTypeString1 = firstDetail.PieceOrContainerType;
    NSString *weightString1 = firstDetail.Weight;
    NSString *cubageString1 = firstDetail.Cubage;
    pieceOrContainerTypeString1 = @"1235CTNS";
    weightString1 = @"17000kgs(毛重)";
    cubageString1 = @"50m^3";
    
    CGSize pieceOrContainerTypeStringSize1 = [pieceOrContainerTypeString1 sizeWithFont:kWeightFont  andMaxSize:CGSizeMake(SCREEN_WIDTH, MAXFLOAT)];
    CGSize weightStringSize1 = [weightString1 sizeWithFont:kWeightFont  andMaxSize:CGSizeMake(SCREEN_WIDTH, MAXFLOAT)];
    CGSize cubageStringSize1 = [cubageString1 sizeWithFont:kWeightFont  andMaxSize:CGSizeMake(SCREEN_WIDTH, MAXFLOAT)];
    
    CGFloat weightViewW1 = pieceOrContainerTypeStringSize1.width + weightStringSize1.width + cubageStringSize1.width + 22;
    CGFloat weightViewH1 = pieceOrContainerTypeStringSize1.height;
    
    [weightView1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(beginTime1.bottom).offset(10);
        make.width.equalTo(weightViewW1);
        make.height.equalTo(weightViewH1);
        make.centerX.equalTo(detailView1.centerX);
    }];
    
    UILabel *pieceOrContainerType1 = [self labelWithTitle:pieceOrContainerTypeString1];
    [weightView1 addSubview:pieceOrContainerType1];
    [pieceOrContainerType1 makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(0);
    }];
    pieceOrContainerType1.font =  kWeightFont;

    UIView *lineView11 = [[UIView alloc] init];
    lineView11.backgroundColor = [UIColor whiteColor];
    [weightView1 addSubview:lineView11];
    [lineView11 makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.equalTo(0);
        make.left.equalTo(pieceOrContainerType1.right).offset(5);
        make.width.equalTo(1);
    }];

    UILabel *weight1 = [self labelWithTitle:weightString1];
    [weightView1 addSubview:weight1];
    weight1.font =  kWeightFont;
    [weight1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.equalTo(0);
        make.left.equalTo(lineView11.right).offset(5);
    }];
    
    UIView *lineView12 = [[UIView alloc] init];
    [weightView1 addSubview:lineView12];
    [lineView12 makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.equalTo(0);
        make.left.equalTo(weight1.right).offset(5);
        make.width.equalTo(1);
    }];
    lineView12.backgroundColor = [UIColor whiteColor];
    
   
    UILabel *cubage1 = [self labelWithTitle:cubageString1];
    [weightView1 addSubview:cubage1];
    [cubage1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(0);
        make.left.equalTo(lineView12.right).offset(5);
    }];
    cubage1.font =  kWeightFont;
    
    /*--------------------------苏杰电子速--------------------------*/
    UILabel *factoryShortName1 = [self labelWithTitle:firstDetail.FactoryShortName];
    [detailView1 addSubview:factoryShortName1];
    [factoryShortName1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weightView1.bottom).offset(7);
        make.centerX.equalTo(detailView1.centerX);
    }];
    factoryShortName1.text = @"苏杰电子速";
    factoryShortName1.font =  kWeightFont;

    /*--------------------------备注--------------------------*/
    UILabel *followRemark1 = [self labelWithTitle:@"备注:"];
    [detailView1 addSubview:followRemark1];
    [followRemark1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(factoryShortName1.bottom).offset(5);
        make.left.equalTo(detailView1.left).offset(15);
    }];
    followRemark1.font = kLabelFont(17);
    
    UILabel *followRemarkName1 = [self labelWithTitle:firstDetail.FollowRemark];
    [detailView1 addSubview:followRemarkName1];
    [followRemarkName1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(factoryShortName1.bottom).offset(5);
        make.left.equalTo(followRemark1.right).offset(8);
    }];
    followRemarkName1.text = @"BeiZhuZaizheli8";
    followRemarkName1.font = kLabelFont(17);
    
    /*--------------------------画虚线--------------------------*/
    DashLineView *dashLineView1 = [[DashLineView alloc] init];
    dashLineView1.lineColor = [UIColor whiteColor];
    dashLineView1.backgroundColor = [UIColor clearColor];
    [totalView addSubview:dashLineView1];
    [dashLineView1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(followRemarkName1.bottom).offset(5);
        make.left.right.equalTo(totalView).offset(0);
        make.height.equalTo(1);
    }];
    
    /*--------------------------node--------------------------*/
    UITableView *nodeTableView1 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,  SCREEN_WIDTH, 3 * 38) style:UITableViewStylePlain];
    [detailView1 addSubview:nodeTableView1];
    [nodeTableView1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dashLineView1.bottom).offset(0);
        make.left.right.equalTo(0);
        make.height.equalTo(kNodeNum * kNodeCellHeight);
    }];
    nodeTableView1.tag = 0;
    nodeTableView1.editing = NO;
    nodeTableView1.separatorStyle = UITableViewCellSeparatorStyleNone;
    nodeTableView1.rowHeight = 38;
    nodeTableView1.dataSource = self;
    nodeTableView1.delegate = self;
    nodeTableView1.scrollEnabled = NO;

    /*****************如果有2个箱子加上第二个箱子的view*********************/
    if (self.detailCount == 2) {
        
        ItemDetail *secondDetail = itemArray[1];
        self.secondDetail = secondDetail;
        UIView *whiteLine = [[UIView alloc] init];
        [totalView addSubview:whiteLine];
        [whiteLine makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(detailView1.bottom).offset(0.5);
            make.left.right.equalTo(totalView);
        }];
        whiteLine.backgroundColor = [UIColor whiteColor];
        
        //   进出口字段2
        UIView *detailView2 = [[UIView alloc] init];
        [totalView addSubview:detailView2];
        [detailView2 makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(whiteLine.bottom).offset(0);
            make.left.right.equalTo(0);
            make.height.equalTo(kDetailViewHeight);
        }];
        self.detailView2 = detailView2;
        detailView2.backgroundColor = kRGB(17, 141, 254);
        
        /*--------------------------船名航次2--------------------------*/
        UILabel *shipVoyage2 = [self labelWithTitle:@"船名航次"];
        [detailView2 addSubview:shipVoyage2];
        [shipVoyage2 makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(detailView2.top).offset(10);
            make.left.equalTo(detailView2.left).offset(kLabelLeftMargin);
        }];
        UILabel *shipVoyageName2 = [self labelWithTitle:secondDetail.ShipVoyage];
        shipVoyageName2.text = @"OOCL ROTTERFAM 035W";
        shipVoyageName2.font = kLabelFont(17);
        [detailView2 addSubview:shipVoyageName2];
        [shipVoyageName2 makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(shipVoyage2.centerY);
            make.left.equalTo(shipVoyage2.right).equalTo(kLabelLeftMargin);
        }];
        /*--------------------------提单号2--------------------------*/
        UILabel *BookingNo2 = [self labelWithTitle:@"提单号"];
        [detailView2 addSubview:BookingNo2];
        [BookingNo2 makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(shipVoyage2.bottom).offset(10);
            make.left.equalTo(totalView.left).offset(kLabelLeftMargin);
        }];
        UILabel *BookingNoName2 = [self labelWithTitle:secondDetail.BookingNo];
        BookingNoName2.text = @"OOLU3333112456WHL";
        BookingNoName2.font = kLabelFont(17);
        [detailView2 addSubview:BookingNoName2];
        [BookingNoName2 makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(BookingNo2.centerY);
            make.left.equalTo(shipVoyageName2.left).equalTo(0);
        }];
        /*--------------------装箱2--------截仓2------------------------*/
        NSInteger businessType2 = secondDetail.BusinessType;
        businessType2 = 1;
        NSString *string21 = (businessType2 == 0 ? @"装箱" : @"装货");
        NSString *string22 = (businessType2 == 0 ? @"截关" : @"截仓");
        UILabel *businessType21 = [self labelWithTitle:string21];
        [detailView2 addSubview:businessType21];
        businessType21.textAlignment = NSTextAlignmentCenter;
        [businessType21 makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(BookingNo2.bottom).offset(10);
            make.left.equalTo(detailView2.left).offset(0);
            make.width.equalTo(SCREEN_WIDTH * 0.5);
            make.height.equalTo(35);
        }];
        UILabel *businessType22 = [self labelWithTitle:string22];
        [detailView2 addSubview:businessType22];
        businessType22.textAlignment = NSTextAlignmentCenter;
        [businessType22 makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(BookingNo2.bottom).offset(10);
            make.right.equalTo(detailView2.right).offset(0);
            make.width.equalTo(SCREEN_WIDTH * 0.5);
            make.height.equalTo(35);
        }];
        
        /*---------------------------出清2-------------------------*/
        UIButton *customsMode2 = [[UIButton alloc] init];
        [detailView2 addSubview:customsMode2];
        [customsMode2 makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(businessType21.top).offset(12);
            make.centerX.equalTo(detailView2.centerX);
            make.width.equalTo(60);
            make.height.equalTo(40);
        }];
        [customsMode2 setTitle:@"出清" forState:UIControlStateNormal];
        customsMode2.layer.borderColor = [[UIColor whiteColor] CGColor];
        customsMode2.layer.borderWidth = 1;
        
        /*----------------装箱time2--------截仓time2-------------------*/
        UILabel *beginTime2 = [self labelWithTitle:secondDetail.BeginTime];
        [detailView2 addSubview:beginTime2];
        [beginTime2 makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(businessType21.bottom).offset(4);
            make.left.equalTo(detailView2.left).offset(0);
            make.right.equalTo(customsMode2.left).offset(0);
        }];
        beginTime2.textAlignment = NSTextAlignmentCenter;
        beginTime2.font = [UIFont systemFontOfSize:13];
        beginTime2.text = @"08月10日16:00";
        
        UILabel *endTime2 = [self labelWithTitle:secondDetail.EndTime];
        [detailView2 addSubview:endTime2];
        endTime2.textAlignment = NSTextAlignmentCenter;
        endTime2.font = [UIFont systemFontOfSize:13];
        endTime2.text = @"08月11日16:00";
        [endTime2 makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(beginTime2.top).offset(0);
            make.right.equalTo(detailView2.right).offset(0);
            make.left.equalTo(customsMode2.right).offset(0);
        }];

        /*--------------------------毛重2--------------------------*/
        UIView *weightView2 = [[UIView alloc] init];
        [detailView2 addSubview:weightView2];
        NSString *pieceOrContainerTypeString2 = secondDetail.PieceOrContainerType;
        NSString *weightString2 = secondDetail.Weight;
        NSString *cubageString2 = secondDetail.Cubage;
        pieceOrContainerTypeString2 = @"1235CTNS";
        weightString2 = @"17000kgs(毛重)";
        cubageString2 = @"50m^3";
        
        CGSize pieceOrContainerTypeStringSize2 = [pieceOrContainerTypeString2 sizeWithFont:kWeightFont  andMaxSize:CGSizeMake(SCREEN_WIDTH, MAXFLOAT)];
        CGSize weightStringSize2 = [weightString2 sizeWithFont:kWeightFont  andMaxSize:CGSizeMake(SCREEN_WIDTH, MAXFLOAT)];
        CGSize cubageStringSize2 = [cubageString2 sizeWithFont:kWeightFont  andMaxSize:CGSizeMake(SCREEN_WIDTH, MAXFLOAT)];
        
        CGFloat weightViewW2 = pieceOrContainerTypeStringSize2.width + weightStringSize2.width + cubageStringSize2.width + 22;
        CGFloat weightViewH2 = pieceOrContainerTypeStringSize2.height;
        
        [weightView2 makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(beginTime2.bottom).offset(10);
            make.width.equalTo(weightViewW2);
            make.height.equalTo(weightViewH2);
            make.centerX.equalTo(detailView2.centerX);
        }];
        
        UILabel *pieceOrContainerType2 = [self labelWithTitle:pieceOrContainerTypeString1];
        [weightView2 addSubview:pieceOrContainerType2];
        [pieceOrContainerType2 makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(0);
        }];
        pieceOrContainerType2.font =  kWeightFont;
        
        UIView *lineView21 = [[UIView alloc] init];
        [weightView2 addSubview:lineView21];
        [lineView21 makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.bottom.equalTo(0);
            make.left.equalTo(pieceOrContainerType2.right).offset(5);
            make.width.equalTo(1);
        }];
        lineView21.backgroundColor = [UIColor whiteColor];
        
        UILabel *weight2 = [self labelWithTitle:weightString2];
        [weightView2 addSubview:weight2];
        weight2.font =  kWeightFont;
        [weight2 makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.bottom.equalTo(0);
            make.left.equalTo(lineView21.right).offset(5);
        }];
        
        UIView *lineView22 = [[UIView alloc] init];
        [weightView2 addSubview:lineView22];
        [lineView22 makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.bottom.equalTo(0);
            make.left.equalTo(weight1.right).offset(5);
            make.width.equalTo(1);
        }];
        lineView22.backgroundColor = [UIColor whiteColor];
        
        
        UILabel *cubage2 = [self labelWithTitle:cubageString2];
        [weightView2 addSubview:cubage2];
        [cubage2 makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(0);
            make.left.equalTo(lineView12.right).offset(5);
        }];
        cubage2.font =  kWeightFont;
        
        /*--------------------------苏杰电子速2--------------------------*/
        UILabel *factoryShortName2 = [self labelWithTitle:secondDetail.FactoryShortName];
        [detailView2 addSubview:factoryShortName2];
        [factoryShortName2 makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weightView2.bottom).offset(7);
            make.centerX.equalTo(detailView2.centerX);
        }];
        factoryShortName2.text = @"苏杰电子速";
        factoryShortName2.font =  kWeightFont;
        
        /*--------------------------备注2--------------------------*/
        UILabel *followRemark2 = [self labelWithTitle:@"备注:"];
        [detailView2 addSubview:followRemark2];
        [followRemark2 makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(factoryShortName2.bottom).offset(5);
            make.left.equalTo(detailView2.left).offset(15);
        }];
        followRemark2.font = kLabelFont(17);
        
        UILabel *followRemarkName2 = [self labelWithTitle:secondDetail.FollowRemark];
        [detailView2 addSubview:followRemarkName2];
        [followRemarkName2 makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(factoryShortName2.bottom).offset(5);
            make.left.equalTo(followRemark2.right).offset(8);
        }];
        followRemarkName2.text = @"BeiZhuZaizheli8";
        followRemarkName2.font = kLabelFont(17);
        
        /*--------------------------画虚线2--------------------------*/
        DashLineView *dashLineView2 = [[DashLineView alloc] init];
        dashLineView2.lineColor = [UIColor whiteColor];
        dashLineView2.backgroundColor = [UIColor clearColor];
        [totalView addSubview:dashLineView2];
        [dashLineView2 makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(followRemark2.bottom).offset(5);
            make.left.right.equalTo(totalView).offset(0);
            make.height.equalTo(1);
        }];

        /*--------------------------node2--------------------------*/
        UITableView *nodeTableView2 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,  SCREEN_WIDTH, 3 * 38) style:UITableViewStylePlain];
        [detailView2 addSubview:nodeTableView2];
        [nodeTableView2 makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(dashLineView2.bottom).offset(1);
            make.left.right.equalTo(0);
            make.height.equalTo(kNodeNum * kNodeCellHeight);
        }];
        nodeTableView2.tag = 1;
        nodeTableView2.editing = NO;
        nodeTableView2.separatorStyle = UITableViewCellSeparatorStyleNone;
        nodeTableView2.rowHeight = 38;
        nodeTableView2.dataSource = self;
        nodeTableView2.delegate = self;
        nodeTableView2.scrollEnabled = NO;
    }
}

- (void)setupFee {
    
    UIView *feeView = [[UIView alloc] init];
    [self.totalView addSubview:feeView];
    [feeView makeConstraints:^(MASConstraintMaker *make) {
        if (self.detailCount == 1) {
            make.top.equalTo(self.detailView1.bottom).offset(0);
        } else if (self.detailCount == 2) {
            make.top.equalTo(self.detailView2.bottom).offset(0);
        }
        make.left.equalTo(self.totalView.left).offset(0);
        make.right.equalTo(self.totalView.right).offset(0);
        make.height.equalTo(40);
    }];
    self.feeView = feeView;
    feeView.backgroundColor = kRGB(255, 255, 255);
    
    UILabel *feeLabel = [self labelWithTitle:@"运费金额:"];
    [feeView addSubview:feeLabel];
    [feeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(feeView.top).offset(0);
        make.left.equalTo(feeView.left).offset(20);
        make.bottom.equalTo(feeView.bottom).offset(0);
    }];
    feeLabel.textColor = [UIColor blackColor];
    
    UILabel *feeNum = [self labelWithTitle:self.firstDetail.Fee];
    [feeView addSubview:feeNum];
    feeNum.text = @"$10000";
    feeNum.textColor = kRGB(244, 74, 12);
    [feeNum makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(feeView.top).offset(0);
        make.left.equalTo(feeLabel.right).offset(30);
        make.bottom.equalTo(feeView.bottom).offset(0);
    }];
}

- (void)setupContact {
    UIView *contactView = [[UIView alloc] init];
    [self.totalView addSubview:contactView];
    [contactView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.feeView.bottom).equalTo(10);
        make.left.equalTo(self.totalView.left).equalTo(0);
        make.right.equalTo(self.totalView.right).equalTo(0);
        make.height.equalTo(100);
    }];
    contactView.backgroundColor = [UIColor whiteColor];

    for (int i = 0; i < 2; i ++) {
        CGFloat lineViewWidth = 0.50f;
        CGFloat lineViewHeight = 60.0f;
        CGFloat margin = (SCREEN_WIDTH - 2 * lineViewWidth) / 3.0 ;
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(margin + (margin + lineViewWidth) * i, (100 - lineViewHeight) / 2.0, lineViewWidth, lineViewHeight)];
        [contactView addSubview:lineView];
        lineView.backgroundColor = [UIColor grayColor];
    }
    
    NSArray *optionButtonTitle = @[@"联系调度", @"拒绝出车", @"马上接单"];
    NSArray *optionButtonImage = @[@"ic_phone", @"ic_rest", @"ic_car_wantList"];
    for (int i = 0; i < 3; i++) {
        CGFloat optionButtonW = (SCREEN_WIDTH - 1) / 3;;
        CGFloat optionButtonH = 100;
        CGFloat margin = (SCREEN_WIDTH - 3 * optionButtonW) / 4.0;
        OptionButton *optionButton = [[OptionButton alloc] initWithTitle:optionButtonTitle[i] imageName:optionButtonImage[i]];
        optionButton.frame = CGRectMake(margin + (margin +  optionButtonW) * i , 0, optionButtonW, optionButtonH);
        optionButton.tag = i;
        optionButton.userInteractionEnabled = YES;
        [optionButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapOptionButton:)]];
        [contactView addSubview:optionButton];
    }
}

#pragma mark - nodeTableView 
#pragma mark dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 0) {
        if (indexPath.row == 0) {
            AddLineCell *topCell = [AddLineCell cellWithTableView:tableView];
            topCell.addLineCellStyle = AddLineCellStyleTop;
            topCell.contentView.backgroundColor = kRGB(17, 141, 254);
            topCell.imageView.image = [UIImage imageNamed:@"ic_white_circle"];
            topCell.textLabel.text = self.firstDetail.Node1;
            topCell.textLabel.text = @"提控规:基隆场地";
            topCell.textLabel.textColor = [UIColor whiteColor];
            topCell.userInteractionEnabled = NO;
            return topCell;
        } else if (indexPath.row == 2) {
            AddLineCell *bottomCell = [AddLineCell cellWithTableView:tableView];
            bottomCell.addLineCellStyle = AddLineCellStyleBottom;
            bottomCell.contentView.backgroundColor = kRGB(17, 141, 254);
            bottomCell.imageView.image = [UIImage imageNamed:@"ic_white_circle"];
            bottomCell.textLabel.text = self.firstDetail.Node3;
            bottomCell.textLabel.text = @"花果山水帘洞齐天大圣";
            bottomCell.textLabel.textColor = [UIColor whiteColor];
            bottomCell.userInteractionEnabled = NO;
            return bottomCell;
        } else {
            AddLineCell *middleCell = [AddLineCell cellWithTableView:tableView];
            middleCell.addLineCellStyle = AddLineCellStyleMiddle;
            middleCell.contentView.backgroundColor = kRGB(17, 141, 254);
            middleCell.imageView.image = [UIImage imageNamed:@"ic_white_circle"];
            middleCell.textLabel.text = self.firstDetail.Node2;
            middleCell.textLabel.text = @"花果山水帘洞齐天大圣";
            middleCell.textLabel.textColor = [UIColor whiteColor];
            middleCell.userInteractionEnabled = NO;
            return middleCell;
        }

    } else if (tableView.tag == 1) {
        if (indexPath.row == 0) {
            AddLineCell *topCell = [AddLineCell cellWithTableView:tableView];
            topCell.addLineCellStyle = AddLineCellStyleTop;
            topCell.contentView.backgroundColor = kRGB(17, 141, 254);
            topCell.imageView.image = [UIImage imageNamed:@"ic_white_circle"];
            topCell.textLabel.text = self.secondDetail.Node1;
            topCell.textLabel.text = @"提控规:我谁也不知道";
            topCell.textLabel.textColor = [UIColor whiteColor];
            topCell.userInteractionEnabled = NO;
            return topCell;
        } else if (indexPath.row == 2) {
            AddLineCell *bottomCell = [AddLineCell cellWithTableView:tableView];
            bottomCell.addLineCellStyle = AddLineCellStyleBottom;
            bottomCell.contentView.backgroundColor = kRGB(17, 141, 254);
            bottomCell.imageView.image = [UIImage imageNamed:@"ic_white_circle"];
            bottomCell.textLabel.text = self.secondDetail.Node3;
            bottomCell.textLabel.text = @"去打卡去哦我的23";
            bottomCell.textLabel.textColor = [UIColor whiteColor];
            bottomCell.userInteractionEnabled = NO;
            return bottomCell;
        } else {
            AddLineCell *middleCell = [AddLineCell cellWithTableView:tableView];
            middleCell.addLineCellStyle = AddLineCellStyleMiddle;
            middleCell.contentView.backgroundColor = kRGB(17, 141, 254);
            middleCell.imageView.image = [UIImage imageNamed:@"ic_white_circle"];
            middleCell.textLabel.text = self.secondDetail.Node2;
            middleCell.textLabel.text = @"不带去晚点来上课";
            middleCell.textLabel.textColor = [UIColor whiteColor];
            middleCell.userInteractionEnabled = NO;
            return middleCell;
        }
    
    }
    
    return nil;
}


#pragma mark - 快速创建Label
- (UILabel *)labelWithTitle:(NSString *)title {
    UILabel *label = [[UILabel alloc] init];
    label.text = title;
    label.textColor =[UIColor whiteColor];
//    label.font = [UIFont systemFontOfSize:18];
    return label;
}

#pragma mark - 底部按钮点击事件
- (void)onTapOptionButton:(UITapGestureRecognizer *)recognizer {
    switch (recognizer.view.tag) {
        case 0:
            TCBLog(@"我要联系和调度");
        {
            NSString *dispatcherMobile = self.firstDetail.DispatcherMobile;
            dispatcherMobile = @"12345678901";
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",dispatcherMobile];
            UIWebView *callWebview = [[UIWebView alloc] init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            [self.view addSubview:callWebview];
            
        }

            break;
        case 1:
            TCBLog(@"我要拒绝出车");
            break;
        case 2:
            
            TCBLog(@"我要马上接单");
            break;
        default:
            break;
    }
}

@end
