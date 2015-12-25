//
//  NoteABillController.m
//  tcb
//
//  Created by Jax on 15/11/28.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import "NoteABillController.h"
#import "SelecteCostListView.h"
#import "ChooseImageView.h"
#import "GTMBase64.h"
#import "ConfigTool.h"
#import "UpLoadImageResultModel.h"
#import "SelectedImgFromAlbumController.h"
#import "SaveFeeResultModel.h"
#import "NSString+Extension.h"

@interface NoteABillController () <UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, SelecteCostListViewDelegate, ChooseImageViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextField *costListField;
@property (nonatomic, strong) UITextField *costField;
@property (nonatomic, copy  ) NSString    *selectedCostListString;
@property (nonatomic, strong) UILabel     *postPhotolabel;
@property (nonatomic, strong) NSString    *imagePath;

@end

@implementation NoteABillController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title                = @"记一笔";
    self.view.backgroundColor = kRGB(235, 234, 234);
    
    //  配置TableView
    [self configTableView];
    
    UIView *footView = [[UIView alloc] init];
    [self.view addSubview:footView];
    [footView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.equalTo(self.tableView.bottom).offset(0);
        if (self.saveFeeType == SaveFeeTypeModifyOrDelete) {
            make.height.equalTo(120);
        }
        if (self.saveFeeType == SaveFeeTypeAdd) {
            make.height.equalTo(60);
        }
    }];
    footView.backgroundColor = kRGB(235, 234, 234);
    
    UIButton *saveButton = [[UIButton alloc] init];
    [footView addSubview:saveButton];
    [saveButton makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(50);
        make.right.equalTo(-5);
        make.left.equalTo(5);
        make.top.equalTo(10);
    }];
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(saveButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [saveButton setTitleColor:kDefaultBarButtonItemColor forState:UIControlStateNormal];
    saveButton.layer.masksToBounds = YES;
    saveButton.layer.cornerRadius = 4;
    saveButton.layer.borderColor = kDefaultBarButtonItemColor.CGColor;
    saveButton.layer.borderWidth = 1.0f;
    
    if (self.saveFeeType == SaveFeeTypeModifyOrDelete) {
        UIButton *deleteButton = [[UIButton alloc] init];
        [footView addSubview:deleteButton];
        [deleteButton makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(saveButton.bottom).offset(10);
            make.bottom.right.equalTo(-5);
            make.left.equalTo(5);
        }];
        [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
        [deleteButton addTarget:self action:@selector(deleteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [deleteButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        deleteButton.layer.masksToBounds = YES;
        deleteButton.layer.cornerRadius = 4;
        deleteButton.layer.borderColor = [UIColor redColor].CGColor;
        deleteButton.layer.borderWidth = 1.0f;
    }

    
}

- (void)configTableView {
    self.tableView                 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64 + 3 * 44) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource      = self;
    self.tableView.delegate        = self;
    self.tableView.backgroundColor = kRGB(235, 234, 234);
    self.tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        UITableViewCell *costListCell = [[UITableViewCell alloc] init];
        
        UILabel *costListlabel = [[UILabel alloc] init];
        [costListCell.contentView addSubview:costListlabel];
        [costListlabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(15);
            make.top.bottom.equalTo(0);
            make.width.equalTo(40);
        }];
        costListlabel.text = @"费目:";
        
        UITextField *costListField = [[UITextField alloc] init];
        self.costListField = costListField;
        [costListCell.contentView addSubview:costListField];
        [costListField makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(costListlabel.right).offset(0);
            make.top.equalTo(costListCell.contentView.top).offset(0);
            make.bottom.equalTo(costListCell.contentView.bottom).offset(0);
            make.right.equalTo(costListCell.contentView.right).offset(0);
        }];
        costListField.userInteractionEnabled = NO;
        
        if (self.saveFeeType == SaveFeeTypeAdd) {
            costListCell.accessoryType    = UITableViewCellAccessoryDisclosureIndicator;
        }
        if (self.saveFeeType == SaveFeeTypeModifyOrDelete) {
            costListField.text = self.feeDetailList.FeeName;
        }
        
        return costListCell;
    } else if (indexPath.row == 1) {
        UITableViewCell *costCell = [[UITableViewCell alloc] init];
        UILabel *label = [[UILabel alloc] init];
        [costCell.contentView addSubview:label];
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(15);
            make.top.bottom.equalTo(0);
            make.width.equalTo(40);
        }];
        label.text = @"金额:";
        
        UITextField *costField = [[UITextField alloc] init];
        self.costField = costField;
        [costCell.contentView addSubview:costField];
        [costField makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(label.right).offset(0);
            make.top.equalTo(costCell.contentView.top).offset(0);
            make.bottom.equalTo(costCell.contentView.bottom).offset(0);
            make.right.equalTo(costCell.contentView.right).offset(0);
        }];
        costField.keyboardType = UIKeyboardTypeNumberPad;
        if (self.saveFeeType == SaveFeeTypeModifyOrDelete) {
            costField.text = [NSString stringWithFormat:@"%0.2f", [NSString cgFloatMoneyFromstringMoney:self.feeDetailList.Money]];
        }
        if (self.canEdit == 1 || self.canEdit == 2) {
            self.costField.userInteractionEnabled = NO;
        }
        
        return costCell;
    } else if (indexPath.row == 2) {
        UITableViewCell *postImageCell = [[UITableViewCell alloc] init];
        
        UILabel *takePhotolabel = [[UILabel alloc] init];
        [postImageCell.contentView addSubview:takePhotolabel];
        [takePhotolabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(15);
            make.top.bottom.equalTo(0);
            make.width.equalTo(40);
        }];
        takePhotolabel.text = @"拍照";
        
        UILabel *postPhotolabel = [[UILabel alloc] init];
        self.postPhotolabel = postPhotolabel;
        [postImageCell.contentView addSubview:postPhotolabel];
        [postPhotolabel makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-5);
            make.top.bottom.equalTo(0);
            make.width.equalTo(90);
        }];
        postPhotolabel.text = @"上传照片";
        
        if (self.saveFeeType == SaveFeeTypeModifyOrDelete) {
            self.imagePath = self.feeDetailList.ImageUrl;
        }
        
        return postImageCell;
    }
    
    return nil;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.costField resignFirstResponder];
    
    if (self.saveFeeType == SaveFeeTypeAdd) {
        if (indexPath.row == 0) {
            [self selectCostList];
        }
        if (indexPath.row == 2) {
            [self selectImage];
        }
    }
    if (self.saveFeeType == SaveFeeTypeModifyOrDelete) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (indexPath.row == 2) {
            if (self.canEdit == 0) {
                [self selectImage];
            }
        }
    }
}

