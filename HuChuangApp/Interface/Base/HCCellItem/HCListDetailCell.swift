//
//  HCListDetailCell.swift
//  HuChuangApp
//
//  Created by yintao on 2019/9/30.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit

public let HCListDetailCell_identifier = "HCListDetailCell"

class HCListDetailCell: HCBaseListCell {

    public var detailTitleLabel: UILabel!

    override func loadView() {
        detailTitleLabel = UILabel()
        detailTitleLabel.textAlignment = .right
        detailTitleLabel.font = .font(fontSize: 14)
        contentView.addSubview(detailTitleLabel)
    }
    
    override var model: HCListCellItem! {
        didSet {
            super.model = model
            
            detailTitleLabel.text = model.detailTitle
            detailTitleLabel.textColor = model.detailTitleColor
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let tempSize = detailTitleLabel.sizeThatFits(.init(width: width * 0.45, height: CGFloat.greatestFiniteMagnitude))
        detailTitleLabel.frame = .init(x: arrowImgV.x - 5 - tempSize.width,
                                       y: (height - tempSize.height) / 2,
                                       width: tempSize.width,
                                       height: tempSize.height)
    }
}
