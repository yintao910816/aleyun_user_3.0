//
//  HCListDetailIconCell.swift
//  HuChuangApp
//
//  Created by yintao on 2019/9/30.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit

public let HCListDetailIconCell_identifier = "HCListDetailIconCell"

class HCListDetailIconCell: HCBaseListCell {

    private var detailIconImgV: UIImageView!

    override func loadView() {
        detailIconImgV = UIImageView()
        detailIconImgV.backgroundColor = .clear
        detailIconImgV.clipsToBounds = true
        contentView.addSubview(detailIconImgV)
        
        detailIconImgV.snp.makeConstraints {
            $0.top.equalTo(10)
            $0.bottom.equalTo(-10)
            $0.right.equalTo(arrowImgV.snp.left).offset(-5)
            $0.width.equalTo(detailIconImgV.snp.height)
        }
    }
    
    override var model: HCListCellItem! {
        didSet {
            super.model = model
            
            detailIconImgV.layer.cornerRadius = (model.cellHeight - 20) / 2.0

            if model.detailIcon.count > 0 {
                if model.iconType == .network {
                    detailIconImgV.setImage(model.detailIcon)
                }else if model.iconType == .userIcon {
                    detailIconImgV.setImage(model.detailIcon, .userIcon)
                }else {
                    detailIconImgV.image = UIImage(named: model.detailIcon)
                }
            }else {
                detailIconImgV.image = nil
            }
        }
    }
}
