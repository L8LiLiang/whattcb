//
//  SaveBankAccountController.m
//  tcb
//
//  Created by Jax on 15/12/7.
//  Copyright © 2015年 Jax. All rights reserved.
//

#define kLabelWidth 80

#import "SaveBankAccountController.h"
#import "SendAuthCodeController.h"
#import "SelecteCostListView.h"
#import "BankNameListModel.h"
#import "VerifyRegexTool.h"
#import "AreaModel.h"
#import "AreaLocalModel.h"

@interface SaveBankAccountController () <UIPickerViewDelegate, UIPickerViewDataSource, SelecteCostListViewDelegate, NSXMLParserDelegate>

@property (nonatomic, strong  ) BankNameListModel   *bankNameListModel;

@property (nonatomic, strong  ) SelecteCostListView *selectBankNameView;
@property (nonatomic, strong  ) SelecteCostListView *selectAreaView;

@property (nonatomic, strong  ) UILabel     *bank;
@property (nonatomic, copy    ) NSString    *bankString;
@property (nonatomic, copy    ) NSString    *bankCode;
@property (nonatomic, strong  ) UILabel     *area;
@property (nonatomic, strong  ) UITextField *name;
@property (nonatomic, strong  ) UITextField *cardId;
@property (nonatomic, strong  ) UITextField *netName;
@property (nonatomic, strong  ) UITextField *phoneNum;

@property (nonatomic, strong  ) NSMutableArray      *xmlDataArray;
@property (nonatomic, strong  ) NSMutableArray      *cityArray;
@property (nonatomic, copy    ) NSMutableString     *provinceString;
@property (nonatomic, copy    ) NSMutableString     *cityString;

@property (nonatomic, strong ) NSArray *provinceArr;
@property (nonatomic, strong ) NSArray * cityArr;

@property (nonatomic, copy  ) NSString  *selectPString;
@property (nonatomic, copy  ) NSString  *selectCString;
@property (nonatomic, assign) NSInteger selectAreaCode;
@property (nonatomic, assign) NSInteger middleSelectAreaCode;
@property (nonatomic, strong) AreaModel *locate;

@property(nonatomic,assign)NSInteger lastSelectIndex;

@end

@implementation SaveBankAccountController

#pragma mark - 懒加载
- (BankNameListModel *)bankNameListModel {
    if (_bankNameListModel == nil) {
        _bankNameListModel = [[BankNameListModel alloc] init];
    }
    return _bankNameListModel;
}

- (NSMutableString *)provinceString {
    if (_provinceString == nil) {
        _provinceString = [NSMutableString string];
    }
    return _provinceString;
}

- (NSMutableString *)cityString {
    if (_cityString == nil) {
        _cityString = [NSMutableString string];
    }
    return _cityString;
}

- (NSMutableArray *)xmlDataArray {
    if (_xmlDataArray == nil) {
        _xmlDataArray = [NSMutableArray array];
    }
    return _xmlDataArray;
}

- (NSMutableArray *)cityArray {
    if (_cityArray == nil) {
        _cityArray = [NSMutableArray array];
    }
    return _cityArray;
}

- (AreaModel *)locate{
    if (!_locate) {
        _locate = [[AreaModel alloc]init];
    }
    return _locate;
}

#pragma mark - view
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"新增银行卡";
    self.view.backgroundColor = kRGB(234, 234, 234);
    [self setupViews];
    
}

