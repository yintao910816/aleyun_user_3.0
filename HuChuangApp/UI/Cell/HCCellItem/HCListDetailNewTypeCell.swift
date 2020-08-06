//
//  HCListDetailNewTypeCell.swift
//  HuChuangApp
//
//  Created by yintao on 2019/9/30.
//  Copyright © 2019 sw. All rights reserved.
//  箭头在右边文字的左边

import UIKit

public let HCListDetailNewTypeCell_identifier = "HCListDetailNewTypeCell"

class HCListDetailNewTypeCell: HCListDetailCell {

    override func loadView() {
        super.loadView()
        
        detailTitleLabel.snp.remakeConstraints {
            $0.right.equalTo(-15)
            $0.centerY.equalTo(contentView.snp.centerY)
        }
        
        arrowImgV.snp.remakeConstraints {
            $0.right.equalTo(detailTitleLabel.snp.left).offset(-5)
            $0.centerY.equalTo(contentView.snp.centerY)
        }
    }
    
}
