//
//  BaseNavigationController.m
//  kunzhang_learnkunzhang海食汇
//
//  Created by kunzhang on 16/10/13.
//  Copyright © 2016年 cznuowang. All rights reserved.
//

#import "BaseNavigationController.h"
#import "BaseTableViewController.h"

@implementation BaseNavigationController
-(void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"zk_nav"] forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:18]};
    self.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.childViewControllers.count > 0) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"kk_back"] forState:(UIControlStateNormal)];
        [button setImage:[UIImage imageNamed:@"kk_back"] forState:(UIControlStateHighlighted)];
        CGRect frame = CGRectMake(0, 0, 25, 25);
        button.frame = frame;
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        button.contentEdgeInsets = UIEdgeInsetsMake(0,0, 0, 0);
        
        [button setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [button setTitleColor:[UIColor redColor] forState:(UIControlStateHighlighted)];
        [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width = -15;  //偏移距离  -向左偏移, +向右偏移
        viewController.navigationItem.leftBarButtonItems = @[negativeSpacer, [[UIBarButtonItem alloc] initWithCustomView:button]];
 
    }
    [super pushViewController:viewController animated:YES];
}


- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [viewController viewWillAppear:animated];
}

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [viewController viewDidAppear:animated];
}


- (void)back {
    
    [self popViewControllerAnimated:YES];
    
}


@end
