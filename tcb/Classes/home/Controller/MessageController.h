//
//  MessageController.h
//  tcb
//
//  Created by Jax on 15/12/11.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLTabedSlideView.h"


@interface MessageController : UIViewController <DLTabedSlideViewDelegate>

@property (strong, nonatomic) DLTabedSlideView *tabedSlideView;

@end
