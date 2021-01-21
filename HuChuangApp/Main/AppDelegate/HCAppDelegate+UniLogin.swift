//
//  HCAppDelegate+UniLogin.swift
//  HuChuangApp
//
//  Created by sw on 2021/1/8.
//  Copyright © 2021 sw. All rights reserved.
//

//private let AppId = "a754666bf7344a79a1371e09faf42192"
//private let AppSecret = "8c9884f16b664a0e"

private let AppId = "9a56a8fd83a1429d9e01c40a8044124d"
private let AppSecret = "6d9ff2ba738f4a21"

import Foundation

extension HCAppDelegate {
    
    public func setupUniLogin(viewController: UIViewController) {
//        UniLogin.shareInstance().delegate = self
        
//        UniLogin.shareInstance().initWithAppId(AppId, secretKey: AppSecret) { [weak self] (flag, msg) in
//            PrintLog("一键登录初始化结果：\(flag) \(msg)")
//            if flag {
//                guard let strongSelf = self else { return }
//                
//                let config = YMCustomConfig()
//                config.cuccModel = strongSelf.createCUCCModel(viewController: viewController, isMini: false)
//                config.ctccMini = false
//                
//                UniLogin.shareInstance().openAtuhVC(with: config, timeout: 30, controller: viewController) { (mobile, msg, result) in
//                    DispatchQueue.main.async {
//                        if let m = mobile, m.count > 0 {
//                            NoticesCenter.alert(message: "一键登录成功：\(m)")
//                        }else {
//                            NoticesCenter.alert(message: msg ?? "一键登录失败")
//    //                        UniLogin.shareInstance().closeViewControler(animated: false, completion: nil)
//                        }
//                    }
//                }
//            }else {
//                NoticesCenter.alert(message: msg)
//            }
//        }
    }
}

extension HCAppDelegate {
    
