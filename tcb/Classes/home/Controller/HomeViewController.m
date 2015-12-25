//
//  HomeViewController.m
//  tcb
//
//  Created by Jax on 15/11/10.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import "HomeViewController.h"
#import "UIBarButtonItem+Extension.h"
#import <SDCycleScrollView.h>
#import "UIImage+JAX.h"
#import "ELInProgressTaskController.h"

#import "ListMoreOrderCell.h"
#import "ListMoreOrderController.h"
#import "ListSingleOrderController.h"
#import "FeeConfirmListController.h"
#import "MessageController.h"
#import "FuelCardListController.h"

#define kLabelMagin ((iPhone4) ? 5 : 5)
#define kImageMargin ((iPhone4) ? 5 : 5)
#define kFontSize ((iPhone4) ? 13 : 17)
#define kLabelHeight ((iPhone4) ? 15 : 30)

@interface HomeViewController ()<SDCycleScrollViewDelegate>

@property (nonatomic, assign) CGFloat sdCycleScrollerViewH;
@property (nonatomic, strong) UIView  *sdCycleView;
@property (nonatomic, strong) SDCycleScrollView *sdCycleScrollerView;

@property (nonatomic, strong) UIView *taskingView;
@property (nonatomic, strong) UIImageView *imageViewTasking;

@property (nonatomic, strong) UIBarButtonItem *rightItem;

@property (nonatomic, strong) UIButton    *messageTipButton;
@property (nonatomic, strong) UIImageView *msgTip0;
@property (nonatomic, strong) UIImageView *msgTip;
@property (nonatomic, strong) UIImageView *msgTip2;

@end

@implementation HomeViewController

#pragma mark - 视图生命周期

