//
//  OilCardDetailItemController.h
//  tcb
//
//  Created by Chuanxun on 15/12/15.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,OilCardDetailItemControllerType) {
    OCDICT_ALL = 0,
    OCDICT_ADD = 1,
    OCDICT_DELETE = 2,
};


@interface OilCardDetailItemController : UITableViewController

- (instancetype)initWithCardID:(NSString *)cardId Type:(OilCardDetailItemControllerType)type;


@end
