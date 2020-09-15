//
//  HCDoctorListCell.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/25.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

public let HCDoctorListCell_identifier = "HCDoctorListCell"
public let HCDoctorListCell_height: CGFloat = 210

class HCDoctorListCell: UICollectionViewCell {

    private var avatar: UIImageView!
    private var doctorInfoLabel: UILabel!
    private var hospitalBg: UIImageView!
    private var hospitalLabel: UILabel!
    private var hospitalAdressLabel: UILabel!
    private var skidInLabel: UILabel!
    private var doctorBriefLabel: UILabel!
    private var consultFirstPriceLabel: UILabel!
    private var consultSecondPriceLabel: UILabel!
    private var consultButton: UIButton!
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
            hospitalLabel.text = model.departmentName
            skidInLabel.text = "擅长: \(model.skin)"
            doctorBriefLabel.attributedText = model.briefText
            consultFirstPriceLabel.text = "图文¥\(model.consultPrice.count > 0 ? model.consultPrice : "0")"
            consultSecondPriceLabel.text = "电话¥\(model.consultPrice.count > 0 ? model.consultPrice : "0")"
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        avatar.frame = .init(x: 15, y: 10, width: 40, height: 40)
        
        let hospitalSize = hospitalLabel.sizeThatFits(.init(width: CGFloat(MAXFLOAT), height: 15))
        var tempSize = doctorInfoLabel.sizeThatFits(.init(width: CGFloat(MAXFLOAT), height: 25))
        
        let maxW: CGFloat = width - avatar.frame.maxX - 10 - 15 - 15
        if (hospitalSize.width + 20 + tempSize.width) > maxW {
            hospitalBg.frame = .init(x: width - 15 - (hospitalSize.width + 20),
                                     y: avatar.y + 3,
                                     width: hospitalSize.width + 20,
                                     height: 20)
            hospitalLabel.frame = .init(x: 10,
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
            hospitalLabel.frame = .init(x: 10,
                                        y: (hospitalBg.height - 15) / 2.0,
                                        width: hospitalSize.width, height: 15)
        }
        
        hospitalAdressLabel.frame = .init(x: doctorInfoLabel.x,
                                          y: doctorInfoLabel.frame.maxY + 5,
                                          width: width - (avatar.frame.maxX + 10 + 15),
                                          height: 20)
        
        skidInLabel.frame = .init(x: doctorInfoLabel.x,
                                  y: hospitalAdressLabel.frame.maxY + 15,
                                  width: width - doctorInfoLabel.x - 15,
                                  height: 45)
        
        doctorBriefLabel.frame = .init(x: doctorInfoLabel.x,
                                       y: skidInLabel.frame.maxY + 15,
                                       width: skidInLabel.width,
                                       height: 17)

        tempSize = consultFirstPriceLabel.sizeThatFits(.init(width: CGFloat(MAXFLOAT), height: 20))
        consultFirstPriceLabel.frame = .init(x: doctorInfoLabel.x,
                                             y: doctorBriefLabel.frame.maxY + 30,
                                             width: tempSize.width,
                                             height: 17)

        tempSize = consultSecondPriceLabel.sizeThatFits(.init(width: CGFloat(MAXFLOAT), height: 20))
        consultSecondPriceLabel.frame = .init(x: consultFirstPriceLabel.frame.maxX + 15,
                                              y: consultFirstPriceLabel.y,
                                              width: tempSize.width,
                                              height: 17)
        
        consultButton.frame = .init(x: width - 15 - 80, y: doctorBriefLabel.frame.maxY + 15, width: 80, height: 30)
        
        bottomLine.frame = .init(x: 0, y: height - 0.5, width: width, height: 0.5)
    }
}

extension HCDoctorListCell {
    
    private func initUI() {
        avatar = UIImageView()
        avatar.layer.cornerRadius = 20
        avatar.contentMode = .scaleAspectFill
        avatar.clipsToBounds = true
        
        doctorInfoLabel = UILabel()
        doctorInfoLabel.textColor = RGB(51, 51, 51)
        doctorInfoLabel.font = .font(fontSize: 18, fontName: .PingFSemibold)
        
        hospitalBg = UIImageView(image: UIImage.init(named: "doctor_hospital"))
        hospitalLabel = UILabel()
        hospitalLabel.textColor = RGB(20, 115, 230)
        hospitalLabel.font = .font(fontSize: 11)
        
        hospitalAdressLabel = UILabel()
        hospitalAdressLabel.textColor = RGB(51, 51, 51)
        hospitalAdressLabel.font = .font(fontSize: 14)

        skidInLabel = UILabel()
        skidInLabel.textColor = RGB(153, 153, 153)
        skidInLabel.font = .font(fontSize: 14)

        doctorBriefLabel = UILabel()
        doctorBriefLabel.textColor = RGB(178, 178, 178)
        doctorBriefLabel.font = .font(fontSize: 12)

        consultFirstPriceLabel = UILabel()
        consultFirstPriceLabel.textColor = RGB(25, 25, 25)
        consultFirstPriceLabel.font = .font(fontSize: 14)

        consultSecondPriceLabel = UILabel()
        consultSecondPriceLabel.textColor = RGB(25, 25, 25)
        consultSecondPriceLabel.font = .font(fontSize: 14)
        
        consultButton = UIButton()
        consultButton.backgroundColor = RGB(255, 79, 120)
        consultButton.layer.cornerRadius = 3
        consultButton.clipsToBounds = true
        consultButton.setTitle("问医生", for: .normal)
        consultButton.setTitleColor(.white, for: .normal)
        consultButton.titleLabel?.font = .font(fontSize: 14, fontName: .PingFSemibold)

        bottomLine = UIView()
        bottomLine.backgroundColor = RGB(243, 243, 243)
        
        addSubview(avatar)
        addSubview(doctorInfoLabel)
        addSubview(hospitalBg)
        hospitalBg.addSubview(hospitalLabel)
        addSubview(hospitalAdressLabel)
        addSubview(skidInLabel)
        addSubview(doctorBriefLabel)
        addSubview(consultFirstPriceLabel)
        addSubview(consultSecondPriceLabel)
        addSubview(consultButton)
        addSubview(bottomLine)
    }
}