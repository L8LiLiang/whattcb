//
//  ELPhoto.m
//  tcb
//
//  Created by Chuanxun on 15/11/26.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import "ELPhoto.h"
#import "TakePhotoController.h"
#import "ConfigTool.h"


@implementation ELPhoto

-(instancetype)initWithUrl:(NSURL *)url photoId:(NSString *)photoId synchronizedWithServer:(BOOL)syncronized status:(NSNumber *)status
{
    if (self = [super init]) {
        self.photoUrl = url;
        self.photoID = photoId;
        self.synchronizedWithServer = syncronized;
        self.status = status;
        self.selected = NO;
        self.indexInAsset = -1;
    }
    return self;
}

-(void)setStatus:(NSNumber *)status
{
    _status = status;
}

-(void)toogleStatus
{
//    if (self.synchronizedWithServer) {
//        if (self.status == PHOTO_STATUS_DELETE) {
//            self.status = PHOTO_STATUS_NORMAL;
//        }else if(self.status == PHOTO_STATUS_NORMAL) {
//            self.status = PHOTO_STATUS_DELETE;
//        }
//    }else {
//        if (self.status == PHOTO_STATUS_ADD) {
//            self.status = PHOTO_STATUS_NORMAL;
//        }else if (self.status == PHOTO_STATUS_NORMAL) {
//            self.status = PHOTO_STATUS_ADD;
//        }
//    }
    
    self.selected = !self.selected;
}

- (UIImage *)bigImage
{
    
    if (self.image) {
        return self.image;
    }
    
    __block UIImage *image;
    
    if (NSClassFromString(@"PHAsset")) {
        PHAsset *asset = (PHAsset *)self.asset;
        PHImageRequestOptions *option = [PHImageRequestOptions new];
        option.synchronous = YES;
        PHCachingImageManager *imageManager = [[PHCachingImageManager alloc] init];
        [imageManager requestImageForAsset:asset
                                targetSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)
                               contentMode:PHImageContentModeAspectFill
                                   options:option
                             resultHandler:^(UIImage *result, NSDictionary *info) {
                                 image = result;
//                                 image = [ConfigTool compressImage:result toMaxFileSize:100 * 1024];
                             }];
    }else {
        ALAsset *asset = self.asset;
//        image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullResolutionImage];
//        NSData *data1 = UIImageJPEGRepresentation(image, 1);
        image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
//        NSData *data2 = UIImageJPEGRepresentation(image, 1);
//        NSLog(@"fullResolution = %zd,fullScreen = %zd",[data1 length],[data2 length]);
//        image = [ConfigTool compressImage:image toMaxFileSize:100 * 1024];
    }
    
    return image;
}

- (UIImage *)thumbnail
{
    if(self.image)
        return self.image;
    
    __block UIImage *image;
    
    if (NSClassFromString(@"PHAsset")) {
        PHAsset *asset = (PHAsset *)self.asset;
        PHCachingImageManager *imageManager = [[PHCachingImageManager alloc] init];
        PHImageRequestOptions *option = [PHImageRequestOptions new];
        option.synchronous = YES;
        [imageManager requestImageForAsset:asset
                                targetSize:CGSizeMake(PHOTO_WIDTH, PHOTO_WIDTH)
                               contentMode:PHImageContentModeAspectFill
                                   options:option
                             resultHandler:^(UIImage *result, NSDictionary *info) {
                                 image = result;
//                                 image = [ConfigTool compressImage:result toMaxFileSize:100 * 1024];
                             }];
    }else {
        ALAsset *asset = self.asset;
        image = [UIImage imageWithCGImage:asset.thumbnail];
    }
    
    return image;
}

@end
