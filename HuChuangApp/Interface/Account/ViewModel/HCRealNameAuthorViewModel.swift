//
//  HCRealNameAuthorViewModel.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/17.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation

import RxCocoa

class HCRealNameAuthorViewModel: BaseViewModel {
    
    init(commit: Driver<Void>) {
        super.init()
        
    }
}

/**
 https://ileyun.ivfcn.com/hc-patient-web/api/consumer/realNameAuth
 realName    是    string    姓名
 sex    是    int    性别 女 0 ，男 1
 birthDay    是    string    出生日期 yyyy-MM-dd
 certificateType    是    string    证件类型 ， 身份证
 certificateNo    是    string
 
 {"realName":"张三","sex":1,"birthDay":"1991-01-01","certificateType":"身份证",
 "certificateNo":"429005198907041123"}

 401    身份失效
 402    未实名认证
 403    微信未绑定手机号
 1111    免费订单
 */