    /// 联通demo设置
    private func createCUCCModel(viewController: UIViewController, isMini: Bool) ->ZOAUCustomModel {
        let model = ZOAUCustomModel()
        if (isMini) {
            model.navBarHidden = true
            model.logoImg = UIImage(named: "app_icon")
            let topCustomHeight: CGFloat = 330
            model.controllerType = .PushController
            model.backgroundColor = UIColor.white
            model.navText = ""
            model.navBgColor = .white
            model.modalPresentationStyle = .fullScreen
            model.privacyOffsetY = -10
            model.topCustomHeight = topCustomHeight
            model.stringAfterPrivacy = "\n"
            model.ifAddPrivacyPageBG = true
            model.logoOffsetY = 0
            model.logoWidth = 35
            model.logoHeight = 35
            model.numberOffsetY = 5
            model.brandOffsetY = 5
            model.logBtnOffsetY = 5
            model.logBtnHeight = 20
            model.logBtnLeading = 100
            model.swithAccOffsetX = 30
            model.navReturnImg = UIImage(named: "navigationButtonReturnClick")
            
            DispatchQueue.main.async {
                let rightItem = UIBarButtonItem.init(title: "close", style: .done, target: self, action: #selector(self.stopLogining))
                model.navControl = rightItem;
            }
            
            ZUOAuthManager.getInstance()?.customUI(withParams: model, topCustomViews: { [weak self] in
                guard let strongSelf = self else { return }
                if let customView = $0 {
                    let button = UIButton.init(type: .custom)
                    button.frame = .init(x: customView.frame.size.width - 55, y: customView.frame.size.height - 25, width: 50, height: 25)
                    button.backgroundColor = UIColor.red
                    button.setTitle("关闭", for: .normal)
                    button.addTarget(strongSelf, action: #selector(strongSelf.stopLogining), for: .touchUpInside)
                    customView.addSubview(button)
                }
            }, bottomCustomViews: nil)
        }else {
            model.modalPresentationStyle = .fullScreen
            model.navBarHidden = false
            model.backgroundColor = .white
            
            model.navBottomLineHidden = true
            model.navBgColor = .white
            model.navText = ""
            
//            model.topCustomHeight = 5
//            model.logoImg = UIImage(named: "app_icon")
//            model.logoWidth = 100
//            model.logoHeight = 100
//            model.logBtnOffsetY = 0
            model.ifHiddenLOGO = true
            
            model.brandColor = RGB(154, 154, 154)
            model.brandFont = .font(fontSize: 12)
            
            model.appNameHidden = true
//            model.appNameColor = .black
//            model.appNameFont = .font(fontSize: 23, fontName: .PingFSemibold)
//            model.appNameOffsetY = 5
            
            model.numberColor = .black
            model.numberFont = .font(fontSize: 24, fontName: .PingFSemibold)
            model.numberOffsetY = 0
                        
            model.logBtnText = "一键登录";
            model.logBtnTextFont = .font(fontSize: 18)
            model.logBtnTextColor = .white
            model.logBtnOffsetY = 10
            model.logBtnRadius = 10
            model.logBtnUsableBGColor = HC_MAIN_COLOR
            model.logBtnUnusableBGColor = .gray
            model.logBtnLeading = 40
            model.logBtnHeight = 48
                        
            model.swithAccHidden = true
            
            model.stringBeforeDefaultPrivacyText = "登录即同意"
            model.defaultPrivacyName = "《中国联通服务协议》"
//            model.stringBeforeAppFPrivacyText = "《爱乐孕用户服务协议》"
//            model.stringBeforeAppSPrivacyText = "《隐私政策》"
//            model.stringAfterPrivacy = "自定义位置4"
//            model.stringAfterAppName = "自定义位置5"
            model.appFPrivacyText = "《爱乐孕用户服务协议》"
            model.appFPrivacyUrl = "http://www.baidu.com"
            model.appSPrivacyText = "《隐私政策》"
            model.appSPrivacyUrl = "https://ileyun.ivfcn.com/cms/alyyhxy.html"
            model.checkBoxHidden = false
            model.checkBoxNormalImg = UIImage(named: "login_unselected_agree")
            model.checkBoxCheckedImg = UIImage(named: "login_selected_agree")
            model.privacyColor = RGB(57, 129, 247)
            model.privacyTextColor  = RGB(154, 154, 154)

            model.loadingText = "请稍后"
                        
//            //动画
//            //用法一
//            model.modalTransitionStyle = .flipHorizontal
//            //
//            //用法二
//            //        CATransition *animation = [CATransition animation];
//            //        animation.duration = 0.5;
//            //        animation.type = @"cube";
//            //        animation.subtype = kCATransitionFromBottom;
//            //        model.presentTransition = animation;
//            //        model.dismissTransition = animation;
            
            
            
            ZUOAuthManager.getInstance()?.customUI(withParams: model, topCustomViews: { [weak self] in
//                guard let strongSelf = self else { return }
                if let customView = $0 {
                    let titleLabel = UILabel(frame: .init(x: (customView.width - 160) / 2, y: 30, width: 160, height: 35))
                    titleLabel.font = .font(fontSize: 32, fontName: .PingFSemibold)
                    titleLabel.text = "登录爱乐孕"
                    titleLabel.textColor = .black
                    titleLabel.backgroundColor = .white
                    
                    let subTitleLabel = UILabel(frame: .init(x: titleLabel.x, y: titleLabel.frame.maxY + 10, width: 84, height: 15))
                    subTitleLabel.font = .font(fontSize: 14)
                    subTitleLabel.text = "为爱孕育生命"
                    subTitleLabel.textColor = RGB(51, 51, 51)
                    subTitleLabel.backgroundColor = .white

                    let icon = UIImageView(frame: .init(x: subTitleLabel.frame.maxX + 5, y: subTitleLabel.y, width: 18, height: 15))
                    icon.image = UIImage(named: "login_title_icon")

                    
                    customView.addSubview(titleLabel)
                    customView.addSubview(subTitleLabel)
                    customView.addSubview(icon)
                }
            }, bottomCustomViews: {
                if let customView = $0 {
                    let leftLine = UIView()
                    leftLine.backgroundColor = RGB(229, 229, 229)
                    
                    let platformRemindLabel = UILabel()
                    platformRemindLabel.text = "其它方式登录"
                    platformRemindLabel.font = .font(fontSize: 14)
                    platformRemindLabel.textColor = RGB(43, 43, 43)
                    
                    let rightLine = UIView()
                    rightLine.backgroundColor = RGB(229, 229, 229)

                    let wchatLoginButton = UIButton()
                    wchatLoginButton.setImage(UIImage(named: "wchat_login"), for: .normal)
                    
                    let phoneLoginButton = UIButton()
                    phoneLoginButton.backgroundColor = RGB(125, 189, 245)
                    phoneLoginButton.layer.cornerRadius = 25
                    phoneLoginButton.clipsToBounds = true
                    
                    let tempSize = platformRemindLabel.sizeThatFits(.init(width: CGFloat(MAXFLOAT), height: 20))
                    let lineW: CGFloat = (customView.width - tempSize.width - 20 * 2 - 40 * 2) / 2.0
                    leftLine.frame = .init(x: 40, y: customView.height - 160, width: lineW, height: 1)
                    platformRemindLabel.frame = .init(x: leftLine.frame.maxX + 20, y: leftLine.y - 10, width: tempSize.width, height: 20)
                    rightLine.frame = .init(x: platformRemindLabel.frame.maxX + 20, y: leftLine.frame.minY, width: lineW, height: 1)
                    
                    phoneLoginButton.frame = .init(x: (customView.width - 100 - 80) / 2, y: platformRemindLabel.frame.maxY + 15, width: 50, height: 50)
                    wchatLoginButton.frame = .init(x: phoneLoginButton.frame.maxX + 80, y: phoneLoginButton.y, width: 50, height: 50)

                    
                    customView.addSubview(leftLine)
                    customView.addSubview(platformRemindLabel)
                    customView.addSubview(rightLine)
                    customView.addSubview(wchatLoginButton)
                    customView.addSubview(phoneLoginButton)
                }
            })
        }
        return model
    }
    
        
    @objc private func stopLogining() {
        DispatchQueue.main.async {
            ZUOAuthManager.getInstance()?.interruptTheCULoginFlow(false, ifDisapperTheShowingLoginPage: true, cancelTheNextAuthorizationPageToPullUp: false)
        }
    }

    private func login(viewController: UIViewController) {
        ZUOAuthManager.getInstance()?.login(NSObject().visibleViewController!, timeout: 15, resultListener: { res in
            PrintLog(res)
        })
    }
}

//extension HCAppDelegate: UniLoginDelegate {
//
//    func ctccCustomBtnClick(_ senderTag: String) {
//        PrintLog(senderTag)
//    }
//
//}
