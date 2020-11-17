//
//  HCMineHealthArchivesCell.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/18.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

public let HCMineHealthArchivesCell_identifier = "HCMineHealthArchivesCell"
public let HCMineHealthArchivesCell_height: CGFloat = 80
class HCMineHealthArchivesCell: UICollectionViewCell {
    
    private var bgView: UIView!
    
    private var nameLabel: UILabel!
    private var ageLabel: UILabel!
    private var sexLabel: UILabel!
    private var sexIcon: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var model: HCPersonalHealthArchivesModel! {
        didSet {
            let gender = (HCGender(rawValue: model.sex) ?? HCGender.female)
            sexLabel.text = gender.genderText
            bgView.backgroundColor = gender == .female ? RGB(250, 228, 228) : RGB(225, 237, 253)
            sexIcon.image = gender == .female ? UIImage(named: "mine_female") : UIImage(named: "mine_male")

            nameLabel.text = model.memberName
            ageLabel.text = "\(model.age)岁"
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bgView.frame = .init(x: 0, y: 0, width: 215, height: height)
        
        var sexIconH: CGFloat = sexIcon.image?.size.height ?? bgView.height
        var sexIconW: CGFloat = sexIcon.image?.size.width ?? bgView.height
        if sexIconH > bgView.height {
            sexIconW = sexIconW * bgView.height / sexIconH
            sexIconH = bgView.height
        }
            
        sexIcon.frame = .init(x: bgView.width - sexIconW,
                              y: (bgView.height - sexIconH) / 2,
                              width: sexIconW,
                              height: sexIconH)
        nameLabel.frame = .init(x: 15, y: 15, width: sexIcon.x - 15 - 15, height: 26)
        
        var tempSize = ageLabel.sizeThatFits(.init(width: CGFloat(MAXFLOAT), height: 20))
        ageLabel.frame = .init(x: nameLabel.x, y: bgView.height - 20 - 15, width: tempSize.width, height: 20)
        
        tempSize = ageLabel.sizeThatFits(.init(width: CGFloat(MAXFLOAT), height: 20))
        sexLabel.frame = .init(x: ageLabel.frame.maxX + 15, y: ageLabel.y, width: tempSize.width, height: 20)
    }
}

extension HCMineHealthArchivesCell {
    
    private func initUI() {
        bgView = UIView()
        bgView.layer.cornerRadius = 4
        bgView.clipsToBounds = true
        
        nameLabel = UILabel()
        nameLabel.textColor = RGB(51, 51, 51)
        nameLabel.font = .font(fontSize: 19, fontName: .PingFSemibold)
        
        ageLabel = UILabel()
        ageLabel.textColor = RGB(51, 51, 51)
        ageLabel.font = .font(fontSize: 14)
        
        sexLabel = UILabel()
        sexLabel.textColor = RGB(51, 51, 51)
        sexLabel.font = .font(fontSize: 14)

        sexIcon = UIImageView()
        sexIcon.contentMode = .scaleAspectFill
        sexIcon.clipsToBounds = true
        
        addSubview(bgView)
        bgView.addSubview(nameLabel)
        bgView.addSubview(ageLabel)
        bgView.addSubview(sexLabel)
        bgView.addSubview(sexIcon)
    }
}
