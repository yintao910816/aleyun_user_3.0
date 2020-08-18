//
//  HCMenuHorizontalCell.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/12.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

public let HCMenuHorizontalCell_identifier = "HCMenuHorizontalCell"
public let HCMenuHorizontalCell_height: CGFloat = 40

class HCMenuHorizontalCell: UICollectionViewCell {
    
    private var icon: UIImageView!
    private var title: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public var mode: HCFunctionsMenuModel! {
        didSet {
            icon.setImage(mode.iconPath)
            title.text = mode.name
        }
    }
    
    private func initUI() {
        icon = UIImageView()
        
        title = UILabel()
        title.textColor = RGB(51, 51, 51)
        title.font = .font(fontSize: 14)
        
        addSubview(icon)
        addSubview(title)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        icon.frame = .init(x: 0, y: (height - 15) / 2.0, width: 15, height: 15)
        title.frame = .init(x: icon.frame.maxX + 5, y: (height - 20) / 2.0, width: width - icon.frame.maxX - 5 - 5, height: 20)
    }

}
