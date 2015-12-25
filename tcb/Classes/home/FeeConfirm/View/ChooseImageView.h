//
//  ChooseImageView.h
//  tcb
//
//  Created by Jax on 15/11/28.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChooseImageViewDelegate <NSObject>

@optional
/**
 *  拍照
 */
- (void)takePictureButtonClicked:(UIButton *)sender;
/**
 *  从手机相册选择
 */
- (void)selectedImageButtonClicked:(UIButton *)sender;

@end

@interface ChooseImageView : UIView

@property (nonatomic, weak) id<ChooseImageViewDelegate> chooseImageViewDelegate;
- (void)show;

@end
