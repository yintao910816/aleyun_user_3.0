//
//  BaseWebViewController.swift
//  HuChuangApp
//
//  Created by sw on 13/02/2019.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit
import JavaScriptCore

class BaseWebViewController: BaseViewController, VMNavigation {

    var url: String = ""
    var redirect_url: String?

    private var context : JSContext?
    private var webTitle: String?
    
    private var bridge: WebViewJavascriptBridge!
    
    private var locationManager: HCLocationManager!
    
    private lazy var hud: NoticesCenter = {
        return NoticesCenter()
    }()
    
    private lazy var webView: UIWebView = {
        let w = UIWebView()
        w.backgroundColor = .clear
        w.scrollView.bounces = false
        w.delegate = self
        return w
    }()
    
    override func prepare(parameters: [String : Any]?) {
        guard let _url = parameters?["url"] as? String else {
            return
        }
        
        webTitle = (parameters?["title"] as? String)
        url = _url
    }
    
    func webCanBack(_ goBack: Bool = true) -> Bool {
        if goBack == true {
            webView.goBack()
        }
        return webView.canGoBack
    }
    
    func requestData(){
        if url.count == 0 { return }
        
        if url.contains("OnlineAuther") {
            locationManager = HCLocationManager()
            locationManager.locationSubject
                .subscribe(onNext: { [weak self] location in
                    guard let strongSelf = self else { return }
                    strongSelf.hud.noticeLoading()

                    PrintLog("位置：\(location)")
                    if location != nil {
                        if strongSelf.url.contains("?") {
                            strongSelf.url = strongSelf.url + "&lat=\(location!.coordinate.latitude)&lng=\(location!.coordinate.longitude)"
                        }else {
                            strongSelf.url = strongSelf.url + "?lat=\(location!.coordinate.latitude)&lng=\(location!.coordinate.longitude)"
                        }
                    }
                    
                    if let requestUrl = URL.init(string: strongSelf.url) {
                        let request = URLRequest.init(url: requestUrl)
                        strongSelf.webView.loadRequest(request)
                    }else {
                        strongSelf.hud.failureHidden("url错误")
                    }
                })
                .disposed(by: disposeBag)
        }else {
            hud.noticeLoading()

            if let requestUrl = URL.init(string: url) {
                let request = URLRequest.init(url: requestUrl)
                webView.loadRequest(request)
            }else {
                hud.failureHidden("url错误")
            }
        }
    }
    
    func reloadData() {
        if let requestUrl = URL.init(string: url) {
            let request = URLRequest.init(url: requestUrl)
            webView.loadRequest(request)
        }else {
            hud.failureHidden("url错误")
        }
    }

    func updateWebCns(bottom: CGFloat, top: CGFloat) {
        webView.snp.updateConstraints{ $0.edges.equalTo(UIEdgeInsets.init(top: top, left: 0, bottom: bottom, right: 0)) }
    }
    
    override func setupUI() {
        view.backgroundColor = .white
        if #available(iOS 11, *) {
            webView.scrollView.contentInsetAdjustmentBehavior = .never
        }

        view.addSubview(webView)
        
//        setupBridge()
        
        if webTitle?.count ?? 0 > 0 { navigationItem.title = webTitle }
        
        webView.snp.makeConstraints{ $0.edges.equalTo(UIEdgeInsets.zero) }
        
        requestData()
    }

    private func setupBridge() {
        WebViewJavascriptBridge.enableLogging()
        bridge = WebViewJavascriptBridge.init(forWebView: webView)
        bridge.setWebViewDelegate(self)
        bridge.registerHandler("appInfo") { [weak self] (data, responseCallBack) in
            PrintLog("appInfo - \(data) ")
            responseCallBack?(self?.stringForAppInfo() ?? "")
        }
    }
    
    private func setTitle() {
        if let title = webView.stringByEvaluatingJavaScript(from: "document.title"){
            navigationItem.title = title
        }
    }

}

extension BaseWebViewController: UIWebViewDelegate{
   
    
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool{
        
        let s = request.url?.absoluteString
        PrintLog("shouldStartLoadWith -- \(String(describing: s))")
        
        if s == "app://reload"{
            webView.loadRequest(URLRequest.init(url: URL.init(string: url)!))
            return false
        }
        
        let urlString = request.url?.absoluteString
        let rs = "\(HCHelper.AppKeys.appSchame.rawValue)://".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        if urlString?.contains("wx.tenpay.com") == true && urlString?.contains("redirect_url=\(rs)") == false
        {
            let sep = s!.components(separatedBy: "redirect_url=")
            redirect_url = sep.last//sep.first(where: { !$0.contains("wx.tenpay.com") })
            let reloadUrl = sep.first(where: { $0.contains("wx.tenpay.com") })!.appending("&redirect_url=\(rs)")
            if let _url = URL.init(string: reloadUrl) {
                var mRequest = URLRequest.init(url: _url)
                mRequest.setValue("\(HCHelper.AppKeys.appSchame.rawValue)://", forHTTPHeaderField: "Referer")
                webView.loadRequest(mRequest)
            }
            return false
            
        }
        
        return true
    }
    
