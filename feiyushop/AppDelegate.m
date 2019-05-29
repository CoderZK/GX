//
//  AppDelegate.m
//  feiyushop
//
//  Created by FY on 2019/2/27.
//  Copyright © 2019年 张坤. All rights reserved.
//

#import "AppDelegate.h"
#import "FYHomeVC.h"
#import "TabBarController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UIViewController * vc = [[FYHomeVC alloc] init];
    self.window.backgroundColor = [UIColor blackColor];
    self.window.rootViewController = vc;
//    [self updateApp];
    return YES;
}

- (void)updateApp {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@",@"1455057374"]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request
                                     completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                         
                                         if (data)
                                         {
                                             NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                                             
                                             if (dic)
                                             {
                                                 
                                                 if ([[NSString stringWithFormat:@"%@",dic[@"resultCount"]] integerValue] == 0) {
                                                     //未上架
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                         TabBarController *tabbar = [[TabBarController alloc] init];
                                                         self.window.rootViewController = tabbar;
                                                         [self.window makeKeyAndVisible];
                                                     });
                                                     return ;
                                                 }
                                                 
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
