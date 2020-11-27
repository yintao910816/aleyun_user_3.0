//
//  HCCollectionDoctorListCell.swift
//  HuChuangApp
//
//  Created by yintao on 2020/11/17.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

public let HCCollectionDoctorListCell_identifier = "HCCollectionDoctorListCell"
public let HCCollectionDoctorListCell_height: CGFloat = 125

class HCCollectionDoctorListCell: UICollectionViewCell {
    
    private var avatar: UIImageView!
    private var doctorInfoLabel: UILabel!
    private var hospitalBg: UIImageView!
    private var hospitalLvLabel: UILabel!
    private var hospitalAdressLabel: UILabel!
    private var skidInLabel: UILabel!
    private var doctorBriefLabel: UILabel!
    private var bottomLine: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var model: HCDoctorListItemModel! {
        didSet {
            avatar.setImage(model.headPath, .userIconWomen)
            doctorInfoLabel.attributedText = model.doctorInfoText
            hospitalLvLabel.text = model.departmentName
            hospitalAdressLabel.text = model.unitName
            skidInLabel.text = "擅长: \(model.skilledIn)"
            doctorBriefLabel.attributedText = model.briefText
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        avatar.frame = .init(x: 15, y: 10, width: 50, height: 50)
        
        let hospitalSize = hospitalLvLabel.sizeThatFits(.init(width: CGFloat(MAXFLOAT), height: 15))
        let tempSize = doctorInfoLabel.sizeThatFits(.init(width: CGFloat(MAXFLOAT), height: 25))
        
        let maxW: CGFloat = width - avatar.frame.maxX - 10 - 15 - 15
        if (hospitalSize.width + 20 + tempSize.width) > maxW {
            hospitalBg.frame = .init(x: width - 15 - (hospitalSize.width + 20),
                                     y: avatar.y + 3,
                                     width: hospitalSize.width + 20,
                                     height: 20)
            hospitalLvLabel.frame = .init(x: 10,
                                          y: (hospitalBg.height - 15) / 2.0,
                                          width: hospitalSize.width, height: 15)
            let doctorInfoLabelW: CGFloat = maxW - (hospitalSize.width + 20) - 15
            doctorInfoLabel.frame = .init(x: avatar.frame.maxX + 10,
                                          y: avatar.y + 3,
                                          width: doctorInfoLabelW,
                                          height: 25)
        }else {
            doctorInfoLabel.frame = .init(x: avatar.frame.maxX + 10,
                                          y: avatar.y + 3,
                                          width: tempSize.width,
                                          height: 25)

            hospitalBg.frame = .init(x: doctorInfoLabel.frame.maxX + 15,
                                     y: avatar.y + 3,
                                     width: hospitalSize.width + 20,
                                     height: 20)
            hospitalLvLabel.frame = .init(x: 10,
                                          y: (hospitalBg.height - 15) / 2.0,
                                          width: hospitalSize.width, height: 15)
        }
        
        hospitalAdressLabel.frame = .init(x: doctorInfoLabel.x,
                                          y: doctorInfoLabel.frame.maxY + 2,
                                          width: width - (avatar.frame.maxX + 10 + 15),
                                          height: 20)
        
        skidInLabel.frame = .init(x: avatar.x,
                                  y: avatar.frame.maxY + 10,
                                  width: width - 30,
                                  height: 15)
        
        doctorBriefLabel.frame = .init(x: skidInLabel.x,
                                       y: skidInLabel.frame.maxY + 10,
                                       width: skidInLabel.width,
                                       height: 17)

        bottomLine.frame = .init(x: 0, y: height - 0.5, width: width, height: 0.5)
    }
}

extension HCCollectionDoctorListCell {
    
    private func initUI() {
        avatar = UIImageView()
        avatar.layer.cornerRadius = 25
        avatar.contentMode = .scaleAspectFill
        avatar.clipsToBounds = true
        
        doctorInfoLabel = UILabel()
        doctorInfoLabel.textColor = RGB(51, 51, 51)
        doctorInfoLabel.font = .font(fontSize: 18, fontName: .PingFSemibold)
        
        hospitalBg = UIImageView(image: UIImage.init(named: "doctor_hospital"))
        hospitalLvLabel = UILabel()
        hospitalLvLabel.textColor = RGB(20, 115, 230)
        hospitalLvLabel.font = .font(fontSize: 11)
        
        hospitalAdressLabel = UILabel()
        hospitalAdressLabel.textColor = RGB(51, 51, 51)
        hospitalAdressLabel.font = .font(fontSize: 14)

        skidInLabel = UILabel()
        skidInLabel.textColor = RGB(153, 153, 153)
        skidInLabel.font = .font(fontSize: 14)

        doctorBriefLabel = UILabel()
        doctorBriefLabel.textColor = RGB(178, 178, 178)
        doctorBriefLabel.font = .font(fontSize: 12)

        bottomLine = UIView()
        bottomLine.backgroundColor = RGB(243, 243, 243)
        
        addSubview(avatar)
        addSubview(doctorInfoLabel)
//        addSubview(hospitalBg)
//        hospitalBg.addSubview(hospitalLvLabel)
        addSubview(hospitalAdressLabel)
        addSubview(skidInLabel)
        addSubview(doctorBriefLabel)
        addSubview(bottomLine)
    }
}