- (void)setupViews {
    UIView *view0 = [[UIView alloc] init];
    [self.view addSubview:view0];
    [view0 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(64);
        make.left.right.equalTo(0);
        make.height.equalTo(25);
    }];
    UILabel *label = [[UILabel alloc] init];
    label.text = @"输入您要添加的卡号";
    [view0 addSubview:label];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(0);
        make.left.equalTo(15);
    }];
    
    
    UIView *view1 = [[UIView alloc] init];
    [self.view addSubview:view1];
    [view1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view0.bottom).offset(0);
        make.left.right.equalTo(0);
        make.height.equalTo(44);
    }];
    view1.backgroundColor = kRGB(245, 245, 245);
    UILabel *label1 = [[UILabel alloc] init];
    label1.text = @"持卡人";
    [view1 addSubview:label1];
    [label1 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.top.bottom.equalTo(0);
        make.width.equalTo(kLabelWidth);
    }];
    UITextField *name = [[UITextField alloc] init];
    [view1 addSubview:name];
    [name makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(0);
        make.left.equalTo(label1.right).offset(0);
    }];
    name.placeholder = @"请输入持卡人姓名";
    self.name = name;
    
    
    UIView *view2 = [[UIView alloc] init];
    [self.view addSubview:view2];
    [view2 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view1.bottom).offset(10);
        make.left.right.equalTo(0);
        make.height.equalTo(44);
    }];
    view2.backgroundColor = kRGB(245, 245, 245);
    UILabel *label2 = [[UILabel alloc] init];
    label2.text = @"卡 号";
    [view2 addSubview:label2];
    [label2 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.top.bottom.equalTo(0);
        make.width.equalTo(kLabelWidth);
    }];
    UITextField *cardId = [[UITextField alloc] init];
    [view2 addSubview:cardId];
    [cardId makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(0);
        make.left.equalTo(label2.right).offset(0);
    }];
    cardId.keyboardType = UIKeyboardTypeNumberPad;
    cardId.placeholder = @"请输入银行卡号";
    self.cardId = cardId;
    
    UIView *view3 = [[UIView alloc] init];
    [self.view addSubview:view3];
    [view3 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view2.bottom).offset(0);
        make.left.right.equalTo(0);
        make.height.equalTo(25);
    }];
    UILabel *label3 = [[UILabel alloc] init];
    label3.text = @"开户行信息";
    [view3 addSubview:label3];
    [label3 makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(0);
        make.left.equalTo(15);
    }];
    
    
    UIView *view4 = [[UIView alloc] init];
    [self.view addSubview:view4];
    [view4 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view3.bottom).offset(0);
        make.left.right.equalTo(0);
        make.height.equalTo(44);
    }];
    view4.backgroundColor = kRGB(245, 245, 245);
    UILabel *label4 = [[UILabel alloc] init];
    label4.text = @"银 行";
    [view4 addSubview:label4];
    [label4 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.top.bottom.equalTo(0);
        make.width.equalTo(kLabelWidth);
    }];
    [view4 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bankViewTapped:)]];
    UIButton *selectBankButton = [[UIButton alloc] init];
    [selectBankButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    selectBankButton.backgroundColor = kRGB(234, 234, 234);
    [view4 addSubview:selectBankButton];
    [selectBankButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view4.centerY);
        make.height.width.equalTo(38);
        make.right.equalTo(-10);
    }];
    [selectBankButton addTarget:self action:@selector(selectBankButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [selectBankButton setImage:[UIImage imageNamed:@"ic_keyboard_arrow_down_white_36dp"] forState:UIControlStateNormal];
    UILabel *bank = [[UILabel alloc] init];
    [view4 addSubview:bank];
    [bank makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(0);
        make.left.equalTo(label4.right).offset(0);
        make.right.equalTo(selectBankButton.left).offset(-10);
    }];
    bank.text = @"请选择银行卡类型";
    bank.textColor = [UIColor lightGrayColor];
    self.bank = bank;
    
    
    UIView *view5 = [[UIView alloc] init];
    [self.view addSubview:view5];
    [view5 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view4.bottom).offset(10);
        make.left.right.equalTo(0);
        make.height.equalTo(44);
    }];
    view5.backgroundColor = kRGB(245, 245, 245);
    [view5 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(areaViewTapped:)]];
    UILabel *label5 = [[UILabel alloc] init];
    label5.text = @"省/市";
    [view5 addSubview:label5];
    [label5 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.top.bottom.equalTo(0);
        make.width.equalTo(kLabelWidth);
    }];
    UIButton *selectAreaButton = [[UIButton alloc] init];
    [selectAreaButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    selectAreaButton.backgroundColor = kRGB(234, 234, 234);
    [view5 addSubview:selectAreaButton];
    [selectAreaButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view5.centerY);
        make.height.width.equalTo(38);
        make.right.equalTo(-10);
    }];
    [selectAreaButton addTarget:self action:@selector(selectAreaButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [selectAreaButton setImage:[UIImage imageNamed:@"ic_keyboard_arrow_down_white_36dp"] forState:UIControlStateNormal];
    UILabel *area = [[UILabel alloc] init];
    [view5 addSubview:area];
    [area makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(0);
        make.left.equalTo(label5.right).offset(0);
        make.right.equalTo(selectAreaButton.left).offset(-10);
    }];
//    area.font = [UIFont systemFontOfSize:13];
    area.text = @"请选择省市地区";
    area.textColor = [UIColor lightGrayColor];
    self.area = area;
    
    UIView *view6 = [[UIView alloc] init];
    [self.view addSubview:view6];
    [view6 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view5.bottom).offset(10);
        make.left.right.equalTo(0);
        make.height.equalTo(44);
    }];
    view6.backgroundColor = kRGB(245, 245, 245);
    UILabel *label6 = [[UILabel alloc] init];
    label6.text = @"网点名称";
    [view6 addSubview:label6];
    [label6 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.top.bottom.equalTo(0);
        make.width.equalTo(kLabelWidth);
    }];
    UITextField *netName = [[UITextField alloc] init];
    [view6 addSubview:netName];
    [netName makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(0);
        make.left.equalTo(label6.right).offset(0);
        make.right.equalTo(0);
    }];
    netName.placeholder = @"请输入网点名称";
    self.netName = netName;
    
    UIView *view7 = [[UIView alloc] init];
    [self.view addSubview:view7];
    [view7 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view6.bottom).offset(10);
        make.left.right.equalTo(0);
        make.height.equalTo(44);
    }];
    view7.backgroundColor = kRGB(245, 245, 245);
    UILabel *label7 = [[UILabel alloc] init];
    label7.text = @"预留手机";
    [view7 addSubview:label7];
    [label7 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.top.bottom.equalTo(0);
        make.width.equalTo(kLabelWidth);
    }];
    UITextField *phoneNum = [[UITextField alloc] init];
    [view7 addSubview:phoneNum];
    [phoneNum makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(0);
        make.left.equalTo(label7.right).offset(0);
        make.right.equalTo(0);
    }];
    self.phoneNum = phoneNum;
    phoneNum.keyboardType = UIKeyboardTypeNumberPad;
    phoneNum.placeholder = @"请输入预留手机号";
    
    UIButton *nextButton = [[UIButton alloc] init];
    [self.view addSubview:nextButton];
    [nextButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(8);
        make.right.equalTo(-8);
        make.top.equalTo(view7.bottom).offset(5);
        make.height.equalTo(48);
    }];
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [nextButton setTitleColor:kDefaultBarButtonItemColor forState:UIControlStateNormal];
    nextButton.backgroundColor = kRGB(167, 167, 167);
    nextButton.layer.cornerRadius = 4;
    [nextButton addTarget:self action:@selector(nextButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
 
}

- (void)bankViewTapped:(UITapGestureRecognizer *)tap {
    [self getBankList];
}
- (void)selectBankButtonClicked:(UIButton *)sender {
    [self getBankList];
}
- (void)getBankList {
    
    [self.name resignFirstResponder];
    [self.cardId resignFirstResponder];
    [self.phoneNum resignFirstResponder];
    [self.netName resignFirstResponder];
    
    SelecteCostListView *selectBankNameView        = [[SelecteCostListView alloc] initWithTag:0];
    self.selectBankNameView                        = selectBankNameView;
    selectBankNameView.selecteCostListViewDelegate = self;
    selectBankNameView.pickView.delegate           = self;
    [selectBankNameView show];
    
    /* 获取银行列表:本地找，没有去网上找 */
    NSFileManager *fileManger = [NSFileManager defaultManager];
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [document stringByAppendingPathComponent:@"bankName.plist"];
    BOOL isFileExist =  [fileManger fileExistsAtPath:path];
    if (isFileExist) {
        NSDictionary *bankNameDict = [NSDictionary dictionaryWithContentsOfFile:path];
        self.bankNameListModel = [BankNameListModel mj_objectWithKeyValues:bankNameDict];
        [self.selectBankNameView.pickView reloadComponent:0];
        [self pickerView:self.selectBankNameView.pickView didSelectRow:0 inComponent:0];
    } else {
        [self getBankNameList];
    }
    
    
}

- (void)areaViewTapped:(UITapGestureRecognizer *)tap {
    [self getProviceAndCity];
}
- (void)selectAreaButtonClicked:(UIButton *)sender {
    [self getProviceAndCity];
}

- (void)nextButtonClicked:(UIButton *)sender {
    if (self.name.text.length == 0) {
        TCBAlertView *tcbAlertView = [[TCBAlertView alloc] initWithTitle:@"拖车宝" contentText:@"亲,你还没有输入持卡人姓名哦" leftButtonTitle:@"取消" rightButtonTitle:@"确定"];
        [tcbAlertView show];
    } else if (self.cardId.text.length == 0) {
        TCBAlertView *tcbAlertView = [[TCBAlertView alloc] initWithTitle:@"拖车宝" contentText:@"亲,你还没有输入银行卡号哦" leftButtonTitle:@"取消" rightButtonTitle:@"确定"];
        [tcbAlertView show];
    } else if (![VerifyRegexTool checkCardNo:self.cardId.text]) {
        TCBAlertView *tcbAlertView = [[TCBAlertView alloc] initWithTitle:@"拖车宝" contentText:@"亲,银行卡号输入错误" leftButtonTitle:@"取消" rightButtonTitle:@"确定"];
        [tcbAlertView show];
    } else if (self.bank.text.length == 0) {
        TCBAlertView *tcbAlertView = [[TCBAlertView alloc] initWithTitle:@"拖车宝" contentText:@"亲,你还没有选择银行类型" leftButtonTitle:@"取消" rightButtonTitle:@"确定"];
        [tcbAlertView show];
    } else if (self.area.text.length == 0) {
        TCBAlertView *tcbAlertView = [[TCBAlertView alloc] initWithTitle:@"拖车宝" contentText:@"亲,你还没有选择省市" leftButtonTitle:@"取消" rightButtonTitle:@"确定"];
        [tcbAlertView show];
    } else if (self.netName.text.length == 0) {
        TCBAlertView *tcbAlertView = [[TCBAlertView alloc] initWithTitle:@"拖车宝" contentText:@"亲,你还没有输入网点名称" leftButtonTitle:@"取消" rightButtonTitle:@"确定"];
        [tcbAlertView show];
    } else if (self.phoneNum.text.length == 0) {
        TCBAlertView *tcbAlertView = [[TCBAlertView alloc] initWithTitle:@"拖车宝" contentText:@"亲,你还没有输入预留手机号" leftButtonTitle:@"取消" rightButtonTitle:@"确定"];
        [tcbAlertView show];
    } else if (![VerifyRegexTool isValidateMobile:self.phoneNum.text]) {
        TCBAlertView *tcbAlertView = [[TCBAlertView alloc] initWithTitle:@"拖车宝" contentText:@"亲,你输入的预留手机号错误" leftButtonTitle:@"取消" rightButtonTitle:@"确定"];
        [tcbAlertView show];
    } else {
        SendAuthCodeController *sendAuthCodeController = [[SendAuthCodeController alloc] init];
        sendAuthCodeController.accountName             = self.name.text;
        sendAuthCodeController.accountNum              = self.cardId.text;
        sendAuthCodeController.bankCode                = self.bankCode;
        sendAuthCodeController.accountType             = self.bankString;
        sendAuthCodeController.accountAddress          = self.netName.text;
        sendAuthCodeController.accountProvince         = self.locate.province;
        sendAuthCodeController.accountCity             = self.locate.city;
        sendAuthCodeController.phoneNo                 = self.phoneNum.text;
        sendAuthCodeController.accountName             = self.name.text;
        [self.navigationController pushViewController:sendAuthCodeController animated:YES];
    }
    
}

- (void)getBankNameList {
    NSMutableDictionary *parma = [NSMutableDictionary dictionary];
    [parma setValue:@"GetBankNameList" forKey:@"cmd"];
    [APIClientTool GetBankNameListWithParam:parma success:^(NSDictionary *dict) {
        BankNameListModel *bankNameListModel = [BankNameListModel mj_objectWithKeyValues:dict];
        self.bankNameListModel               = bankNameListModel;
        
        /* 第一次网络请求银行列表成功之后，本地保存，以后不再发网络请求 */
        NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *path = [document stringByAppendingPathComponent:@"bankName.plist"];
        [dict writeToFile:path atomically:YES];
        
        [self.selectBankNameView.pickView reloadComponent:0];
        [self pickerView:self.selectBankNameView.pickView didSelectRow:0 inComponent:0];
    } failed:^{
        
    }];
}

- (void)getProviceAndCity {
    [self.name resignFirstResponder];
    [self.cardId resignFirstResponder];
    [self.phoneNum resignFirstResponder];
    [self.netName resignFirstResponder];
    
    /* XML解析文件*/
    [self xmlParserProviceData];
}

- (void)xmlParserProviceData {
    NSString *path        = [[NSBundle mainBundle] pathForResource:@"province_data.xml" ofType:nil];
    NSData *data          = [[NSData alloc] initWithContentsOfFile:path];
    NSXMLParser *xmlParse = [[NSXMLParser alloc] initWithData:data];
    xmlParse.delegate     = self;
    [xmlParse parse];
}

#pragma mark - NSXMLParse Delegate

- (void)parserDidStartDocument:(NSXMLParser *)parser{
    [self.xmlDataArray removeAllObjects];
    
}
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict {
    
    if ([elementName isEqualToString:@"province"]) {
        self.provinceString = [[attributeDict objectForKey:@"name"] mutableCopy];
    }
    if ([elementName isEqualToString:@"city"]) {
        self.cityString = [[attributeDict objectForKey:@"name"] mutableCopy];
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {

}

-(void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:@"city"]) {
        [self.cityArray addObject:self.cityString];
        self.cityString = [@"" mutableCopy];
    }
    if ([elementName isEqualToString:@"province"]) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:self.cityArray forKey:@"cities"];
        [dict setValue:self.provinceString forKey:@"province"];
        [self.xmlDataArray addObject:dict];
        self.cityArray      = nil;
        self.provinceString = nil;
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    self.provinceArr = self.xmlDataArray;
    self.cityArr = [self.provinceArr[0] objectForKey:@"cities"];
    
    
    self.locate.province = self.provinceArr[0][@"province"];
    self.locate.city = self.cityArr[0];

    SelecteCostListView *selectAreaView        = [[SelecteCostListView alloc] initWithTag:1];
    self.selectAreaView                        = selectAreaView;
    selectAreaView.selecteCostListViewDelegate = self;
    selectAreaView.pickView.delegate           = self;
    [selectAreaView show];

}

