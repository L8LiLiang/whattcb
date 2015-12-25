//
//  ELPhoto.h
//  tcb
//
//  Created by Chuanxun on 15/11/26.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>


#define  PHOTO_STATUS_NORMAL [NSNumber numberWithInt:0]
#define  PHOTO_STATUS_DELETE [NSNumber numberWithInt:1]
#define  PHOTO_STATUS_ADD [NSNumber numberWithInt:2]



@interface ELPhoto : NSObject

@property (strong, nonatomic) UIImage *image;
@property (copy, nonatomic) NSURL *photoUrl;
@property (assign, nonatomic) BOOL synchronizedWithServer;
@property (assign, nonatomic) NSNumber *status;
@property (assign, nonatomic) BOOL selected;
@property (strong, nonatomic) id asset;

//photoID @"-1"代表此photo是拍照按钮对应的photo，否则是服务器返回的photoID
@property (copy, nonatomic) NSString *photoID;

//有一些ELPhoto是从相册里去的，通过这个属性关联此ELPhoto对应到相册中的序号
@property (assign, nonatomic) NSInteger indexInAsset;

- (instancetype)initWithUrl:(NSURL *)url photoId:(NSString *)photoId synchronizedWithServer:(BOOL)syncronized status:(NSNumber *)status;

- (void)toogleStatus;

- (UIImage *)thumbnail;
- (UIImage *)bigImage;
@end
