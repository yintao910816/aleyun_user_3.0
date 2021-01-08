//
//  UniLogin.h
//  UniLogin
//
//  Created by 乔春晓 on 2019/10/10.
//  Copyright © 2019 乔春晓. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "YMCustomConfig.h"

NS_ASSUME_NONNULL_BEGIN

/**
 YMInitResultBlock: 初始化结果回调
 isSuccess: 是否成功
 msg: 提示信息
 */
typedef void(^YMInitResultBlock)(BOOL isSuccess, NSString *msg);

/**
 YMPrepareLoginResultBlock: 预登录结果回调
 isSuccess: 是否成功
 msg: 提示信息
 result: 更多信息（运营商返回的结果）
 */
typedef void(^YMPrepareLoginResultBlock)(BOOL isSuccess, NSString *msg, NSDictionary * _Nullable result);

/**
 YMLoginResultBlock: 打开登录页面结果回调
 mobile: 手机号码
 msg: 提示信息
 result: 更多信息（运营商返回的结果）移动联通的是字典类型，电信的是NSError
 */
typedef void(^YMLoginResultBlock)(NSString * _Nullable mobile, NSString * _Nullable msg, id _Nullable result);

@protocol UniLoginDelegate <NSObject>

- (void)ctccCustomBtnClick:(NSString *)senderTag;

@end


@interface UniLogin : NSObject

/**
 代理
 */
@property (nonatomic, weak) id<UniLoginDelegate> delegate;


/// 单例
+(instancetype)shareInstance;


/// 登录方法
/// @param currectVC 当前控制器
/// @param customConfig 配置参数
/// @param appId 分配的appId
/// @param secretKey 分配的密钥
/// @param complete 完成回调
- (void)loginWithViewControler:(UIViewController *)currectVC customConfig:(YMCustomConfig *)customConfig appId:(NSString *)appId secretKey:(NSString *)secretKey complete:(void(^)(NSString * _Nullable mobile, NSString* _Nullable msg))complete;


/// 关闭授权页面
/// @param flag 关闭页面动画开关 （对移动联通可行，电信依然依赖配置参数的设置）
/// @param completion 回调（仅用于移动、联通）
- (void)closeUniLoginViewControlerAnimated:(BOOL)flag completion:(void (^ __nullable)(void))completion;


/// 获取当前SDK版本号
- (NSString *)getVersion;


// v5版本新增方法

/// 初始化方法
/// @param appId 分配的appId
/// @param secretKey 分配的密钥
/// @param complete 结果回调
- (void)initWithAppId:(NSString *)appId secretKey:(NSString *)secretKey complete:(YMInitResultBlock)complete;


/// 预登录
/// @param timeout 超时时间 单位：秒
/// @param complete 结果回调
- (void)prepareLoginWithTimeout:(NSUInteger)timeout complete:(YMPrepareLoginResultBlock)complete;


/// 打开授权界面
/// @param customConfig 配置参数
/// @param timeout 超时
/// @param viewController 当前控制器
/// @param complete 结果回调
- (void)openAtuhVCWithConfig:(YMCustomConfig *)customConfig timeout:(NSUInteger)timeout controller:(UIViewController *)viewController complete:(YMLoginResultBlock)complete;


/// 网络类型及运营商（双卡下，获取上网卡的运营商）
/// "carrier"     运营商： 0.未知 / 1.中国移动 / 2.中国联通 / 3.中国电信
/// "networkType" 网络类型： 0.无网络/ 1.数据流量 / 2.wifi / 3.数据+wifi
/// @return  @{NSString : NSNumber}
- (NSDictionary *)getNetworkInfo;

@end
NS_ASSUME_NONNULL_END
