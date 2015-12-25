//
//  ConsumptionDetailController.m
//  tcb
//
//  Created by Chuanxun on 15/12/15.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import "ConsumptionDetailController.h"
#import "ConsumptionDetail.h"
#import "ConsumptionDetailCell.h"

@interface CDCHeaderView : UIView

@property (copy, nonatomic) NSString *cost;

- (instancetype)initWithCost:(NSString *)cost;

@end

@implementation CDCHeaderView

-(instancetype)initWithCost:(NSString *)cost
{
    if (self = [super init]) {
        self.cost = cost;
        
        [self makeContent];
    }
    
    return self;
}


- (void)makeContent
{
    self.backgroundColor = [UIColor whiteColor];
    
    UIImageView *icon = [UIImageView new];
    UILabel *titleLable = [UILabel new];
    UILabel *costLabel = [UILabel new];
    titleLable.textColor = [UIColor darkGrayColor];
    titleLable.font = [UIFont systemFontOfSize:18];
    costLabel.textColor = [UIColor blackColor];
    costLabel.font = [UIFont boldSystemFontOfSize:20];
    
    if ([self.cost characterAtIndex:0] == '-') {
        UIImage *image = [UIImage imageNamed:@"ic_consumption"];
        icon.image = image;
        titleLable.text = @"消费金额";
        costLabel.text = [self.cost substringFromIndex:1];
    }else  if([self.cost characterAtIndex:0] == '+'){
        UIImage *image = [UIImage imageNamed:@"ic_recharge"];
        icon.image = image;
        titleLable.text = @"存入金额";
        costLabel.text = [self.cost substringFromIndex:1];
    }else {
        UIImage *image = [UIImage imageNamed:@"ic_recharge"];
        icon.image = image;
        titleLable.text = @"存入金额";
        costLabel.text = [self.cost substringFromIndex:0];
    }
    [self addSubview:icon];
    [self addSubview:titleLable];
    [self addSubview:costLabel];
    
    [icon makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.leading).offset(8);
        make.top.equalTo(self.top).offset(8);
        make.width.equalTo(@32);
        make.height.equalTo(@32);
    }];
    
    [titleLable makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(icon);
        make.leading.equalTo(icon.trailing).offset(8);
    }];
    
    [costLabel makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(icon.leading).offset(@4);
        make.top.equalTo(icon.bottom).offset(8);
    }];
    
}

@end




@interface ConsumptionDetailController ()

@property (copy, nonatomic) NSString * consumptionId;
@property (assign, nonatomic) BOOL isRecharge;
@property (strong, nonatomic) ConsumptionDetail *detail;
@property (strong, nonatomic) NSMutableArray *displayKeyAndValues;

@end

@implementation ConsumptionDetailController

static NSString *reuse_id = @"ConsumptionDetailCell";

-(instancetype)initWithConsumptionId:(NSString *)consumptionId isRecharge:(BOOL)isRecharge
{
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        self.consumptionId = consumptionId;
        self.isRecharge = isRecharge;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:@"ConsumptionDetailCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:reuse_id];
    self.tableView.rowHeight = [ConsumptionDetailCell bestHeight];
    
    if (self.isRecharge) {        
        self.navigationItem.title = @"充值详情";
    }else {
        self.navigationItem.title = @"消费详情";
    }
    
    [self loadData];
}

- (void)loadData
{
    [SVProgressHUD showWithStatus:@"正在加载数据"];
    
    NSDictionary *dict = @{@"cmd":@"GetConsumptionDetail",@"data":@{@"consumptionId":self.consumptionId}};
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:dict];
    
    [APIClientTool GetConsumptionDetailWithParam:params success:^(NSDictionary *dict) {
        int ret = [[dict valueForKey:@"ret"] intValue];
        if (ret == 0) {
            [SVProgressHUD dismiss];
            self.detail = [ConsumptionDetail mj_objectWithKeyValues:[dict valueForKey:@"data"]];
            
            [self.displayKeyAndValues addObject:@[@"余额",self.detail.Balence]];
            [self.displayKeyAndValues addObject:@[@"卡号",self.detail.FuelCardNo]];
            [self.displayKeyAndValues addObject:@[@"日期",self.detail.Time]];
            [self.displayKeyAndValues addObject:@[@"类型",self.detail.Type]];
            [self.displayKeyAndValues addObject:@[@"备注",self.detail.Remark]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }else {
            [SVProgressHUD showErrorWithStatus:[dict valueForKey:@"msg"]];
        }
    } failed:^{
        [SVProgressHUD showErrorWithStatus:@"网络异常"];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.displayKeyAndValues.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ConsumptionDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse_id forIndexPath:indexPath];
    
    NSArray *titleAndContent = self.displayKeyAndValues[indexPath.row];
    cell.title = titleAndContent.firstObject;
    cell.content = titleAndContent.lastObject;
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CDCHeaderView *headerView = [[CDCHeaderView alloc] initWithCost:self.detail.Cost];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 90;
}

#pragma mark - lazy load

-(NSMutableArray *)displayKeyAndValues
{
    if (!_displayKeyAndValues) {
        _displayKeyAndValues = [NSMutableArray new];
    }
    return _displayKeyAndValues;
}

@end
