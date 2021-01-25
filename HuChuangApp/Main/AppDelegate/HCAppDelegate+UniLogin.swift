//
//  HCAppDelegate+UniLogin.swift
//  HuChuangApp
//
//  Created by sw on 2021/1/8.
//  Copyright © 2021 sw. All rights reserved.
//

public enum HCUniLoginEvent {
    case phoneLogin
    case watchLogin
    case tokenLogin
    case error
}

private let AppKey = "1c2f442942496da4a432295d"
private let AppSecret = "84870f31a3fc8ecb68bd432f"

import Foundation

extension HCAppDelegate {
    
    public func startUniLogin(viewController: UIViewController,
                              otherLoginCallBack:@escaping (((HCUniLoginEvent, String))->()),
                              presentCallBack:@escaping (()->())) {
        customFullScreenUI(viewController: viewController, otherLoginCallBack: otherLoginCallBack)
        
        let config = JVAuthConfig()
        config.appKey = AppKey
        JVERIFICATIONService.setup(with: config)
        
        JVERIFICATIONService.getAuthorizationWith(viewController, hide: false, animated: true, timeout: 15*1000, completion: { (result) in
            if let result = result {
                if let token = result["loginToken"] as? String {
//                    if let code = result["code"], let op = result["operator"] {
//                        print("一键登录 result: code = \(code), operator = \(op), loginToken = \(token)")
//                    }
                    JVERIFICATIONService.dismissLoginController(animated: true) {
                        otherLoginCallBack((.tokenLogin, token))
                    }
                }else if let code = result["code"] as? Int, let content = result["content"] {
                    print("一键登录 result: code = \(code), content = \(content)")
                    if code != 6002 {
                        NoticesCenter.alert(message: "一键登录失败: \(code)(\(content))")
                    }
                }
            }else {
                NoticesCenter.alert(message: "一键登录失败: 未知错误")
            }
        }) { (type, content) in
            if let content = content {
                print("一键登录 actionBlock :type = \(type), content = \(content)")
            }

            if type == 2 {
                presentCallBack()
            }
        }
    }
}

extension HCAppDelegate {
    
    func customFullScreenUI(viewController: UIViewController, otherLoginCallBack:@escaping (((HCUniLoginEvent, String))->())) {
        let config = JVUIConfig()
        //导航栏
        config.navCustom = false
        config.navText = NSAttributedString.init(string: "", attributes: nil)
        config.navReturnHidden = false
        config.navReturnImg = UIImage(named: "navigationButtonReturnClick")
        config.navColor = .white
        
        config.shouldAutorotate = true
        config.autoLayout = true
        //弹窗弹出方式
        config.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        //logo
        config.logoHidden = true
        
        //号码栏
        config.numberFont = .font(fontSize: 24, fontName: .PingFSemibold)
        
        let numberConstraintX = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.super, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant:0)
        let numberConstraintY = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.super, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 110)
        let numberConstraintW = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.none, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1, constant:viewController.view.width - 80)
        let numberConstraintH = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.none, attribute: NSLayoutConstraint.Attribute.height, multiplier: 1, constant:33)
        config.numberConstraints = [numberConstraintX!, numberConstraintY!, numberConstraintW!, numberConstraintH!]
        config.numberHorizontalConstraints = config.numberConstraints
        
        //slogan
        config.sloganFont = .font(fontSize: 12)
        config.sloganTextColor = RGB(154, 154, 154)
        
        let sloganConstraintX = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.super, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant:0)
        let sloganConstraintY = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.number, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 7)
        let sloganConstraintW = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.none, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1, constant:viewController.view.width - 80)
        let sloganConstraintH = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.none, attribute: NSLayoutConstraint.Attribute.height, multiplier: 1, constant:20)
        config.sloganConstraints = [sloganConstraintX!, sloganConstraintY!, sloganConstraintW!, sloganConstraintH!]
        config.sloganHorizontalConstraints = config.sloganConstraints
        
        //登录按钮
        config.logBtnText = "一键登录"
        let login_nor_image = UIImage.image(with: RGB(255, 79, 120))
        let login_dis_image = UIImage.image(with: RGB(160, 160, 160))
        let login_hig_image = login_nor_image
        if let norImage = login_nor_image, let disImage = login_dis_image, let higImage = login_hig_image {
            config.logBtnImgs = [norImage, disImage, higImage]
        }
        let loginBtnWidth = viewController.view.width - 80
        let loginBtnHeight: CGFloat = 48.0
        let loginConstraintX = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.super, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant:0)
        let loginConstraintY = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.slogan, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant:20)
        let loginConstraintW = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.none, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1, constant:loginBtnWidth)
        let loginConstraintH = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.none, attribute: NSLayoutConstraint.Attribute.height, multiplier: 1, constant:loginBtnHeight)
        config.logBtnConstraints = [loginConstraintX!, loginConstraintY!, loginConstraintW!, loginConstraintH!]
        config.logBtnHorizontalConstraints = config.logBtnConstraints
        
        //勾选框
        let uncheckedImage = UIImage(named: "login_unselected_agree")
        let checkedImage = UIImage(named: "login_selected_agree")
        let checkViewWidth = uncheckedImage?.size.width ?? 10
        let checkViewHeight = uncheckedImage?.size.height ?? 10
        config.uncheckedImg = uncheckedImage
        config.checkedImg = checkedImage
        let checkViewConstraintX = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.login, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1, constant:0)
        let checkViewConstraintY = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.login, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant:20)
        let checkViewConstraintW = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.none, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1, constant:checkViewWidth)
        let checkViewConstraintH = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.none, attribute: NSLayoutConstraint.Attribute.height, multiplier: 1, constant:checkViewHeight)
        config.checkViewConstraints = [checkViewConstraintX!, checkViewConstraintY!, checkViewConstraintW!, checkViewConstraintH!]
        config.checkViewHorizontalConstraints = config.checkViewConstraints
        
        //隐私
        config.privacyState = false
        config.appPrivacyColor = [RGB(154, 154, 154), RGB(57, 129, 247)]
        config.privacyTextFontSize = 12
        config.privacyTextAlignment = NSTextAlignment.left
        config.appPrivacyOne = ["《爱乐孕用户服务协议》","https://ileyun.ivfcn.com/cms/alyyhxy.html"]
        config.appPrivacyTwo = ["《隐私政策》","https://ileyun.ivfcn.com/cms/0-1073.html"]
        let privacyConstraintX = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.check, attribute: NSLayoutConstraint.Attribute.right, multiplier: 1, constant:5)
        let privacyConstraintX2 = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.right, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.super, attribute: NSLayoutConstraint.Attribute.right, multiplier: 1, constant:-40)
        let privacyConstraintY = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.check, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant:0)
