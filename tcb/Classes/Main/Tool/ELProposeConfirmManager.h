//
//  ELProposeConfirmManager.h
//  tcb
//
//  Created by Chuanxun on 15/12/7.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ELProposeConfirmManager : NSObject

+ (instancetype)sharedManager;
- (void)proposeWithControllser:(UIViewController *)vc title:(NSString *)title msg:(NSArray *)msgs blocks:(NSArray*)actionBlocks;

@end
