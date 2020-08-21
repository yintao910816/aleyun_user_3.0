//
//  HCMineInServerCell.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/18.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

public let HCMineInServerCell_identifier = "HCMineInServerCell"
public let HCMineInServerCell_height: CGFloat = 56

class HCMineInServerCell: UICollectionViewCell {
    
    private var avatar: UIImageView!
    private var nameLabel: UILabel!
    private var jobLabel: UILabel!
    private var hospitalLabel: UILabel!
    private var detailButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var model: HCPersonalProgressServiceModel! {
        didSet {
            avatar.setImage(model.headPath, .userIconWomen)
            nameLabel.text = model.userName
            jobLabel.text = model.technicalPost
            hospitalLabel.text = model.unitName
            detailButton.setTitle("未知状态", for: .normal)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        avatar.frame = .init(x: 27, y: (height - 40) / 2.0, width: 40, height: 40)
        
        let detailButtonSize = detailButton.sizeThatFits(.init(width: CGFloat(MAXFLOAT), height: 30))
        detailButton.frame = .init(x: width - 20 - detailButtonSize.width, y: (height - 30) / 2.0, width: detailButtonSize.width, height: 30)
        
        let totleWidth: CGFloat = detailButton.x - avatar.frame.maxX - 15 - 15
        var nameLabelSize = nameLabel.sizeThatFits(.init(width: CGFloat(MAXFLOAT), height: 22))
        var jobLabelSize = nameLabel.sizeThatFits(.init(width: CGFloat(MAXFLOAT), height: 20))
        if nameLabelSize.width + jobLabelSize.width + 10 > totleWidth {
            nameLabelSize.width = totleWidth / 2.0
            jobLabelSize.width = totleWidth / 2.0
        }
        nameLabel.frame = .init(x: avatar.frame.maxX + 15, y: avatar.y, width: nameLabelSize.width, height: 22)
        jobLabel.frame = .init(x: nameLabel.frame.maxX + 10, y: nameLabel.y + 2, width: jobLabelSize.width, height: 20)
        
        hospitalLabel.frame = .init(x: nameLabel.x, y: avatar.frame.maxY - 20, width: totleWidth, height: 20)
    }
}

extension HCMineInServerCell {
    
    private func initUI() {
        avatar = UIImageView()
        avatar.image = UIImage(named: "default_user_icon")
        avatar.contentMode = .scaleAspectFill
        avatar.clipsToBounds = true
        avatar.layer.cornerRadius = 20
        
        nameLabel = UILabel()
        nameLabel.textColor = RGB(51, 51, 51)
        nameLabel.font = .font(fontSize: 16, fontName: .PingFSemibold)
        
        jobLabel = UILabel()
        jobLabel.textColor = RGB(153, 153, 153)
        jobLabel.font = .font(fontSize: 14)

        detailButton = UIButton()
        detailButton.setTitleColor(HC_MAIN_COLOR, for: .normal)
        detailButton.titleLabel?.font = .font(fontSize: 14)
        
        hospitalLabel = UILabel()
        hospitalLabel.textColor = RGB(153, 153, 153)
        hospitalLabel.font = .font(fontSize: 14)
        
        addSubview(avatar)
        addSubview(nameLabel)
        addSubview(jobLabel)
        addSubview(detailButton)
        addSubview(hospitalLabel)
    }
}
