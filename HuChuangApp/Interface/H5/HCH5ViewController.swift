//
//  HCH5ViewController.swift
//  HuChuangApp
//
//  Created by sw on 2021/1/11.
//  Copyright © 2021 sw. All rights reserved.
//

import UIKit
import JavaScriptCore

class HCH5ViewController: BaseViewController {

    private var redirect_url: String?

    private var correctURL: String = ""
    private var webTitle: String?

    private var locationManager: HCLocationManager!
    
    override func setupUI() {
        if webTitle?.count ?? 0 > 0 { navigationItem.title = webTitle }

        view.addSubview(webView)
        
        NotificationCenter.default.rx.notification(NotificationName.Pay.wChatPayFinish)
            .subscribe(onNext: { [weak self] _ in
                if let redirect = self?.redirect_url, let redirectURL = URL(string: redirect) {
                    let request = URLRequest.init(url: redirectURL)
                    self?.webView.load(request)
                }
                self?.redirect_url = nil
            })
            .disposed(by: disposeBag)
        
        requestData()
    }
           
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        for item in configList() {
            PrintLog("添加交互方法：\(item)")
            webView.configuration.userContentController.add(self, name: item)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    
        for item in configList() {
            PrintLog("移除交互方法：\(item)")
            webView.configuration.userContentController.removeScriptMessageHandler(forName: item)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        webView.frame = view.bounds
    }
    
    //MARK: 配置交互方法
    private func webConfig() ->WKWebViewConfiguration {
        PrintLog("注册交互方法")
        
        let config = WKWebViewConfiguration()
        
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        config.preferences = preferences
                
        config.userContentController = WKUserContentController()
        
        let js = "appInfo('\(stringForAppInfo())')"
        PrintLog("appInfo JS: \(js)")
        let script = WKUserScript.init(source: js,
                                       injectionTime: .atDocumentStart,
                                       forMainFrameOnly: true)
        config.userContentController.addUserScript(script)
        
        return config
    }
    
    public func configList() ->[String] {
        return ["changeTitle", "backHomeFnApi", "backToList", "userInvalid", "getUserInfoFnApi", "backFnApi"]
    }
    
    //MARK: 参数设置
    public var url: String = "" {
        didSet {
            configURLStr(urlPreStr: url)
        }
    }
    
    public func configURLStr(urlPreStr: String, needUnitId: Bool = true) {
        PrintLog("h5拼接前地址：\(urlPreStr)")

        var userInfoStr = ""
        if let userInfo = HCHelper.share.userInfoModel?.toJSONString(), let encodeInfo = userInfo.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)  {
            userInfoStr = encodeInfo
        }

        if urlPreStr.contains("?") == false {
            correctURL = "\(urlPreStr)?token=\(userDefault.token)&facilityType=APP&t=\(Date.timepStr())"
        }else {
            correctURL = "\(urlPreStr)&token=\(userDefault.token)&facilityType=APP&t=\(Date.timepStr())"
        }

        if userInfoStr.count > 0 {
            correctURL = "\(correctURL)&userInfo=\(userInfoStr)"
        }

        if needUnitId {
            correctURL = "\(correctURL)&unitId=\(userDefault.unitId)"
        }

        PrintLog("h5拼接后地址：\(correctURL)")
    }

    public class func createWeb(url: String, title: String? = nil, needUnitId: Bool = true) ->HCH5ViewController {
        let web = HCH5ViewController()
        web.prepare(parameters: ["url": url, "title": title ?? "", "needUnitId": needUnitId])
        return web
    }

    override func prepare(parameters: [String : Any]?) {
        guard let _url = parameters?["url"] as? String else {
            return
        }
        
        var needUnitId: Bool = true
        if let unid = parameters?["needUnitId"] as? Bool {
            needUnitId = unid
        }
        
        webTitle = (parameters?["title"] as? String)
        
        configURLStr(urlPreStr: _url, needUnitId: needUnitId)
    }
    
    public func requestData(){
        if url.count == 0 && correctURL.count == 0 { return }
        
        if url.contains("OnlineAuther") {
            locationManager = HCLocationManager()
            locationManager.locationSubject
                .subscribe(onNext: { [weak self] location in
                    guard let strongSelf = self else { return }
                    strongSelf.hud.noticeLoading()

                    PrintLog("位置：\(String(describing: location))")
                    if location != nil {
                        if strongSelf.url.contains("?") {
                            strongSelf.correctURL = strongSelf.correctURL + "&lat=\(location!.coordinate.latitude)&lng=\(location!.coordinate.longitude)"
                        }else {
                            strongSelf.correctURL = strongSelf.correctURL + "?lat=\(location!.coordinate.latitude)&lng=\(location!.coordinate.longitude)"
                        }
                    }

                    if let requestUrl = URL.init(string: strongSelf.correctURL) {
                        let request = URLRequest.init(url: requestUrl)
                        strongSelf.webView.load(request)
                    }else {
                        strongSelf.hud.failureHidden("url错误")
                    }
                })
                .disposed(by: disposeBag)
        }else {
            hud.noticeLoading()

            if let requestUrl = URL.init(string: correctURL) {
                let request = URLRequest.init(url: requestUrl)
                webView.load(request)
            }else {
                hud.failureHidden("url错误")
            }
        }
        
    }

