//
//  SaveFeeResultModel.h
//  tcb
//
//  Created by Jax on 15/12/1.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SaveFeeResultModel : NSObject


@property (nonatomic, copy) NSString *data;

@property (nonatomic, assign) NSInteger pagenumber;

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, assign) NSInteger rownumber;

@property (nonatomic, assign) NSInteger ret;


@end
