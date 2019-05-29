//
//  BaseViewController.h
//  kunzhang_learnkunzhang海食汇
//
//  Created by kunzhang on 16/10/13.
//  Copyright © 2016年 cznuowang. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface BaseViewController : UIViewController
@property(strong,nonatomic)UIButton * rightBtn2;
- (void)gotoLoginVC;

-(void)setNavLeftBtnWithImg:(NSString *)imgName title:(NSString *)title withBlock:(void (^)(UIButton *leftBtn))leftBtn handleBtn:(void(^)())buttonClick;
- (void)setNavRightBtnWithImg:(NSString *)imgName title:(NSString *)title withBlock:(void (^)(UIButton *rightBtn))rightBtn handleBtn:(void(^)())buttonClick;
- (BOOL)isCanUsePhotos;
- (BOOL)isCanUsePicture;


;

@end

