//
//  MacroDefine.h
//  tcb
//
//  Created by Jax on 15/11/9.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConfigTool.h"

@interface MacroDefine : NSObject

// 适配当前设备系统iOS7、iOS8、当前屏幕的宽高、当前app版本、当前窗口、当前设备
#define iOS9         ([[UIDevice currentDevice].systemVersion doubleValue] >= 9.0f)
#define iOS8         ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0f && [[UIDevice currentDevice].systemVersion doubleValue] < 9.0f)
#define iOS7         ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0f && [[UIDevice currentDevice].systemVersion doubleValue] < 8.0f)
#define SCREEN_WIDTH  ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define AppVersion   [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define iPhone4      (SCREEN_HEIGHT == 480.f)
#define iPhone5      (SCREEN_HEIGHT == 568.f)
#define iPhone6      (SCREEN_HEIGHT == 667.f)
#define iPhone6plus  (SCREEN_HEIGHT == 736.f)

// 调试状态, 打开LOG功能
#ifdef DEBUG
#define TCBLog(...) NSLog(__VA_ARGS__)
#else
// 发布状态, 关闭LOG功能
#define TCBLog(...)
#endif

//  RGB
#define kDefaultBarButtonItemColor [UIColor colorWithRed:0 green:0.478431 blue:1 alpha:1]
#define kRGBA(r, g, b, a) [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:(a) / 255.0]
#define kRGB(r, g, b) kRGBA(r, g, b, 255)

#define kLCLightGreenColor kRGB((184.0/255.0), (233.0/255.0), (122.0/255.0))
#define kLCGreenColor kRGB((0.0/255.0), (204.0/255.0), (134.0/255.0))

#define kLastWindow [ConfigTool lastWindow]

#define BaiDuStatAppId @"1234567890"

#define ThemeColor [UIColor colorWithRed:235.0/255 green:235.0/255 blue:243.0/255 alpha:1.0]

@end
