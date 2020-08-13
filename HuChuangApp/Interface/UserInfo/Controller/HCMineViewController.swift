//
//  HCMineViewController.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/8.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCMineViewController: BaseViewController {

    private var containerView: HCMineViewContainer!
    
    override func viewWillAppear(_ animated: Bool) {        
        navigationController?.navigationBar.barTintColor = RGB(255, 244, 251)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : RGB(51, 51, 51),
                                                                   NSAttributedString.Key.font : UIFont.font(fontSize: 18, fontName: .PingFRegular)]
    }
    
    override func setupUI() {
        containerView = HCMineViewContainer.init(frame: .init(x: 0, y: 0, width: view.width, height: view.height))
        view.addSubview(containerView)
    }
    
    override func rxBind() {
        
        containerView.excuteAction = { [weak self] in
            switch $0 {
            case .verify:
                self?.navigationController?.pushViewController(HCAccountSettingViewController(), animated: true)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        containerView.frame = view.bounds
    }
}