#pragma mark - 选择费目/拍照/上传照片
- (void)selectCostList {
    SelecteCostListView *selecteCostListView        = [[SelecteCostListView alloc] initWithTag:0];
    [selecteCostListView show];
    selecteCostListView.pickView.delegate           = self;
    selecteCostListView.selecteCostListViewDelegate = self;
    
    if (![self.costListField.text isEqualToString:@""]) {
        for (int i = 0; i < self.feeDetailTypeListArray.count; i ++) {
            FeeDetailTypeList *feeDetailTypeList = self.feeDetailTypeListArray[i];
            if ([self.costListField.text isEqualToString:[NSString stringWithFormat:@"%@", feeDetailTypeList.FeeName]]) {
                [selecteCostListView.pickView selectRow:i inComponent:0 animated:NO];
                break;
            }
        }
    } else {
        [selecteCostListView.pickView selectRow:0 inComponent:0 animated:YES];
        [self pickerView:selecteCostListView.pickView didSelectRow:0 inComponent:0];
    }
}

- (void)selectImage {
    ChooseImageView *chooseImageView = [[ChooseImageView alloc] init];
    chooseImageView.chooseImageViewDelegate = self;
    [chooseImageView show];
}

#pragma mark pickView delegate dataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.feeDetailTypeListArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        FeeDetailTypeList *feeDetailTypeList = self.feeDetailTypeListArray[row];
        return feeDetailTypeList.FeeName;
    }
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    
    FeeDetailTypeList *feeDetailTypeList = self.feeDetailTypeListArray[row];
    self.selectedCostListString = feeDetailTypeList.FeeName;
    if (![self nsarry:self.alreadyExistFeeNameArray isIncludeObject:self.selectedCostListString]) {
        self.feeTypeID = feeDetailTypeList.FeeId;
    }
    

}

