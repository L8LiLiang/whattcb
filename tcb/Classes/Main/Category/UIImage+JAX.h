//
//  UIImage+HR.h
//  DooLii
//
//  Created by zhaoqiang on 15/1/16.
//  Copyright (c) 2015年 hairun. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  UIImage的分类
 */
@interface UIImage (HR)

/**
 *  根据图片名自动加载适配iOS6\7\8的图片
 */
+ (UIImage *)imageWithName:(NSString *)name;

/**
 *  根据图片名返回一张能够自由拉伸的图片
 */
+ (UIImage *)resizedImage:(NSString *)name;

/**
 *  根据RGB颜色值，返回一张图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color;
/**
 *  tabBar加载最原始的图片不要渲染
 */
+ (instancetype)imageWithOriginalName:(NSString *)imageName;
/**
 *  可拉伸不变形的图片
 */
+ (instancetype)imageWithStretchableName:(NSString *)imageName;

@end
