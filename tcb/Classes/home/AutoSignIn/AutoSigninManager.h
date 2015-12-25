//
//  AutoSigninManager.h
//  tcb
//
//  Created by Chuanxun on 15/12/10.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AutoSigninManager : NSObject

+ (instancetype)sharedManager;

- (void)autoSignIn;

@end
