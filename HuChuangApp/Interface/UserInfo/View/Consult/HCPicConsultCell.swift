//
//  HCPicConsultCell.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/22.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

public let HCPicConsultCell_identifier: String = "HCPicConsultCell"
public let HCPicConsultCell_height: CGFloat = 153

class HCPicConsultCell: UITableViewCell {

    private var avatar: UIImageView!
    private var nameLabel: UILabel!
    private var payStatusLabel: UILabel!
    private var contentLabel: UILabel!
    private var lineView: UIView!
    private var timeDesLabel: UILabel!
    private var actionButton: UIButton!

    public var actionCallBack: ((HCConsultItemModel)->())?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var model: HCConsultItemModel! {
        didSet {
            avatar.setImage(model.headPath, .userIconWomen)
            nameLabel.attributedText = model.nameText
            payStatusLabel.text = model.statusMode.myConsultPayStatusText
            timeDesLabel.text = model.timeText
            actionButton.setTitle(model.statusMode.myConsultButtonText, for: .normal)
            
            if model.consultTypeName == "视频咨询" {
                contentLabel.text = "预约时间  \(model.appointTimeDesc)"
            }else {
                contentLabel.text = model.content
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        avatar.frame = .init(x: 15, y: 15, width: 30, height: 30)
        
        var tempSize: CGSize = payStatusLabel.sizeThatFits(.init(width: CGFloat(MAXFLOAT), height: 20))
        payStatusLabel.frame = .init(x: width - 15 - tempSize.width,
                                     y: avatar.y + (30 - 20) / 2,
                                     width: tempSize.width, height: 20)

        let nameY = avatar.y + (30 - 22) / 2
        nameLabel.frame = .init(x: avatar.frame.maxX + 12,
                                y: nameY,
                                width: payStatusLabel.x - avatar.frame.maxX - 12 - 12,
                                height: 22)
        
        tempSize = contentLabel.sizeThatFits(.init(width: width - 30, height: CGFloat(MAXFLOAT)))
        tempSize.height = tempSize.height > 46 ? 46 : tempSize.height
        contentLabel.frame = .init(x: 15, y: avatar.frame.maxY + 12, width: width - 30, height: tempSize.height)
        
        lineView.frame = .init(x: 15, y: contentLabel.frame.maxY + 10, width: width - 30, height: 0.5)
        
        tempSize = actionButton.sizeThatFits(.init(width: CGFloat(MAXFLOAT), height: 26))
        tempSize.width += 8
        actionButton.frame = .init(x: width - 15 - tempSize.width, y: lineView.frame.maxY + 7, width: tempSize.width, height: 26)
        
        timeDesLabel.frame = .init(x: 15,
                                   y: lineView.frame.maxY + 10,
                                   width: actionButton.x - 15 - 15,
                                   height: 22)
    }
}

extension HCPicConsultCell {
    
    private func initUI() {
        avatar = UIImageView()
        avatar.contentMode = .scaleAspectFill
        avatar.clipsToBounds = true
        avatar.layer.cornerRadius = 15
                
        nameLabel = UILabel()
        nameLabel.textColor = RGB(51, 51, 51)
        nameLabel.font = .font(fontSize: 16, fontName: .PingFSemibold)

        payStatusLabel = UILabel()
        payStatusLabel.textColor = RGB(51, 51, 51)
        payStatusLabel.font = .font(fontSize: 14)

        contentLabel = UILabel()
        contentLabel.textColor = RGB(51, 51, 51)
        contentLabel.font = .font(fontSize: 14)
        contentLabel.numberOfLines = 2

        lineView = UIView()
        lineView.backgroundColor = RGB(243, 243, 243)
        
        timeDesLabel = UILabel()
        timeDesLabel.textColor = RGB(153, 153, 153)
        timeDesLabel.font = .font(fontSize: 14)

        actionButton = UIButton()
        actionButton.setTitleColor(RGB(255, 79, 120), for: .normal)
        actionButton.titleLabel?.font = .font(fontSize: 14)
        actionButton.layer.cornerRadius = 3
        actionButton.layer.borderColor = RGB(255, 79, 120).cgColor
        actionButton.layer.borderWidth = 1
        actionButton.clipsToBounds = true
        actionButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        contentView.addSubview(avatar)
        contentView.addSubview(nameLabel)
        contentView.addSubview(payStatusLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(lineView)
        contentView.addSubview(timeDesLabel)
        contentView.addSubview(actionButton)
    }

    @objc private func buttonAction() {
        actionCallBack?(model)
    }
}
