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
    }
    
    override var model: HCListCellItem! {
        didSet {
            super.model = model
            
            detailIconImgV.layer.cornerRadius = (model.cellHeight - 20) / 2.0

            if model.detailIcon.count > 0 {
                if model.iconType == .network {
                    detailIconImgV.setImage(model.detailIcon)
                }else if model.iconType == .userIcon {
                    detailIconImgV.setImage(model.detailIcon, .userIconWomen)
                }else {
                    detailIconImgV.image = UIImage(named: model.detailIcon)
                }
            }else {
                detailIconImgV.image = nil
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if model.detailIcon.count > 0 {
            if detailIconImgV.superview == nil {
                contentView.addSubview(detailIconImgV)
            }
            let imgVHeight: CGFloat = height - 20
            detailIconImgV.frame = .init(x: arrowImgV.x - 5 - imgVHeight,
                                         y: 10,
                                         width: imgVHeight,
                                         height: imgVHeight)
        }else {
            detailIconImgV.removeFromSuperview()
        }
    }
}
