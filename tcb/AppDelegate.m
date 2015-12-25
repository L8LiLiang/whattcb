//
//  AppDelegate.m
//  tcb
//
//  Created by Jax on 15/11/9.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import "AppDelegate.h"
#import "TCBNavigationController.h"
#import "TCBTabBarController.h"
#import "LoginViewController.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "BoxNoInputController.h"
#import "AutoSigninManager.h"

//#import "BaiduMobStat.h"

@interface AppDelegate ()
@property (strong, nonatomic) AutoSigninManager *autoSigninManager;
@property (strong, nonatomic) LoginViewController *loginController;
@end

@implementation AppDelegate

#pragma mark - 初始化百度统计
- (void)startBaiduMobStat {
//    BaiduMobStat* statTracker = [BaiduMobStat defaultStat];
//    statTracker.shortAppVersion  = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
//    // 设置在mtj网站上添加的app的appkey,此处AppId即为应用的appKey
//    [statTracker startWithAppId:BaiDuStatAppId];
}

#pragma mark - application delegate
//- (void)application:(UIApplication *)application
//didReceiveRemoteNotification:(NSDictionary *)userInfo
//fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
//    /* 在这里保存userInfo到本地文件，用于在didFinishLaunchingWithOptions方法中判断是通过点击了图标进入程序还是点击了推送进入程序 */
//    /* When we get a push, just writing it to file */
//    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    NSString *path = [document stringByAppendingPathComponent:@"push.plist"];
//    [userInfo writeToFile:path atomically:YES];
//    completionHandler(UIBackgroundFetchResultNewData);
//}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    /*--------------------------------百度统计------------------------------------*/
    [self startBaiduMobStat];
    
    
    /*-----------------------------设置窗口根控制器--------------------------------*/
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
    LoginViewController *loginController = [LoginViewController new];
    loginController.source = @"不自动登陆";
    self.loginController = loginController;
    UINavigationController *navCtrl = [[UINavigationController alloc] initWithRootViewController:loginController];
    self.window.rootViewController = navCtrl;
    

    
    [[IQKeyboardManager sharedManager] disableInViewControllerClass:[BoxNoInputController class]];
    
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
//        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge  |UIUserNotificationTypeSound |UIUserNotificationTypeAlert  categories:nil];
//        
//        [[UIApplication sharedApplication]registerUserNotificationSettings:settings];
//        
//        [[UIApplication sharedApplication] registerForRemoteNotifications];
//    }else {
//        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound)];
//    }

    /**********************************推送**********************************/
    
//    [self makeNotification:@"didFinishLaunchingWithOptions" fireDate:[NSDate dateWithTimeIntervalSinceNow:10]];
    /* 判断是通过图标进入的应用程序还是点击推送通知进入的程序 */
    NSDictionary *userInfo = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    NSLog(@"info == %@", userInfo);
    if (userInfo) {
        /* 通过点击推送启动的 */
        TCBLog(@"我是点击推送进来的");
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *newDispatch = [defaults objectForKey:@"kNewDispatch"];
        NSString *newTask = [defaults objectForKey:@"kNewTask"];
        NSString *newFee = [defaults objectForKey:@"kNewFee"];
        NSString *newNoti = [defaults objectForKey:@"kNewNoti"];
        
        NSDictionary *apsDict = [userInfo objectForKey:@"aps"];
        NSString *alert = [apsDict objectForKey:@"alert"];
        if ([alert containsString:@"新派单"]) {
            newDispatch = @"新派单";
        }
        if ([alert containsString:@"新任务"]) {
            newTask = @"新任务";
        }
        if ([alert containsString:@"新费用"]) {
            newFee = @"新费用";
        }
        if ([alert containsString:@"新通知"]) {
            newNoti = @"新通知";
        }
        [defaults setValue:newDispatch forKey:@"kNewDispatch"];
        [defaults setValue:newTask forKey:@"kNewTask"];
        [defaults setValue:newFee forKey:@"kNewFee"];
        [defaults setValue:newNoti forKey:@"kNewNoti"];
        [defaults synchronize];
        
        
        self.loginController.source = @"自动登入";

    } else {
        /* 通过点击图标启动的 */
        
        
    }
    
    self.autoSigninManager = [AutoSigninManager sharedManager];
    
    /******************************1.用户推送********************************/
    if (iOS8 || iOS9) {
        //1.创建消息上面要添加的动作(按钮的形式显示出来)
        UIMutableUserNotificationAction *action = [[UIMutableUserNotificationAction alloc] init];
        action.identifier = @"action";  //按钮的标示
        action.title= @"Accept";    //按钮的标题
        action.activationMode = UIUserNotificationActivationModeBackground ;//当点击的时候启动程序
        action.authenticationRequired = YES;
        action.destructive = YES;
        
        UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];
        action2.identifier = @"action2";
        action2.title=  @"Reject";
        action2.activationMode = UIUserNotificationActivationModeBackground | UIUserNotificationActivationModeForeground ;    //当点击的时候不启动程序，在后台处理
        action.authenticationRequired = YES;    //需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
        action.destructive = YES;
        
        //2.创建动作(按钮)的类别集合
        UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
        categorys.identifier = @"alert";//这组动作的唯一标示,推送通知的时候也是根据这个来区分
        [categorys setActions:@[action,action2] forContext:(UIUserNotificationActionContextMinimal)];
        
        //3.创建UIUserNotificationSettings，并设置消息的显示类类型
        UIUserNotificationSettings *notiSettings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIRemoteNotificationTypeSound) categories:[NSSet setWithObjects:categorys, nil]];
        [application registerUserNotificationSettings:notiSettings];
        
    }else{
        /* 该方法 在ios8 and later is not supported */
        [application registerForRemoteNotificationTypes: UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
    }
    
    return YES;
}

