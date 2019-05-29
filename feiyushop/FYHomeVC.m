//
//  FYHomeVC.m
//  feiyushop
//
//  Created by FY on 2019/2/27.
//  Copyright © 2019年 张坤. All rights reserved.
//

#import "FYHomeVC.h"
#import "FYShopVC.h"
#import "FYCarVC.h"
#import "FYMineVC.h"
#import <WebKit/WebKit.h>
#define FYSSH [[UIApplication sharedApplication] statusBarFrame].size.height
#define FYNaviH  44
#define FYScreenW [UIScreen mainScreen].bounds.size.width
#define FYScreenH [UIScreen mainScreen].bounds.size.height
#define FYURL  @"http://new.ganzheapp.com/"
#import <JavaScriptCore/JavaScriptCore.h>
@interface FYHomeVC ()
@property (nonatomic,weak) JSContext * context;
@property(nonatomic,strong)FYShopVC *shopVC;
@property(nonatomic,strong)UIButton *settingBt;
@property(nonatomic,strong)UIView *backV;
@property(nonatomic,strong)FYCarVC *carVC;
@property(nonatomic,strong)FYMineVC *mineVC;
@end

@implementation FYHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    self.shopVC = [[FYShopVC alloc] init];
    self.shopVC.view.backgroundColor = [UIColor redColor];
    
    self.carVC = [[FYCarVC alloc] init];
    self.carVC.view.backgroundColor = [UIColor greenColor];
    
    
    self.mineVC = [[FYMineVC alloc] init];
    self.mineVC.view.layer.borderColor = [UIColor redColor].CGColor;
    
    WKWebView * web = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, FYScreenW, FYScreenH)];
    [self.view addSubview: web];
    web.scrollView.backgroundColor =[UIColor blackColor];
    [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:FYURL]]];
    web.scrollView.bounces = NO;
    web.backgroundColor = [UIColor blackColor];
    if (FYSSH > 20) {
        self.backV.frame = CGRectMake(FYScreenW - 60 - 10, FYScreenH  - 34 - 15 - 60 - 49 - 120 , 70, 180);
        web.frame = CGRectMake(0, FYSSH, FYScreenW, FYScreenH - FYSSH - 34);
    }
    
    UIView * vv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, FYSSH)];
    vv.backgroundColor =[UIColor blackColor];
    [self.view addSubview:vv];
    
    
//    UIWebView * web =[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, FYScreenW, FYScreenH)];
//    [self.view addSubview: web];
//    self.view.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
//    web.backgroundColor = [UIColor whiteColor];
//
//    [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:FYURL]]];
//    web.scrollView.bounces = NO;
//    web.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
//    if (FYSSH > 20) {
//        self.backV.frame = CGRectMake(FYScreenW - 60 - 10, FYScreenH  - 34 - 15 - 60 - 49 - 120 , 70, 180);
//        web.frame = CGRectMake(0, FYSSH, FYScreenW, FYScreenH - FYSSH - 34);
//    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
