//
//  MyPhoto.h
//  tcb
//
//  Created by Jax on 15/11/30.
//  Copyright © 2015年 Jax. All rights reserved.
//

typedef NS_ENUM(NSInteger, MyPhotoStatusType) {
    MyPhotoStatusTypeNone = 0,
    MyPhotoStatusTypeSelected,
};

#import <Foundation/Foundation.h>

@interface MyPhoto : NSObject

@property (strong, nonatomic) UIImage *image;
@property (assign, nonatomic) BOOL selected;
@property (nonatomic, assign) MyPhotoStatusType myPhotoStatusType;

- (instancetype)initWithMyPhotoWithImage:(UIImage *)image myPhotoStatusType:(MyPhotoStatusType)myPhotoStatusType;
- (void)changeStatus;

@end
