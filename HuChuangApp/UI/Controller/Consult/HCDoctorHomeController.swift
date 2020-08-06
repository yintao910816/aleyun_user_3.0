//
//  HCDoctorHomeController.swift
//  HuChuangApp
//
//  Created by yintao on 2019/12/30.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit

class HCDoctorHomeController: BaseWebViewController {

    private var doctorModel: HCDoctorItemModel!
    private var viewModel: HCDoctorHomeViewModel!
    
    private var shareButton: UIButton!

//    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
//        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//        
//        navBarColor = HC_MAIN_COLOR
//        (navigationController as? BaseNavigationController)?.backItemInterface = .red
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func setupUI() {
        super.setupUI()
        navigationItem.title = "医生主页"
        
        shareButton = UIButton()
        shareButton.frame = .init(x: 0, y: 0, width: 30, height: 30)
        shareButton.setImage(UIImage(named: "button_share_black"), for: .normal)
//        shareButton.sizeToFit()

        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: shareButton)
    }
    
    override func rxBind() {
        super.rxBind()
        
        viewModel = HCDoctorHomeViewModel.init(doctorModel: doctorModel,
                                               shareDriver: shareButton.rx.tap.asDriver())
    }

    override func prepare(parameters: [String : Any]?) {
        doctorModel = (parameters!["model"] as! HCDoctorItemModel)
        super.prepare(parameters: ["url": "\(H5Type.doctorHome.getLocalUrl())&userId=\(doctorModel.userId)"])
    }
}

extension HCDoctorHomeController {
    
    public class func preprare(model: HCDoctorItemModel) ->[String: HCDoctorItemModel] {
        return ["model": model]
    }
}
