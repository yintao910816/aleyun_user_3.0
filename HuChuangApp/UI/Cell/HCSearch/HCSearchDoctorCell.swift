//
//  HCSearchDoctorCell.swift
//  HuChuangApp
//
//  Created by yintao on 2019/12/17.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit

public let HCSearchDoctorCell_idetifier = "HCSearchDoctorCell"
public let HCSearchDoctorCell_Height: CGFloat = 112

class HCSearchDoctorCell: HCBaseDoctorCell {

    override func setupUI() {
        
        coverImgV.snp.makeConstraints {
            $0.left.top.equalTo(15)
            $0.bottom.equalTo(-15)
            $0.width.equalTo(coverImgV.snp.height)
        }
        
        priceLabel.snp.makeConstraints {
            $0.right.equalTo(-15)
            $0.top.equalTo(coverImgV.snp.top).offset(6)
        }

        titleLabel.snp.makeConstraints {
            $0.left.equalTo(coverImgV.snp.right).offset(15)
            $0.right.equalTo(priceLabel.snp.left).offset(10).priority(.low)
            $0.top.equalTo(coverImgV.snp.top).offset(3)
        }

        subTitleLabel.snp.makeConstraints {
            $0.left.equalTo(coverImgV.snp.right).offset(15)
            $0.right.equalTo(contentView.snp.right).offset(-30)
            $0.top.equalTo(titleLabel.snp.bottom).offset(5)
        }

        infoLabel.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(5)
            $0.left.equalTo(coverImgV.snp.right).offset(15)
            $0.right.equalTo(contentView.snp.right).offset(-30)
        }
    }

    override var model: Any! {
        didSet {
            let selfModel = (model as! HCSearchDoctorItemModel)
            
            coverImgV.setImage(selfModel.headPath)
            titleLabel.text = "\(selfModel.userName) \(selfModel.technicalPost)"
            subTitleLabel.text = "\(selfModel.technicalPost)·\(selfModel.brief)"
            infoLabel.text = "擅长：\(selfModel.skilledIn)"
            priceLabel.attributedText = selfModel.priceAttText
        }
    }

}
