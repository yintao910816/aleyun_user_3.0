//
//  HCConsultListCell.swift
//  HuChuangApp
//
//  Created by sw on 2019/9/25.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit

public let HCConsultListCell_idetifier = "HCConsultListCell"
public let HCConsultListCell_Height: CGFloat = 160

class HCConsultListCell: HCBaseDoctorCell {
    
    private var countLabel: UILabel!
    private var consultButton:UIButton!
    
    public var consultCallBack: ((HCDoctorItemModel)->())?
    
    override func setupUI() {
        selectionStyle = .none
        
        countLabel = UILabel()
        countLabel.textColor = RGB(153, 153, 153)
        countLabel.font = .font(fontSize: 10, fontName: .PingFRegular)

        consultButton = UIButton()
        consultButton.backgroundColor = HC_MAIN_COLOR
        consultButton.layer.cornerRadius = 12.5
        consultButton.clipsToBounds = true
        consultButton.setTitleColor(.white, for: .normal)
        consultButton.titleLabel?.font = .font(fontSize: 12, fontName: .PingFRegular)
        consultButton.setTitle("图文咨询", for: .normal)
        consultButton.addTarget(self, action: #selector(consultAction), for: .touchUpInside)
                
        contentView.addSubview(countLabel)
        contentView.addSubview(consultButton)

        coverImgV.snp.makeConstraints {
            $0.left.top.equalTo(15)
            $0.bottom.equalTo(-15)
            $0.width.equalTo(100)
        }
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(coverImgV.snp.right).offset(15)
            $0.right.equalTo(-15)
            $0.top.equalTo(coverImgV.snp.top).offset(7)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.left.equalTo(titleLabel.snp.left)
            $0.right.equalTo(titleLabel.snp.right)
            $0.top.equalTo(titleLabel.snp.bottom).offset(11)
        }

        infoLabel.snp.makeConstraints {
            $0.left.equalTo(titleLabel.snp.left)
            $0.right.equalTo(titleLabel.snp.right)
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(10)
        }

        consultButton.snp.makeConstraints {
            $0.right.equalTo(titleLabel.snp.right)
            $0.top.equalTo(infoLabel.snp.bottom).offset(14)
            $0.size.equalTo(CGSize.init(width: 100, height: 25))
        }

        priceLabel.snp.makeConstraints {
            $0.left.equalTo(titleLabel.snp.left)
            $0.bottom.equalTo(consultButton.snp.bottom)
        }

        countLabel.snp.makeConstraints {
            $0.left.equalTo(priceLabel.snp.right).offset(14)
            $0.centerY.equalTo(priceLabel.snp.centerY)
        }        
    }
    
    @objc private func consultAction() {
        consultCallBack?((model as! HCDoctorItemModel))
    }
    
    override var model: Any! {
        didSet {
            let selfModel = (model as! HCDoctorItemModel)
            
            coverImgV.setImage(selfModel.headPath)
            titleLabel.text = selfModel.titleText
            subTitleLabel.text = selfModel.unitNameText
            infoLabel.text = selfModel.skilledInText
            priceLabel.attributedText = selfModel.priceAttText
            countLabel.text = selfModel.askNumText
        }
    }        
}
