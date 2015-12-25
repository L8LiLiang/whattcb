//
//  UIImage+JAX.m
//  DooLii
//
//  Created by zhaoqiang on 15/1/16.
//  Copyright (c) 2015年 hairun. All rights reserved.
//

#import "UIImage+JAX.h"
#import "MacroDefine.h"

@implementation UIImage (JAX)

+ (UIImage *)imageWithName:(NSString *)name {
    UIImage *image = nil;
    if (iOS8) {//处理iOS8的图片
        NSString *newName = [name stringByAppendingString:@"_os8"];
        image = [UIImage imageNamed:newName];
    }else if (iOS7){//处理iOS7的图片
        NSString *newName = [name stringByAppendingString:@"_os7"];
        image = [UIImage imageNamed:newName];
    }
    
    if (image == nil) {//处理iOS6以及之前的图片
        image = [UIImage imageNamed:name];
    }
    
    return image;
}

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)resizedImage:(NSString *)name
{
    //设置图片的如何拉伸,定好四个边的内边距,只拉伸里面的外面保持原状（实际是外边不变 内部来个平铺图片）
    UIImage *image = [UIImage imageNamed:name];
    CGFloat w = image.size.width * 0.5;
    CGFloat h = image.size.height * 0.5;
    return [image resizableImageWithCapInsets:UIEdgeInsetsMake(h, w, h, w) resizingMode:UIImageResizingModeStretch];
}

+ (instancetype)imageWithOriginalName:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

+ (instancetype)imageWithStretchableName:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    return [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
}

@end
