//
//  FYOutVC.m
//  SUNWENTAOAPP
//
//  Created by FY on 2018/12/13.
//  Copyright © 2018年 张坤. All rights reserved.
//

#import "FYOutVC.h"

@interface FYOutVC ()
@property (weak, nonatomic) IBOutlet UIButton *loginOutBt;

@end

@implementation FYOutVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"设置";
    
    self.loginOutBt.layer.cornerRadius = 21;
    self.loginOutBt.clipsToBounds = YES;
    if ([FYSignleTool shareTool].isLogin) {
        self.loginOutBt.hidden = NO;
    }else {
        self.loginOutBt.hidden = YES;
    }
    
    
}
- (IBAction)outAction:(id)sender {
    [FYSignleTool shareTool].isLogin = NO;
    [self.navigationController popViewControllerAnimated:YES];
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
