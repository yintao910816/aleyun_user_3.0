//
//  SRUserAPI.swift
//  StoryReader
//
//  Created by 020-YinTao on 2016/11/25.
//  Copyright © 2016年 020-YinTao. All rights reserved.
//

import Foundation
import Moya

/// 文件类型
enum HCFileUploadType: String {
    case image = "image/jpeg"
    case audio = "audio/mp3"
    
    public var getSuffix: String {
        switch self {
        case .image:
            return ".jpg"
        case .audio:
            return ".mp3"
        }
    }
}

/// 系统消息列表对应code
enum HCMsgListCode: String {
    /// 系统消息
    case notification_type1 = "notification_type1"
    /// 通知公告
    case notification_type2 = "notification_type2"
    /// 圈子
    case notification_type3 = "notification_type3"
    /// 医生咨询
    case notification_type4 = "notification_type4"
    /// 预约
    case notification_type5 = "notification_type5"
    /// 提醒
    case notification_type6 = "notification_type6"
    /// 预留1
    case notification_type7 = "notification_type7"
    /// 快速提问
    case notification_type8 = "notification_type8"
    /// 预留3
    case notification_type9 = "notification_type9"
}

/// 文章栏目编码
enum HCCmsType: String {
    /// 首页-推荐课程列表
    case SGBK = "SGBK"
    /// 热门资讯 类目code
    case RMZX = "RMZX"
    /// api/cms/recommend
    case webCms001 = "webCms001"
}

enum HCMergeProOpType: String {
    /// 添加同房记录
    case knewRecord = "knewRecord"
    /// 添加排卵日
    case ovulation = "ovulation"
    /// 添加体温记录
    case temperature = "temperature"
}

enum HCBannerCode: String {
    case bannerdoctor = "bannerdoctor"
}

enum H5Type: String {
    /// 好孕消息
    case goodNews = "goodnews"
    /// 消息中心
    case notification = "notification"
    /// 公告
    case announce = "announce"
    /// 认证
    case bindHos = "bindHos"
    /// 绑定成功
    case succBind = "succBind"
    /// 问诊记录
    case consultRecord = "consultRecord"
    /// 我的预约
    case memberSubscribe = "memberSubscribe"
    /// 我的收藏
    case memberCollect = "memberCollect"
    /// 用户反馈
    case memberFeedback = "memberFeedback"
    /// cms功能：readNumber=阅读量,modifyDate=发布时间，hrefUrl=调整地址
    case hrefUrl = "hrefUrl"
    /// 医生咨询
    case doctorConsult = "doctorConsult"
    /// 患者咨询
    case patientConsult = "patientConsult"
    /// 开发中
    case underDev = "underDev"
    /// 咨询医生信息
    case doctorHome = "doctorHome"
    /// 快速问诊
    case doctorCs = "DoctorCs"
    /// 问诊记录
    case doctorComments = "doctorComments"
    /// 我的关注
    case myFocused = "myFocused"
    /// 我的搜藏
    case myCollection = "myCollection"
    /// 我的卡卷
    case voucherCenter = "myCoupon"
    /// 经期设置
    case menstrualSetting = "MenstrualSetting"
    /// 个人中心健康档案
    case healthRecordsUser = "healthRecords"
    /// 用户反馈
    case feedback = "feedback"
    /// 帮助中心
    case helpCenter = "NounParsing"
    /// 通知中心
    case noticeAndMessage = "noticeAndMessage"
    /// 订单
    case csRecord = "CsRecord"
    /// 我的医生
    case myDoctor = "myDoctor"
    /// 分享app给好友
    case share = "share"
        
    func getLocalUrl(needToken: Bool = true) ->String {
        var host = APIAssistance.baseH5Host

        if needToken {
            host = "\(host)#/\(rawValue)?token=\(userDefault.token)&titleLock=true"
        }else {
            host = "\(APIAssistance.baseH5Host)#/\(rawValue)?titleLock=true"
        }
        return host
    }
}

