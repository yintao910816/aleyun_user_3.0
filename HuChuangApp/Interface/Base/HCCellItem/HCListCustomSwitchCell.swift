//
//  HCListCustomSwitchCell.swift
//  HuChuangApp
//
//  Created by yintao on 2020/12/16.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

public let HCListCustomSwitchCell_identifier = "HCListCustomSwitchCell"

class HCListCustomSwitchCell: HCBaseListCell {
    
    private var switchView: HCSwitch!
    
    override func loadView() {
        switchView = HCSwitch()
        switchView.addTarget(self, action: #selector(changeValue(switch:)), for: .valueChanged)
//        switchView.onTintColor = RGB(245, 102, 149)
        contentView.addSubview(switchView)
    }
    
    @objc private func changeValue(switch: UISwitch) {
        clickedSwitchCallBack?((switchView.isOn, model))
    }
    
    override var model: HCListCellItem! {
        didSet {
            super.model = model
            
            switchView.isOn = model.isOn
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if arrowImgV.superview != nil {
            arrowImgV.removeFromSuperview()
        }
        
        switchView.frame = .init(x: width - 15 - HCSwitchNormalSize.width,
                                 y: (height - HCSwitchNormalSize.height) / 2,
                                 width: HCSwitchNormalSize.width,
                                 height: HCSwitchNormalSize.height)
    }
    
}
