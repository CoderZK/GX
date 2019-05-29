//
//  NewsVC.m
//  SUNWENTAOAPP
//
//  Created by FY on 2018/12/8.
//  Copyright © 2018年 张坤. All rights reserved.
//

#import "NewsVC.h"
#import "FYLoginVC.h"
#import "FYNewsCell.h"
#import "FYHomeModel.h"

@interface NewsVC()
@property(nonatomic,strong)NSMutableArray<FYHomeModel *> *dataArray;

@end


@implementation NewsVC

- (NSMutableArray<FYHomeModel *> *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

  
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"FYNewsCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.navigationItem.title = @"我的消息";
    [self getData];
    
}

- (void)getData {
    
    NSString * sql = [NSString stringWithFormat:@"select *from kk_news where name = '%@'",[FYSignleTool shareTool].session_uid];
    FMDatabase * db = [FMDBSingle shareFMDB].fd;
    BOOL isOpen = [db open];
    if (isOpen) {
        FMResultSet * result = [db executeQuery:sql];
        while ([result next]) {
            FYHomeModel * model = [[FYHomeModel alloc] init];
            model.title = [result stringForColumn:@"name"];
            model.content = [result stringForColumn:@"content"];
            [self.dataArray addObject:model];
        }
        [self.tableView reloadData];
        
    }else {
        [SVProgressHUD showErrorWithStatus:@"数据异常请稍后再试"];
    }
    
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FYNewsCell * cell =[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.titleLB.text = self.dataArray[indexPath.row].title;
    cell.contentLB.text = self.dataArray[indexPath.row].content;
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
