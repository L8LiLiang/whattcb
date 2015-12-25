//
//  AutoSignInController.m
//  tcb
//
//  Created by Chuanxun on 15/11/17.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import "AutoSignInController.h"
#import "OrderProcessFlowView.h"
#import "OrderProcessFlowNodeView.h"
#import "OrderInfoView.h"
#import "ElChangeTitlePositionButton.h"
#import "OrderProcessFlowInputBoxNoView.h"
#import "BoxNoInputController.h"
#import "TakePhotoController.h"
#import "ELDispatchOrder.h"
#import <MBProgressHUD.h>
#import "ELInProgressTask.h"
#import "NSString+Extension.h"
#import "ServiceURLConstant.h"
#import <CoreLocation/CoreLocation.h>
#import "FeeDetailController.h"
#import "L8RegionMonitor.h"

@interface AutoSignInController () <OrderInfoViewDelegate,OrderProcessFlowViewDelegate,CLLocationManagerDelegate>

@property (strong, nonatomic) OrderProcessFlowView *flowView;
@property (strong, nonatomic) OrderProcessFlowNodeView *nodeView;
@property (strong, nonatomic) OrderInfoView *topView;

@property (strong, nonatomic) UILabel *lblPhotoNum;
@property (weak, nonatomic) UIButton *photoButton;
@property (weak, nonatomic) UIButton *chargeButton;
@property (strong, nonatomic) ELDispatchOrder *order;

@property (assign, nonatomic) NSInteger currentIndex;
@property (strong, nonatomic) MBProgressHUD *hud;


@property (strong, nonatomic) NSArray *dispatchIDs;
@property (strong, nonatomic) NSArray *telephoneNums;

@property (assign, nonatomic) BOOL readonly;

@property (strong,nonatomic) ELDispatchOrderItemNode *nodeForSignin;

@end

@implementation AutoSignInController

