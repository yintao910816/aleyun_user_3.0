//
//  HCMineEmptyConsultCell.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/8.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

public let HCMineEmptyConsultCell_identifier = "HCMineEmptyConsultCell"
public let HCMineEmptyConsultCell_height: CGFloat = 90

class HCMineEmptyConsultCell: UICollectionViewCell {
   
    private var titleLabel: UILabel!
    private var actionButton: UIButton!
    
    public var action: (()->())?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.frame = .init(x: (width - 112) / 2.0, y: 15, width: 112, height: 20)
        actionButton.frame = .init(x: (width - 70) / 2.0, y: titleLabel.frame.maxY + 10, width: 70, height: 30)
    }
}

extension HCMineEmptyConsultCell {
    
    private func initUI() {
        titleLabel = UILabel()
        titleLabel.font = .font(fontSize: 14)
        titleLabel.textColor = RGB(153, 153, 153)
        titleLabel.text = "没有进行中的服务"
        titleLabel.textAlignment = .center
        
        actionButton = UIButton()
        actionButton.titleLabel?.font = .font(fontSize: 15)
        actionButton.setTitleColor(HC_MAIN_COLOR, for: .normal)
        actionButton.backgroundColor = RGB(255, 232, 239)
        actionButton.layer.borderColor = HC_MAIN_COLOR.cgColor
        actionButton.layer.borderWidth = 0.5
        actionButton.layer.cornerRadius = 4
        actionButton.clipsToBounds = true
        actionButton.setTitle("去咨询", for: .normal)
        actionButton.addTarget(self, action: #selector(actionEvent), for: .touchUpInside)
        
        addSubview(titleLabel)
        addSubview(actionButton)
    }
    
    @objc private func actionEvent() {
        action?()
    }
}