/// 搜索的内容类型
enum HCsearchModule: String {
    /// 专家
    case doctor = "doctor"
    /// 课程
    case course = "course"
    /// 资讯
    case article = "information"
    /// 直播
    case live = "live"
}

//MARK:
//MARK: 接口定义
enum API{
    // --------------- 3.0接口
    /// 获取验证码
    case validateCode(mobile: String)
    /// 登录
    case loginTel(mobile: String, smsCode: String)
    /// 微信授权登录---获取绑定信息
    case getAuthMember(openId: String)
    /// 绑定微信
    case bindAuthMember(openId: String, mobile: String, smsCode: String)
    /// 一键登录
    case tokenLogin(token: String)
    /// 实名认证
    case realNameAuth(realName: String, sex: String, birthDay: String, certificateType: String, certificateNo: String)
    /// 账号设置 - 头像/昵称
    case accountSetting(nickName: String, headPath: String)
    /// 上传头像
    case uploadIcon(image: UIImage)
    /// 文件上传
    case uploadFile(data: Data, fileType: HCFileUploadType)
    /// 个人中心
    case personalCenterInfo
    /// 首页菜单
    case functionsMenu
    /// 首页推荐文章
    case cmsRecommend(cmsCode: HCCmsType)
    /// 首页第三部分菜单
    case getRecommedList(cmsCode: HCCmsType)
    /// 热门资讯 类目
    case cmsCmsChanelList(cmsCode: HCCmsType)
    /// 热门资讯—文章列表
    case cmsArticleList(channelId: String)
    /// 获取文章详情h5链接
    case cmsDetail(articleId: String)
    /// 关注与收藏
    case attentionStore(moduleType: HCMenuListModuleType, pageNum: Int, pageSize: Int)
    /// 文章收藏取消 - storeStatus: 收藏 ture , 取消 false
    case articelStore(articleId: String, storeStatus: Bool)
    /// 是否已收藏
    case cmsFollow(articleId: String)
    /// 医生收藏
    case attentionDoctor(userId: String, attention: Bool)
    /// 医生是否已收藏
    case doctorFollow(userId: String, memberId: String)
    /// 搜索
    case search(moduleType: HCsearchModule, searchWords: String, pageSize: Int, pageNum: Int)
    /// 我的优惠卷
    case myCoupon(orderSn: String, useStatus: Int, pageSize: Int, pageNum: Int)
    /// 我的问诊
    case myConsult(consultType: Int, pageSize: Int, pageNum: Int, status: String?)
    /// 消息中心
    case messageCenter
    /// banner
    case selectBanner(code: HCBannerCode)
    /// 医生/医院数量统计 - 专家问诊
    case statisticsDoctorHopital
    /// 我的医生 - 专家问诊
    case myDoctor(lng: String, lat: String)
    /// 获取所有省
    case allProvice
    /// 获取所有热门地区
    case allHotCity
    /// 获取市
    case city(id: String)
    /// 专家列表
    case doctorList(areaCode: String, sortType: String, consultType: String, pageSize: Int, pageNum: Int)
    /// 试管百科
    case groupCmsArticle(code: HCCmsType)
    /// 生殖中心
    case hospitalList(searchWords: String, areaCode: String, level: String)
    /// 药品百科
    case medicine(searchWords: String)
    
    /// 获取视频签名 医生用userId 患者用memberId
    case videoChatSignature(memberId: String)
    /**
     * 接听电话获取头像姓名信息
     */
    case consultVideoUserInfo(memberId: String, userId: String, consultId: String)
    /// 接听电话
    case consultReceivePhone(memberId: String, userId: String, consultId: String)
    /// 拨打电话
    case consultStartPhone(memberId: String, userId: String)
    /// 结束通话
    case consultEndPhone(memberId: String, userId: String, watchTime: String)

