//
//  MeViewController.m
//  tcb
//
//  Created by Jax on 15/11/10.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import "MeViewController.h"
#import "MyInfoController.h"
#import "MyInfoResultModel.h"
#import "AddCompanyCardController.h"

@interface MeViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIView *navView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIImageView *imageview;
@property (nonatomic, strong) UIImageView *navBarHairlineImageView;

@property (nonatomic, strong) NSArray *settingImageArray;
@property (nonatomic, strong) NSArray *settingTitleArray;

@end

@implementation MeViewController

#pragma mark - 懒加载
- (NSArray *)settingImageArray {
    if (_settingImageArray == nil) {
        _settingImageArray = [NSArray array];
    }
    return _settingImageArray;
}

- (NSArray *)settingTitleArray {
    if (_settingTitleArray == nil) {
        _settingTitleArray = [NSArray array];
    }
    return _settingTitleArray;
}


#pragma mark - view生命周期
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = ThemeColor;
    
    UIView *navView = [[UIView alloc] init];
    [[ConfigTool lastWindow] addSubview:navView];
    navView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 64);
    self.navView = navView;
    
    UIImageView *imageview = [[UIImageView alloc] init];
    [navView addSubview:imageview];
    imageview.frame = CGRectMake(0, 0, SCREEN_WIDTH, 64);
    imageview.image = [UIImage imageNamed:@"mine_top_bg"];
    self.imageview = imageview;
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"我是司机";
    [self.navView addSubview:label];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.frame = CGRectMake(0, 20, SCREEN_WIDTH, 44);
    
    self.navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    
    self.navBarHairlineImageView.hidden = YES;
    
    self.navigationController.navigationBarHidden = YES;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    
    self.navBarHairlineImageView.hidden = YES;

    
    //  配置设置TableView的setting数据
    [self configSettingData];
    //  顶部视图
    [self setUpTopView];
    //  兑换积分按钮
    [self setUpScoreButton];
    //  底部tableview
    [self configTableView];
    
}

- (void)setUpTopView {
    UIView *topView = [[UIView alloc] init];
    self.topView = topView;
    [self.view addSubview:topView];
    [topView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top).offset(64);
        make.left.equalTo(self.view.left).offset(0);
        make.right.equalTo(self.view.right).offset(0);
        make.height.equalTo(180 - 64);
    }];
    topView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"mine_top_bg"]];
    
    UIButton *statusButton = [[UIButton alloc] init];
    [topView addSubview:statusButton];
    [statusButton setTitle:@"我是司机" forState:UIControlStateNormal];
    [statusButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top).offset(35);
        make.centerX.equalTo(self.view.centerX);
        make.height.equalTo(35);
    }];
//    [statusButton addTarget:self action:@selector(setStatus:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"myStatus"]];
    [topView addSubview:imageView];
    [imageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(statusButton.bottom).offset(10);
        make.left.equalTo(topView.left).offset(30);
        make.width.and.height.equalTo(80);
    }];
    
    UILabel *phoneNumLabel = [[UILabel alloc] init];
    phoneNumLabel.textColor = [UIColor whiteColor];
    NSArray *accountAndPassword =  [ConfigTool getOwnAccountAndPassword];
    phoneNumLabel.text = [accountAndPassword firstObject];
    
    [topView addSubview:phoneNumLabel];
    [phoneNumLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.top).offset(5);
        make.left.equalTo(imageView.right).offset(20);
        make.right.equalTo(topView.right).offset(0);
        make.height.equalTo(30);
    }];
    
    UILabel *scoreLabel = [[UILabel alloc] init];
    scoreLabel.text = [NSString stringWithFormat:@"积分:100"];
    scoreLabel.textColor = [UIColor whiteColor];
    [topView addSubview:scoreLabel];
    [scoreLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneNumLabel.bottom).offset(5);
        make.left.equalTo(imageView.right).offset(20);
        make.right.equalTo(topView.right).offset(0);
        make.height.equalTo(30);
    }];
}