#pragma mark - 保存/修改/删除 记账
- (void)saveButtonClicked:(UIButton *)sender {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:@"SaveFee" forKey:@"cmd"];
    NSMutableDictionary *data  = [NSMutableDictionary dictionary];
    [data setValue:self.dispCode forKey:@"dispCode"];
    if (self.saveFeeType == SaveFeeTypeAdd) {
        //    id: 费目编号，添加时为空
        [data setValue:@"" forKey:@"id"];
    }
    if (self.saveFeeType == SaveFeeTypeModifyOrDelete) {
        [data setValue:self.feeDetailList.Id forKey:@"id"];
    }
    //    type:操作类型：1 添加或修改
    [data setValue:@1 forKey:@"type"];
    [data setValue:self.imagePath forKey:@"imageUrl"];
    [data setValue:self.costField.text forKey:@"cost"];
    [data setValue:[NSNumber numberWithInteger:self.feeTypeID] forKey:@"feeTypeID"];
    [param setValue:data forKey:@"data"];
    NSLog(@"param == %@", param);
    [SVProgressHUD showWithStatus:@"正在保存费用" maskType:SVProgressHUDMaskTypeBlack];
    [APIClientTool saveFeeWithParam:param success:^(NSDictionary *dict) {
        [SVProgressHUD dismiss];
        SaveFeeResultModel *saveFeeResultModel = [SaveFeeResultModel mj_objectWithKeyValues:dict];
        if (saveFeeResultModel.ret == 0) {
            self.reloadFeeDetailBlock();
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [SVProgressHUD showErrorWithStatus:@"保存费用失败"];
        }
        
    } failed:^{
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"网络连接失败"];
    }];
}

- (void)deleteButtonClicked:(UIButton *)sender {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:@"SaveFee" forKey:@"cmd"];
    NSMutableDictionary *data  = [NSMutableDictionary dictionary];
    [data setValue:self.dispCode forKey:@"dispCode"];
    [data setValue:self.feeDetailList.Id forKey:@"id"];
    //    type:操作类型：1 添加或修改
    [data setValue:self.imagePath forKey:@"imageUrl"];
    [data setValue:self.costField.text forKey:@"cost"];
    [data setValue:@2 forKey:@"type"];
    [data setValue:[NSNumber numberWithInteger:self.feeTypeID] forKey:@"feeTypeID"];
    [param setValue:data forKey:@"data"];
    [SVProgressHUD showWithStatus:@"正在保存费用" maskType:SVProgressHUDMaskTypeBlack];
    [APIClientTool saveFeeWithParam:param success:^(NSDictionary *dict) {
        [SVProgressHUD dismiss];
        SaveFeeResultModel *saveFeeResultModel = [SaveFeeResultModel mj_objectWithKeyValues:dict];
        NSLog(@"%@", dict);
        if (saveFeeResultModel.ret == 0) {
            [SVProgressHUD showSuccessWithStatus:@"保存费用成功"];
        } else {
            [SVProgressHUD showErrorWithStatus:@"保存费用失败"];
        }
        
    } failed:^{
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"网络连接失败"];
    }];
}


