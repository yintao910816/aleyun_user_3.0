//
//  HCPicConsultRecordCell.swift
//  HuChuangApp
//
//  Created by yintao on 2020/8/23.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

public let HCConsultRecordCell_identifier = "HCPicConsultRecordCell"
public let HCConsultRecordCell_height: CGFloat = 80

class HCConsultRecordCell: UITableViewCell {
    
    private var avatar: UIImageView!
    private var nameLabel: UILabel!
    private var timeLabel: UILabel!
    private var contentLabel: UILabel!
    private var lineView: UIView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var model: HCConsultItemModel! {
        didSet {
            avatar.setImage(model.headPath)
            nameLabel.text = model.userName
            timeLabel.text = model.createDate.timeSeprate2()
            contentLabel.text = model.content
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        avatar.frame = .init(x: 15, y: (height - 50) / 2.0, width: 50, height: 50)
        
        let timeSize = timeLabel.sizeThatFits(.init(width: CGFloat(MAXFLOAT), height: 15))
        timeLabel.frame = .init(x: width - 15 - timeSize.width, y: avatar.y + 7, width: timeSize.width, height: 15)
        
        nameLabel.frame = .init(x: avatar.frame.maxX + 13,
                                y: avatar.y + 3,
                                width: timeLabel.x - avatar.frame.maxX - 13,
                                height: 15)
        
        contentLabel.frame = .init(x: nameLabel.x,
                                   y: nameLabel.frame.maxY + 7,
                                   width: timeLabel.frame.minX - avatar.frame.maxX - 24,
                                   height: 17)
        
        lineView.frame = .init(x: 0, y: height - 0.5, width: width, height: 0.5)
    }
}

extension HCConsultRecordCell {
    
    private func initUI() {
        avatar = UIImageView()
        avatar.contentMode = .scaleAspectFill
        avatar.layer.cornerRadius = 25
        avatar.clipsToBounds = true
        
        nameLabel = UILabel()
        nameLabel.textColor = RGB(51, 51, 51)
        nameLabel.font = .font(fontSize: 16)
        
        timeLabel = UILabel()
        timeLabel.textColor = RGB(204, 204, 204)
        timeLabel.font = .font(fontSize: 11)
        
        contentLabel = UILabel()
        contentLabel.textColor = RGB(153, 153, 153)
        contentLabel.font = .font(fontSize: 12)
        
        lineView = UIView()
        lineView.backgroundColor = RGB(243, 243, 243)
        
        addSubview(avatar)
        addSubview(nameLabel)
        addSubview(timeLabel)
        addSubview(contentLabel)
        addSubview(lineView)
    }
}
