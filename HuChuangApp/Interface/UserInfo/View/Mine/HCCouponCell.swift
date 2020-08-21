//
//  HCCouponCell.swift
//  HuChuangApp
//
//  Created by yintao on 2020/8/21.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

public let HCCouponCell_identifier = "HCCouponCell"
public let HCCouponCell_height: CGFloat = 150

class HCCouponCell: UICollectionViewCell {
    
    private var couponTypeLabel: UILabel!
    private var couponLabel: UILabel!
    private var couponTypeDetailLabel: UILabel!
    private var timeLabel: UILabel!
    private var useLimitLabel: UILabel!
    private var bottomLine: UIView!
    private var subTitleLabel: UILabel!
    private var statusButton: UIButton!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var model: HCCouponModel! {
        didSet {
            couponTypeLabel.text = model.scenarioName
            couponLabel.attributedText = model.attributeName
            couponTypeDetailLabel.text = model.scenarioName
            timeLabel.text = model.remainDaysText
            useLimitLabel.text = model.content
            subTitleLabel.text = model.bak
            statusButton.isSelected = model.status == 1
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let tempSize: CGSize = couponTypeLabel.sizeThatFits(.init(width: CGFloat(MAXFLOAT), height: 26))
        
        couponTypeLabel.frame = .init(x: 35, y: 15, width: tempSize.width + 20, height: 26)
        
        couponTypeDetailLabel.frame = .init(x: couponTypeLabel.frame.maxX + 40,
                                            y: couponTypeLabel.y,
                                            width: width - 35 - couponTypeLabel.width - 40 - 13,
                                            height: 26)
        timeLabel.frame = .init(x: couponTypeDetailLabel.x,
                                y: couponTypeDetailLabel.frame.maxY + 7,
                                width: couponTypeDetailLabel.width,
                                height: 16)
     
        useLimitLabel.frame = .init(x: couponTypeDetailLabel.x,
                                    y: timeLabel.frame.maxY + 7,
                                    width: couponTypeDetailLabel.width,
                                    height: 16)
        
        couponLabel.frame = .init(x: couponTypeLabel.x - 20,
                                  y: couponTypeLabel.frame.maxY + 5,
                                  width: couponTypeLabel.width + 40,
                                  height: 46)
        
        bottomLine.frame = .init(x: 13, y: useLimitLabel.frame.maxY + 23, width: width - 26, height: 0.5)
        
        statusButton.frame = .init(x: width - 20 - 13, y: bottomLine.frame.maxY + 7, width: 20, height: 20)
        
        subTitleLabel.frame = .init(x: 13,
                                    y: bottomLine.frame.maxY + 10,
                                    width: statusButton.x - 13 - 13,
                                    height: 16)
    }
}

extension HCCouponCell {
    private func initUI() {
        layer.cornerRadius = 5
        backgroundColor = .white
        
        couponTypeLabel = UILabel()
        couponTypeLabel.backgroundColor = RGB(255, 79, 120)
        couponTypeLabel.textColor = .white
        couponTypeLabel.font = .font(fontSize: 14)
        couponTypeLabel.textAlignment = .center
        couponTypeLabel.layer.cornerRadius = 3
        couponTypeLabel.clipsToBounds = true
        
        couponLabel = UILabel()
        couponLabel.textColor = RGB(255, 79, 120)
        couponLabel.font = .font(fontSize: 20, fontName: .PingFSemibold)

        couponTypeDetailLabel = UILabel()
        couponTypeDetailLabel.textColor = RGB(51, 51, 51)
        couponTypeDetailLabel.font = .font(fontSize: 17, fontName: .PingFSemibold)

        timeLabel = UILabel()
        timeLabel.textColor = RGB(94, 97, 106)
        timeLabel.font = .font(fontSize: 12)

        useLimitLabel = UILabel()
        useLimitLabel.textColor = RGB(94, 97, 106)
        useLimitLabel.font = .font(fontSize: 12)

        subTitleLabel = UILabel()
        subTitleLabel.textColor = RGB(170, 171, 178)
        subTitleLabel.font = .font(fontSize: 12)

        bottomLine = UIView()
        bottomLine.backgroundColor = RGB(224, 225, 230)
        
        statusButton = UIButton()
        statusButton.setImage(UIImage(named: "login_unselected_agree"), for: .normal)
        statusButton.setImage(UIImage(named: "login_selected_agree"), for: .selected)
        
        addSubview(couponTypeLabel)
        addSubview(couponLabel)
        addSubview(couponTypeDetailLabel)
        addSubview(timeLabel)
        addSubview(useLimitLabel)
        addSubview(subTitleLabel)
        addSubview(bottomLine)
        addSubview(statusButton)
    }
}

