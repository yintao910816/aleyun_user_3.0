//
//  HCMyRecordViewController.swift
//  HuChuangApp
//
//  Created by yintao on 2020/8/23.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCMyRecordViewController: BaseViewController {
    
    private var slideCtrl: TYSlideMenuController!
    private var picConsultRecordCtrl: HCPicConsultRecordViewController!
    private var videoConsultRecordCtrl: HCVideoConsultRecordViewController!
    private var accurateReservationRecordCtrl: HCAccurateReservationRecordController!

    override func setupUI() {
        navigationItem.title = "我的记录"
        
        slideCtrl = TYSlideMenuController()
        addChild(slideCtrl)
        view.addSubview(slideCtrl.view)
        
        picConsultRecordCtrl = HCPicConsultRecordViewController()
        picConsultRecordCtrl.pushH5CallBack = {
            let url = APIAssistance.consultationChat(with: $0.consultId)
            HCMineViewController.push(HCConsultChatController.self, ["url": url, "title": $0.userName])

        }

        videoConsultRecordCtrl = HCVideoConsultRecordViewController()
        videoConsultRecordCtrl.pushH5CallBack = { 
            let url = APIAssistance.consultationChat(with: $0.consultId)
            HCMineViewController.push(HCConsultChatController.self, ["url": url, "title": $0.userName])
        }

        accurateReservationRecordCtrl = HCAccurateReservationRecordController()
        accurateReservationRecordCtrl.pushH5CallBack = {
            let url = APIAssistance.consultationChat(with: $0.consultId)
            HCMineViewController.push(HCConsultChatController.self, ["url": url, "title": $0.userName])
        }

        slideCtrl.menuItems = TYSlideItemModel.createMyRecordData()
        slideCtrl.menuCtrls = [picConsultRecordCtrl, videoConsultRecordCtrl, accurateReservationRecordCtrl]
        
        slideCtrl.pageScroll = { [weak self] page in
//            self?.viewModel.changeMenuSignal.onNext(page)
        }
    }
        
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        slideCtrl.view.frame = .init(x: 0, y: 0, width: view.width, height: view.height)
    }
}