    //MARK - lazy
    public lazy var webView: WKWebView = {
        let w = WKWebView(frame: .zero, configuration: webConfig())
        w.backgroundColor = .clear
        w.scrollView.bounces = false
        w.navigationDelegate = self
        w.uiDelegate = self
        return w
    }()
    
    private lazy var payWeb: UIWebView = {
        let w = UIWebView(frame: view.bounds)
        w.backgroundColor = .clear
        w.scrollView.bounces = false
        w.delegate = self
        view.addSubview(w)
        view.bringSubviewToFront(w)
        return w
    }()
    
    public lazy var hud: NoticesCenter = {
        return NoticesCenter()
    }()

}

extension HCH5ViewController: WKNavigationDelegate {
    
    // 决定网页能否被允许跳转    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let s = navigationAction.request.url?.absoluteString
        PrintLog("网页能否被允许跳转 -- \(String(describing: s))")

        if s == "app://reload"{
            payWeb.isHidden = true
            webView.load(URLRequest.init(url: URL.init(string: correctURL)!))
            decisionHandler(.cancel)
            return
        }
        
        let rs = "\(HCHelper.AppKeys.appSchame.rawValue)://".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!

        if s?.contains("wx.tenpay.com") == true && s?.contains("redirect_url=\(rs)") == false
        {
            let sep = s!.components(separatedBy: "redirect_url=")
            redirect_url = sep.last?.removingPercentEncoding//sep.first(where: { !$0.contains("wx.tenpay.com") })
            let reloadUrl = sep.first(where: { $0.contains("wx.tenpay.com") })!.appending("&redirect_url=\(rs)")
            if let _url = URL.init(string: reloadUrl) {
                var mRequest = URLRequest.init(url: _url)
                mRequest.setValue("\(HCHelper.AppKeys.appSchame.rawValue)://", forHTTPHeaderField: "Referer")
//                webView.load(mRequest)
                payWeb.isHidden = false
                payWeb.loadRequest(mRequest)
            }
            decisionHandler(.cancel)
            return
        }
        
        payWeb.isHidden = true
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow)
    }


    // 处理网页开始加载
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        let s = webView.url?.absoluteString
        PrintLog("开始加载 -- \(String(describing: s))")
                
    }
     
    // 处理网页加载失败
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        PrintLog("网页加载失败")
        hud.failureHidden(error.localizedDescription)
    }
     
    // 处理网页内容开始返回
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        PrintLog("理网页内容开始返回")
    }
     
    // 处理网页加载完成
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        PrintLog("网页加载完成")
        hud.noticeHidden()
        
//        webView.evaluateJavaScript("appInfo('\(stringForAppInfo())')") { (res, error) in
//            PrintLog("js调用appInfo：\(res) --- \(error)")
//        }
    }
     
    // 处理网页返回内容时发生的失败
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        PrintLog("网页返回内容失败")
        hud.failureHidden(error.localizedDescription)
    }
     
    // 处理网页进程终止
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        hud.failureHidden("进程断开")
    }
}

extension HCH5ViewController: WKUIDelegate {
    
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {

        if prompt == "appInfo" {
            completionHandler(stringForAppInfo())
        }
    }
}

extension HCH5ViewController: WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        PrintLog("h5调用:\(message.name)  参数:\(message.body)")

        if message.name == "changeTitle", let title = message.body as? String, title.count > 0 {
            webTitle = title
            navigationItem.title = webTitle
        }else if message.name == "backHomeFnApi" {
            navigationController?.popToRootViewController(animated: true)
        }else if message.name == "backToList" {
            if webView.canGoBack == true {
                webView.goBack()
            }
        }else if message.name == "userInvalid" {
            HCHelper.presentLogin(presentVC: navigationController, { [weak self] in
                self?.navigationController?.popToRootViewController(animated: true)
            })
        }else if message.name == "getUserInfoFnApi" {
            // 刷新首页
            NotificationCenter.default.post(name: NotificationName.UserInterface.jsReloadHome, object: nil)
        }else if message.name == "backFnApi" {
            // 返回上一个界面 （如个人中心提交反馈成功）
            navigationController?.popViewController(animated: true)
        }
    }
    
}

extension HCH5ViewController {
    
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

//MARK: 微信支付暂时使用此方法
extension HCH5ViewController: UIWebViewDelegate {
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool{
        return true
    }
    
    func webViewDidStartLoad(_ webView: UIWebView){
        PrintLog("didStartLoad")
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView){
        PrintLog("didFinishLoad")
        hud.noticeHidden()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error){
        hud.failureHidden(error.localizedDescription)
    }

}
