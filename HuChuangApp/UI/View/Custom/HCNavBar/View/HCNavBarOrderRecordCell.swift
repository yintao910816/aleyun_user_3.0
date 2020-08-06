//
//  HCNavBarOrderRecordCell.swift
//  HuChuangApp
//
//  Created by yintao on 2020/7/21.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

let HCNavBarOrderRecordCell_identifier = "HCNavBarOrderRecordCell"
class HCNavBarOrderRecordCell: UICollectionViewCell {
    
    private var colorBgView: UIView!
    private var contentTextLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        colorBgView = UIView()
        colorBgView.backgroundColor = RGB(246, 246, 246)
        colorBgView.layer.cornerRadius = 5
        colorBgView.layer.borderWidth = 1
        colorBgView.layer.borderColor = UIColor.clear.cgColor
        
        contentTextLabel = UILabel()
        contentTextLabel.font = .font(fontSize: 14)
        contentTextLabel.textColor = RGB(61, 55, 68)
        contentTextLabel.textAlignment = .center
        
        addSubview(colorBgView)
        addSubview(contentTextLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var model: HCNavBarOrderRecordModel! {
        didSet {
            contentTextLabel.text = model.title
            if model.isSelected {
                colorBgView.backgroundColor = RGB(254, 229, 231)
                colorBgView.layer.borderColor = HC_MAIN_COLOR.cgColor
                contentTextLabel.textColor = HC_MAIN_COLOR
            }else {
                colorBgView.backgroundColor = RGB(246, 246, 246)
                colorBgView.layer.borderColor = UIColor.clear.cgColor
                contentTextLabel.textColor = RGB(61, 55, 68)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        colorBgView.frame = bounds
        contentTextLabel.frame = bounds
    }
}