    /// 系统消息列表
    case msgListByCode(code: HCMsgListCode, pageNum: Int, pageSize: Int)
    
    //MARK: 工具相关接口
    /// 查询基础信息(周期和持续时间)
    case getMenstruationBasis
    /// 根据日期查询基础信息
    case getBaseInfoByDate(date: String)
    /// 经期开始时间设置，修改，取消
    case updateMenstruationDate(menstruationDate: String)
    /// 设置经期结束时间
    case settingMenstruationEndDate(menstruationEndDate: String)
    /// 添加或取消同房记录，排卵日记录
    case mergePro(opType: HCMergeProOpType, date: String)
    /// 保存或修改体温
    case saveOrUpdateTemperature(temperature: String, temperatDate: String)
    /// 保存或修改体重
    case saveOrUpdateWeight(weight: String, measureDate: String)
    /// 保存或修改月经基础数据
    case saveOrUpdateBasis(menstruationCycle: String, menstruationDuration: String)
    /// 删除体温或体重 类型1体温2体重
    case delTemperatureOrWeight(type: Int, date: String)
    // --------------- 2.0接口
    /// 向app服务器注册友盟token
    case UMAdd(deviceToken: String)

    /// 获取用户信息
    case selectInfo
    /// 修改用户信息
    case updateInfo(param: [String: String])
    /// 首页功能列表
    case functionList
    /// 好消息
    case goodNews
    /// 首页通知消息
    case noticeList(type: String, pageNum: Int, pageSize: Int)
    /// 获取未读消息
    case messageUnreadCount
    case article(id: String)
    /// 今日知识点击更新阅读量
    case increReading(id: String)
    
    /// 医生列表
    case consultList(pageNum: Int, pageSize: Int)
    
    /// 获取h5地址
    case unitSetting(type: H5Type)
    
    /// 检查版本更新
    case version
    
    //MARK:--爱乐孕治疗四期接口
    /// 怀孕几率查询
    case probability
    /// 首页好孕课堂
//    case allChannelArticle(cmsType: HCWebCmsType, pageNum: Int, pageSize: Int)
    /// 名医推荐
    case recommendDoctor(areaCode: String, lat: String, lng: String)
    /// 课堂
//    case column(cmsType: HCWebCmsType)
    /// 栏目文章列表
    case articlePage(id: Int, pageNum: Int, pageSize: Int)
    /// 健康档案
    case getHealthArchives
    /// 专家问诊医生列表
    case consultSelectListPage(pageNum: Int, pageSize: Int, searchName: String, areaCode: String, opType: [String: Any], sceen: [String: Any])
    /// 咨询医生信息
    case getUserInfo(userId: String)
    /// 最近三个周期信息
    case getLast2This2NextWeekInfo
    /// 获取月经周期基础数据
    case getMenstruationBaseInfo
    /// 文章当前收藏数量
    case storeAndStatus(articleId: String)
    /// 区域城市
    case allCity
    /// 添加/修改/删除,月经周期
    case mergeWeekInfo(id: Int, startDate: String, keepDays: Int, next: Int)
}

//MARK:
//MARK: TargetType 协议
extension API: TargetType{
    
