//
//  HCShareWebViewController.swift
//  HuChuangApp
//
//  Created by yintao on 2020/11/27.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCShareWebViewController: BaseWebViewController {
    
    private var viewModel: HCShareWebViewModel!
    private var shareModel: HCShareDataModel!
    private var mode: HCShareMode = .article
    private var isAddRightItems: Bool = true
    
//    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
//        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//
//        navBarColor = HC_MAIN_COLOR
//        (navigationController as? BaseNavigationController)?.backItemInterface = .red
//    }
    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func setupUI() {
        super.setupUI()
        
        title = shareModel.title
        
        if isAddRightItems {
            addRightItems()
        }
    }
    
    override func rxBind() {
        super.rxBind()
        
        let storeDriver = storeButton.rx.tap.asDriver()
            .map{ [unowned self] in !self.storeButton.isSelected }
        
        viewModel = HCShareWebViewModel.init(input: (shareModel: shareModel, mode: mode),
                                             tap: (storeDriver: storeDriver,
                                                   shareDriver: shareButton.rx.tap.asDriver()))
        
        viewModel.storeEnable.asDriver()
            .drive(storeButton.rx.isUserInteractionEnabled)
            .disposed(by: disposeBag)
        
        viewModel.articleStatusObser.asDriver()
            .skip(0)
            .drive(onNext: { [weak self] data in
                self?.storeButton.isSelected = data.status
//                self?.storeButton.setTitle("\(data.store)", for: .normal)
            })
            .disposed(by: disposeBag)
        
        viewModel.reloadSubject.onNext(Void())
    }
    
    public class func configParameters(mode: HCShareMode,
                                       model: HCShareDataModel,
                                       needUnitId: Bool = true,
                                       isAddRightItems: Bool = true) ->[String: Any] {
        return ["model": model, "mode": mode, "needUnitId": needUnitId, "isAddRightItems": isAddRightItems]
    }
    
    override func prepare(parameters: [String : Any]?) {
        shareModel = (parameters!["model"] as! HCShareDataModel)
        mode = (parameters!["mode"] as! HCShareMode)
        
        if let add = parameters!["isAddRightItems"] as? Bool {
            isAddRightItems = add
        }
        
        super.prepare(parameters: ["url": shareModel.href])
    }
}
