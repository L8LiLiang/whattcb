//
//  ConfigTool.m
//  tcb
//
//  Created by Jax on 15/11/12.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import "ConfigTool.h"

#import "SSKeychain.h"

NSString *const kService = @"TcbService";
NSString *const kAccount = @"TcbAccount";

static BOOL isLogin = false;

@implementation ConfigTool


+(void)setLoginStatus:(BOOL)login
{
    isLogin = login;
}

+(BOOL)isLogin
{
    return isLogin;
}

+ (UIWindow *)lastWindow
{
    NSArray *windows = [[UIApplication sharedApplication] windows];
    for(UIWindow *window in [windows reverseObjectEnumerator]) {
        if ([window isKindOfClass:[UIWindow class]] &&
            window.windowLevel == UIWindowLevelNormal &&
            CGRectEqualToRect(window.bounds, [UIScreen mainScreen].bounds))
            return window;
    }
    
    return [UIApplication sharedApplication].keyWindow;
}

+ (void)saveUserAccount:(NSString *)account andPassword:(NSString *)password {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:account forKey:kAccount];
    [defaults synchronize];
    [SSKeychain setPassword:password forService:kService account:account];
    
}

+ (NSString *)accountName
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *account = [userDefaults objectForKey:kAccount];
    return account;
}

+ (NSArray *)getOwnAccountAndPassword {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *account = [userDefaults objectForKey:kAccount];
    NSString *password = [SSKeychain passwordForService:kService account:account];
    if (account && password && ![account isEqualToString:@""] && ![password isEqualToString:@""]) {
        return @[account, password];
    }
    return nil;
}

+ (void)deletePasswordAndUsername {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *account = [userDefaults objectForKey:kAccount];
    if (account) {
        [SSKeychain deletePasswordForService:kService account:account];
        [userDefaults setValue:@"" forKey:kAccount];
    }
}

+ (UIImage *)compressImage:(UIImage *)image toMaxFileSize:(NSInteger)maxFileSize {
    
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    if(!imageData) {
        imageData = UIImagePNGRepresentation(image);
    }
    while ([imageData length] > maxFileSize && compression > maxCompression) {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(image, compression);
    }
    
    UIImage *compressedImage = [UIImage imageWithData:imageData];
    return compressedImage;
}

@end