- (void)noticeToChangeTaskStatus:(NSNotification *)noti {
    NSUserDefaults *userDefautls = [NSUserDefaults standardUserDefaults];
    NSString *newDispatch = [userDefautls valueForKey:@"kNewDispatch"];
    if ([newDispatch isEqualToString:@"新派单"]) {
        self.msgTip0.hidden = NO;
    } else {
        self.msgTip0.hidden = YES;
    }
    
    NSString *newTask = [userDefautls valueForKey:@"kNewTask"];
    if ([newTask isEqualToString:@"新任务"]) {
        self.msgTip.hidden = NO;
    } else {
        self.msgTip.hidden = YES;
    }
    
    NSString *newFee = [userDefautls valueForKey:@"kNewFee"];
    if ([newFee isEqualToString:@"新费用"]) {
        self.msgTip2.hidden = NO;
    } else {
        self.msgTip2.hidden = YES;
    }

    NSString *newNoti = [userDefautls valueForKey:@"kNewNoti"];
    if ([newNoti isEqualToString:@"新通知"]) {
        
         [self.messageTipButton setImage:[UIImage imageNamed:@"ic_sms_new"] forState:UIControlStateNormal];

    } else {
        
         [self.messageTipButton setImage:[UIImage imageNamed:@"ic_sms"] forState:UIControlStateNormal];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
    [notiCenter addObserver:self selector:@selector(noticeToChangeTaskStatus:) name:
     NSUserDefaultsDidChangeNotification object:nil];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"拖车宝";

    
//     UIBarButtonItem *rightItem = [UIBarButtonItem itemWithImageName:@"ic_sms" target:self action:@selector(messageTipPressed:)];
//    self.rightItem = rightItem;
//    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIButton *messageTipButton = [[UIButton alloc] init];
    messageTipButton.frame = CGRectMake(0, 0, 40, 40);
    self.messageTipButton = messageTipButton;
    [self.messageTipButton addTarget:self action:@selector(messageTipPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.messageTipButton setImage:[UIImage imageNamed:@"ic_sms"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:messageTipButton];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *newNoti = [defaults valueForKey:@"kNewNoti"];
    if ([newNoti isEqualToString:@"新通知"]) {
        
        [self.messageTipButton setImage:[UIImage imageNamed:@"ic_sms_new"] forState:UIControlStateNormal];
        
    } else {
        
        [self.messageTipButton setImage:[UIImage imageNamed:@"ic_sms"] forState:UIControlStateNormal];
    }

    
//    self.navigationItem.rightBarButtonItem = [UIBarButtonItem alloc] initWithImage:<#(nullable UIImage *)#> landscapeImagePhone:<#(nullable UIImage *)#> style:<#(UIBarButtonItemStyle)#> target:<#(nullable id)#> action:<#(nullable SEL)#>
//    NSUserDefaults *userDefautls = [NSUserDefaults standardUserDefaults];
//    NSString *newNoti = [userDefautls valueForKey:@"kNewNoti"];
//    if ([newNoti isEqualToString:@"新通知"]) {
//        self.navigationItem.rightBarButtonItem = nil;
//        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"ic_sms_new" target:self action:@selector(messageTipPressed)];
//    } else {
//        self.navigationItem.rightBarButtonItem = nil;
//        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"ic_sms" target:self action:@selector(messageTipPressed)];
//    }

    
    //  创建轮播视图
    [self setUPCycleImageView];
    //  创建taskView
    [self setUpTaskView];
    
}

- (void)messageTipPressed:(UIButton *)sender {
    NSLog(@"我爱你");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:@"" forKey:@"kNewNoti"];
    [defaults synchronize];
    
    MessageController *messageController = [[MessageController alloc] init];
    [self.navigationController pushViewController:messageController animated:YES];
}
//- (void)setUpNavgationBar {
//    UIView *navgationBarView = [[UIView alloc] init];
//    [self.view addSubview:navgationBarView];
//    navgationBarView.backgroundColor = kRGB(247, 247, 247);
//    [navgationBarView makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view.top).offset(0);
//        make.left.equalTo(self.view.left).offset(0);
//        make.right.equalTo(self.view.right).offset(0);
//        make.height.equalTo(64);
//    }];
//    
//    UILabel *TCBTitleView = [[UILabel alloc] init];
//    [navgationBarView addSubview:TCBTitleView];
//    TCBTitleView.text = @"拖车宝";
//    TCBTitleView.frame = CGRectMake((SCREEN_WIDTH - 100) * 0.5, 20, 100, 44);
//    TCBTitleView.textAlignment = NSTextAlignmentCenter;
//    
//    
//    
//    UIButton *msgButton =[[UIButton alloc] init];
//    [navgationBarView addSubview:msgButton];
//    [msgButton setBackgroundImage:[UIImage imageNamed:@"Home_messageTip"] forState:UIControlStateNormal];
//    msgButton.frame = CGRectMake(SCREEN_WIDTH - 46, 26, 32, 32);
//    [msgButton addTarget:self action:@selector(messageTipPressed:) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIButton *msgNumButton = [[UIButton alloc] init];
//    [navgationBarView addSubview:msgNumButton];
//    msgNumButton.titleLabel.font = [UIFont systemFontOfSize:10];
//    [msgNumButton setTitle:@"5" forState:UIControlStateNormal];
//    [msgNumButton setBackgroundImage:[UIImage imageNamed:@"Home_Msg_num"] forState:UIControlStateNormal];
//    msgNumButton.frame = CGRectMake(SCREEN_WIDTH - 20, 22, 15, 15);
//}

- (void)setUPCycleImageView {
    CGFloat   sdCycleScrollerViewH = 0.0f;
    if (iPhone4 || iPhone5) {
        sdCycleScrollerViewH = 320 * 270 / 720;
    } else if (iPhone6) {
        sdCycleScrollerViewH = 375 * 270 / 720;
    } else if (iPhone6plus){
        sdCycleScrollerViewH = 414 * 270 / 720;
    }
    self.sdCycleScrollerViewH = sdCycleScrollerViewH;
    NSArray *imageNameArray = @[@"Home_Advertising_default_1", @"Home_Advertising_default_1", @"Home_Advertising_default_1", @"Home_Advertising_default_1"];
    NSMutableArray *localImageArray = [NSMutableArray array];
    for (NSString *imageName in imageNameArray) {
        [localImageArray addObject:[UIImage imageNamed:imageName]];
    }
    UIView *sdCycleView = [[UIView alloc] init];
    self.sdCycleView = sdCycleView;
    [self.view addSubview:sdCycleView];
    sdCycleView.frame = CGRectMake(0, 64, SCREEN_WIDTH, sdCycleScrollerViewH);
    SDCycleScrollView *sdCycleScrollerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, sdCycleScrollerViewH) imagesGroup:[localImageArray copy]];
    [sdCycleView addSubview:sdCycleScrollerView];
    self.sdCycleScrollerView = sdCycleScrollerView;
    sdCycleScrollerView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    sdCycleScrollerView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
    sdCycleScrollerView.autoScrollTimeInterval = 3.0;
    sdCycleScrollerView.dotColor = [UIColor orangeColor];
    //    cycleScrollView.placeholderImage = [UIImage imageNamed:@"focus_placeholder"];
    sdCycleScrollerView.delegate = self;
    [self.view addSubview:sdCycleScrollerView];
}

