//
//  HCShareWebViewController.swift
//  HuChuangApp
//
//  Created by yintao on 2020/11/27.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCShareWebViewController: HCConsultChatController {
    
    private var viewModel: HCShareWebViewModel!
    private var shareModel: HCShareDataModel!
    private var mode: HCShareMode = .article
    
    public var storeButton: TYClickedButton!
    public var shareButton: TYClickedButton!
    
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
    
    override func configList() -> [String] {
        var names = super.configList()
        names.append(contentsOf: ["updateCollectStatus", "updateShareStatus"])
        return names
    }

    public var isAddRightItems: Bool = true {
        didSet {
            if isAddRightItems {
                configRightItems()
            }
        }
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

extension HCShareWebViewController {
        
    override func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        super.userContentController(userContentController, didReceive: message)

        if message.name == "updateCollectStatus" {
            if let json = message.body as? String,
               let flag = json.transform()["updateCollectStatus"] as? Bool {
                reloadStoreItem(isAdd: flag)
            }else {
                reloadStoreItem(isAdd: false)
            }
        }else if message.name == "updateShareStatus" {
            if let json = message.body as? String,
               let flag = json.transform()["updateShareStatus"] as? Bool{
                reloadShareItem(isAdd: flag)
            }else {
                reloadShareItem(isAdd: false)
            }
        }
    }

}

extension HCShareWebViewController {
    
    private func configRightItems() {
        storeButton = TYClickedButton.init(type: .custom)
        storeButton.frame = .init(x: 0, y: 0, width: 30, height: 30)
        storeButton.setEnlargeEdge(top: 10, bottom: 10, left: 10, right: 10)
        storeButton.backgroundColor = .clear
        storeButton.setImage(UIImage(named: "button_collect_unsel"), for: .normal)
        storeButton.setImage(UIImage(named: "button_collect_sel"), for: .selected)
        //        storeButton.titleLabel?.font = .font(fontSize: 10)
        //        storeButton.imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 10)
        //        storeButton.sizeToFit()

        shareButton = TYClickedButton.init(type: .custom)
        shareButton.frame = .init(x: 0, y: 0, width: 30, height: 30)
        shareButton.setEnlargeEdge(top: 10, bottom: 10, left: 10, right: 10)
        shareButton.setImage(UIImage(named: "button_share_black"), for: .normal)
    }
    
    public func addRightItems() {
        navigationItem.rightBarButtonItems = [UIBarButtonItem.init(customView: shareButton),
                                              UIBarButtonItem.init(customView: storeButton)]
    }
    
    public func reloadShareItem(isAdd: Bool) {
        var hasStore: Bool = false
        for item in navigationItem.rightBarButtonItems ?? [] {
            if item.customView == storeButton {
                hasStore = true
                break
            }
        }

        if isAdd {
            if hasStore {
                navigationItem.rightBarButtonItems = [UIBarButtonItem.init(customView: shareButton),
                                                      UIBarButtonItem.init(customView: storeButton)]
            }else {
                navigationItem.rightBarButtonItems = [UIBarButtonItem.init(customView: shareButton)]
            }
        }else {
            if hasStore {
                navigationItem.rightBarButtonItems = [UIBarButtonItem.init(customView: storeButton)]
            }else {
                navigationItem.rightBarButtonItems = []
            }
        }
    }
    
    public func reloadStoreItem(isAdd: Bool) {
        var hasShare: Bool = false
        for item in navigationItem.rightBarButtonItems ?? [] {
            if item.customView == shareButton {
                hasShare = true
                break
            }
        }

        if isAdd {
            if hasShare {
                navigationItem.rightBarButtonItems = [UIBarButtonItem.init(customView: shareButton),
                                                      UIBarButtonItem.init(customView: storeButton)]
            }else {
                navigationItem.rightBarButtonItems = [UIBarButtonItem.init(customView: storeButton)]
            }
        }else {
            if hasShare {
                navigationItem.rightBarButtonItems = [UIBarButtonItem.init(customView: shareButton)]
            }else {
                navigationItem.rightBarButtonItems = []
            }
        }
    }

}
