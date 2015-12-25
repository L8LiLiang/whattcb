//
//  CheckController.h
//  tcb
//
//  Created by Jax on 15/11/10.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLTabedSlideView.h"



@interface CheckController : UIViewController<DLTabedSlideViewDelegate>
@property (strong, nonatomic) DLTabedSlideView *tabedSlideView;


@end