#pragma mark - SelecteCostListViewDelegate
- (void)selecteCostListViewOkButtonClicked:(UIButton *)sender {
    /* 判断当前选择费用是否已存在*/
    if ([self nsarry:self.alreadyExistFeeNameArray isIncludeObject:self.selectedCostListString]) {
        TCBAlertView *tcbAlertView = [[TCBAlertView alloc] initWithTitle:@"拖车宝" contentText:[NSString stringWithFormat:@"费目:%@存在", self.selectedCostListString]leftButtonTitle:@"取消" rightButtonTitle:@"确定"];
        [tcbAlertView show];
    } else if ([self.otherFeeName containsString:self.selectedCostListString]) {
        TCBAlertView *tcbAlertView = [[TCBAlertView alloc] initWithTitle:@"拖车宝" contentText:[NSString stringWithFormat:@"费目:%@已录入另一柜", self.selectedCostListString]leftButtonTitle:@"取消" rightButtonTitle:@"确定"];
        [tcbAlertView show];
    } else {
        self.costListField.text = self.selectedCostListString;
    }
}

#pragma mark - ChooseImageViewDelegate

- (void)takePictureButtonClicked:(UIButton *)sender {
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        if([[[UIDevice
              currentDevice] systemVersion] floatValue]>=8.0) {
            self.modalPresentationStyle=UIModalPresentationOverCurrentContext;
        }
        
        [self presentViewController:picker animated:YES completion:nil];
    }
}

- (void)selectedImageButtonClicked:(UIButton *)sender {
//    SelectedImgFromAlbumController *selectedImgFromAlbumController = [[SelectedImgFromAlbumController alloc] init];
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:selectedImgFromAlbumController];
//    selectedImgFromAlbumController.passValue = ^(NSString *stringValue){
//        self.postPhotolabel.text = stringValue;
//        self.postPhotolabel.textColor = [UIColor redColor];
//    };
//    
//    [self.navigationController presentViewController:nav animated:YES completion:^{
//        
//    }];
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        if([[[UIDevice
              currentDevice] systemVersion] floatValue]>=8.0) {
            self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        }
        [self presentViewController:picker animated:YES completion:nil];
    }

}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    /* 此处info 有六个值
     * UIImagePickerControllerMediaType; // an NSString UTTypeImage)
     * UIImagePickerControllerOriginalImage;  // a UIImage 原始图片
     * UIImagePickerControllerEditedImage;    // a UIImage 裁剪后图片
     * UIImagePickerControllerCropRect;       // an NSValue (CGRect)
     * UIImagePickerControllerMediaURL;       // an NSURL
     * UIImagePickerControllerReferenceURL    // an NSURL that references an asset in the AssetsLibrary framework
     * UIImagePickerControllerMediaMetadata    // an NSDictionary containing metadata from a captured photo
     */
    //获取图片后的操作
//    UIImagePNGRepresentation

    UIImage *compressImage = [ConfigTool compressImage:image toMaxFileSize:100 * 1024];
    NSData *imageData = UIImagePNGRepresentation(compressImage);
    NSString *imageBase64Data = [GTMBase64 stringByEncodingData:imageData];

    //  上传图片
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:@"UploadPicBase64" forKey:@"cmd"];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    [data setValue:imageBase64Data forKey:@"data"];
    [param setValue:data forKey:@"data"];
    
    [APIClientTool uploadImageWithParam:param success:^(NSDictionary *dict) {
        UpLoadImageResultModel *upLoadImageResultModel = [UpLoadImageResultModel mj_objectWithKeyValues:dict];
        if (upLoadImageResultModel.ret == 0) {
            self.postPhotolabel.text = @"已上传照片";
            self.postPhotolabel.textColor = [UIColor redColor];
            self.imagePath = upLoadImageResultModel.data;
        }
        
    } failed:^{
        [SVProgressHUD showErrorWithStatus:@"网络连接失败"];
    }];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    //  没有选择图片
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 判断一个字符串是否在数组中
- (BOOL)nsarry:(NSMutableArray *)array isIncludeObject:(NSString *)object {
    
    __block BOOL isInclude = false;
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([object isEqualToString:obj]) {
            isInclude = YES;
            *stop = YES;
        }
    }];
    
    return isInclude;
}

@end
