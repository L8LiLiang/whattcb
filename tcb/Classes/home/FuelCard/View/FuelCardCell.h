//
//  FuelCardCell.h
//  tcb
//
//  Created by Jax on 15/12/14.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GasCardModel.h"

@class FuelCardCell;

@protocol FuelCardCellDelegate <NSObject>

@optional
- (void)detailButtonClickedOnFuelCardCell:(FuelCardCell *)cell;

@end

@interface FuelCardCell : UICollectionViewCell

@property (nonatomic,strong) GasCardInfo *gasCardInfo;
@property (nonatomic, weak) id<FuelCardCellDelegate>  fuelCardCellDelegate;

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath;


@end
