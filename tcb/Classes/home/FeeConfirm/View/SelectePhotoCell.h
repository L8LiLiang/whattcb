//
//  SelectePhotoCell.h
//  tcb
//
//  Created by Jax on 15/11/30.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyPhoto.h"
#import <MWPhoto.h>

@class SelectePhotoCell;

@protocol SelectePhotoCellDelegate <NSObject>

@optional
- (void)tapImageViewOnSelectePhotoCell:(SelectePhotoCell *)selectePhotoCell;
- (void)clickImageHandleButtonOnSelectePhotoCell:(SelectePhotoCell *)selectePhotoCell;

@end

@interface SelectePhotoCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView              *imgView;
@property (nonatomic, strong) UIButton                 *imageHandleButton;

@property (nonatomic, strong) MyPhoto*                  myPhoto;
@property (nonatomic, weak  ) id<SelectePhotoCellDelegate> selectePhotoCellDelegate;

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath;

@end
