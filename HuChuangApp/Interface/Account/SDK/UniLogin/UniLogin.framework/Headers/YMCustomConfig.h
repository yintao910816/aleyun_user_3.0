//
//  YMCustomConfig.h
//  UniLogin
//
//  Created by 乔春晓 on 2020/2/11.
//  Copyright © 2020 乔春晓. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EAccountHYSDK/EAccountOpenPageConfig.h"
#import "EAccountHYSDK/EAccountOpenPageSDK.h"
#import "TYRZUISDK/UACustomModel.h"
#import "OAuth/ZOAUCustomModel.h"
#import "OAuth/ZUOAuthManager.h"
#import "EACustomAnimatedTransitioning.h"

NS_ASSUME_NONNULL_BEGIN

@interface YMCustomConfig : NSObject

// 移动
@property (nonatomic, strong) UACustomModel *cmccModel;
// 联通
@property (nonatomic, strong) ZOAUCustomModel *cuccModel;
// 电信
@property (nonatomic, strong) EAccountOpenPageConfig *ctccModel;

// 电信登录是否用mini窗口
@property (nonatomic, assign) BOOL ctccMini;

// 移动授权页面关闭时的动画开关
//@property (nonatomic, assign) BOOL ctccCloseVCAni;

@end

NS_ASSUME_NONNULL_END
