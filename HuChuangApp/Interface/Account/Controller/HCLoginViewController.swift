//
//  HCLoginViewController.swift
//  HuChuangApp
//
//  Created by sw on 02/02/2019.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit
import RxSwift

class HCLoginViewController: BaseViewController {
    
    private var containerView: HCLoginViewContainer!
    
    private var viewModel: HCLoginViewModel!
    
    @IBAction func actions(_ sender: UIButton) {
        if sender.tag == 1000 {
            let webVC = BaseWebViewController()
            webVC.url = "https://ileyun.ivfcn.com/cms/alyyhxy.html"
            navigationController?.pushViewController(webVC, animated: true)
        }else if sender.tag == 1001 {
            sender.isSelected = !sender.isSelected
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func setupUI() {
        let topArea = LayoutSize.fitTopArea + 87
        containerView = HCLoginViewContainer.init(frame: .init(x: 0, y: topArea,
                                                               width: view.width,
                                                               height: view.height - topArea - LayoutSize.bottomVirtualArea))
        view.addSubview(containerView)
//        #if DEBUG
//        accountInputOutlet.text = "13995631675"
//        //        accountInputOutlet.text = "15717102067"
//        //        accountInputOutlet.text = "13244762499"
//        passInputOutlet.text  = "8888"
//        #else
//        accountInputOutlet.text = userDefault.loginPhone
//        #endif

    }
    
    override func rxBind() {
        viewModel = HCLoginViewModel.init(input: containerView.phoneTf.rx.text.orEmpty.asDriver(),
                                          tap: (codeTap: containerView.getCodeButton.rx.tap.asDriver(),
                                                agreeTap: Observable.just(true).asDriver(onErrorJustReturn: true)))
    }
    
}