#pragma mark - 推送消息处理

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(nonnull UIUserNotificationSettings *)notificationSettings {
    /*****************************2.远程推送********************************/
    /* 注:消息大小不超过2KB || APNs限制了每个notification的payload最大长度是256字节，超长的消息是不能发送的 */
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"error == %@", error);
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(nonnull NSData *)deviceToken {
    /* you can see deviceToken is <0901ed35 faedff77 7734b80c 98d45813 78a9d061 aab8d6b7 349e1147 9ddf707b> */
    
    NSString *token = [NSString stringWithFormat:@"%@",deviceToken];
    token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:token forKey:@"deviceToken"];
    [defaults synchronize];
    /* 这里进行的操作，是将Device Token发送到服务端(由于服务器需要用户名，deviceToken就不在这里发送) */
    /* 7c45665ae52ef45c7228b6e7c3c18c7d2133636654b736a7c80a286b2ab510ec */
    NSLog(@"Receive DeviceToken: %@", token);
}



/* ios8才有的 */
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler {
    
}
/* ios8才有的 */
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)())completionHandler {
    NSLog(@"%@", identifier);
    if ([identifier isEqualToString:@"RickAction"]) {
        [self handleAcceptActionWithNotification:notification];
    }
    completionHandler();
}
- (void)handleAcceptActionWithNotification:(UILocalNotification*)notification {
    
}
/* ios3就有了 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo  {
//    if (application.applicationState == UIApplicationStateActive) {
        // 转换成一个本地通知，显示到通知栏，你也可以直接显示出一个alertView，只是那样稍显aggressive：）
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.userInfo = userInfo;
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        localNotification.alertBody = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
        localNotification.fireDate = [NSDate date];
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
//    } else {
    
//    }
    
    NSLog(@"%@", userInfo);
//    {
//    aps:{
//    alert:Your message Here
//    }
//    }

    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *newDispatch = [defaults objectForKey:@"kNewDispatch"];
    NSString *newTask = [defaults objectForKey:@"kNewTask"];
    NSString *newFee = [defaults objectForKey:@"kNewFee"];
    NSString *newNoti = [defaults objectForKey:@"kNewNoti"];
    
    NSDictionary *apsDict = [userInfo objectForKey:@"aps"];
    NSString *alert = [apsDict objectForKey:@"alert"];
    if ([alert containsString:@"新派单"]) {
        newDispatch = @"新派单";
    } 
    if ([alert containsString:@"新任务"]) {
        newTask = @"新任务";
    }
    if ([alert containsString:@"新费用"]) {
        newFee = @"新费用";
    }
    if ([alert containsString:@"新通知"]) {
        newNoti = @"新通知";
    }
    [defaults setValue:newDispatch forKey:@"kNewDispatch"];
    [defaults setValue:newTask forKey:@"kNewTask"];
    [defaults setValue:newFee forKey:@"kNewFee"];
    [defaults setValue:newNoti forKey:@"kNewNoti"];
    [defaults synchronize];
    
    self.loginController.source = @"不自动登入";
}


#pragma mark -
- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
   
}

- (void)applicationWillTerminate:(UIApplication *)application {
   
}

- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier
  completionHandler:(void (^)())completionHandler
{
    self.backgroundSessionCompletionHandler = completionHandler;
}

-(void)makeNotification:(NSString *)content fireDate:(NSDate *)date
{
    //1.创建本地通知
    UILocalNotification *local = [[UILocalNotification alloc]init];
    
    // 5秒之后触发一个本地通知
    if (date) {
        
        local.fireDate = date;
    }
    
    local.alertBody = content;
    
    local.soundName = @"UILocalNotificationDefaultSoundName";
    
    //    local.alertLaunchImage = @"ic_sound";
    
    //local.applicationIconBadgeNumber = 10;
    
    local.hasAction = YES;
    
    local.alertAction = @"show l8 app";
    
    local.userInfo = @{@"name" : @"李亮" , @"QQ":@"222",@"info":@"信息!"};
    //2.定制通知
    //[[UIApplication sharedApplication]scheduleLocalNotification:local];
    
    //取消所有
    //[[UIApplication sharedApplication]cancelAllLocalNotifications];
    //立即推送通知
    if (date) {
        [[UIApplication sharedApplication]scheduleLocalNotification:local];
    }else {
        [[UIApplication sharedApplication]presentLocalNotificationNow:local];
    }
}


@end
