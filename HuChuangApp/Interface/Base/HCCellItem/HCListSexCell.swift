//
//  HCListSexCell.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/17.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCListSexCell: HCBaseListCell {

    private var boyButton: UIButton!
    private var girlButton: UIButton!

    override func loadView() {
        arrowImgV.isHidden = true

        boyButton = UIButton()
        boyButton.setTitle("男", for: .normal)
        boyButton.backgroundColor = RGB(243, 243, 243)
        boyButton.setTitleColor(RGB(51, 51, 51), for: .normal)
        boyButton.layer.cornerRadius = 3
        boyButton.clipsToBounds = true
        boyButton.titleLabel?.font = .font(fontSize: 14)
        
        girlButton = UIButton()
        girlButton.setTitle("男", for: .normal)
        girlButton.backgroundColor = RGB(255, 232, 239)
        girlButton.setTitleColor(RGB(255, 79, 120), for: .normal)
        girlButton.layer.cornerRadius = 3
        girlButton.layer.borderWidth = 0.5
        girlButton.layer.borderColor = RGB(237, 106, 148).cgColor
        girlButton.clipsToBounds = true
        girlButton.titleLabel?.font = .font(fontSize: 14)

        addSubview(boyButton)
        addSubview(girlButton)
        
        girlButton.snp.makeConstraints {
            $0.right.equalTo(contentView).offset(-15)
            $0.size.equalTo(CGSize.init(width: 64, height: 30))
            $0.centerY.equalTo(contentView.snp.centerY)
        }

        boyButton.snp.makeConstraints {
            $0.size.equalTo(girlButton.snp.size)
            $0.right.equalTo(girlButton.snp.left).offset(8)
            $0.centerY.equalTo(contentView.snp.centerY)
        }
    }
    
    override var model: HCListCellItem! {
        didSet {
            super.model = model
            
        }
    }

}