- (void)setUpTaskView {
    /*------------------------------taskView----------------------------*/
    CGFloat taskViewHeight = SCREEN_HEIGHT - 64 - self.sdCycleScrollerViewH - 49;
    UIView *taskView = [[UIView alloc] init];
    [self.view addSubview:taskView];
    [taskView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sdCycleView.bottom).offset(0);
        make.left.equalTo(self.view.left).offset(0);
        make.right.equalTo(self.view.right).offset(0);
        make.height.equalTo(taskViewHeight);
    }];
    
    CGFloat margin = 5.0f;
    /*------------------------------wantListView----------------------------*/
    UIView *wantListView = [[UIView alloc] init];
    CGFloat wantListViewH = (taskViewHeight - 2 * margin) * 0.6;
    CGFloat wantListViewW = (SCREEN_WIDTH - 3 * margin) / 2;
    [taskView addSubview:wantListView];
    [wantListView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sdCycleScrollerView.bottom).offset(margin);
        make.left.equalTo(self.view.left).equalTo(margin);
        make.width.equalTo(wantListViewW);
        make.height.equalTo(wantListViewH);
    }];
    UIButton *wantListButton = [[UIButton alloc] init];
    [wantListView addSubview:wantListButton];
    [wantListButton setBackgroundImage:[UIImage resizedImage:@"btn_bg_blue_normal"] forState:UIControlStateNormal];
    [wantListButton setBackgroundImage:[UIImage resizedImage:@"btn_bg_blue_press"] forState:UIControlStateHighlighted];
    [wantListButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wantListView.top).offset(0);
        make.left.equalTo(wantListView.left).offset(0);
        make.right.equalTo(wantListView.right).offset(0);
        make.bottom.equalTo(wantListView.bottom).offset(0);
    }];
    [wantListButton addTarget:self action:@selector(wantListButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat marginWantList = 0;
    marginWantList = ((iPhone4)?5:20);
    UILabel *wantListLabel = [self labelWithTitle:@"我要接单" fontSize:kFontSize];
    [wantListView addSubview:wantListLabel];
    [wantListLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wantListView.top).offset(marginWantList);
        make.left.equalTo(wantListView.left).offset(marginWantList);
        make.width.equalTo(100);
        make.height.equalTo(kLabelHeight);
    }];
    
    CGFloat marginWantList1 = 0;
    marginWantList1 = ((iPhone4)?5:25);
    UILabel *driverLabel = [self labelWithTitle:@"司机师傅快来接单" fontSize:kFontSize];
    [wantListView addSubview:driverLabel];
    [driverLabel makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(wantListView.bottom).offset(-marginWantList1);
        make.centerX.equalTo(wantListView.centerX);
        make.height.equalTo(kLabelHeight);
    }];
    
    UIImageView *imageViewList = [[UIImageView alloc] init];
    [wantListView addSubview:imageViewList];
    imageViewList.image = [UIImage imageNamed:@"Home_Want_List"];
    [imageViewList makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(wantListViewW * 0.6);
        make.center.equalTo(wantListView.center);
        make.width.equalTo(imageViewList.height);
    }];

    UIImageView *msgTip0 = [[UIImageView alloc] init];
    msgTip0.image = [UIImage imageNamed:@"Home_Msg_num"];
    [wantListView addSubview:msgTip0];
    [msgTip0 makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(10);
        make.height.equalTo(10);
        make.bottom.equalTo(imageViewList.top).offset(10);
        make.left.equalTo(imageViewList.right).offset(5);
    }];
    self.msgTip0 = msgTip0;
    
    NSUserDefaults *userDefautls = [NSUserDefaults standardUserDefaults];
    NSString *newDispatch = [userDefautls valueForKey:@"kNewDispatch"];
    if ([newDispatch isEqualToString:@"新派单"]) {
        msgTip0.hidden = NO;
    } else {
        msgTip0.hidden = YES;
    }
    
    
    
    /*------------------------------taskingView----------------------------*/
    UIView *taskingView = [[UIView alloc] init];
    CGFloat taskingViewH = (wantListViewH - margin) * 0.5;
    [taskView addSubview:taskingView];
    [taskingView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(taskView.top).offset(margin);
        make.left.equalTo(wantListView.right).equalTo(margin);
        make.right.equalTo(self.view.right).offset(-margin);
        make.height.equalTo(taskingViewH);
    }];
    self.taskingView = taskingView;
    
    
    UIButton *taskingButton = [[UIButton alloc] init];
    [taskingView addSubview:taskingButton];
    [taskingButton setBackgroundImage:[UIImage resizedImage:@"btn_bg_blue_normal"] forState:UIControlStateNormal];
    [taskingButton setBackgroundImage:[UIImage resizedImage:@"btn_bg_blue_press"] forState:UIControlStateHighlighted];
    [taskingButton makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsZero);
    }];
     [taskingButton addTarget:self action:@selector(taskingButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *taskingLabel = [self labelWithTitle:@"进行中任务" fontSize:kFontSize];
    [taskingView addSubview:taskingLabel];
    [taskingLabel makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(taskingView.bottom).offset(-kLabelMagin);
        make.centerX.equalTo(taskingView.centerX);
        make.height.equalTo(kLabelHeight);
    }];
    
    UIImageView *imageViewTasking = [[UIImageView alloc] init];
    [taskingView addSubview:imageViewTasking];
    imageViewTasking.image = [UIImage imageNamed:@"Home_Car"];
    [imageViewTasking makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(taskingLabel.top).offset(-kImageMargin);
        make.centerX.equalTo(taskingView.centerX);
        make.height.equalTo(taskingViewH * 0.5);
        make.width.equalTo(taskingViewH * 0.5 * 100 / 72.0);
    }];
    self.imageViewTasking = imageViewTasking;
    
    UIImageView *msgTip = [[UIImageView alloc] init];
    msgTip.image = [UIImage imageNamed:@"Home_Msg_num"];
    [self.taskingView addSubview:msgTip];
    [msgTip makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(10);
        make.height.equalTo(10);
        make.bottom.equalTo(self.imageViewTasking.top).offset(10);
        make.left.equalTo(self.imageViewTasking.right).offset(5);
    }];
    self.msgTip = msgTip;
  
    NSString *newTask = [userDefautls valueForKey:@"kNewTask"];
    if ([newTask isEqualToString:@"新任务"]) {
        msgTip.hidden = NO;
    } else {
        msgTip.hidden = YES;
    }


    /*------------------------------verityCostView----------------------------*/
    UIView *verityCostView = [[UIView alloc] init];
    [taskView addSubview:verityCostView];
    [verityCostView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(taskingView.bottom).offset(margin);
        make.left.equalTo(wantListView.right).equalTo(margin);
        make.right.equalTo(self.view.right).offset(-margin);
        make.height.equalTo(taskingViewH);
    }];
    
    UIButton *verityCostButton = [[UIButton alloc] init];
    [verityCostView addSubview:verityCostButton];
    [verityCostButton setBackgroundImage:[UIImage resizedImage:@"btn_bg_blue_normal"] forState:UIControlStateNormal];
    [verityCostButton setBackgroundImage:[UIImage resizedImage:@"btn_bg_blue_press"] forState:UIControlStateHighlighted];
    [verityCostButton makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsZero);
    }];
    [verityCostButton addTarget:self action:@selector(verityCostButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *verityCostLabel = [self labelWithTitle:@"费用确认" fontSize:kFontSize];
    [verityCostView addSubview:verityCostLabel];
    [verityCostLabel makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(verityCostView.bottom).offset(-kLabelMagin);
        make.centerX.equalTo(verityCostView.centerX);
        make.height.equalTo(kLabelHeight);
    }];
    
    UIImageView *imageViewCost = [[UIImageView alloc] init];
    [verityCostView addSubview:imageViewCost];
    imageViewCost.image = [UIImage imageNamed:@"Home_verityCost"];
    [imageViewCost makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(verityCostLabel.top).offset(-kImageMargin);
        make.centerX.equalTo(verityCostView.centerX);
        make.height.equalTo(taskingViewH * 0.5);
        make.width.equalTo(imageViewCost.height);
    }];

    UIImageView *msgTip2 = [[UIImageView alloc] init];
    msgTip2.image = [UIImage imageNamed:@"Home_Msg_num"];
    [verityCostView addSubview:msgTip2];
    [msgTip2 makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(10);
        make.height.equalTo(10);
        make.bottom.equalTo(imageViewCost.top).offset(10);
        make.left.equalTo(imageViewCost.right).offset(5);
    }];
    self.msgTip2 = msgTip2;
    NSString *newFee = [userDefautls valueForKey:@"kNewFee"];
    if ([newFee isEqualToString:@"新费用"]) {
        msgTip2.hidden = NO;
    } else {
        msgTip2.hidden = YES;
    }
    
    /*------------------------------addGasCard----------------------------*/
    CGFloat addGasCardViewH = taskViewHeight - wantListViewH - 3 * margin;
    UIView *addGasCardView = [[UIView alloc] init];
    [taskView addSubview:addGasCardView];
    [addGasCardView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(verityCostView.bottom).offset(margin);
        make.right.equalTo(self.view.right).offset(-margin);
        make.height.equalTo(addGasCardViewH);
        make.width.equalTo(wantListViewW);
    }];

    UIButton *addGasCardButton = [[UIButton alloc] init];
    [addGasCardView addSubview:addGasCardButton];
    [addGasCardButton setBackgroundImage:[UIImage resizedImage:@"btn_bg_green_normal"] forState:UIControlStateNormal];
    [addGasCardButton setBackgroundImage:[UIImage resizedImage:@"btn_bg_green_press"] forState:UIControlStateHighlighted];
    [addGasCardButton makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsZero);
    }];
    [addGasCardButton addTarget:self action:@selector(addGasCardButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *addGasCardLabel = [self labelWithTitle:@"加油卡" fontSize:kFontSize];
    [addGasCardView addSubview:addGasCardLabel];
    [addGasCardLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(addGasCardView.top).offset(kLabelMagin);
        make.left.equalTo(addGasCardView.left).offset(kLabelMagin);
        make.width.equalTo(100);
        make.height.equalTo(kLabelHeight);
    }];
    
    UILabel *remainingLabel = [self labelWithTitle:@"余额 8888.88元" fontSize:kFontSize];
    [addGasCardView addSubview:remainingLabel];
    [remainingLabel makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(addGasCardView.bottom).offset(-kLabelMagin);
        make.centerX.equalTo(addGasCardView.centerX);
        make.height.equalTo(kLabelHeight);
    }];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [addGasCardView addSubview:imageView];
    imageView.image = [UIImage imageNamed:@"Home_JiaYou"];
    [imageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(addGasCardLabel.bottom).offset(kImageMargin);
        make.bottom.equalTo(remainingLabel.top).offset(-kImageMargin);
        make.centerX.equalTo(addGasCardView.centerX);
        make.width.equalTo(imageView.height);
    }];
    
    /*---------------------------feedBackToLiftView-------------------------------*/
    CGFloat feedBackToLiftViewH = (addGasCardViewH - margin) * 0.5;
    UIView *feedBackToLiftView = [[UIView alloc] init];
    [taskView addSubview:feedBackToLiftView];
    [feedBackToLiftView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wantListView.bottom).offset(margin);
        make.left.equalTo(self.view.left).offset(margin);
        make.height.equalTo(feedBackToLiftViewH);
        make.width.equalTo(wantListViewW);
    }];
    
    UIButton *feedBackToLiftButton = [[UIButton alloc] init];
    [feedBackToLiftView addSubview:feedBackToLiftButton];
    [feedBackToLiftButton setBackgroundImage:[UIImage resizedImage:@"btn_bg_dark_blue_normal"] forState:UIControlStateNormal];
    [feedBackToLiftButton setBackgroundImage:[UIImage resizedImage:@"btn_bg_dark_blue_press"] forState:UIControlStateHighlighted];
    [feedBackToLiftButton setTitle:@"反馈拿礼品" forState:UIControlStateNormal];
    [feedBackToLiftButton setImage:[UIImage imageNamed:@"Home_FeedBack_Lift"] forState:UIControlStateNormal];
    [feedBackToLiftButton makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsZero);
    }];
    [feedBackToLiftButton addTarget:self action:@selector(feedBackToLiftButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
     /*---------------------------breakRuleView-------------------------------*/
    UIView *breakRuleView = [[UIView alloc] init];
    [taskView addSubview:breakRuleView];
    [breakRuleView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(feedBackToLiftView.bottom).offset(margin);
        make.left.equalTo(self.view.left).offset(margin);
        make.height.equalTo(feedBackToLiftViewH);
        make.width.equalTo(wantListViewW);
    }];
    
    UIButton *breakRuleButton = [[UIButton alloc] init];
    [breakRuleView addSubview:breakRuleButton];
    [breakRuleButton setBackgroundImage:[UIImage resizedImage:@"btn_bg_red_norma"] forState:UIControlStateNormal];
    [breakRuleButton setBackgroundImage:[UIImage resizedImage:@"btn_bg_red_press"] forState:UIControlStateHighlighted];
    [breakRuleButton setTitle:@"违章查看" forState:UIControlStateNormal];
    [breakRuleButton setImage:[UIImage imageNamed:@"Home_Break_Rule"] forState:UIControlStateNormal];
    [breakRuleButton makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsZero);
    }];
    [breakRuleButton addTarget:self action:@selector(breakRuleButtonPressed:) forControlEvents:UIControlEventTouchUpInside];


    
}

