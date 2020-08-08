//
//  HCVerifyViewController.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/7.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCVerifyViewController: BaseViewController {

    private var containerView: HCVerifyViewContainer!
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func setupUI() {
        let topArea = LayoutSize.fitTopArea + 87
        containerView = HCVerifyViewContainer.init(frame: .init(x: 0, y: topArea,
                                                                width: view.width,
                                                                height: view.height - topArea - LayoutSize.bottomVirtualArea))
        view.addSubview(containerView)
        
        containerView.finishInput = { [weak self] in
            PrintLog($0)
            self?.dismiss(animated: true, completion: nil)
        }
    }
    
    override func rxBind() {
        
    }
}
