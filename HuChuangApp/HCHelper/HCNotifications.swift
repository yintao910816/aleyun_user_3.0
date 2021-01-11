//
//  HCNotifications.swift
//  HuChuangApp
//
//  Created by sw on 13/02/2019.
//  Copyright © 2019 sw. All rights reserved.
//

import Foundation

typealias NotificationName = Notification.Name

extension Notification.Name {
    
    public struct User {
        /**
         * 登录成功，需要重新拉取数据和重新向app后台上传umtoken的界面可接受此通知
         */
        static let LoginSuccess = Notification.Name(rawValue: "org.user.notification.name.loginSuccess")
    }
    
    public struct UserInterface {
        /// 连续2次点击同一个tabBar
        static let tabBarSelectedTwice = Notification.Name(rawValue: "org.UserInterface.notification.name.tabBarSelectedTwice")
        /// 跳转首页
        static let selectedHomeTabBar = Notification.Name(rawValue: "org.UserInterface.notification.name.selectedHomeTabBar")

        static let webHistoryItemChanged = Notification.Name(rawValue: "WebHistoryItemChangedNotification")
        /// js通知刷新首页数据
        static let jsReloadHome = Notification.Name(rawValue: "org.UserInterface.notification.name.jsReloadHome")
        /// 记录对比时同步滚动
        static let recordScroll = Notification.Name(rawValue: "org.UserInterface.notification.name.recordScroll")
    }
    
    public struct UILogic {
        /// 首页文章更多点击跳转课程tab
        static let gotoClassRoom = Notification.Name(rawValue: "org.UILogic.notification.name.gotoClassRoom")
        /// 首页顶部红色背景点击跳转记录界面
        static let gotoRecord = Notification.Name(rawValue: "org.UILogic.notification.name.gotoRecord")
    }
    
    public struct Pay {
        /// 微信支付完成
        static let wChatPayFinish = Notification.Name(rawValue: "org.Pay.notification.name.wChatPayFinish")
    }

    public struct ChatCall {
        /// 发起视频通话对方接受
        static let videoCallAccept = Notification.Name(rawValue: "org.UILogic.notification.name.videoCallAccept")
        /// 对方离开通话
        static let otherLeaveVideoCall = Notification.Name(rawValue: "org.UILogic.notification.name.otherLeaveVideoCall")
        /// 对方拒绝通话
        static let otherRejectVideoCall = Notification.Name(rawValue: "org.UILogic.notification.name.otherRejectVideoCall")
        /// 占线中 onLineBusy
        static let onLineBusyVideoCall = Notification.Name(rawValue: "org.UILogic.notification.name.onLineBusyVideoCall")
        /// 铃声播放完成还未接通
        static let finishAudio = Notification.Name(rawValue: "org.UILogic.notification.name.finishAudio")
    }
    
    public struct APPAction {
        /// 文章搜藏成功
        static let articleStoreSuccess = Notification.Name(rawValue: "org.Pay.notification.name.articleStoreSuccess")
    }

    public struct Menstruation {
        /**
         * 基础经期数据设置成功
         */
        static let SuccessBaseSetting = Notification.Name(rawValue: "org.user.notification.name.SuccessBaseSetting")
    }

}
