//
//  HCCollectionViewController.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/19.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCCollectionViewController: BaseViewController {

    private var slideCtrl: TYSlideMenuController!
    private var doctorCtrl: HCMyDoctorViewController!
    private var classCtrl: HCMyClassViewController!
    private var informationCtrl: HCMyInformationViewController!
    
    override func setupUI() {
        navigationItem.title = "关注收藏"
        
        slideCtrl = TYSlideMenuController()
        addChild(slideCtrl)
        view.addSubview(slideCtrl.view)

        doctorCtrl = HCMyDoctorViewController()
        doctorCtrl.cellDidSelected = { [unowned self] in
            let url = APIAssistance.consultationHome(with: $0.id, unitId: $0.unitId)
            self.navigationController?.pushViewController(BaseWebViewController.createWeb(url: url,
                                                                                          title: $0.name,
                                                                                          needUnitId: false),
                                                          animated: true)
        }

        classCtrl = HCMyClassViewController()
        informationCtrl = HCMyInformationViewController()
        
        slideCtrl.menuItems = TYSlideItemModel.createAttentionStoreData()
        slideCtrl.menuCtrls = [doctorCtrl, classCtrl, informationCtrl]
        
        slideCtrl.pageScroll = { [weak self] page in
//            self?.viewModel.requestTodayListSubject.onNext(page)
        }
    }
    
    override func rxBind() {

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        slideCtrl.view.frame = .init(x: 0, y: 0, width: view.width, height: view.height)
    }
}
