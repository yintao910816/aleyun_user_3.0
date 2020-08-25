//
//  HCAreaCell.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/25.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

public let HCAreaCell_identifier = "HCAreaCell"
public let HCAreaCell_height: CGFloat = 45

class HCAreaCell: UITableViewCell {

    private var titleLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configContent(title: String, titleColor: UIColor, backgroundColor: UIColor? = nil) {
        titleLabel.text = title
        titleLabel.textColor = titleColor
        self.backgroundColor = backgroundColor == nil ? .clear : backgroundColor
    }
    
    private func initUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        titleLabel = UILabel()
        titleLabel.font = .font(fontSize: 15)
        titleLabel.backgroundColor = .clear
        titleLabel.textAlignment = .center
        addSubview(titleLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.frame = .init(x: 20, y: 0, width: width - 40, height: height)
    }
}
