//
//  FuelCardListController.m
//  tcb
//
//  Created by Jax on 15/12/14.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import "FuelCardListController.h"
#import "FuelCardCell.h"
#import "OptionButton.h"
#import "GasStationAddress.h"
#import "GasCardModel.h"
#import "OilCardDetailController.h"

@interface FuelCardListController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, FuelCardCellDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIPageControl    *pageController;
@property (nonatomic, strong) GasCardModel     *gasCardModel;

@property (nonatomic, copy  ) NSString         *cardId;//liliang test

@end

@implementation FuelCardListController

#pragma mark - 懒加载

- (GasCardModel *)gasCardModel {
    if (_gasCardModel == nil) {
        _gasCardModel = [[GasCardModel alloc] init];
    }
    return _gasCardModel;
}

#pragma mark - view life

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title                = @"加油卡";

    [self setUpCollectionView];
    [self setUpBottomView];
    
    [self getFuelCardList];
}

- (void)setUpCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing          = 0;
    flowLayout.minimumInteritemSpacing     = 0;
    flowLayout.itemSize                    = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - 100 - 32);
    flowLayout.sectionInset                = UIEdgeInsetsMake(0, 0, 0, 0);
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    self.collectionView                    = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 32, SCREEN_WIDTH, SCREEN_HEIGHT - 100 - 32) collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor    = [UIColor whiteColor];
    self.collectionView.delegate           = self;
    self.collectionView.dataSource         = self;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.bounces = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.collectionView registerClass:[FuelCardCell class] forCellWithReuseIdentifier:@"FuelCardCell"];
    [self.view addSubview:self.collectionView];
    
}

- (void)setUpPageController {
    UIPageControl *pageController = [[UIPageControl alloc] init];
    if (iPhone4) {
        pageController.frame = CGRectMake(0, SCREEN_HEIGHT - 122, SCREEN_WIDTH, 30);
    } else if (iPhone5 || iPhone6 || iPhone6plus) {
        pageController.frame = CGRectMake(0, SCREEN_HEIGHT - 130, SCREEN_WIDTH, 30);
    }
    pageController.numberOfPages = self.gasCardModel.data.list.count;
    pageController.currentPage = 0;
    self.pageController = pageController;
    [self.view addSubview:pageController];
}

- (void)setUpBottomView {
    UIView *bottonView = [[UIView alloc] init];
    [self.view addSubview:bottonView];
    [bottonView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectionView.bottom).offset(0);
        make.left.right.equalTo(0);
        make.bottom.equalTo(0);
    }];
    
    NSArray *optionButtonTitle = @[@"加油站地址", @"车队信息"];
    NSArray *optionButtonImage = @[@"gasStation", @"fleetInfo"];
    for (int i = 0; i < 2; i++) {
        CGFloat optionButtonW = (SCREEN_WIDTH - 1) / 2;;
        CGFloat optionButtonH = 100;
        CGFloat margin = (SCREEN_WIDTH - 2 * optionButtonW) / 3.0;
        OptionButton *optionButton = [[OptionButton alloc] initWithTitle:optionButtonTitle[i] imageName:optionButtonImage[i]];
        optionButton.frame = CGRectMake(margin + (margin +  optionButtonW) * i , 0, optionButtonW, optionButtonH);
        optionButton.tag = i;
        optionButton.userInteractionEnabled = YES;
        [optionButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapOptionButton:)]];
        [bottonView addSubview:optionButton];
    }
    
    UIView *lineView = [[UIView alloc] init];
    [bottonView addSubview:lineView];
    [lineView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(10);
        make.bottom.equalTo(-10);
        make.width.equalTo(1);
        make.centerX.equalTo(bottonView.centerX);
    }];
    lineView.backgroundColor = [UIColor lightGrayColor];
}

#pragma mark - 加油站地址&车队信息
- (void)onTapOptionButton:(UITapGestureRecognizer *)tap {
    if (tap.view.tag == 0) {
        [self getGasStationAddress];
    } else if (tap.view.tag == 1) {
        [self getFleetInfo];
    }
}

- (void)getGasStationAddress {
    GasStationAddress *gasStationAddress = [[GasStationAddress alloc] init];
    [self.navigationController pushViewController:gasStationAddress animated:YES];
}
- (void)getFleetInfo {
    
}

#pragma mark - 获取加油卡列表信息
- (void)getFuelCardList {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"GetFuelCards" forKey:@"cmd"];
    [SVProgressHUD showWithStatus:@"加油卡信息获取中" maskType:SVProgressHUDMaskTypeBlack];
    [APIClientTool GetFuelCardsWithParam:params success:^(NSDictionary *dict) {
        [SVProgressHUD dismiss];
        GasCardModel *gasCardModel = [GasCardModel mj_objectWithKeyValues:dict];
        if (gasCardModel.ret == 0) {
            self.gasCardModel = gasCardModel;
            [self.collectionView reloadData];
            [self setUpPageController];
        } else {
            [SVProgressHUD showErrorWithStatus:gasCardModel.msg];
        }
        
        //liliang test
        NSDictionary *data = [dict valueForKey:@"data"];
        NSArray *array = [data valueForKey:@"list"];
        NSDictionary *firstObject = array.firstObject;
        NSString *cardId = [firstObject valueForKey:@"Id"];
        self.cardId = cardId;
        
    } failed:^{
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"网络连接失败"];
    }];
}

#pragma mark - UICollectionView DataSource DelegateFlowLayout
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.gasCardModel.data.list.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FuelCardCell *fuelCardCell        = [FuelCardCell cellWithCollectionView:collectionView forIndexPath:indexPath];
    GasCardInfo *gasCardInfo          = self.gasCardModel.data.list[indexPath.row];
    fuelCardCell.gasCardInfo          = gasCardInfo;
    fuelCardCell.fuelCardCellDelegate = self;
    fuelCardCell.tag = indexPath.row;
    return fuelCardCell;
}

 - (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //    页码 = (contentoffset.x + scrollView一半宽度)/scrollView宽度
     CGFloat scrollviewW             = scrollView.frame.size.width;
     CGFloat x                       = scrollView.contentOffset.x;
     int page                        = (x + scrollviewW / 2) /  scrollviewW;
     self.pageController.currentPage = page;
}

#pragma mark - FuelCardCellDelegate
- (void)detailButtonClickedOnFuelCardCell:(FuelCardCell *)cell {
    //  详情按钮点击
    GasCardData *data = self.gasCardModel.data;
    GasCardInfo *info = data.list[cell.tag];
    
    OilCardDetailController *vc = [[OilCardDetailController alloc] initWithCardID:info.Id];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