- (void)setUpScoreButton {
    UIButton *scoreButton = [[UIButton alloc] init];
    [self.view addSubview:scoreButton];
    [scoreButton setTitle:@"积分兑换" forState:UIControlStateNormal];
    [scoreButton setImage:[UIImage imageNamed:@"mine_lift"] forState:UIControlStateNormal];
    [scoreButton setBackgroundImage:[UIImage imageNamed:@"mine_jifen_bg"] forState:UIControlStateNormal];
    [scoreButton addTarget:self action:@selector(scoreButtonOnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [scoreButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.bottom).offset(0);
        make.left.equalTo(self.view.left).offset(0);
        make.right.equalTo(self.view.right).offset(0);
        make.height.equalTo(50);
    }];
    
}

- (void)configTableView {
    UITableView *settingTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 230, SCREEN_WIDTH, SCREEN_HEIGHT - 230 - 49) style:UITableViewStyleGrouped];
    [self.view addSubview:settingTableView];
    settingTableView.dataSource = self;
    settingTableView.delegate = self;
    settingTableView.sectionFooterHeight = 5.0;
    [settingTableView reloadData];
    
}

- (void)configSettingData {
    self.settingImageArray = @[@"mine_counts", @"mine_friend", @"mine_message", @"mine_setting", @"mine_about"];
    self.settingTitleArray = @[@"收款账号", @"邀请好友", @"意见反馈", @"设置", @"关于"];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return self.settingTitleArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.imageView.image = [UIImage imageNamed:@"mine_avatar"];
        cell.textLabel.text = @"我的资料";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    } else if (indexPath.section == 1) {
        if (indexPath.row == 2) {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            cell.textLabel.text = self.settingTitleArray[indexPath.row];
            cell.imageView.image = [UIImage imageNamed:self.settingImageArray[indexPath.row]];
            UILabel *scoreToLiftLabel = [[UILabel alloc] init];
            scoreToLiftLabel.text = @"(积分换好礼)";
            scoreToLiftLabel.font = [UIFont systemFontOfSize:12];
            [cell.contentView addSubview:scoreToLiftLabel];
            [scoreToLiftLabel makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell.contentView.top).offset(0);
                make.bottom.equalTo(cell.contentView.bottom).offset(0);
                make.right.equalTo(cell.contentView.right).offset(0);
            }];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        } else {
            static NSString *settingCellID = @"settingCellId";
            UITableViewCell *settingCell = [tableView dequeueReusableCellWithIdentifier:settingCellID];
            if (settingCell == nil) {
                settingCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:settingCellID];
             }
            settingCell.textLabel.text = self.settingTitleArray[indexPath.row];
            settingCell.imageView.image = [UIImage imageNamed:self.settingImageArray[indexPath.row]];
            settingCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return settingCell;
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 10;
    } else {
        return 1;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view =[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    return view;
} 




#pragma mark - UITableViewDataDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            /* 我的资料 */
            [self myInfomation];
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            /* 收款账号 */
            [self getCollectionAccount];
        }
    }
    
    
}

#pragma mark - 选择身份

#pragma mark - 积分兑换
- (void)scoreButtonOnClicked:(UIButton *)sender {
    TCBLog(@"积分兑换");
}

#pragma mark - 我的资料
- (void)myInfomation {
    MyInfoController *myInfoController = [[MyInfoController alloc] init];
    [self.navigationController pushViewController:myInfoController animated:YES];
}

#pragma mark - 收款账号
- (void)getCollectionAccount {
    AddCompanyCardController *addCompanyCardController = [[AddCompanyCardController alloc] init];
    [self.navigationController pushViewController:addCompanyCardController animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navView removeFromSuperview];
    self.navView = nil;
}

#pragma mark - 实现找出导航栏底部的后十年书的函数
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

@end
