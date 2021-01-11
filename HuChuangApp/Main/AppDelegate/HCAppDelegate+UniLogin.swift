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
    
    public func setupUniLogin(viewController: UIViewController) {
        UniLogin.shareInstance().initWithAppId(AppId, secretKey: AppSecret) { [weak self] (flag, msg) in
            PrintLog("一键登录初始化结果：\(flag) \(msg)")
            if flag {
                guard let strongSelf = self else {
                    return
                }
                
                let config = YMCustomConfig()
                config.cuccModel = strongSelf.createCUCCModel(viewController: viewController, isMini: false)
                config.ctccMini = false
                
                UniLogin.shareInstance().openAtuhVC(with: config, timeout: 30, controller: viewController) { (mobile, msg, result) in
                    DispatchQueue.main.async {
                        if let m = mobile, m.count > 0 {
                            NoticesCenter.alert(message: "一键登录成功：\(m)")
                        }else {
                            NoticesCenter.alert(message: msg ?? "一键登录失败")
    //                        UniLogin.shareInstance().closeViewControler(animated: false, completion: nil)
                        }
                    }
                }
            }else {
                NoticesCenter.alert(message: msg)
            }
        }
    }
}

extension HCAppDelegate {
    
    /// 联通demo设置
    private func createCUCCModel(viewController: UIViewController, isMini: Bool) ->ZOAUCustomModel {
        let model = ZOAUCustomModel()
        if (isMini) {
            model.navBarHidden = true
            model.logoImg = UIImage(named: "Logo")
            let topCustomHeight: CGFloat = 330
            model.controllerType = .PresentController
            model.backgroundColor = UIColor.white//[UIColor colorWithWhite:0 alpha:0];
            let bgImg = imageWithColor(color: RGB(255, 248, 220), size: .init(width: viewController.view.size.width, height: viewController.view.size.height - topCustomHeight + 30), viewController: viewController)
            model.bgImage = bgImg
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
            model.navReturnImg = UIImage(named: "back_1")
            
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
            
            
            // 第二种
            /**
             model.controllerType = PresentController;
                     model.backgroundColor=[UIColor colorWithWhite:0 alpha:0];
             model.bgImage = [UIImage imageNamed:@"1234"];
             model.modalPresentationStyle = UIModalPresentationOverFullScreen;
             model.navBarHidden = YES;
             model.privacyOffsetY = 100;
             model.stringAfterPrivacy = @"\n";
             model.ifAddPrivacyPageBG = YES;
             model.navReturnImg = [UIImage imageNamed:@"back_1"];
             //        dispatch_async(dispatch_get_main_queue(), ^{
             //            UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithTitle:@"close" style:0 target:self action:@selector(stopLogining:)];
             //            model.navControl = rightItem;
             //        });
                 
             [[ZUOAuthManager getInstance]customUIWithParams:model topCustomViews:^(UIView *customView) {
                     
                 UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
                 button.frame = CGRectMake(250, 60, 30, 30);
                 button.backgroundColor = UIColor.redColor;
                 [button setTitle:@"关闭" forState:UIControlStateNormal];
                 [button addTarget:self action:@selector(stopLogining) forControlEvents:UIControlEventTouchUpInside];
                 [customView addSubview:button];
                     
             } bottomCustomViews:nil];
             */
        }else {
            model.modalPresentationStyle = .fullScreen
            model.statusBarStyle = .lightContent
            model.statusBarStyleInWebView = .default
            model.navBarHidden = false
            model.backgroundColor = .gray
            //        model.bgImage = [self createImageWithColor:UIColor.yellowColor];
            
            model.navBottomLineHidden = true
            model.navBgColor = .orange
            model.navText = "自定义标题"
            model.navTextFont = .font(fontSize: 15, fontName: .PingFSemibold)
            model.navTextColor = .blue
            
            model.topCustomHeight = 5
            model.logoImg = UIImage(named: "Logo")
            model.logoWidth = 100
            model.logoHeight = 100
            model.logBtnOffsetY = 0
            
            model.appNameHidden = false
            model.appNameColor = .red
            model.appNameFont = .font(fontSize: 23, fontName: .PingFSemibold)
            model.appNameOffsetY = 5
            
            model.numberColor = .red
            model.numberFont = .font(fontSize: 40, fontName: .PingFSemibold)
            model.numberOffsetY = 5
            
            model.brandColor = .red
            model.brandFont = .font(fontSize: 10, fontName: .PingFSemibold)
            model.brandOffsetY = 5
            
            model.logBtnText = "自定义登录按钮标题";
            model.logBtnTextFont = .font(fontSize: 30, fontName: .PingFSemibold)
            model.logBtnTextColor = .red
            model.logBtnOffsetY = 5
            model.logBtnRadius = 10
            model.logBtnUsableBGColor = .green
            model.logBtnUnusableBGColor = .lightGray
            model.logBtnLeading = 50
            model.logBtnHeight = 30
            
            model.swithAccTextColor = .blue
            model.swithAccTextFont  = .font(fontSize: 15, fontName: .PingFSemibold)
            model.swithAccOffsetY = 20
            model.swithAccOffsetX = 0
            model.switchText = "自定义其他登录方式按钮"
            
            model.stringBeforeDefaultPrivacyText = "自定义位置1"
            model.defaultPrivacyName = "默认协议"
            model.stringBeforeAppFPrivacyText = "自定义位置2"
            model.stringBeforeAppSPrivacyText = "自定义位置3"
            model.stringAfterPrivacy = "自定义位置4"
            model.stringAfterAppName = "自定义位置5"
            model.appFPrivacyText = "《自定义服务协议1》"
            model.appFPrivacyUrl = "http://www.baidu.com"
            model.appSPrivacyText = "《自定义服务协议2》"
            model.appSPrivacyUrl = "http://www.baidu.com"
            model.checkBoxHidden = true
            model.loadingText = "请稍后"
            model.privacyColor = .orange
            model.privacyTextColor  = .red
            
            //        model.interfaceOrientation = UIInterfaceOrientationPortrait;
            
            //动画
            //用法一
            model.modalTransitionStyle = .flipHorizontal
            //
            //用法二
            //        CATransition *animation = [CATransition animation];
            //        animation.duration = 0.5;
            //        animation.type = @"cube";
            //        animation.subtype = kCATransitionFromBottom;
            //        model.presentTransition = animation;
            //        model.dismissTransition = animation;
            
            
            
            ZUOAuthManager.getInstance()?.customUI(withParams: model, topCustomViews: { [weak self] in
//                guard let strongSelf = self else { return }
                if let customView = $0 {
                    let button = UIButton.init(type: .custom)
                    button.frame = .init(x: 250, y: 0, width: 60, height: 15)
                    button.backgroundColor = UIColor.red
                    button.setTitle("自定义按钮", for: .normal)
//                    button.addTarget(strongSelf, action: #selector(strongSelf.stopLogining), for: .touchUpInside)
                    customView.addSubview(button)
                }
            }, bottomCustomViews: nil)
        }
        return model
    }
    
    
    // 根据颜色生成UIImage
    private func imageWithColor(color: UIColor, size: CGSize, viewController: UIViewController) ->UIImage {
        // 开始画图的上下文
        UIGraphicsBeginImageContext(viewController.view.frame.size)
        // 设置背景颜色
        color.set()
        // 设置填充区域
        UIRectFill(.init(x: 0, y: 0, width: size.width, height: size.height))
        
        // 返回UIImage
        let image = UIGraphicsGetImageFromCurrentImageContext()
        // 结束上下文
        UIGraphicsEndImageContext()
        //改变该图片的方向
        let backImage = UIImage.init(cgImage: image!.cgImage!, scale: image!.scale, orientation: .down)
        
        return backImage
    }
    
    @objc private func stopLogining() {
        DispatchQueue.main.async {
            ZUOAuthManager.getInstance()?.interruptTheCULoginFlow(false, ifDisapperTheShowingLoginPage: true, cancelTheNextAuthorizationPageToPullUp: false)
        }
        NoticesCenter.alert(message: "CANCLE_LOGIN")
    }

}
