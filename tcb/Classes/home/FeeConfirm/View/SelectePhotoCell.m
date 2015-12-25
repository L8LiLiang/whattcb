//
//  SelectePhotoCell.m
//  tcb
//
//  Created by Jax on 15/11/30.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import "SelectePhotoCell.h"

@interface SelectePhotoCell ()

@end

@implementation SelectePhotoCell

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"SelectePhotoCell";
    SelectePhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[SelectePhotoCell alloc] init];
    }
    return cell;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpViews];
    }
    return self;
}

- (void)setUpViews {
    UIImageView *imgView = [[UIImageView alloc] init];
    self.imgView = imgView;
    [self.contentView addSubview:imgView];
    [imgView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsZero);
    }];
    [imgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(imageViewTapped:)]];
    imgView.userInteractionEnabled = YES;
    
    UIButton *imageHandleButton = [[UIButton alloc] init];
    [imageHandleButton addTarget:self action:@selector(imageHandleButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.imageHandleButton = imageHandleButton;
    self.imageHandleButton.titleLabel.font = [UIFont systemFontOfSize:8];
    [self.contentView addSubview:imageHandleButton];
    [imageHandleButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(0);
        make.width.height.equalTo(35);
    }];
    [self.imageHandleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
}

- (void)imageViewTapped:(UITapGestureRecognizer *)tap {
    if ([self.selectePhotoCellDelegate respondsToSelector:@selector(tapImageViewOnSelectePhotoCell:)]) {
        [self.selectePhotoCellDelegate tapImageViewOnSelectePhotoCell:self];
    }
}

- (void)imageHandleButtonClicked:(SelectePhotoCell *)selectePhotoCell {
    [self.myPhoto changeStatus];
    //  修改控制器的selections
    if ([self.selectePhotoCellDelegate respondsToSelector:@selector(clickImageHandleButtonOnSelectePhotoCell:)]) {
        [self.selectePhotoCellDelegate clickImageHandleButtonOnSelectePhotoCell:self];
    }
}

- (void)setMyPhoto:(MyPhoto *)myPhoto {
    [_myPhoto removeObserver:self forKeyPath:@"myPhotoStatusType"];
    _myPhoto = myPhoto;
    [_myPhoto addObserver:self forKeyPath:@"myPhotoStatusType" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];

    self.imgView.image = myPhoto.image;
    if (myPhoto.myPhotoStatusType == MyPhotoStatusTypeNone) {
        [self.imageHandleButton setBackgroundImage:[UIImage imageNamed:@"ImageSelectedSmallOff"] forState:UIControlStateNormal];
    } else if (myPhoto.myPhotoStatusType == MyPhotoStatusTypeSelected) {
        [self.imageHandleButton setBackgroundImage:[UIImage imageNamed:@"ImageSelectedSmallOn"] forState:UIControlStateNormal];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqual:@"myPhotoStatusType"]) {
        NSInteger newPhotoHandleType = [[change valueForKeyPath:NSKeyValueChangeNewKey] integerValue];
        if (newPhotoHandleType == MyPhotoStatusTypeNone) {
            self.selected = MyPhotoStatusTypeNone;
            [self.imageHandleButton setBackgroundImage:[UIImage imageNamed:@"ImageSelectedSmallOff"] forState:UIControlStateNormal];
        } else if (newPhotoHandleType == MyPhotoStatusTypeSelected) {
            self.selected = MyPhotoStatusTypeSelected;
            [self.imageHandleButton setBackgroundImage:[UIImage imageNamed:@"ImageSelectedSmallOn"] forState:UIControlStateNormal];
        }
    }
}

- (void)dealloc {
    [self.myPhoto removeObserver:self forKeyPath:@"myPhotoStatusType"];
}

@end
