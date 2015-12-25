//
//  ConfigTool.h
//  tcb
//
//  Created by Jax on 15/11/12.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConfigTool : NSObject


/**
 *  获取最上面的那个窗口
 *
 *  @return 获取最上面的那个窗口
 */
+ (UIWindow *)lastWindow;

/**
 *  存取账号和密码
 *
 *  @param account  account
 *  @param password password
 */
+ (void)saveUserAccount:(NSString *)account andPassword:(NSString *)password;
+ (NSArray *)getOwnAccountAndPassword;
+ (void)deletePasswordAndUsername;
/**
 *  压缩图片
 *
 *  @param image       图片
 *  @param maxFileSize 图片压缩后的最大大小
 *
 *  @return 返回压缩后的图片
 */
+ (UIImage *)compressImage:(UIImage *)image toMaxFileSize:(NSInteger)maxFileSize;


+ (BOOL)isLogin;
+ (void)setLoginStatus:(BOOL)login;
+ (NSString *)accountName;

@end
