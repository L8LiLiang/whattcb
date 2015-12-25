//
//  OicCardConsumptionList.h
//  tcb
//
//  Created by Chuanxun on 15/12/15.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OilCardConsumptionItem : NSObject

@property (copy, nonatomic) NSString *Id;
@property (copy, nonatomic) NSString *Team;
@property (copy, nonatomic) NSString *Time;
@property (copy, nonatomic) NSString *Balance;
@property (copy, nonatomic) NSString *Cost;

@end



@interface OilCardConsumptionList : NSObject


@property (strong, nonatomic) NSArray<OilCardConsumptionItem *> *list;

@end
