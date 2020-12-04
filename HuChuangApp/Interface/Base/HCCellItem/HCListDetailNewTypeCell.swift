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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let tempSize = detailTitleLabel.sizeThatFits(.init(width: 0.45 * width, height: CGFloat.greatestFiniteMagnitude))
        detailTitleLabel.frame = .init(x: width - 15 - tempSize.width,
                                       y: (height - tempSize.height) / 2,
                                       width: tempSize.width,
                                       height: tempSize.height)
        
        arrowImgV.frame = .init(x: detailTitleLabel.x - 5 - 8,
                                y: (height - 15)/2,
                                width: 8,
                                height: 15)
    }
}
