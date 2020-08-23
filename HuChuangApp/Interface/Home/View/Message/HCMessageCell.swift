//
//  HCMessageCell.swift
//  HuChuangApp
//
//  Created by yintao on 2020/8/23.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

public let HCMessageCell_identifier = "HCMessageCell"
public let HCMessageCell_height: CGFloat = 75

class HCMessageCell: UICollectionViewCell {
    
    private var avatar: UIImageView!
    private var titleLabel: UILabel!
    private var timeLabel: UILabel!
    private var contentLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var model: HCMessageItemModel! {
        didSet {
            avatar.setImage(model.headPath, .messageSystom)
            titleLabel.text = model.name
            timeLabel.text = model.date
            contentLabel.text = model.content
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        avatar.frame = .init(x: 10, y: (height - 50) / 2.0, width: 50, height: 50)
        
        let timeSize = timeLabel.sizeThatFits(.init(width: CGFloat(MAXFLOAT), height: 15))
        timeLabel.frame = .init(x: width - 15 - timeSize.width, y: avatar.y + 7, width: timeSize.width, height: 15)

        let titleLabelW: CGFloat = timeLabel.x - avatar.frame.maxX - 13 - 13
        titleLabel.frame = .init(x: avatar.frame.maxX + 13,
                                 y: avatar.y + 3,
                                 width: titleLabelW,
                                 height: 23)
        
        contentLabel.frame = .init(x: titleLabel.x,
                                   y: avatar.frame.maxY - 17 - 3,
                                   width: timeLabel.x - avatar.frame.maxX - 13,
                                   height: 17)
    }
}

extension HCMessageCell {
    
    private func initUI() {
        backgroundColor = .white
        layer.cornerRadius = 5
        clipsToBounds = true
        
        avatar = UIImageView()
        avatar.contentMode = .scaleAspectFill
        avatar.layer.cornerRadius = 25
        avatar.clipsToBounds = true
        
        titleLabel = UILabel()
        titleLabel.textColor = RGB(51, 51, 51)
        titleLabel.font = .font(fontSize: 16)
        
        timeLabel = UILabel()
        timeLabel.textColor = RGB(204, 204, 204)
        timeLabel.font = .font(fontSize: 11)

        contentLabel = UILabel()
        contentLabel.textColor = RGB(153, 153, 153)
        contentLabel.font = .font(fontSize: 12)

        addSubview(avatar)
        addSubview(titleLabel)
        addSubview(timeLabel)
        addSubview(contentLabel)
    }
}
