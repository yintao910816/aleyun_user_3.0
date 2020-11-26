//
//  HCServerMsgCell.swift
//  HuChuangApp
//
//  Created by yintao on 2020/11/26.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

public let HCServerMsgCell_identifier = "HCServerMsgCell"
public let HCServerMsgCell_height: CGFloat = 98

class HCServerMsgCell: UITableViewCell {

    private var titleLabel: UILabel!
    private var timeLabel: UILabel!
    private var contentLabel: UILabel!
    private var topView: UIView!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        titleLabel = UILabel()
        titleLabel.textColor = RGB(51, 51, 51)
        titleLabel.font = .font(fontSize: 16)
        
        timeLabel = UILabel()
        timeLabel.textColor = RGB(204, 204, 204)
        timeLabel.font = .font(fontSize: 11)

        contentLabel = UILabel()
        contentLabel.textColor = RGB(153, 153, 153)
        contentLabel.font = .font(fontSize: 12)
        contentLabel.numberOfLines = 2
        
        topView = UIView()
        topView.backgroundColor = RGB(243, 243, 243)

        addSubview(titleLabel)
        addSubview(timeLabel)
        addSubview(contentLabel)
        addSubview(topView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public var model: HCMessageItemModel! {
        didSet {
            titleLabel.text = model.name
            timeLabel.text = model.date
            contentLabel.text = model.content
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
                
        topView.frame = .init(x: 0, y: 0, width: width, height: 8)
        
        let timeSize = timeLabel.sizeThatFits(.init(width: CGFloat(MAXFLOAT), height: 15))
        timeLabel.frame = .init(x: width - 25 - timeSize.width,
                                y: topView.frame.maxY + 22,
                                width: timeSize.width,
                                height: 15)

        let titleLabelW: CGFloat = timeLabel.x - 25 - 13
        titleLabel.frame = .init(x: 25,
                                 y: topView.frame.maxY + 15,
                                 width: titleLabelW,
                                 height: 23)
        
        contentLabel.frame = .init(x: titleLabel.x,
                                   y: titleLabel.frame.maxY + 5,
                                   width: width - 50,
                                   height: 35)
    }
}
