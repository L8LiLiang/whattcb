//
//  TakePhotoController.h
//  tcb
//
//  Created by Chuanxun on 15/11/25.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import <UIKit/UIKit.h>


#define PHOTO_COLUMN_COUNT (iPhone4 ? 3 : 4)
#define PHOTO_ITEM_SPACING 8
#define PHOTO_WIDTH ((SCREEN_WIDTH) - ((PHOTO_COLUMN_COUNT) + 1) * (PHOTO_ITEM_SPACING)) / PHOTO_COLUMN_COUNT


@class ELDispatchOrderItem;

@interface TakePhotoController : UICollectionViewController

- (instancetype)initWithPhotoUrls:(NSArray *)urls smallPhotoUrls:(NSArray *)smallPhotoUrls dispOrderItem:(ELDispatchOrderItem *)item;

@end