    var path: String{
        switch self {
            
        case .validateCode(_):
            return "api/login/validateCode"
        case .loginTel(_, _):
            return "api/login/loginTel"
        case .getAuthMember(_):
            return "api/login/getAuthMember"
        case .bindAuthMember(_):
            return "api/login/bindAuthMember"
        case .tokenLogin(_):
            return "api/login/jgLogin"
        case .realNameAuth(_, _, _, _, _):
            return "api/consumer/realNameAuth"
        case .accountSetting(_, _):
            return "api/personalCenter/accountSetting"
        case .uploadIcon(_):
            return "api/upload/imgSingle"
        case .uploadFile(_):
            return "api/upload/imgSingle"
        case .personalCenterInfo:
            return "api/personalCenter/info"
        case .functionsMenu:
            return "api/functions/menu"
        case .cmsRecommend(let cmsCode):
            return "api/cms/recommend/\(cmsCode.rawValue)"
        case .getRecommedList(let cmsCode):
            return "api/cms/getRecommedList/\(cmsCode.rawValue)"
        case .cmsCmsChanelList(let cmsCode):
            return "api/cms/cmsChanelList/\(cmsCode.rawValue)"
        case .cmsArticleList(let channelId):
            return "api/cms/articleList/\(channelId)"
        case .articelStore(_):
            return "api/cms/store"
        case .cmsFollow(let articleId):
            return "api/cms/follow/\(articleId)"
        case .attentionDoctor(_, _):
            return "api/doctor/attentionDoctor"
        case .doctorFollow(_, _):
            return "api/attentionStore/isAttention"
        case .cmsDetail(let articleId):
            return "api/cms/detail/\(articleId)"
        case .attentionStore(_, _, _):
            return "api/attentionStore/attentionStore"
        case .search(_, _, _, _):
            return "api/search/search"
        case .myCoupon(_, _, _, _):
            return "api/coupon/myCoupon"
        case .myConsult(_, _, _, _):
            return "api/consult/myConsult"
        case .messageCenter:
            return "api/messageCenter/groupMsg"
        case .selectBanner(let code):
            return "api/advert/banner/\(code.rawValue)"
        case .statisticsDoctorHopital:
            return "api/statistics/doctorHopital"
        case .myDoctor(_, _):
            return "api/doctor/myDoctor"
        case .allProvice:
            return "api/area/newAllProvice"
        case .allHotCity:
            return "api/area/allHotCity"
        case .city(let id):
            return "api/area/city/\(id)"
        case .doctorList(_, _, _, _, _):
            return "api/doctor/doctorList"
        case .groupCmsArticle(let code):
            return "api/cms/getCmsArticleByCode/\(code.rawValue)"
        case .hospitalList(_, _, _):
            return "api/hospital/list"
        case .medicine(_):
            return "api/cms/medicine"
        
        case .videoChatSignature(_):
            return "api/consult/signature"
        case .consultVideoUserInfo(_, _, _):
            return "api/consult/videoUserInfo"
        case .consultReceivePhone(_, _, _):
            return "api/consult/receivePhone"
        case .consultStartPhone(_, _):
            return "api/consult/startPhone"
        case .consultEndPhone(_, _, _):
            return "api/consult/endPhone"

        case .msgListByCode(_, _, _):
            return "api/messageCenter/msgListByCode"
            
        case .getMenstruationBasis:
            return "api/physiology/getMenstruationBasis"
        case .getBaseInfoByDate(_):
            return "api/physiology/getBaseInfoByDate"
        case .updateMenstruationDate(_):
            return "api/physiology/updateMenstruationDate"
        case .settingMenstruationEndDate(_):
            return "api/physiology/settingMenstruationEndDate"
        case .mergePro(_, _):
            return "api/physiology/mergePro"
        case .saveOrUpdateTemperature(_, _):
            return "api/physiology/saveOrUpdateTemperature"
        case .saveOrUpdateWeight(_, _):
            return "api/physiology/saveOrUpdateWeight"
        case .saveOrUpdateBasis(_, _):
            return "api/physiology/saveOrUpdateBasis"
        case .delTemperatureOrWeight(_, _):
            return "api/physiology/delTemperatureOrWeight"
            
        case .UMAdd(_):
            return "api/umeng/add"
        case .selectInfo:
            return "api/member/selectInfo"
        case .updateInfo(_):
            return "api/member/updateInfo"
        case .functionList:
            return "api/index/select"
        case .noticeList(_):
            return "api/index/noticeList"
        case .messageUnreadCount:
            return "api/messageCenter/unread"
        case .goodNews:
            return "api/index/goodNews"
        case .article(_):
            return "api/index/article"
        case .increReading(_):
            return "api/index/increReading"
        case .unitSetting(_):
            return "api/index/unitSetting"
        case .version:
            return "api/apk/version"
        case .consultList(_):
            return "api/consult/selectPageList"
            
//        case .column(_):
//            return "api/index/column"
//        case .allChannelArticle(_):
//            return "api/index/allChannelArticle"
        case .recommendDoctor(_):
            return "api/doctor/recommendDoctor"
        case .articlePage(_):
            return "api/index/articlePage"
        case .getHealthArchives:
            return "api/member/getHealthArchives"
        case .consultSelectListPage(_):
            return "api/consult/selectListPage"
        case .getUserInfo(_):
            return "api/consult/getUserInfo"
        case .probability:
            return "api/physiology/probability"
        case .getLast2This2NextWeekInfo:
            return "api/physiology/getLast2This2NextWeekInfo"
        case .getMenstruationBaseInfo:
            return "api/physiology/getMenstruationBaseInfo"
        case .storeAndStatus(_):
            return "api/cms/storeAndStatus"
        case .allCity:
            return "api/area/allCity"
        case .mergeWeekInfo(_):
            return "api/physiology/mergeWeekInfo"
        }
    }
    
