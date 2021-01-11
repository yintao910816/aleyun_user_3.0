//
//  HCMyInServerController.swift
//  HuChuangApp
//
//  Created by yintao on 2020/11/26.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCMyInServerController: BaseViewController {

    private var container: HCMyInServerContainer!
    private var progressServices: [HCPersonalProgressServiceModel] = []
    
    override func setupUI() {
        navigationItem.title = "进行中的服务"
        
        container = HCMyInServerContainer(frame: view.bounds)
        view.addSubview(container)
        
        container.progressServices = progressServices
        
        container.excuteMyServerAction = { 
            let url = APIAssistance.consultationChat(with: $0.consultId)
            HCMineViewController.push(HCConsultChatController.self, ["url": url, "title": $0.userName])
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        container.frame = view.bounds
    }
    
    override func prepare(parameters: [String : Any]?) {
        if let models = parameters!["models"] as? [HCPersonalProgressServiceModel] {
            progressServices = models
        }
    }
}
