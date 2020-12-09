//
//  HCForecastRemindView.swift
//  HuChuangApp
//
//  Created by yintao on 2020/12/10.
//  Copyright © 2020 sw. All rights reserved.
//  显示预测日期提示

import UIKit

class HCForecastRemindView: UIView {

    private var titleLabel: UILabel!
    private var detailLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel = UILabel()
        titleLabel.textColor = RGB(51, 51, 51)
        titleLabel.font = .font(fontSize: 18)
        titleLabel.numberOfLines = 0
        
        detailLabel = UILabel()
        detailLabel.textColor = RGB(161, 161, 161)
        detailLabel.font = .font(fontSize: 14)
        detailLabel.text = "无法记录未来的日子"
        detailLabel.numberOfLines = 0

        addSubview(titleLabel)
        addSubview(detailLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var model: TYCalendarItem? {
        didSet {
            titleLabel.text = model?.remindText
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let layoutW: CGFloat = width - 50
        let titleSize = titleLabel.sizeThatFits(.init(width: layoutW, height: CGFloat.greatestFiniteMagnitude))
        let detailSize = detailLabel.sizeThatFits(.init(width: layoutW, height: CGFloat.greatestFiniteMagnitude))

        titleLabel.frame = .init(x: (width - titleSize.width) / 2,
                                 y: (height - titleSize.height - 10 - detailSize.height) / 2,
                                 width: titleSize.width,
                                 height: titleSize.height)
        
        detailLabel.frame = .init(x: (width - detailSize.width) / 2,
                                  y: titleLabel.frame.maxY + 10,
                                  width: detailSize.width,
                                  height: detailSize.height)
    }
}