//        let privacyConstraintH = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.none, attribute: NSLayoutConstraint.Attribute.height, multiplier: 1, constant:50)
        config.privacyConstraints = [privacyConstraintX!,privacyConstraintX2!, privacyConstraintY!]
        config.privacyHorizontalConstraints = config.privacyConstraints
        
        //loading
        let loadingConstraintX = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.super, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant:0)
        let loadingConstraintY = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.super, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant:0)
        let loadingConstraintW = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.none, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1, constant:30)
        let loadingConstraintH = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.none, attribute: NSLayoutConstraint.Attribute.height, multiplier: 1, constant:30)
        config.loadingConstraints = [loadingConstraintX!, loadingConstraintY!, loadingConstraintW!, loadingConstraintH!]
        config.loadingHorizontalConstraints = config.loadingConstraints
        
        // 协议页面
        config.agreementNavBackgroundColor = .white
        config.agreementNavReturnImage = UIImage(named: "navigationButtonReturnClick")
        config.agreementNavTextColor = RGB(60, 60, 60)
        
        JVERIFICATIONService.customUI(with: config) { [unowned self] in
            //自定义view, 加到customView上
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
                                
                let platformContainer = UIView()
                platformContainer.backgroundColor = .white
                
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
                phoneLoginButton.setImage(UIImage(named: "phone_login"), for: .normal)
                
                customView.addSubview(titleLabel)
                customView.addSubview(subTitleLabel)
                customView.addSubview(icon)
                customView.addSubview(platformContainer)
                platformContainer.addSubview(leftLine)
                platformContainer.addSubview(platformRemindLabel)
                platformContainer.addSubview(rightLine)
                platformContainer.addSubview(wchatLoginButton)
                platformContainer.addSubview(phoneLoginButton)

                platformContainer.frame = .init(x: 40, y: customView.height - 85 - 50, width: customView.width - 80, height: 85)

                let tempSize = platformRemindLabel.sizeThatFits(.init(width: CGFloat(MAXFLOAT), height: 20))
                let lineW: CGFloat = (platformContainer.width - tempSize.width - 40) / 2.0

                leftLine.frame = .init(x: 0, y: 9, width: lineW, height: 1)
                platformRemindLabel.frame = .init(x: leftLine.frame.maxX + 20, y: 0, width: tempSize.width, height: 20)
                rightLine.frame = .init(x: platformRemindLabel.frame.maxX + 20, y: leftLine.frame.minY, width: lineW, height: 1)
                
                phoneLoginButton.frame = .init(x: (platformContainer.width - 100 - 80) / 2, y: platformRemindLabel.frame.maxY + 15, width: 50, height: 50)
                wchatLoginButton.frame = .init(x: phoneLoginButton.frame.maxX + 80, y: phoneLoginButton.y, width: 50, height: 50)
                
                phoneLoginButton.rx.controlEvent(.touchUpInside)
                    .subscribe(onNext: {
                        JVERIFICATIONService.dismissLoginController(animated: true) {
                            otherLoginCallBack((.phoneLogin, ""))
                        }
                    })
                    .disposed(by: disposeBag)
                
                wchatLoginButton.rx.controlEvent(.touchUpInside)
                    .subscribe(onNext: {
                        JVERIFICATIONService.dismissLoginController(animated: true) {
                            otherLoginCallBack((.watchLogin, ""))
                        }
                    })
                    .disposed(by: disposeBag)
            }
        }
        
    }

}
