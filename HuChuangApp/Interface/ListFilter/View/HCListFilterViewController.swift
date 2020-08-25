//
//  HCListFilterViewController.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/25.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

enum HCListFilterMode {
    /// 排序方式
    case sorted
    /// 咨询类型
    case consultType
}

class HCListFilterViewController: UIViewController {

    private var mode: HCListFilterMode = .sorted
    
    private var container: HCListFilterContainer!
    
    public var commitCallBack: ((HCListFilterModel?)->())?

    init(mode: HCListFilterMode) {
        super.init(nibName: nil, bundle: nil)
        self.mode = mode
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()

        container = HCListFilterContainer.init(frame: view.bounds)
        view.addSubview(container)
        
        container.commitCallBack = { [weak self] in
            self?.commitCallBack?($0)
            self?.excuteAnimotion()
        }
        
        container.dismissCallBack = { [weak self] in self?.excuteAnimotion() }
        
        switch mode {
        case .sorted:
            container.datasource = HCListFilterSectionModel.createExpertConsultationSortedData()
        case .consultType:
            container.datasource = HCListFilterSectionModel.createExpertConsultationTypeData()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        container.frame = view.bounds
    }
    
}

extension HCListFilterViewController {
    
    public func excuteAnimotion() {
        container.excuteAnimotion { [weak self] in
            if $0 {
                self?.view.removeFromSuperview()
                self?.removeFromParaentViewController()
            }
        }
    }

}
