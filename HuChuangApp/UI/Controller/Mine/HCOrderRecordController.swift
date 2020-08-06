//
//  HCOrderRecordController.swift
//  HuChuangApp
//
//  Created by yintao on 2020/7/21.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCOrderRecordController: BaseWebViewController {

    private var titleView: HCNavBarTitleView!
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        titleView.titleContentView.disAppear()
    }
    
    override func setupUI() {
        super.setupUI()
        
        titleView = HCNavBarTitleView.init(frame: .init(x: 0, y: 0, width: view.size.width - 120, height: 44), model: .orderRecord)
        navigationItem.titleView = titleView
        
        titleView.titleContentView.titleClicked = {
            
        }
    }
}

extension HCOrderRecordController {
    
    override func webViewDidFinishLoad(_ webView: UIWebView) {
        super.webViewDidFinishLoad(webView)
        
    }
}
