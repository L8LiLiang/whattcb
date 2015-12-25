//
//  TakePhotoCell.h
//  tcb
//
//  Created by Chuanxun on 15/11/25.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELPhoto.h"

@class TakePhotoCell;

@protocol TakePhotoCellDelegate <NSObject>

- (void)cellBackgroundBtnClicked:(TakePhotoCell *)cell;
- (void)cellPhotoSelectedStatusChanged:(TakePhotoCell *)cell;
@end


@interface TakePhotoCell : UICollectionViewCell

@property (weak, nonatomic) id<TakePhotoCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIButton *backgroundBtn;
@property (strong, nonatomic) ELPhoto *photo;

@end