    var baseURL: URL{ return APIAssistance.baseURL(API: self) }
    
    var task: Task {
        switch self {
        case .uploadFile(let data, let fileType):
            //根据当前时间设置图片上传时候的名字
            let timeInterval: TimeInterval = Date().timeIntervalSince1970
            let dateStr = "\(Int(timeInterval))\(fileType.getSuffix)"
            let formData = MultipartFormData(provider: .data(data), name: "file", fileName: dateStr, mimeType: fileType.rawValue)
            return .uploadMultipart([formData])
        case .uploadIcon(let image):
            let data = image.jpegData(compressionQuality: 0.6)!
            //根据当前时间设置图片上传时候的名字
            let date:Date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd-HH:mm:ss"
            let dateStr:String = formatter.string(from: date)
            
            let formData = MultipartFormData(provider: .data(data), name: "file", fileName: dateStr, mimeType: "image/jpeg")
            return .uploadMultipart([formData])
        case .version:
            return .requestParameters(parameters: ["type": "ios", "packageName": Bundle.main.bundleIdentifier],
                                      encoding: URLEncoding.default)
        case .tokenLogin(let token):
            return .requestParameters(parameters: ["token": token],
                                      encoding: URLEncoding.default)
        default:
            if let _parameters = parameters {
                guard let jsonData = try? JSONSerialization.data(withJSONObject: _parameters, options: []) else {
                    return .requestPlain
                }
                return .requestCompositeData(bodyData: jsonData, urlParameters: [:])
            }
        }
        
        return .requestPlain
    }
    
    var method: Moya.Method { return APIAssistance.mothed(API: self) }
    
    var sampleData: Data{ return Data() }
    
    var validate: Bool { return false }
    
    var headers: [String : String]? {
        var contentType: String = "application/json; charset=utf-8"
        switch self {
        case .uploadIcon(_):
            contentType = "image/jpeg"
        case .uploadFile(_, let fileType):
            contentType = fileType.rawValue
        default:
            break
        }
        
        let userAgent: String = "\(Bundle.main.bundleIdentifier),\(Bundle.main.version),\(UIDevice.iosVersion),\(UIDevice.modelName)"
        
        
        let customHeaders: [String: String] = ["token": userDefault.token,
                                               "User-Agent": userAgent,
                                               "unitId": userDefault.unitId,
                                               "Content-Type": contentType,
                                               "Accept": "application/json"]
        PrintLog("request headers -- \(customHeaders)")
        return customHeaders
    }
    
}

//MARK:
//MARK: 请求参数配置
extension API {
    
