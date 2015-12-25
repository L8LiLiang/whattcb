//
//  NoteABillController.h
//  tcb
//
//  Created by Jax on 15/11/28.
//  Copyright © 2015年 Jax. All rights reserved.
//

typedef NS_ENUM(NSInteger, SaveFeeType) {
    SaveFeeTypeAdd = 0,
    SaveFeeTypeModifyOrDelete,
};


#import <UIKit/UIKit.h>
#import "FeeDetailModel.h"

typedef void (^ ReloadFeeDetailBlock)();

@interface NoteABillController : UIViewController

@property (nonatomic, strong) NSArray              *feeDetailTypeListArray;
@property (nonatomic, copy  ) NSString             *dispCode;
@property (nonatomic, assign) SaveFeeType          saveFeeType;

@property (nonatomic, strong) FeeDetailList        *feeDetailList;
@property (nonatomic, assign) NSInteger            feeTypeID;

@property (nonatomic, copy  ) ReloadFeeDetailBlock reloadFeeDetailBlock;

@property (nonatomic, strong) NSMutableArray       *alreadyExistFeeNameArray;
@property (nonatomic, copy  ) NSString             *otherFeeName;

@property (nonatomic, assign) NSInteger            canEdit;

@end
