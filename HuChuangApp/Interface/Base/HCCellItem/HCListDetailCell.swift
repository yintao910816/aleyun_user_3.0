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

        detailTitleLabel.snp.makeConstraints {
            $0.right.equalTo(arrowImgV.snp.left).offset(-5)
            $0.centerY.equalTo(contentView.snp.centerY)
            $0.width.equalTo(contentView.snp.width).multipliedBy(0.45)
        }
    }
    
    override var model: HCListCellItem! {
        didSet {
            super.model = model
            
            detailTitleLabel.text = model.detailTitle
            detailTitleLabel.textColor = model.detailTitleColor
        }
    }
}