#pragma mark - SelecteCostListViewDelegate
- (void)selecteCostListViewOkButtonClicked:(UIButton *)sender {
    if (sender.tag == 0) {
        self.bank.text = self.bankString;
        self.bank.textColor = [UIColor blackColor];
    } else if (sender.tag == 1) {
        
        NSString *selectString = [NSString stringWithFormat:@"%@ %@", self.locate.province, self.locate.city];
        self.area.text         = selectString;
        self.area.textColor = [UIColor blackColor];
        self.selectAreaCode    = self.middleSelectAreaCode;
        
    }
}

#pragma mark - pickview data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (pickerView.tag == 0) {
        return 1;
    }
    if (pickerView.tag == 1) {
        return 2;
    }
    return 0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView.tag == 0) {
         return self.bankNameListModel.data.count;
    }
    if (pickerView.tag == 1) {
        switch (component) {
            case 0:
                return  self.provinceArr.count;
                break;
            case 1:
                return self.cityArr.count;
                break;
            default:
                return 0;
                break;
        }

    }
    return 0;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    if (pickerView.tag == 1) {
        UILabel* pickerLabel = (UILabel*)view;
        if (!pickerLabel){
            pickerLabel                           = [[UILabel alloc] init];
            pickerLabel.minimumScaleFactor        = 8.0;
            pickerLabel.adjustsFontSizeToFitWidth = YES;
            [pickerLabel setTextAlignment:NSTextAlignmentCenter];
            [pickerLabel setBackgroundColor:[UIColor clearColor]];
            [pickerLabel setFont:[UIFont boldSystemFontOfSize:15]];
        }
        pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
        return pickerLabel;
    } else {
        UILabel* pickerLabel = (UILabel*)view;
        if (!pickerLabel){
            pickerLabel                           = [[UILabel alloc] init];
            pickerLabel.minimumScaleFactor        = 8.0;
            pickerLabel.adjustsFontSizeToFitWidth = YES;
            [pickerLabel setTextAlignment:NSTextAlignmentCenter];
            [pickerLabel setBackgroundColor:[UIColor clearColor]];
            [pickerLabel setFont:[UIFont boldSystemFontOfSize:15]];
        }
        pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
        return pickerLabel;
    }
    return nil;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (pickerView.tag == 0) {
        BankInfo *bankInfo = self.bankNameListModel.data[row];
        return bankInfo.BankName;
    }
    if (pickerView.tag == 1) {
        switch (component) {
            case 0:
                return  [[self.provinceArr objectAtIndex:row] objectForKey:@"province"];
                break;
            case 1:
                return [self.cityArr objectAtIndex:row];
                break;
            default:
                return @"";
                break;
        }
    }
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (pickerView.tag == 0) {
        BankInfo *bankInfo = self.bankNameListModel.data[row];
        self.bankString    = bankInfo.BankName;
        self.bankCode      = bankInfo.BankCode;
    }
    if (pickerView.tag == 1) {
        switch (component) {
            case 0:
                self.cityArr = [self.provinceArr[row] objectForKey:@"cities"];
                [pickerView reloadComponent:1];
                [pickerView selectRow:0 inComponent:1 animated:YES];
                
                self.locate.province = [self.provinceArr[row] objectForKey:@"province"];
                self.locate.city = self.cityArr[0];
                break;
                
            case 1:
                self.locate.city = self.cityArr[row];
                break;

                
            default:
                break;
        }

    }
}

@end
