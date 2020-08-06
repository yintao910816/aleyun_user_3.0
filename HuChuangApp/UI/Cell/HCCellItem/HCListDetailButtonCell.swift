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
        
        detailButton.snp.makeConstraints {
            $0.right.equalTo(contentView).offset(-15)
            $0.size.equalTo(CGSize.init(width: 100, height: 25))
            $0.centerY.equalTo(contentView.snp.centerY)
        }
    }

    override var model: HCListCellItem! {
        didSet {
            super.model = model
            
            detailButton.setTitle(model.detailButtonTitle, for: .normal)
            detailButton.setTitleColor(model.detailTitleColor, for: .normal)
            
            detailButton.snp.updateConstraints {
                $0.size.equalTo(model.detailButtonSize)
            }
        }
    }

}