    func webViewDidStartLoad(_ webView: UIWebView){
        PrintLog("didStartLoad")
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView){
        PrintLog("didFinishLoad")
        hud.noticeHidden()
        
        context = (webView.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as! JSContext)

        // 设置标题
        let changeTitle: @convention(block) () ->() = {[weak self] in
            guard let params = JSContext.currentArguments() else { return }
            PrintLog("h5 调用 - changeTitle")
            
            DispatchQueue.main.async {
                for idx in 0..<params.count {
                    if idx == 0 {
                        let _title = ((params[0] as AnyObject).toString()) ?? ""
                        PrintLog("h5 调用 - changeTitle -- \(_title)")
                        self?.navigationItem.title = _title
                    }
                }
            }
        }
        context?.setObject(unsafeBitCast(changeTitle, to: AnyObject.self), forKeyedSubscript: "changeTitle" as NSCopying & NSObjectProtocol)

        //使用优惠券跳转医生列表 - openActivity(String name, String csId)
        let openActivity: @convention(block) () ->() = {
            DispatchQueue.main.async {
                PrintLog("h5 调用 - openActivity")
                BaseWebViewController.sbPush("HCMain", "expertConsultCtrl")
            }
        }
        context?.setObject(unsafeBitCast(openActivity, to: AnyObject.self), forKeyedSubscript: "openActivity" as NSCopying & NSObjectProtocol)

        let backHomeFnApi: @convention(block) () ->() = {[weak self]in
            DispatchQueue.main.async {
                PrintLog("h5 调用 - backHomeFnApi")

                self?.navigationController?.popToRootViewController(animated: true)
            }
        }
        context?.setObject(unsafeBitCast(backHomeFnApi, to: AnyObject.self), forKeyedSubscript: "backHomeFnApi" as NSCopying & NSObjectProtocol)

        let backToList: @convention(block) () ->() = { [weak self] in
            DispatchQueue.main.async {
                PrintLog("h5 调用 - backToList")

                if self?.webView.canGoBack == true {
                    self?.webView.goBack()
                }
            }
        }
        context?.setObject(unsafeBitCast(backToList, to: AnyObject.self), forKeyedSubscript: "backToList" as NSCopying & NSObjectProtocol)

        let userInvalid: @convention(block) () ->() = { [weak self] in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                PrintLog("h5 调用 - userInvalid")
                HCHelper.presentLogin(presentVC: strongSelf.navigationController, {
                    strongSelf.navigationController?.popToRootViewController(animated: true)
                })
            }
        }
        context?.setObject(unsafeBitCast(userInvalid, to: AnyObject.self), forKeyedSubscript: "userInvalid" as NSCopying & NSObjectProtocol)

        let isApp: @convention(block) () ->() = { [weak self] in
            PrintLog("暂时不用 - isApp")
        }
        context?.setObject(unsafeBitCast(isApp, to: AnyObject.self), forKeyedSubscript: "isApp" as NSCopying & NSObjectProtocol)

        let nativeOpenURL: @convention(block) () ->() = { [weak self] in
            PrintLog("暂时不用 - nativeOpenURL")
        }
        context?.setObject(unsafeBitCast(nativeOpenURL, to: AnyObject.self), forKeyedSubscript: "nativeOpenURL" as NSCopying & NSObjectProtocol)

        context?.exceptionHandler = {(context, value)in
            PrintLog(value)
        }

        let appInfo: @convention(block) () ->(String) = { [weak self] in
            PrintLog("h5 调用 - appInfo")

            return self?.stringForAppInfo() ?? ""
        }
        context?.setObject(unsafeBitCast(appInfo, to: AnyObject.self), forKeyedSubscript: "appInfo" as NSCopying & NSObjectProtocol)

        // js调用，刷新首页
        let getUserInfoFnApi: @convention(block) () ->() = {
            DispatchQueue.main.async {
                PrintLog("h5 调用 - getUserInfoFnApi")

                NotificationCenter.default.post(name: NotificationName.UserInterface.jsReloadHome, object: nil)
            }
        }
        context?.setObject(unsafeBitCast(getUserInfoFnApi, to: AnyObject.self), forKeyedSubscript: "getUserInfoFnApi" as NSCopying & NSObjectProtocol)

        /// 返回上一个界面 （如个人中心提交反馈成功）
        let backFnApi: @convention(block) () ->() = {[weak self]in
            DispatchQueue.main.async {
                PrintLog("h5 调用 - backFnApi")

                self?.navigationController?.popViewController(animated: true)
            }
        }
        context?.setObject(unsafeBitCast(backFnApi, to: AnyObject.self), forKeyedSubscript: "backFnApi" as NSCopying & NSObjectProtocol)

//        setTitle()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error){
        hud.failureHidden(error.localizedDescription)
    }
}

extension BaseWebViewController {
    
    private func stringForAppInfo() ->String {
        let infoDic: [String : String] = ["app_version": Bundle.main.version,
                                          "app_name": Bundle.main.appName,
                                          "app_packge": Bundle.main.bundleIdentifier,
                                          "app_sign": "",
                                          "app_type": "ios"]
        guard JSONSerialization.isValidJSONObject(infoDic) else { return "" }
        guard let jsonData =  try? JSONSerialization.data(withJSONObject: infoDic, options: []) else { return "" }
        guard let jsonString =  String.init(data: jsonData, encoding: .utf8) else { return "" }
        PrintLog("app信息：\(jsonString)")
        return jsonString
    }
}
