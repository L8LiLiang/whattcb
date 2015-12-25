//
//  ELStatementAttachController.m
//  tcb
//
//  Created by Chuanxun on 15/12/7.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import "ELStatementAttachController.h"
#import "ELStatementAttachCell.h"
#import "ELStatementAttach.h"



@interface ELStatementAttachController ()

@property (strong, nonatomic) ELStatementAttachList *list;
@property (copy, nonatomic) NSString *checkNo;

@end


@implementation ELStatementAttachController


static NSString *reuse_id = @"ELStatementAttachCell";


-(instancetype)initWithCheckNo:(NSString *)checkNo
{
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        self.checkNo = checkNo;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"已付挂靠费明细";
    
    UINib *nib = [UINib nibWithNibName:@"ELStatementAttachCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:reuse_id];
    
    self.tableView.rowHeight = [ELStatementAttachCell cellHeight];
    
    [self loadData];
}

- (void)loadData
{
    NSDictionary *dict = @{@"cmd":@"GetStatementAttachList",@"data":@{@"checkNo":self.checkNo}};
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:dict];
    
    [SVProgressHUD showWithStatus:@"正在加载挂靠费..."];
    [APIClientTool getStatementAttachListWithParam:params success:^(NSDictionary *dict) {        
        int ret = [[dict valueForKey:@"ret"] intValue];
        if (ret == 0) {
            [SVProgressHUD dismiss];
            ELStatementAttachList *list = [ELStatementAttachList mj_objectWithKeyValues:[dict valueForKey:@"data"]];
            self.list = list;
            
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
    return self.list.list.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ELStatementAttachCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse_id forIndexPath:indexPath];
    
    cell.attach = self.list.list[indexPath.row];
    
    return cell;
}


-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footer = [UIView new];
    footer.backgroundColor = kRGB(233, 233, 233);
    
    UILabel *totalMoney = [UILabel new];
    totalMoney.text = self.list.totalCost;
    totalMoney.font = [UIFont systemFontOfSize:20];
    totalMoney.textColor = kRGB(250, 73, 9);
    [footer addSubview:totalMoney];
    
    UILabel *title = [UILabel new];
    title.text = @"共计：";
    title.font = [UIFont systemFontOfSize:20];
    [footer addSubview:title];
    
    [totalMoney makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(footer.trailing).offset(-8);
        make.centerY.equalTo(footer);
    }];
    
    [title makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(totalMoney.leading).offset(-8);
        make.centerY.equalTo(footer);
    }];
    
    return footer;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 40;
}



//- (UIView *)footerView
//{
//    UIView *footer = [UIView new];
//    footer.backgroundColor = kRGB(233, 233, 233);
//    
//    UILabel *totalMoney = [UILabel new];
//    totalMoney.text = self.list.totalCost;
//    totalMoney.font = [UIFont systemFontOfSize:20];
//    totalMoney.textColor = kRGB(250, 73, 9);
//    [footer addSubview:totalMoney];
//    
//    UILabel *title = [UILabel new];
//    title.text = @"共计：";
//    title.font = [UIFont systemFontOfSize:20];
//    [footer addSubview:title];
//    
//    [totalMoney makeConstraints:^(MASConstraintMaker *make) {
//        make.trailing.equalTo(footer.trailing).offset(-8);
//        make.centerY.equalTo(footer);
//    }];
//    
//    [title makeConstraints:^(MASConstraintMaker *make) {
//        make.trailing.equalTo(totalMoney.leading).offset(-8);
//        make.centerY.equalTo(footer);
//    }];
//    
//    return footer;
//}

@end
