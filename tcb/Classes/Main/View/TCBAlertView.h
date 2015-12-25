//
//  TCBAlertView.h
//  tcb
//
//  Created by Jax on 15/11/12.
//  Copyright © 2015年 Jax. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface TCBAlertView : UIView

@property (nonatomic, copy) dispatch_block_t leftBlock;
@property (nonatomic, copy) dispatch_block_t rightBlock;

/**
 *  初始化弹出框
 */
- (instancetype)initWithTitle:(NSString *)title
                  contentText:(NSString *)content
              leftButtonTitle:(NSString *)leftTitle
             rightButtonTitle:(NSString *)rigthTitle;

- (void)show;

@end
