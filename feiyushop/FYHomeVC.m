//
//  FYHomeVC.m
//  feiyushop
//
//  Created by FY on 2019/2/27.
//  Copyright © 2019年 张坤. All rights reserved.
//

#import "FYHomeVC.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "UIView+KKEB.h"
#import <SVProgressHUD.h>
#import <UMSocialCore/UMSocialCore.h>
#import <UShareUI/UShareUI.h>
#import <AddressBook/AddressBook.h>
#import "FYLinkModel.h"
#import <Contacts/Contacts.h>



#define SSSSBarH [UIApplication sharedApplication].statusBarFrame.size.height
#define HHHHHH [UIScreen mainScreen].bounds.size.height
#define WWWWW [UIScreen mainScreen].bounds.size.width
//#define  URLURL @"http://gzh.dkyapp.com/app/index.php?i=2&c=entry&m=ewei_shopv2&do=mobile&r=diypage&id=5&tp=1"

//#define  URLURL @"http://gzh.dkyapp.com/app/index.php?i=2&c=entry&m=ewei_shopv2&do=mobile&r=diypage&id=5"

#define  URLURL @"http://www.gxpt168.com/app/index.php?i=15&c=entry&m=ewei_shopv2&do=mobile"


@interface FYHomeVC ()<UIWebViewDelegate>
@property (nonatomic,weak) JSContext * context;
@property(nonatomic,strong)UIButton *settingBt;
@property(nonatomic,strong)UIView *backV;
@property(nonatomic,strong)NSArray *dataArray;
@end

@implementation FYHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    UIWebView * web =[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, WWWWW, HHHHHH)];
    [self.view addSubview: web];
    self.view.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
    web.delegate = self;
    web.backgroundColor = [UIColor whiteColor];
    [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:URLURL]]];
    web.scrollView.bounces = NO;
    web.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
    //    web.backgroundColor =[UIColor redColor];
    self.backV = [[UIView alloc] initWithFrame:CGRectMake(WWWWW - 60 - 10, HHHHHH  - 15 - 60 - 49 - 120 , 60, 180)];
    if (SSSSBarH > 20) {
        self.backV.frame = CGRectMake(WWWWW - 60 - 10, HHHHHH  - 34 - 15 - 60 - 49 - 120 , 70, 180);
        web.frame = CGRectMake(0, SSSSBarH, WWWWW, HHHHHH - SSSSBarH - 34);
    }
    [self.view addSubview:self.backV];
    UIImageView * imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    imageV.userInteractionEnabled = YES;
    imageV.image = [UIImage imageNamed:@"kk_zuoyou"];
    [self.backV addSubview:imageV];
    UIPanGestureRecognizer * sg = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(backPan:)];
    [imageV addGestureRecognizer:sg];
    self.webView = web;
    for (int i = 0 ; i < 2 ; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake( 0 , 60 * i + 60 , 60, 60);
        button.tag = i;
        [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"kk_%d",i]] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.backV addSubview:button];
    }
}

-(void)doSwipe:(UISwipeGestureRecognizer *)sender{
    CGPoint point = [sender locationInView:self.view];
    NSLog(@"%@",NSStringFromCGPoint(point));
    if (point.x > ([UIScreen mainScreen].bounds.size.width/2.0) + 40 && point.x < [UIScreen mainScreen].bounds.size.width - 40 - 15){
        self.settingBt.frame = CGRectMake(point.x, SSSSBarH + 2 , 40 , 40);
    }
}

-(void)backPan:(UISwipeGestureRecognizer *)sender{
    CGPoint point = [sender locationInView:self.view];
    CGPoint point2 = [sender locationInView:self.backV];
    NSLog(@"%@",NSStringFromCGPoint(point));
    NSLog(@"===\n%@",NSStringFromCGPoint(point2));
    CGFloat x = 0;
    CGFloat y = 0;
    if (point.x < 0) {
        x = 0;
    }else if (point.x > [UIScreen mainScreen].bounds.size.width - 60) {
        x = [UIScreen mainScreen].bounds.size.width - 60;
    }else {
        x = point.x;
    }
    
    if (point.y < SSSSBarH + 44) {
        y = SSSSBarH + 44;
    }else if (point.y > HHHHHH - 49  - 180) {
        y = HHHHHH - 49 - 180;
    }else {
        y = point.y;
    }
    self.backV.x = x;
    self.backV.y = y;
}

- (void)swipeGes:(UISwipeGestureRecognizer *)swipeGes {
    CGPoint point = [swipeGes locationInView:self.view];
    NSLog(@"%@",NSStringFromCGPoint(point));
    if (( point.x > 0 && point.x < [UIScreen mainScreen].bounds.size.width - 60) && (point.y > (SSSSBarH + 44) && point.y < HHHHHH - 49 - 34 - 180)){
        self.backV.frame = CGRectMake(point.x, point.y , 70 , 180);
    }
}

