//
//  FYLinkModel.h
//  feiyushop
//
//  Created by zk on 2019/6/3.
//  Copyright © 2019 张坤. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface FYLinkModel : NSObject
@property (nonatomic, copy  ) NSString *name;//解析后 真正的name

@property (nonatomic, copy  ) NSString *firstName;
@property (nonatomic, copy  ) NSString *lastName;
@property (nonatomic, copy  ) NSString *midName;
@property (nonatomic, copy  ) NSString *prefix;
@property (nonatomic, copy  ) NSString *suffix;
@property (nonatomic, copy  ) NSString *nickName;
@property (nonatomic, copy  ) NSString *firstNamePhonetic;//firstName拼音音标
@property (nonatomic, copy  ) NSString *lastNamePhonetic;//
@property (nonatomic, copy  ) NSString *midNamePhonetic;//
@property (nonatomic, copy  ) NSString *organiztion;//公司
@end


