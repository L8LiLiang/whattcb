//
//  SelectedImgFromAlbumController.h
//  tcb
//
//  Created by Jax on 15/11/30.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ postImageLabelBlock) (NSString *);

@interface SelectedImgFromAlbumController : UIViewController

@property (nonatomic, copy) postImageLabelBlock passValue;

@end
