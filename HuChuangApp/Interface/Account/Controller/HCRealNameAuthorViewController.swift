//
//  HCRealNameAuthorViewController.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/17.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCRealNameAuthorViewController: BaseViewController {

    private var containerView: HCRealNameAuthorContainer!
    private var viewModel: HCRealNameAuthorViewModel!
    
    override func setupUI() {
        title = "实名认证"
        
        containerView = HCRealNameAuthorContainer.init(frame: .init(x: 0, y: 0, width: view.width, height: view.height))
        view.addSubview(containerView)
    }
    
    override func rxBind() {
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        containerView.frame = view.bounds
    }

}
