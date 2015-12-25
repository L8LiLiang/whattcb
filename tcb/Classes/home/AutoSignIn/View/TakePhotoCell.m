//
//  TakePhotoCell.m
//  tcb
//
//  Created by Chuanxun on 15/11/25.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import "TakePhotoCell.h"
#import <UIButton+WebCache.h>
#import "UIImage+JAX.h"

@interface TakePhotoCell ()

@property (weak, nonatomic) IBOutlet UIButton *statusBtn;

@end

@implementation TakePhotoCell

-(instancetype)init
{
    if (self = [super init]) {
        NSLog(@"cell init");
        
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    [self.statusBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    UIImage *image = [UIImage imageNamed:@"ImageSelectedOff"];
    [self.statusBtn setBackgroundImage:image forState:UIControlStateNormal];
    
    image = [UIImage imageNamed:@"ImageSelectedOn"];
    [self.statusBtn setBackgroundImage:image forState:UIControlStateSelected];
}

- (IBAction)backgroundBtnClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(cellBackgroundBtnClicked:)]) {
        [self.delegate cellBackgroundBtnClicked:self];
    }
}

- (IBAction)statusBtnClicked:(id)sender {
    [self.photo toogleStatus];
}

-(void)setPhoto:(ELPhoto *)photo
{
    if (![_photo.photoID isEqualToString:@"-1"]) {
        
        [_photo removeObserver:self forKeyPath:@"selected"];
    }
    
    _photo = photo;
    
    if ([photo.photoID isEqualToString:@"-1"]) {
        UIImage *image = [UIImage imageWithOriginalName:@"add_icon"];
        [self.backgroundBtn setImage:image forState:UIControlStateNormal];
        [self.backgroundBtn setBackgroundImage:nil forState:UIControlStateNormal];
        [self.statusBtn setBackgroundImage:nil forState:UIControlStateNormal];
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.contentView.layer.borderColor = [UIColor grayColor].CGColor;
        self.contentView.layer.borderWidth = 1;
        return;
    }
    UIColor *color = [UIColor colorWithRed:216/255.0 green:221/255.0 blue:226/255.0 alpha:1.0];
    self.contentView.backgroundColor = color;
    self.contentView.layer.borderWidth = 0;
    [self.backgroundBtn setImage:nil forState:UIControlStateNormal];
    
//    [_photo addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:NULL];
    [_photo addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew context:NULL];
//    if (photo.status == PHOTO_STATUS_NORMAL) {
//        [self.statusBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        UIImage *image = [UIImage imageNamed:@"ImageSelectedOff"];
//        [self.statusBtn setBackgroundImage:image forState:UIControlStateNormal];
//    }else if (photo.status == PHOTO_STATUS_ADD) {
//        [self.statusBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
//        UIImage *image = [UIImage imageNamed:@"ImageSelectedOn"];
//        [self.statusBtn setBackgroundImage:image forState:UIControlStateNormal];
//    }else if (photo.status == PHOTO_STATUS_DELETE ) {
//        [self.statusBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//        UIImage *image = [UIImage imageNamed:@"ImageSelectedOn"];
//        [self.statusBtn setBackgroundImage:image forState:UIControlStateNormal];
//    }
    UIImage *image;
    if(_photo.selected) {
        image = [UIImage imageNamed:@"ImageSelectedOn"];
    }else {
        image = [UIImage imageNamed:@"ImageSelectedOff"];
    }
    [self.statusBtn setBackgroundImage:image forState:UIControlStateNormal];
    
    if (photo.photoUrl) {
        [self.backgroundBtn sd_setBackgroundImageWithURL:photo.photoUrl forState:UIControlStateNormal];
    }else {
        [self.backgroundBtn setBackgroundImage:[photo thumbnail] forState:UIControlStateNormal];
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
//    if ([keyPath isEqualToString:@"status"]) {
////        PHOTO_STATUS oldStatus = [change valueForKey:NSKeyValueChangeOldKey];
//        NSNumber *newStatus = [change valueForKey:NSKeyValueChangeNewKey];
//        if (newStatus == PHOTO_STATUS_NORMAL) {
//            [self.statusBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//            UIImage *image = [UIImage imageNamed:@"ImageSelectedOff"];
//            [self.statusBtn setBackgroundImage:image forState:UIControlStateNormal];
//        }else if (newStatus == PHOTO_STATUS_ADD) {
//            [self.statusBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
//            UIImage *image = [UIImage imageNamed:@"ImageSelectedOn"];
//            [self.statusBtn setBackgroundImage:image forState:UIControlStateNormal];
//        }else if (newStatus == PHOTO_STATUS_DELETE ) {
//            [self.statusBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//            UIImage *image = [UIImage imageNamed:@"ImageSelectedOn"];
//            [self.statusBtn setBackgroundImage:image forState:UIControlStateNormal];
//        }
//        
//        if (self.photo.indexInAsset != -1) {
//            if ([self.delegate respondsToSelector:@selector(cellPhotoSelectedStatusChanged:)]) {
//                [self.delegate cellPhotoSelectedStatusChanged:self];
//            }
//        }
//    }else
    if([keyPath isEqualToString:@"selected"]) {
        NSNumber *selectedNum = [change valueForKey:NSKeyValueChangeNewKey];
        UIImage *image;
        if(selectedNum.intValue == 1) {
            image = [UIImage imageNamed:@"ImageSelectedOn"];
        }else {
            image = [UIImage imageNamed:@"ImageSelectedOff"];
        }
        [self.statusBtn setBackgroundImage:image forState:UIControlStateNormal];
        
        if (self.photo.indexInAsset != -1) {
            if ([self.delegate respondsToSelector:@selector(cellPhotoSelectedStatusChanged:)]) {
                [self.delegate cellPhotoSelectedStatusChanged:self];
            }
        }
    }else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

-(void)dealloc
{
    if (![self.photo.photoID isEqualToString:@"-1"]) {
        
        [self.photo removeObserver:self forKeyPath:@"selected"];
    }
}

@end
