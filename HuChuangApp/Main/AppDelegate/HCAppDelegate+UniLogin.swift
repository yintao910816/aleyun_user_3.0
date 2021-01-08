//
//  HCAppDelegate+UniLogin.swift
//  HuChuangApp
//
//  Created by sw on 2021/1/8.
//  Copyright © 2021 sw. All rights reserved.
//

private let AppId = "a754666bf7344a79a1371e09faf42192"
private let AppSecret = "8c9884f16b664a0e"

import Foundation

extension HCAppDelegate {
    
    public func setupUniLogin() {
        UniLogin.shareInstance().initWithAppId(AppId, secretKey: AppSecret) { (flag, msg) in
            PrintLog("一键登录初始化结果：\(flag) \(msg)")
        }
    }
}
