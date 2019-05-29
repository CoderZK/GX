//
//  FYGoodDetailTVC.h
//  SUNWENTAOAPP
//
//  Created by FY on 2018/12/13.
//  Copyright © 2018年 张坤. All rights reserved.
//

#import "BaseTableViewController.h"
#import "FYHomeModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface FYGoodDetailTVC : BaseTableViewController
@property(nonatomic,strong)FYHomeModel *model;
/**  */
@property(nonatomic , assign)NSInteger  index;
@end

NS_ASSUME_NONNULL_END
