//
//  HCDoctorCardCell.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/25.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

public let HCDoctorCardCell_identifier = "HCDoctorCardCell"
public let HCDoctorCardCell_size: CGSize = .init(width: 230, height: 98)

class HCDoctorCardCell: UICollectionViewCell {
    
    private var avatar: UIImageView!
    private var titleLabel: UILabel!
    private var subTitleLabel: UILabel!
    
    private var picButton: UIButton!
    private var yuyueButton: UIButton!
    private var callButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var model: HCDoctorListItemModel! {
        didSet {
            avatar.setImage(model.headPath, .doctor)
            titleLabel.attributedText = model.doctorInfoText
            subTitleLabel.text = model.departmentName
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        avatar.frame = .init(x: 13, y: 10, width: 40, height: 40)
        
        let titleW: CGFloat = width - avatar.frame.maxX - 13.0 - 7.0
        titleLabel.frame = .init(x: avatar.frame.maxX + 7,
                                 y: avatar.y + 3,
                                 width: titleW,
                                 height: 25)
        
        subTitleLabel.frame = .init(x: titleLabel.x, y: titleLabel.frame.maxY + 5, width: titleLabel.width, height: 20)
        
        let buttonSize: CGSize = .init(width: 47, height: 19)
        picButton.frame = .init(origin: .init(x: avatar.x + 3, y: height - 10 - buttonSize.height), size: buttonSize)
        yuyueButton.frame = .init(origin: .init(x: picButton.frame.maxX + 7, y: picButton.y), size: buttonSize)
        callButton.frame = .init(origin: .init(x: yuyueButton.frame.maxX + 7, y: picButton.y), size: buttonSize)
    }
}

extension HCDoctorCardCell {
    
    private func initUI() {
        backgroundColor = RGB(243, 243, 243)
        layer.cornerRadius = 3
        
        avatar = UIImageView()
        avatar.contentMode = .scaleAspectFill
        avatar.clipsToBounds = true
        avatar.layer.cornerRadius = 20
        avatar.clipsToBounds = true
        
        titleLabel = UILabel()
        titleLabel.font = .font(fontSize: 18, fontName: .PingFSemibold)
        titleLabel.textColor = RGB(51, 51, 51)
        
        subTitleLabel = UILabel()
        subTitleLabel.font = .font(fontSize: 14)
        subTitleLabel.textColor = RGB(51, 51, 51)
        
        picButton = UIButton()
        picButton.backgroundColor = RGB(20, 115, 230, 1)
        picButton.setTitleColor(.white, for: .normal)
        picButton.titleLabel?.font = .font(fontSize: 11)
        picButton.layer.cornerRadius = 3
        picButton.clipsToBounds = true
        picButton.setTitle("图文", for: .normal)
        
        yuyueButton = UIButton()
        yuyueButton.backgroundColor = RGB(109, 206, 110)
        yuyueButton.setTitleColor(.white, for: .normal)
        yuyueButton.titleLabel?.font = .font(fontSize: 11)
        yuyueButton.layer.cornerRadius = 3
        yuyueButton.clipsToBounds = true
        yuyueButton.setTitle("预约", for: .normal)

        callButton = UIButton()
        callButton.backgroundColor = RGB(245, 154, 35)
        callButton.setTitleColor(.white, for: .normal)
        callButton.titleLabel?.font = .font(fontSize: 11)
        callButton.layer.cornerRadius = 3
        callButton.clipsToBounds = true
        callButton.setTitle("电话", for: .normal)

        addSubview(avatar)
        addSubview(titleLabel)
        addSubview(subTitleLabel)
        addSubview(picButton)
        addSubview(yuyueButton)
        addSubview(callButton)
    }
}
