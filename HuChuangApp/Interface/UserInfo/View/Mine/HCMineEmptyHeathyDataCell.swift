//
//  HCMineEmptyHeathyDataCell.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/8.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

public let HCMineEmptyHeathyDataCell_identifier = "HCMineEmptyHeathyDataCell"
public let HCMineEmptyHeathyDataCell_height: CGFloat = 82

class HCMineEmptyHeathyDataCell: UICollectionViewCell {
    
    private var titleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel = UILabel()
        titleLabel.textColor = RGB(51, 51, 51)
        titleLabel.font = .font(fontSize: 14)
        titleLabel.textAlignment = .center
        titleLabel.text = "添加档案>"
        titleLabel.layer.borderColor = RGB(231, 231, 231).cgColor
        titleLabel.layer.borderWidth = 1
        titleLabel.clipsToBounds = true
        addSubview(titleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.frame = bounds
    }
}
