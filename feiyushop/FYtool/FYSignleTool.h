//
//  FYSignleTool.h
//  BYXuNiPan
//
//  Created by kunzhang on 2018/7/5.
//  Copyright © 2018年 kunzhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FYSignleTool : NSObject

+ (FYSignleTool *)shareTool;
@property(nonatomic,assign)BOOL isLogin;
@property(nonatomic,strong)NSString * session_token;
@property(nonatomic,strong)NSString * session_uid;
@property(nonatomic,strong)NSString * deviceToken;
-(void)uploadDeviceTokenWith:(NSString *)deviceToken;
@property (nonatomic,strong)NSMutableArray *serachTiezi;
@property (nonatomic,strong)NSMutableArray *serachBiZhong;
@end