-(instancetype)initWithDispatchOrderIDs:(NSArray *)dispatchIDs  SelectedItemIndex:(NSInteger)index telephoneNums:(NSArray *)telephoneNums  readonly:(BOOL)readonly
{
    if (self = [super init]) {
        
        self.currentIndex = index;
        self.dispatchIDs = dispatchIDs;
        self.telephoneNums = telephoneNums;
        self.readonly = readonly;
        
        //订单信息view
        OrderInfoView *topView = [OrderInfoView viewWithOrder:nil selectedIndex:index];
        [self.view addSubview:topView];
        topView.delegate = self;
        self.topView = topView;
        
        //监装拍照 费用录入按钮
        ElChangeTitlePositionButton *buttonPhoto = [ElChangeTitlePositionButton buttonWithType:UIButtonTypeCustom];
        NSString *tip = NSLocalizedString(@"Photos", @"监装拍照");
        buttonPhoto.titleLabel.font = FONT_MIDDLE;
        [buttonPhoto setTitle:tip forState:UIControlStateNormal];
        buttonPhoto.backgroundColor = [UIColor clearColor];
        buttonPhoto.layer.borderColor = topView.backgroundColor.CGColor;
        buttonPhoto.layer.borderWidth = 1;
        buttonPhoto.layer.cornerRadius = 5;
        [buttonPhoto setTitleColor:topView.backgroundColor forState:UIControlStateNormal];
        [self.view addSubview:buttonPhoto];
        self.photoButton = buttonPhoto;
        [buttonPhoto addTarget:self action:@selector(photoButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        ElChangeTitlePositionButton *buttonCharge = [ElChangeTitlePositionButton buttonWithType:UIButtonTypeCustom];
        buttonCharge.titleLabel.font = FONT_MIDDLE;
        tip = NSLocalizedString(@"Charge", @"费用录入");
        [buttonCharge setTitle:tip forState:UIControlStateNormal];
        buttonCharge.backgroundColor = [UIColor clearColor];
        buttonCharge.layer.borderColor = topView.backgroundColor.CGColor;
        buttonCharge.layer.borderWidth = 1;
        buttonCharge.layer.cornerRadius = 5;
        [buttonCharge setTitleColor:topView.backgroundColor forState:UIControlStateNormal];
        [self.view addSubview:buttonCharge];
        self.chargeButton = buttonCharge;
        [buttonCharge addTarget:self action:@selector(chargeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        int margin = 16;
        [buttonPhoto makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.left).offset(margin);
            make.top.equalTo(topView.bottom).offset(4);
            make.right.equalTo(buttonCharge.left).offset(-margin);
        }];
        
        [buttonCharge makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(buttonPhoto.right).offset(margin);
            make.right.equalTo(self.view.right).offset(-margin);
            make.centerY.equalTo(buttonPhoto);
            make.width.equalTo(buttonPhoto);
        }];
        
        //订单处理流程view
        OrderProcessFlowView *flowView = [OrderProcessFlowView flowViewWithOrderItem:nil width:SCREEN_WIDTH delegate:self];
        [self.view addSubview:flowView];
//        flowView.frame = self.view.bounds;
        self.flowView = flowView;
        
        CGFloat height = [topView bestHeight];
        [self.topView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(20);
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.height.equalTo(height);
        }];
        
        [self.flowView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.bottom.equalTo(self.view);
            make.top.equalTo(buttonPhoto.bottom).offset(4);
        }];
        
        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
        [self.view addSubview:hud];
        self.hud = hud;
        hud.dimBackground = YES;
        hud.labelText = @"正在获取派车单详情...";
        [self.view addSubview:hud];
        
        self.view.backgroundColor = [UIColor whiteColor];
        
        if (readonly) {
            self.photoButton.enabled = NO;
            self.photoButton.layer.borderColor = [UIColor grayColor].CGColor;
            [self.photoButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            buttonCharge.enabled = NO;
            buttonCharge.layer.borderColor = [UIColor grayColor].CGColor;
            [buttonCharge setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = self.topView.backgroundColor;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationBarHidden = YES;
    [self loadData];
    //    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    //    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    //    self.navigationController.navigationBar.backgroundColor = self.topView.backgroundColor;
}

- (void)loadData{
    [self.hud show:YES];
    
    if (self.dispatchIDs.count == 0) {
        return;
    }
    
    if (self.currentIndex > self.dispatchIDs.count -  1) {
        self.currentIndex = 0;
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                                    @"cmd":@"GetDispatchOrderDetail",
                                                                                    @"data":@{@"dispCode":self.dispatchIDs[self.currentIndex]}
                                                                                    }];
    
    [APIClientTool dispatchOrderDetailWithParam:params success:^(NSDictionary *dict) {
        NSNumber *rtn = [dict valueForKey:@"ret"];
        NSLog(@"%@",dict);
        if (rtn.intValue == 0) {
            
            ELDispatchOrder *order = [ELDispatchOrder mj_objectWithKeyValues:[dict valueForKey:@"data"]];
            self.order = order;
            self.topView.order = order;
            
            ELDispatchOrderItem *item = order.item[self.currentIndex];
            self.flowView.orderItem = item;
            
            
            NSInteger photoCount = item.PictureUrl.count;
            if (photoCount > 0) {
                NSString *tip = NSLocalizedString(@"Photos", @"监装拍照");
                [self.photoButton setTitle:[NSString stringWithFormat:@"%@ (%zd)",tip,photoCount] forState:UIControlStateNormal];
            }else {
                [self.photoButton setTitle:NSLocalizedString(@"Photos", @"监装拍照") forState:UIControlStateNormal];
            }
            
            [self.chargeButton setTitle:[NSString stringWithFormat:@"¥ %@",item.RecordedFee] forState:UIControlStateNormal];
            
            [self.hud hide:YES];
            
        }else {
            [self.hud hide:YES];
            
            [SVProgressHUD showErrorWithStatus:[dict valueForKey:@"msg"]];
            
        }
    } failed:^{
        NSLog(@"dispatchOrderDetailWithParam error");
        [self.hud hide:YES];
        
        [SVProgressHUD showErrorWithStatus:@"连接网络失败"];
    }];

}

- (void)photoButtonClicked:(UIButton *)sender
{    
    NSMutableArray *urls = [NSMutableArray new];
    NSMutableArray *smallUrls = [NSMutableArray new];
    NSArray *picture = self.order.item[self.currentIndex].PictureUrl;
    NSArray *smalPicture = self.order.item[self.currentIndex].PictureSmallUrl;
    for (int i = 0; i < picture.count; i ++) {
//        [urls addObject:[@"http://192.168.1.41" stringByAppendingPathComponent:picture[i]]];
        [urls addObject:picture[i]];
    }
    for (int i = 0; i < smalPicture.count; i ++) {
//        [smallUrls addObject:[@"http://192.168.1.41" stringByAppendingPathComponent:smalPicture[i]]];
        [smallUrls addObject:smalPicture[i]];
    }
    
    TakePhotoController *photoController = [[TakePhotoController alloc] initWithPhotoUrls:urls smallPhotoUrls:smallUrls dispOrderItem:self.order.item[self.currentIndex]];
    [self.navigationController pushViewController:photoController animated:YES];
}

- (void)chargeButtonClicked:(UIButton *)sender
{
    FeeDetailController *feeDetailController = [[FeeDetailController alloc] init];
    feeDetailController.sourceType = SourceTypeTask;
    feeDetailController.dispCode             = self.order.item[self.currentIndex].DispCode;
    feeDetailController.phoneNumberArray     = [NSMutableArray arrayWithArray:self.telephoneNums];
    feeDetailController.dispCodeArray        = [NSMutableArray arrayWithArray:self.dispatchIDs];;
    [self.navigationController pushViewController:feeDetailController animated:YES];

}


#pragma mark - OrderInfoViewDelegate

-(void)infoViewCallButtonClicked:(OrderInfoView *)infoView
{
    if (self.readonly) {
        return;
    }
    NSLog(@"infoViewCallButtonClicked");
    NSString *mobile = self.telephoneNums[self.currentIndex];
        
    if ([mobile isTelephoneNum]) {
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",mobile];
        UIWebView * callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self.view addSubview:callWebview];
    }
}

-(void)infoViewBackButtonClicked:(OrderInfoView *)infoView
{
    NSLog(@"infoViewBackButtonClicked");
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)infoViewChangeBox:(OrderInfoView *)infoView toIndex:(NSInteger)index
{
    NSLog(@"infoViewChangeBox");
    self.currentIndex = index;
    ELDispatchOrderItem *item = self.order.item[index];
    self.flowView.orderItem = item;
    
    NSInteger photoCount = item.PictureUrl.count;
    if (photoCount > 0) {
        
        [self.photoButton setTitle:[NSString stringWithFormat:@"Photos (%zd)",photoCount] forState:UIControlStateNormal];
    }else {
        [self.photoButton setTitle:@"Photos" forState:UIControlStateNormal];
    }
    
    [self.chargeButton setTitle:[NSString stringWithFormat:@"¥ %@",item.RecordedFee] forState:UIControlStateNormal];
}


#pragma mark - OrderProcessFlowInputBoxNoViewDelegate

-(void)inputBoxNoView:(OrderProcessFlowInputBoxNoView *)view btnClicked:(UIButton *)button
{
    if (self.readonly) {
        return;
    }
    
    BoxNoInputController *controller = [BoxNoInputController controllerWithOrder:self.order.item[self.currentIndex]];
    [self.navigationController pushViewController:controller animated:YES];
}


#pragma mark - OrderProcessFlowViewDelegate
-(void)flowNodeViewCall:(OrderProcessFlowNodeView *)view
{
    if (self.readonly) {
        return;
    }
    ELDispatchOrderItemNode *node = view.nodes.firstObject;
    
    if ([node.Telephone isTelephoneNum]) {
        NSString *str = [NSString stringWithFormat:@"tel:%@",node.Telephone];
        UIWebView *webView = [[UIWebView alloc] init];
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self.view addSubview:webView];
    }
}

