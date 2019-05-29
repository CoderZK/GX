//
//  FYMineGouWuListTVC.m
//  SUNWENTAOAPP
//
//  Created by FY on 2018/12/20.
//  Copyright © 2018年 张坤. All rights reserved.
//

#import "FYMineGouWuListTVC.h"
#import "FYHomeModel.h"
#import "FYMyCarCell.h"
#import "FYGoodDetailTVC.h"
@interface FYMineGouWuListTVC ()
@property(nonatomic , strong)NSMutableArray<FYHomeModel *> *dataArray;
@end

@implementation FYMineGouWuListTVC

-(NSMutableArray<FYHomeModel *> *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的购物记录";
    [self.tableView registerNib:[UINib nibWithNibName:@"FYMyCarCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
   
    [self getData];
}

- (void)getData {
    
    NSString * sql = [NSString stringWithFormat:@"select *from kk_mygoodscar where userName = '%@' and status = 1",[FYSignleTool shareTool].session_uid];
    
    FMDatabase * db = [FMDBSingle shareFMDB].fd;
    if ([db open]) {
        FMResultSet * result = [db executeQuery:sql];
        [self.dataArray removeAllObjects];
        while ([result next]) {
            
            FYHomeModel * model = [[FYHomeModel alloc] init];
            model.ID = [result intForColumn:@"ID"];
            model.goodId = [result stringForColumn:@"goodId"];
            model.desTwo = [result stringForColumn:@"desTwo"];
            model.title = [result stringForColumn:@"des"];
            model.number = [result intForColumn:@"number"];
            model.price = [result doubleForColumn:@"price"];
            [self.dataArray addObject:model];
        }
    }
    [db close];
    [self.tableView reloadData];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FYMyCarCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    // cell.nameLB.text = @"fgkodkgfeoprkgkp";
    cell.btW.constant = 0;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLB.text = self.dataArray[indexPath.row].title;
    cell.contentLB.text = self.dataArray[indexPath.row].des;
    cell.moneyLB.text =  [NSString stringWithFormat:@"￥%.2f",self.dataArray[indexPath.row].price];
    if (self.dataArray[indexPath.row].isSelect) {
        [cell.bt setBackgroundImage:[UIImage imageNamed:@"FY_xuanzhong"] forState:UIControlStateNormal];
    }else {
        [cell.bt setBackgroundImage:[UIImage imageNamed:@"FY_weixuanzhong"] forState:UIControlStateNormal];
    }
    cell.imgV.image = [UIImage imageNamed: [NSString stringWithFormat:@"k%@",self.dataArray[indexPath.row].goodId]];
    cell.numberLB.text =  [NSString stringWithFormat:@"数量:%ld",self.dataArray[indexPath.row].number];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    FYHomeModel * model = self.dataArray[indexPath.row];
    
    FYGoodDetailTVC * vc =[[FYGoodDetailTVC alloc] init];
    vc.index = indexPath.row;
    vc.hidesBottomBarWhenPushed = YES;
    model.ID = [model.goodId integerValue];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
    
}



@end