- (UILabel *)labelWithTitle:(NSString *)title fontSize:(NSInteger)fontSize {
    UILabel *label = [[UILabel alloc] init];
    label.text = title;
    label.font = [UIFont systemFontOfSize:fontSize];
    label.textColor = [UIColor whiteColor];
    return label;
}



#pragma mark - taskView中按钮点击
- (void)wantListButtonPressed:(UIButton *)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:@"" forKey:@"kNewDispatch"];
    [defaults synchronize];
    
    
    ListMoreOrderController *listMoreOrderController = [[ListMoreOrderController alloc] init];
    [self.navigationController pushViewController:listMoreOrderController animated:YES];
  
}

- (void)taskingButtonPressed:(UIButton *)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:@"" forKey:@"kNewTask"];
    [defaults synchronize];
    
    ELInProgressTaskController *inProgressTaskController = [[ELInProgressTaskController alloc] init];
    [self.navigationController pushViewController:inProgressTaskController animated:YES];
}

- (void)verityCostButtonPressed:(UIButton *)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:@"" forKey:@"kNewFee"];
    [defaults synchronize];
    
    FeeConfirmListController *feeConfirmListController = [[FeeConfirmListController alloc] init];
    [self.navigationController pushViewController:feeConfirmListController animated:YES];
}

- (void)addGasCardButtonPressed:(UIButton *)sender {
    TCBLog(@"加油卡");
    FuelCardListController *fuelCardListController = [[FuelCardListController alloc] init];
    [self.navigationController pushViewController:fuelCardListController animated:YES];
    
}

- (void)feedBackToLiftButtonPressed:(UIButton *)sender {
    TCBLog(@"反馈拿礼品");
}

- (void)breakRuleButtonPressed:(UIButton *)sender {
    TCBLog(@"违章查看");
}


#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    //  轮播器代理实现
}


@end