- (void)clickAction:(UIButton *)button {
    if (button.tag == 0) {
        if([self.webView canGoBack]) {
            [self.webView goBack];
        }
    }else if (button.tag == 1) {
//        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:URLURL]]];
        [self fetchAddressBookOnIOS9AndLater];
        NSDictionary * dict = @{@"code":@(1),@"data":[self.dataArray subarrayWithRange:NSMakeRange(0, 6)]};
        NSString * atrr =  [self convertToJsonDataWithDict:dict];
        NSLog(@"\n====%@",atrr);

    }
}

- (void)fetchAddressBookOnIOS9AndLater{
    //创建CNContactStore对象
    CNContactStore *contactStore = [[CNContactStore alloc] init];
    //首次访问需用户授权
    if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusNotDetermined) {//首次访问通讯录
        [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (!error){
                if (granted) {//允许
                    NSLog(@"已授权访问通讯录");
                    self.dataArray = [self fetchContactWithContactStore:contactStore];//访问通讯录
                   
                }else{//拒绝
                    NSLog(@"拒绝访问通讯录");
                   
                }
            }else{
                NSLog(@"发生错误!");
            }
        }];
    }else{//非首次访问通讯录
        self.dataArray = [self fetchContactWithContactStore:contactStore];//访问通讯录
     
    }
}

-(NSString *)convertToJsonDataWithDict:(id)dict

{
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    
    if (!jsonData) {
        
        NSLog(@"%@",error);
        
    }else{
        
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    return mutStr;
    
}

- (NSMutableArray *)fetchContactWithContactStore:(CNContactStore *)contactStore{
    //判断访问权限
    if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusAuthorized) {//有权限访问
        NSError *error = nil;
        //创建数组,必须遵守CNKeyDescriptor协议,放入相应的字符串常量来获取对应的联系人信息
        NSArray <id<CNKeyDescriptor>> *keysToFetch = @[CNContactFamilyNameKey, CNContactGivenNameKey, CNContactPhoneNumbersKey];
        //获取通讯录数组
        NSArray<CNContact*> *arr = [contactStore unifiedContactsMatchingPredicate:nil keysToFetch:keysToFetch error:&error];
        if (!error) {
            NSMutableArray *contacts = [NSMutableArray array];
            for (int i = 0; i < arr.count; i++) {
                CNContact *contact = arr[i];
                NSString *givenName = contact.givenName;
                NSString *familyName = contact.familyName;
                
                for (int i = 0 ; i < contact.phoneNumbers.count; i++) {
                     NSString *phoneNumber = ((CNPhoneNumber *)(contact.phoneNumbers[i].value)).stringValue;
                    NSMutableDictionary * dict = @{}.mutableCopy;
                    dict[@"name"] = [givenName stringByAppendingString:familyName];
                    dict[@"telPhone"] = phoneNumber;
                    [contacts insertObject:dict atIndex:0];
                }
                
               
               
               
            }
            return contacts;
        }else {
            return nil;
        }
    }else{//无权限访问
        NSLog(@"无权限访问通讯录");
        return nil;
    }
}





- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSLog(@"开始响应请求时触发");
    NSDictionary *headers = [request allHTTPHeaderFields];
    
    BOOL hasReferer = [headers objectForKey:@"Referer"] != nil;
    if (hasReferer) {
        
        // .. is this my referer?
        //        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //            dispatch_async(dispatch_get_main_queue(), ^{
        //                NSURL *url = [request URL];
        //                NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        //                [request setHTTPMethod:@"GET"];
        //                [request setValue:@"m.aidatouli.com://" forHTTPHeaderField: @"Referer"];
        //                [self.webView loadRequest:request];
        //            });
        //        });
        return YES;
    } else {
        // relaunch with a modified request
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSURL *url = [request URL];
                NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
                [request setHTTPMethod:@"GET"];
                [request setValue:@"m.aidatouli.com://" forHTTPHeaderField: @"Referer"];
                [self.webView loadRequest:request];
            });
        });
        return NO;
    }
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    NSLog(@"开始加载网页");
//    [SVProgressHUD show];
}
//JS 调用OC 方法并且传参,要你管啊 你想也不想啊 干啥的额

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    NSURL *url = webView.request.URL;
    NSString *scheme = [url scheme];
    if (![scheme isEqualToString:@"https"] && ![scheme isEqualToString:@"http"]) {
        [[UIApplication sharedApplication] openURL:url];
    }
    
    
    NSLog(@"%@",@"网页加载王城");
    //获取JS运行环境
    _context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    //html 调用无惨OC
    _context[@"devicetoken"] =^() {
        return [[NSUserDefaults standardUserDefaults] valueForKey:@"token"];
    };
    __weak typeof(self) weakSelf = self;
    _context[@"shareAction"] = ^() {
        NSArray * arr = [JSContext currentArguments];
        [weakSelf shareWithSetPreDefinePlatforms:nil withArr:arr];
    };
    
    _context[@"addresslist"] = ^() {
        
        [self fetchAddressBookOnIOS9AndLater];
        
        if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusAuthorized) {
            //允许访问
            NSDictionary * dict = @{@"code":@(1),@"data":[self.dataArray subarrayWithRange:NSMakeRange(0, 6)]};
            return [weakSelf convertToJsonDataWithDict:dict];
        }else {
            //不允许访问
            NSDictionary * dict = @{@"code":@(-1),@"data":@[]};
            return [weakSelf convertToJsonDataWithDict:dict];
        }
    };
    
    _context[@"copyURLURL"] = ^(){
        NSArray * arr = [JSContext currentArguments];
        
        if (arr.count > 0) {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = [NSString stringWithFormat:@"%@",arr[0]];
            [SVProgressHUD showSuccessWithStatus:@"复制成功"];
        }
    };
    
