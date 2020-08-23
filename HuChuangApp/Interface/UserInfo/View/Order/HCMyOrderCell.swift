//
//  HCMyOrderCell.swift
//  HuChuangApp
//
//  Created by yintao on 2020/8/23.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

public let HCMyOrderCell_identifier: String = "HCMyOrderCell"
public let HCMyOrderCell_height: CGFloat = 100

class HCMyOrderCell: UITableViewCell {

    private var titleLabel: UILabel!
    private var timeLabel: UILabel!
    private var inlidateLabel: UILabel!
    private var priceLabel: UILabel!
    private var lineView: UIView!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var model: HCMyOrderItemModel! {
        didSet {
            
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let priceSize = priceLabel.sizeThatFits(.init(width: CGFloat(MAXFLOAT), height: 46))
        priceLabel.frame = .init(x: width - 15 - priceLabel.width,
                                 y: (height - 46) / 2,
                                 width: priceSize.width,
                                 height: 46)
        
        let layoutW: CGFloat = priceLabel.x - 15 - 15
        
        titleLabel.frame = .init(x: 15, y: 12, width: layoutW, height: 23)
        timeLabel.frame = .init(x: titleLabel.x, y: titleLabel.frame.maxY + 4, width: layoutW, height: 20)
        inlidateLabel.frame = .init(x: titleLabel.x, y: timeLabel.frame.maxY + 4, width: layoutW, height: 20)
        lineView.frame = .init(x: titleLabel.x, y: height - 0.5, width: width, height: 0.5)
    }
}

extension HCMyOrderCell {
    
    private func initUI() {
        titleLabel = UILabel()
        titleLabel.textColor = RGB(51, 51, 51)
        titleLabel.font = .font(fontSize: 16)
        
        timeLabel = UILabel()
        timeLabel.textColor = RGB(153, 153, 153)
        timeLabel.font = .font(fontSize: 14)

        inlidateLabel = UILabel()
        inlidateLabel.textColor = RGB(255, 79, 120)
        inlidateLabel.font = .font(fontSize: 14)

        priceLabel = UILabel()
        priceLabel.textColor = RGB(255, 79, 120)
        priceLabel.font = .font(fontSize: 20, fontName: .PingFSemibold)
        
        lineView = UIView()
        lineView.backgroundColor = RGB(243, 243, 243)
        
        addSubview(titleLabel)
        addSubview(timeLabel)
        addSubview(inlidateLabel)
        addSubview(priceLabel)
        addSubview(lineView)
    }
}
