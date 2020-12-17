//
//  AppSetup.swift
//  StoryReader
//
//  Created by 020-YinTao on 2016/11/25.
//  Copyright © 2016年 020-YinTao. All rights reserved.
//

import Foundation

class AppSetup {
    
    static let instance = AppSetup()
    
    var requestParam: [String : Any] = [:]    
    
    /**
     版本号拼接到所有请求url
     不能超过1000
     */
    var urlVision: String{
        get{
            // 获取版本号
            let versionInfo = Bundle.main.infoDictionary
            let appVersion = versionInfo?["CFBundleShortVersionString"] as! String
            let resultString = appVersion.replacingOccurrences(of: ".", with: "")
            return resultString
        }
    }
    
    /**
     切换用户重新设置请求相关参数
     */
    public func resetParam() {
//                requestParam = [
//                    "uid": userDefault.uid,
//                    "token": userDefault.token
//        ]
        
        PrintLog("默认请求参数已改变：\(requestParam)")
    }
}

import Moya

struct APIAssistance {
        
    /// 测试地址最后加s，正式去掉
    public static let base   = "https://ileyun.ivfcn.com/hc-patient-web/"
    public static let fileBase = "https://ileyun.ivfcn.com/hc-files/"
//    /// 检测版本更新域名地址
//    public static let versionBase   = "https://ileyun.ivfcn.com/hc-patient/"

    /// 测试地址最后加s，正式去掉
    public static let baseH5Host = "https://ileyun.ivfcn.com/hc-patient-web/"
    /// 咨询相关h5主页
    public static let consultsH5Host = "https://ileyun.ivfcn.com/consult/"

    static public func baseURL(API: API) ->URL{
        switch API {
        case .uploadIcon(_):
            return URL(string: fileBase)!
//        case .version:
//            return URL(string: versionBase)!
        default:
            return URL(string: base)!
        }
    }
    
    /**
     请求方式
     */
    static public func mothed(API: API) ->Moya.Method{
        switch API {
        case .version, .getUserInfo(_), .getMenstruationBasis:
            return .get
        default:
            return .post
        }
    }
    
    /// 拼接医生主页分享链接
    static func doctorHomeLink(forShare userId: String) ->String {
        let urlString = "\(APIAssistance.baseH5Host)?from=groupmessage#/\(H5Type.doctorHome)?userId=\(userId)&share=1"
        return urlString
    }
    
    /// 分享链接统一用这个
    static func shareLink(forUrl url: String) ->String {
        if url.contains("?") {
            return "\(url)&share=1"
        }
        return "\(url)?share=1"
    }

    /// 拼接文章分享链接
    static func articleLink(forUrl url: String) ->String {
        return "\(url)?share=1&from=groupmessage"
    }

    /// id拼接文章详情跳转链接
    static public func link(with id: String) ->String {
        return "\(APIAssistance.base)api/cms/detail/\(id)"
    }
    
    /// id 拼接药品详情链接
    static public func medicineDetail(with id: String) ->String {
        return "\(APIAssistance.base)api/cms/medicineDetail/\(id)"
    }

    /// 咨询医生主页
    static public func consultationHome(with doctorId: String, unitId: String) ->String {
        return "\(APIAssistance.consultsH5Host)#/consultationHome/\(doctorId)?unitId=\(unitId)"
    }
    
    /// 咨询聊天室
    static public func consultationChat(with consultId: String) ->String {
        return "\(APIAssistance.consultsH5Host)#/chatConsultation/\(consultId)"
    }
    
    /// 医院详情链接
    static public func hospitalDetails(with id: String) ->String {
        return "\(APIAssistance.consultsH5Host)#/hospitalDetails/\(id)"
    }

    /// 药品详情链接
    static public func drugActivityDetails(with id: String) ->String {
        return "\(APIAssistance.consultsH5Host)#/drugActivityDetails/\(id)"
    }

    /// 添加健康档案链接
    static public func HealthRecords() ->String {
        return "\(APIAssistance.consultsH5Host)#/HealthRecords"
    }
    
    /// 订单详情
    static public func orderDetail(with orderSn: String) ->String {
        return "\(APIAssistance.consultsH5Host)#/chatConsulOrderDetails/\(orderSn)"
    }

}

/**
 public static final String base_url = "https://ileyun.ivfcn.com/consults/#";
 public static final String DRUG_URL = base_url + "/drugActivityDetails/"; //药品详情;
 public static final String UNIT_URL = base_url + "/hospitalDetails/"; //医院详情;
 public static final String DOCTOR_URL = base_url + "/doctorHome/"; //医生主页;
 public static final String CONSULT_URL = base_url + "/consultationHome/"; //咨询主页;
 public static final String HEALTH_RECORD_URL = base_url + "/HealthRecords/"; //咨询主页;
 public static final String HEALTH_ORDER_URL = base_url + "/payOrder/"; //订单支付;
 public static final String HEALTH_ORDER_DETAIL_URL = base_url + "/chatConsulOrderDetails/"; //订单页面;
 public static final String HEALTH_CONSULT_DETAIL_URL = base_url + "/chatConsultation/"; //咨询详情;
 public static final String HEALTH_CONSULT_HISTORY_URL = base_url + "/openInquiryHistory/"; //咨询详情;
 */
