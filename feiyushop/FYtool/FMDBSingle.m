//
//  FMDBSingle.m
//  FMDB
//
//  Created by FY on 2018/10/23.
//  Copyright © 2018年 张坤. All rights reserved.
//

#import "FMDBSingle.h"

@interface FMDBSingle()
@end
@implementation FMDBSingle
+ (FMDBSingle *)shareFMDB {
    static FMDBSingle * single = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        single = [[FMDBSingle alloc] init];
    });
    return single;
}
- (FMDatabase *)fd {
    
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [documentPath stringByAppendingPathComponent:@"GGG.db"];
    NSString *filePathTwo = [[NSBundle mainBundle] pathForResource:@"GGG" ofType:@"db"];
    NSFileManager * fileManger = [NSFileManager defaultManager];
    NSError * error;
    
    if ([fileManger fileExistsAtPath:filePath] == NO) {
        BOOL isOK = [fileManger copyItemAtPath:filePathTwo toPath:filePath error:&error];
        if (isOK) {
            NSLog(@"%@",@"复制成功\n\n\n");
        }else {
            NSLog(@"%@",@"复制失败\n\n\n");
        }
    }else {
//        if ([fileManger fileExistsAtPath:filePathTwo] == NO) {
//            BOOL isOK = [fileManger copyItemAtPath:filePath toPath:res error:&error];
//            if (isOK) {
//                NSLog(@"%@",@"复制成功\n\n\n");
//            }else {
//                NSLog(@"%@",@"复制失败\n\n\n");
//            }
//        }
//        BOOL isDeleate = [fileManger removeItemAtPath:filePath error:&error];
//        if (isDeleate) {
//            BOOL isOK = [fileManger copyItemAtPath:filePath toPath:filePathTwo error:&error];
//            if (isOK) {
//                NSLog(@"%@",@"复制成功\n\n\n");
//            }else {
//                NSLog(@"%@",@"复制失败\n\n\n");
//            }
//        }else {
//            NSLog(@"%@",@"删除成功");
//
//        }
    }
    //实例化FMDataBase对象
    NSLog(@"---path:%@",filePath);
    NSLog(@"---path:%@",filePathTwo);
//    NSLog(@"---path:%@",filePathThree);
    FMDatabase *  fmdb = [FMDatabase databaseWithPath:filePath];
    return fmdb;
}

-(void)initDataBase{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [documentPath stringByAppendingPathComponent:@"student.db"];
    NSLog(@"---path:%@",filePath);
    FMDatabase *  fmdb = [FMDatabase databaseWithPath:filePath];
    if([fmdb open]) {
        //初始化数据表
        [fmdb close];
    }else{
        NSLog(@"数据库打开失败---%@", fmdb.lastErrorMessage);
    }
}
@end
