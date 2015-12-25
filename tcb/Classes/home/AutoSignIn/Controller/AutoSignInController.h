//
//  AutoSignInController.h
//  tcb
//
//  Created by Chuanxun on 15/11/17.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ELInProgressTask;

@interface AutoSignInController : UIViewController 


-(instancetype)initWithDispatchOrderIDs:(NSArray *)dispatchIDs  SelectedItemIndex:(NSInteger)index telephoneNums:(NSArray *)telephoneNums readonly:(BOOL)readonly;

@end
