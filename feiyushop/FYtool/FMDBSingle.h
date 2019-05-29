//
//  FMDBSingle.h
//  FMDB
//
//  Created by FY on 2018/10/23.
//  Copyright © 2018年 张坤. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FMDBSingle : NSObject
+(FMDBSingle *)shareFMDB;
- (FMDatabase *)fd;
@end

NS_ASSUME_NONNULL_END