    private var parameters: [String: Any]? {
        var params = [String: Any]()
        switch self {
        case .validateCode(let mobile):
            params["mobile"] = mobile
        case .loginTel(let mobile, let smsCode):
            params["mobile"] = mobile
            params["smsCode"] = smsCode
        case .realNameAuth(let realName, let sex, let birthDay, let certificateType, let certificateNo):
            params["realName"] = realName
            params["sex"] = sex
            params["birthDay"] = birthDay
            params["certificateType"] = certificateType
            params["certificateNo"] = certificateNo
        case .accountSetting(let nickName, let headPath):
            params["nickName"] = nickName
            params["headPath"] = headPath
        case .attentionStore(let moduleType, let pageNum, let pageSize):
            params["moduleType"] = moduleType.rawValue
            params["pageNum"] = pageNum
            params["pageSize"] = pageSize
        case .search(let moduleType, let searchWords, let pageSize, let pageNum):
            params["moduleType"] = moduleType.rawValue
            params["searchWords"] = searchWords
            params["pageSize"] = pageSize
            params["pageNum"] = pageNum
        case .myCoupon(let orderSn, let useStatus, let pageSize, let pageNum):
            params["orderSn"] = orderSn
            params["useStatus"] = useStatus
            params["pageSize"] = pageSize
            params["pageNum"] = pageNum
        case .myConsult(let consultType, let pageSize, let pageNum, let status):
            params["consultType"] = consultType
            params["pageSize"] = pageSize
            params["pageNum"] = pageNum
            if let s = status {
                params["status"] = s
            }else {
                params["status"] = nil
            }
        case .myDoctor(let lng, let lat):
            params["lng"] = lng
            params["lat"] = lat
        case .doctorList(let areaCode, let sortType, let consultType, let pageSize, let pageNum):
            params["areaCode"] = areaCode
            params["sortType"] = sortType
            params["consultType"] = consultType
            params["pageSize"] = pageSize
            params["pageNum"] = pageNum
        case .hospitalList(let searchWords, let areaCode, let level):
            params["searchWords"] = searchWords
            params["areaCode"] = areaCode
            params["level"] = level
        case .medicine(let searchWords):
            params["searchWords"] = searchWords

        case .videoChatSignature(let memberId):
            params["memberId"] = memberId
        case .consultVideoUserInfo(let memberId, let userId, let consultId):
            params["memberId"] = memberId
            params["userId"] = userId
            params["consultId"] = consultId
        case .consultReceivePhone(let memberId, let userId, let consultId):
            params["memberId"] = memberId
            params["userId"] = userId
            params["consultId"] = consultId
        case .consultStartPhone(let memberId, let userId):
            params["memberId"] = memberId
            params["userId"] = userId
        case .consultEndPhone(let memberId, let userId, let watchTime):
            params["memberId"] = memberId
            params["userId"] = userId
            params["watchTime"] = watchTime
        case .msgListByCode(let code, let pageNum, let pageSize):
            params["code"] = code.rawValue
            params["pageNum"] = pageNum
            params["pageSize"] = pageSize

        case .getBaseInfoByDate(let date):
            params["date"] = date
        case .updateMenstruationDate(let menstruationDate):
            params["menstruationDate"] = menstruationDate
        case .settingMenstruationEndDate(let menstruationEndDate):
            params["menstruationEndDate"] = menstruationEndDate
        case .mergePro(let opType, let date):
            params["opType"] = opType.rawValue
            params["date"] = date
        case .saveOrUpdateTemperature(let temperature, let temperatDate):
            params["temperature"] = temperature
            params["temperatDate"] = temperatDate
        case .saveOrUpdateWeight(let weight, let measureDate):
            params["weight"] = weight
            params["measureDate"] = measureDate
        case .saveOrUpdateBasis(let menstruationCycle, let menstruationDuration):
            params["menstruationCycle"] = menstruationCycle
            params["menstruationDuration"] = menstruationDuration
        case .delTemperatureOrWeight(let type, let date):
            params["type"] = type
            params["date"] = date


        case .UMAdd(let deviceToken):
            params["deviceToken"] = deviceToken
            params["appPackage"] = Bundle.main.bundleIdentifier
            params["appType"] = "ios"
        case .bindAuthMember(let openId, let mobile, let smsCode):
            params["openId"] = openId
            params["appType"] = "IOS"
            params["oauthType"] = "weixin"
            params["mobile"] = mobile
            params["smsCode"] = smsCode
        case .updateInfo(let param):
            params = param

        case .noticeList(let type, let pageNum, let pageSize):
            params["type"] = type
            params["pageNum"] = pageNum
            params["pageSize"] = pageSize
        case .article(let id):
            params["id"] = id
        case .unitSetting(let type):
            params["settingCode"] = type.rawValue
        
        case .increReading(let id):
            params["id"] = id

        case .consultList(let pageNum, let pageSize):
            params["pageNum"] = pageNum
            params["pageSize"] = pageSize

//        case .allChannelArticle(let articleType, let pageNum, let pageSize):
//            params["unitId"] = userDefault.unitId
//            params["cmsCode"] = articleType.rawValue
//            params["pageNum"] = pageNum
//            params["pageSize"] = pageSize
        case .recommendDoctor(let areaCode, let lat, let lng):
            params["areaCode"] = areaCode
            params["lat"] = lat
            params["lng"] = lng
//        case .column(let cmsType):
//            params["cmsCode"] = cmsType.rawValue
        case .articlePage(let id, let pageNum, let pageSize):
            params["id"] = id
            params["unitId"] = userDefault.unitId
            params["pageNum"] = pageNum
            params["pageSize"] = pageSize
        case .consultSelectListPage(let pageNum, let pageSize, let searchName, let areaCode, let opType, let sceen):
            params["unitId"] = userDefault.unitId
            params["pageNum"] = pageNum
            params["pageSize"] = pageSize
            params["searchName"] = searchName
            params["areaCode"] = areaCode
            params["opType"] = opType
            params["sceen"] = sceen
        case .getUserInfo(let userId):
            params["userId"] = userId
        case .getAuthMember(let openId):
            params["openId"] = openId
            params["appType"] = "IOS"
            params["oauthType"] = "weixin"
        case .storeAndStatus(let articleId):
            params["articleId"] = articleId
        case .articelStore(let articleId, let status):
            params["articleId"] = articleId
            params["storeStatus"] = status
        case .attentionDoctor(let userId, let attention):
            params["userId"] = userId
            params["attention"] = attention
        case .doctorFollow(let userId, let memberId):
            params["userId"] = userId
            params["memberId"] = memberId


        case .mergeWeekInfo(let id, let startDate, let keepDays, let next):
            params["id"] = id
            params["startDate"] = startDate
            params["keepDays"] = keepDays
            params["next"] = next
        default:
            return nil
        }
        
        PrintLog(params)
        return params
    }
}


//func stubbedResponse(_ filename: String) -> Data! {
//    @objc class TestClass: NSObject { }
//
//    let bundle = Bundle(for: TestClass.self)
//    let path = bundle.path(forResource: filename, ofType: "json")
//    return (try? Data(contentsOf: URL(fileURLWithPath: path!)))
//}

//MARK:
//MARK: API server
let HCProvider = MoyaProvider<API>(plugins: [MoyaPlugins.MyNetworkActivityPlugin,
                                             RequestLoadingPlugin()]).rx

/**
 yyyy, [22.12.19 09:48]
 https://ileyun.ivfcn.com/hc-patient/api/physiology/mergePro

 yyyy, [22.12.19 09:49]
 opType = knewRecord

 yyyy, [22.12.19 09:49]
 opType = ovulation

 yyyy, [22.12.19 09:49]
 opType = temperature
 */
