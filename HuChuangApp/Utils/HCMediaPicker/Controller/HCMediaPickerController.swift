//
//  HCMediaPickerController.swift
//  HuChuangApp
//
//  Created by yintao on 2020/11/5.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCMediaPickerController: UIViewController {

    private var contentView: UIView!
    private var mediaView: HCPickerMediaView!
    private var menuView: HCPickerMenuView!
    private var cancelButton: UIButton!
    
    public var pickerMenuData: [HCPickerMenuSectionModel] = []
    
    public var selectedImage:((UIImage)->())?
    public var selectedMenu:((HCPickerMenuItemModel)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView = UIView.init(frame: .init(x: 0, y: view.height - 280, width: view.width, height: 280))
        contentView.backgroundColor = RGB(247, 247, 247)

        mediaView = HCPickerMediaView.init(frame: .init(x: 0, y: 0, width: contentView.width, height: 105))
        menuView = HCPickerMenuView.init(frame: .init(x: 0, y: mediaView.frame.maxY + 10, width: contentView.width, height: 110))
        
        cancelButton = UIButton.init(frame: .init(x: 0, y: menuView.frame.maxY, width: contentView.width, height: 50))
        cancelButton.setTitle("取消", for: .normal)
        cancelButton.titleLabel?.font = .font(fontSize: 16)
        cancelButton.setTitleColor(RGB(86, 91, 110), for: .normal)
        cancelButton.backgroundColor = .white
        cancelButton.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)
        
        let line = UIView.init(frame: .init(x: 0, y: 0, width: cancelButton.width, height: 0.5))
        line.backgroundColor = RGB(153, 153, 153)
        
        view.addSubview(contentView)
        contentView.addSubview(mediaView)
        contentView.addSubview(menuView)
        contentView.addSubview(cancelButton)
        cancelButton.addSubview(line)
        
        menuView.sectionDatas = pickerMenuData
        
        HCAssetManager.getAllAsset { [weak self] in self?.mediaView.mediaDatas = $0 }
        
        menuView.selectedMenu = { [weak self] item in
            self?.dismiss(animated: true) {
                self?.selectedMenu?(item)
            }
        }
        mediaView.selectedImage = { [weak self] image in
            self?.dismiss(animated: true) {
                self?.selectedImage?(image)
            }
        }
    }
    
    @objc private func dismissAction() {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        contentView.frame = .init(x: 0, y: view.height - 280, width: view.width, height: 280)
    }
}
