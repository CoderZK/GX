//
//  AppDelegate.m
//  Shop
//
//  Created by 朱啸 on 2018/4/11.
//  Copyright © 2018年 朱啸. All rights reserved.
//

#import "AppDelegate.h"
#import "TabBarController.h"
#import "FYHomeVC.h"
//import <UMSocialCore/UMSocialCore.h>
#import <UShareUI/UShareUI.h>
#import "UMessage.h"
//#import "ViewController.h"
#import <WXApi.h>
//#import <AlipaySDK/AlipaySDK.h>
#import <UserNotifications/UserNotifications.h>
//推送
#define UMKey @"5ba076ecf1f5563fef000179"
//友盟安全密钥//quvss8rcpv3jahqyajgeuspa6o1vdeqr
#define SinaAppKey @"102135063"
#define SinaAppSecret @"47a31952aed883dc13cdccaf9b30df0d"
#define QQAppID @"101504727"
#define QQAppKey @"2e7928e5d1e2974eb06a35fa408e0950"
#define WXAppID @"wxcb65aa46d04ad49b"
#define WXAppSecret @"e44bf1d172e7b6a4638e8ecc63bb80e1"



@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];

    [[UMSocialManager defaultManager] setUmSocialAppkey:UMKey];
    
    [self configUSharePlatforms];
    [self initUment:launchOptions];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    NSString *userAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    NSString *newUserAgent = [userAgent stringByAppendingString:@"/kyhios/CK 2.0"];//自定义需要拼接的字符串
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:newUserAgent, @"UserAgent", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
    
    FYHomeVC * vc = [[FYHomeVC alloc] init];
    self.window.rootViewController = vc;
    [self.window makeKeyAndVisible];
    
    [self updateApp];
    
    return YES;
}

- (void)configUSharePlatforms
{
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:WXAppID appSecret:WXAppSecret redirectURL:@"http://mobile.umeng.com/social"];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:QQAppID/*设置QQ平台的appID*/  appSecret:QQAppKey redirectURL:@"http://mobile.umeng.com/social"];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:SinaAppKey  appSecret:SinaAppSecret redirectURL:@"https://sns.whalecloud.com/sina2/callback"];
}

- (void)initUment:(NSDictionary *)launchOptions{
    [UMessage startWithAppkey:UMKey launchOptions:launchOptions httpsEnable:YES];
    [UMessage registerForRemoteNotifications];
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate=self;
    UNAuthorizationOptions types10=UNAuthorizationOptionBadge|  UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:types10     completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            //点击允许
            //这里可以添加一些自己的逻辑
        } else {
            //点击不允许
            //这里可以添加一些自己的逻辑
        }
    }];
    [UMessage setBadgeClear:NO];
    //打开日志，方便调试
    [UMessage setLogEnabled:YES];
}


//在用户接受推送通知后系统会调用
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [UMessage registerDeviceToken:deviceToken];
    //2.获取到deviceToken
    NSString *token = [[[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] stringByReplacingOccurrencesOfString:@" " withString:@""];
    //将deviceToken给后台
    NSLog(@"send_token:%@",token);
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //    [zkSignleTool shareTool].deviceToken = token;
    //    if ([zkSignleTool shareTool].isLogin) {
    //        [[zkSignleTool shareTool] uploadDeviceTokenWith:[zkSignleTool shareTool].deviceToken];
    //    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         FYHomeVC* vc = (FYHomeVC *)self.window.rootViewController;
        [vc.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"updateiosdevice('%@');",token]];
    });
}


//iOS10以下使用这个方法接收通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
    [UMessage didReceiveRemoteNotification:userInfo];
    
    NSLog(@"10一下::: === %@",userInfo);
    
    
    
    //        self.userInfo = userInfo;
    //定制自定的的弹出框
    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
    {
        //        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"标题"
        //                                                            message:@"Test On ApplicationStateActive"
        //                                                           delegate:self
        //                                                  cancelButtonTitle:@"确定"
        //                                                  otherButtonTitles:nil];
        //
        //        [alertView show];
        
    }
}

//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler API_AVAILABLE(ios(10.0)){
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时的远程推送接受
        //关闭U-Push自带的弹出框
        [UMessage setAutoAlert:NO];
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
        [self goUrlWithDict:userInfo];
        
    }else{
        //应用处于后台台时的本地推送接受
    }
    //当应用处于前台时提示设置，需要哪个可以设置哪一个
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}

//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler API_AVAILABLE(ios(10.0)){
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前后台时的远程推送接受
        [UMessage setAutoAlert:NO];
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
        [self goUrlWithDict:userInfo];
        
    }else{
        //应用处于后台时的本地推送接受
        
        
        
    }
}


- (void)goUrlWithDict:(NSDictionary *)dict {
    
    if ([dict.allKeys containsObject:@"ao"] && [[NSString stringWithFormat:@"%@",dict[@"ao"]] isEqualToString:@"go_url"]) {
        
        FYHomeVC * vc = (FYHomeVC *)self.window.rootViewController;
        [vc.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:dict[@"ul"]]]];
        
    }
    
}



- (void)updateApp {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@",@"1445514961"]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request
                                     completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                         
                                         if (data)
                                         {
                                             NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                                             
                                             if (dic)
                                             {
                                                 NSArray * arr = [dic objectForKey:@"results"];
                                                 if (arr.count>0)
                                                 {
                                                     NSDictionary * versionDict = arr.firstObject;
                                                     
                                                     //服务器版本
                                                     NSString * version = [[versionDict objectForKey:@"version"] stringByReplacingOccurrencesOfString:@"." withString:@""];
                                                     //当前版本
                                                     NSString * currentVersion = [[[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleShortVersionString"] stringByReplacingOccurrencesOfString:@"." withString:@""];
                                                    
                                                     
                                                   
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                         
                                                         if ([version integerValue] < [currentVersion integerValue]) {
                                                             TabBarController *tabbar = [[TabBarController alloc] init];
                                                             self.window.rootViewController = tabbar;
                                                             [self.window makeKeyAndVisible];
                                                         }else {
                                                             FYHomeVC * vc = [[FYHomeVC alloc] init];
                                                             self.window.rootViewController = vc;
                                                             [self.window makeKeyAndVisible];
                                                         }
                                                        
                                                         
                                                     });
                                                  
                                                    
                                                     
//                                                     if ([version integerValue]>[currentVersion integerValue])
//                                                     {
//                                                         NSString * str=[versionDict objectForKey:@"releaseNotes"];
//
//                                                         UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"发现新版本" message:str preferredStyle:UIAlertControllerStyleAlert];
//                                                         UIView *subView1 = alert.view.subviews[0];
//                                                         UIView *subView2 = subView1.subviews[0];
//                                                         UIView *subView3 = subView2.subviews[0];
//                                                         UIView *subView4 = subView3.subviews[0];
//                                                         UIView *subView5 = subView4.subviews[0];
//                                                         UILabel *message = subView5.subviews[1];
//                                                         message.textAlignment = NSTextAlignmentCenter;
//
//                                                         [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil]];
//                                                         [alert addAction:[UIAlertAction actionWithTitle:@"去更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//                                                             [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/cn/app/id%@?mt=8",@"1435758559"]]];
//                                                             exit(0);
//
//                                                         }]];
//                                                         [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
//                                                     }
                                                     
                                                     
                                                 }
                                             }
                                         }
                                     }] resume];
    
    
}




- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
