//
//  OilCardDetailController.h
//  tcb
//
//  Created by Chuanxun on 15/12/15.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLTabedSlideView.h"

@interface OilCardDetailController : UIViewController <DLTabedSlideViewDelegate>

@property (strong, nonatomic) DLTabedSlideView *tabedSlideView;

- (instancetype)initWithCardID:(NSString *)cardId;

@end
