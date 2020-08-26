//
//  HCHospitalListCell.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/26.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

public let HCHospitalListCell_identifier = "HCHospitalListCell"
public let HCHospitalListCell_height: CGFloat = 75

class HCHospitalListCell: UITableViewCell {

    private var titleLabel: UILabel!
    private var subTitleLabel: UILabel!
    private var lineView: UIView!
    private var arrowImgV: UIImageView!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        titleLabel = UILabel()
        titleLabel.font = .font(fontSize: 17, fontName: .PingFSemibold)
        titleLabel.textColor = RGB(51, 51, 51)
        
        subTitleLabel = UILabel()
        subTitleLabel.font = .font(fontSize: 13, fontName: .PingFLight)
        subTitleLabel.textColor = RGB(51, 51, 51)
        
        arrowImgV = UIImageView()
        arrowImgV.image = UIImage(named: "home_button_more")

        lineView = UIView()
        lineView.backgroundColor = RGB(235, 235, 235)
        
        addSubview(titleLabel)
        addSubview(subTitleLabel)
        addSubview(lineView)
        addSubview(arrowImgV)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var model: HCHospitalListItemModel! {
        didSet {
            titleLabel.text = "标题"
            subTitleLabel.text = "副标题"
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.frame = .init(x: 15, y: 15, width: width - 30 - 6 - 10, height: 24)
        subTitleLabel.frame = .init(x: titleLabel.x, y: height - 18 - 15, width: titleLabel.width, height: 18)
        lineView.frame = .init(x: titleLabel.x, y: height - 0.5, width: width - 30, height: 0.5)
        arrowImgV.frame = .init(x: width - 15 - 6, y: (height - 10) / 2.0, width: 6, height: 10)
    }
}
