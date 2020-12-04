//
//  HCListDetailButtonCell.swift
//  HuChuangApp
//
//  Created by sw on 2019/10/19.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit

public let HCListDetailButtonCell_identifier = "HCListDetailButtonCell"

class HCListDetailButtonCell: HCBaseListCell {

    private var detailButton: UIButton!
    
    override func loadView() {
        arrowImgV.isHidden = true
        
        detailButton = UIButton()
        detailButton.setTitleColor(.black, for: .normal)
        detailButton.titleLabel?.font = .font(fontSize: 14)
        
        contentView.addSubview(detailButton)
    }

    override var model: HCListCellItem! {
        didSet {
            super.model = model
            
            detailButton.setTitle(model.detailButtonTitle, for: .normal)
            detailButton.setTitleColor(model.detailTitleColor, for: .normal)            
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        detailButton.frame = .init(x: width - 15 - model.detailButtonSize.width,
                                   y: (height - model.detailButtonSize.height) / 2,
                                   width: model.detailButtonSize.width,
                                   height: model.detailButtonSize.height)
    }
}
