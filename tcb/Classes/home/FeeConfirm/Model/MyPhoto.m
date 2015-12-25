//
//  MyPhoto.m
//  tcb
//
//  Created by Jax on 15/11/30.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import "MyPhoto.h"

@implementation MyPhoto

- (instancetype)initWithMyPhotoWithImage:(UIImage *)image myPhotoStatusType:(MyPhotoStatusType)myPhotoStatusType {
    if (self = [super init]) {
        self.image = image;
        self.myPhotoStatusType = myPhotoStatusType;
        self.selected = myPhotoStatusType;
    }
    return self;
}

- (void)setMyPhotoStatusType:(MyPhotoStatusType)myPhotoStatusType {
    _myPhotoStatusType = myPhotoStatusType;
}

- (void)changeStatus {
    if (self.myPhotoStatusType == MyPhotoStatusTypeNone) {
        self.myPhotoStatusType = MyPhotoStatusTypeSelected;
        self.selected = MyPhotoStatusTypeSelected;
    } else if (self.myPhotoStatusType == MyPhotoStatusTypeSelected) {
        self.myPhotoStatusType = MyPhotoStatusTypeNone;
        self.selected = MyPhotoStatusTypeNone;
    }
}

@end