-(void)flowNodeViewSign:(OrderProcessFlowNodeView *)view success:(void (^)(void))block
{
    [SVProgressHUD showWithStatus:@"正在签到..."];
    ELDispatchOrderItemNode *node = view.nodes.firstObject;
    self.nodeForSignin = node;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *dateStr = [formatter stringFromDate:[NSDate date]];
    NSDictionary *dict = @{@"cmd":@"SignNode",
                           @"data":@{@"dispCode":self.order.item[self.currentIndex].DispCode,
                                     @"nodeCode":self.nodeForSignin.NodeCode,
                                     @"lng":[NSString stringWithFormat:@"%.3f",[L8RegionMonitor sharedMonitor].locationManager.location.coordinate.longitude],
                                     @"lat":[NSString stringWithFormat:@"%.3f",[L8RegionMonitor sharedMonitor].locationManager.location.coordinate.latitude],
                                     @"signTime":dateStr}};
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:dict];
    [APIClientTool signNodeWithParam:params success:^(NSDictionary *dict) {
        int ret = [[dict valueForKey:@"ret"] intValue];
        if (ret == 0) {
            [SVProgressHUD showSuccessWithStatus:@"签到成功"];
            block();
        }else {
            [SVProgressHUD showErrorWithStatus:[dict valueForKey:@"msg"]];
        }
    } failed:^{
        [SVProgressHUD showErrorWithStatus:@"网络异常"];
    }];
}

//- (void)signin
//{
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    formatter.dateFormat = @"yyyy-MM-dd HH-mm-ss";
//    NSString *dateStr = [formatter stringFromDate:[NSDate date]];
//    NSDictionary *dict = @{@"cmd":@"SignNode",
//                           @"data":@{@"dispCode":self.order.item[self.currentIndex].DispCode,
//                                     @"nodeCode":self.nodeForSignin.NodeCode,
//                                     @"lng":[NSString stringWithFormat:@"%.3f",[L8RegionMonitor sharedMonitor].locationManager.location.coordinate.longitude],
//                                     @"lat":[NSString stringWithFormat:@"%.3f",[L8RegionMonitor sharedMonitor].locationManager.location.coordinate.latitude],
//                                     @"signTime":dateStr}};
//    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:dict];
//    [APIClientTool signNodeWithParam:params success:^(NSDictionary *dict) {
//        int ret = [[dict valueForKey:@"ret"] intValue];
//        if (ret == 0) {
//            self.hud.labelText = @"succeeded.";
//        }else {
//            self.hud.labelText = [dict valueForKey:@"msg"];
//        }
//        [self.hud hide:YES afterDelay:1.5];
//    } failed:^{
//        self.hud.labelText = @"网络异常";
//        [self.hud hide:YES afterDelay:1.5];
//    }];
//    
//}



@end