//    [SVProgressHUD dismiss];
    _context[@"copyURLURL666"] = ^(){
        [SVProgressHUD showErrorWithStatus:@"你点错了啊"];
    };
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if (error) {
        NSLog(@"\nerror === %@",error.description);
    }
}

- (void)getMessage:(NSString *)str {
    NSLog(@"%@",str);
}

#pragma 供JS调用的方法
-(void)menthod1{
    NSLog(@"JS调用了无参数OC方法");
}
-(void)menthod2:(NSString *)str1 and:(NSString *)str2{
    NSLog(@"%@%@",str1,str2);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma OC调用JS方法
-(void)function1{
    [_webView stringByEvaluatingJavaScriptFromString:@"aaa()"];
}
-(void)function2{
    NSString * name = @"pheromone";
    NSInteger num = 520;//准备传去给JS的参数
    [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"bbb('%@','%ld');",name,num]];
}

- (void)shareWithSetPreDefinePlatforms:(NSArray *)platforms withArr:(NSArray *)arr {
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_Sina),@(UMSocialPlatformType_QQ)]];
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        [self shareImageAndTextToPlatformType:platformType withArr:arr];
    }];
}


//分享
- (void)shareImageAndTextToPlatformType:(UMSocialPlatformType)platformType withArr:(NSArray *)arr
{
    NSString * url = @"";
    NSString *title = @"卡有汇";
    NSString * logoStr = @"";
    NSString *descStr = @"最好的app等你来玩!";
    if (arr.count > 0) {
        title = [NSString stringWithFormat:@"%@",arr[0]];
    }
    if (arr.count > 1) {
        descStr = [NSString stringWithFormat:@"%@",arr[1]];
    }
    if (arr.count > 2) {
        logoStr = [NSString stringWithFormat:@"%@",arr[2]];
    }
    if (arr.count > 3) {
        url = [NSString stringWithFormat:@"%@",arr[3]];
    }
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    if ([url hasSuffix:@".jpg"] || [url hasSuffix:@".JPG"] || [url hasSuffix:@".jpeg"] || [url hasSuffix:@".JPEG"] || [url hasSuffix:@".gif"] || [url hasSuffix:@".GIF"] || [url hasSuffix:@".png"]|| [url hasSuffix:@".PNG"] || [url hasSuffix:@".bmp"] || [url hasSuffix:@".BMP"]) {
        //设置文本
        messageObject.text = @"社会化组件UShare将各大社交平台接入您的应用，快速武装App。";
        //创建图片内容对象
        UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
        //如果有缩略图，则设置缩略图
        if (logoStr.length == 0 || [logoStr isEqualToString:@"(null)"] || [logoStr isEqualToString:@"<null>"] || [logoStr isEqualToString:@"[object Object]"]) {
            shareObject.thumbImage = [UIImage imageNamed:@"logo"];
        }else {
            shareObject.thumbImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:logoStr]]];;
        }
        UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
        [shareObject setShareImage:image];
        messageObject.shareObject = shareObject;
    }else {
        //创建网页内容对象
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:descStr thumImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:logoStr]]]];
        if (logoStr.length == 0 || [logoStr isEqualToString:@"(null)"] || [logoStr isEqualToString:@"<null>"] ) {
            shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:descStr thumImage:[UIImage imageNamed:@"logo"]];
        }
        //设置网页地址
        shareObject.webpageUrl =url;
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
    }
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            NSLog(@"response data is %@",data);
        }
    }];
}




@end

