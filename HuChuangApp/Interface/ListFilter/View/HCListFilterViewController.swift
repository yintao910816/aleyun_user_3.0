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
    /// 生殖中心筛选
    case szzx
}

class HCListFilterViewController: UIViewController {

    private var mode: HCListFilterMode = .sorted
    private var selectedIdentifier: String?
    
    private var container: HCListFilterContainer!
    
    public var commitCallBack: ((HCListFilterModel?)->())?

    init(mode: HCListFilterMode, selectedIdentifier: String? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.mode = mode
        self.selectedIdentifier = selectedIdentifier
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
            container.datasource = HCListFilterSectionModel.createExpertConsultationSortedData(selectedIdentifier: selectedIdentifier)
        case .consultType:
            container.datasource = HCListFilterSectionModel.createExpertConsultationTypeData(selectedIdentifier: selectedIdentifier)
        case .szzx:
            container.datasource = HCListFilterSectionModel.createSZZXData(selectedIdentifier: selectedIdentifier)
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
