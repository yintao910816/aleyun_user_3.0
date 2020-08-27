//
//  HCClassRoomHeaderReusableView.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/27.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

public let HCClassRoomHeaderReusableView_identifier = "HCClassRoomHeaderReusableView"
public let HCClassRoomHeaderReusableView_size: CGSize = .init(width: PPScreenW, height: 30)

class HCClassRoomHeaderReusableView: HCClassRoomBaseReusableView {
    
    private var bgImgV: UIImageView!
    private var titleLabel: UILabel!
    private var subTitleLabel: UILabel!
    private var arrowImgV: UIImageView!
    private var detailButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setup(with title: String, subTitle: String, titleBgImg: UIImage?) {
        bgImgV.image = titleBgImg
        titleLabel.text = title
        subTitleLabel.text = subTitle
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bgImgV.frame = .init(x: 12, y: (height - 23) / 2.0, width: 23, height: 23)
        
        var tempSize: CGSize = titleLabel.sizeThatFits(.init(width: CGFloat(MAXFLOAT), height: 25))
        titleLabel.frame = .init(x: bgImgV.x, y: (height - 25) / 2.0, width: tempSize.width, height: 25)
        
        if subTitleLabel.text?.count ?? 0 > 0 {
            tempSize = subTitleLabel.sizeThatFits(.init(width: CGFloat(MAXFLOAT), height: 20))
            
            arrowImgV.frame = .init(x: width - 15 - 7, y: (height - 13) / 2.0, width: 7, height: 13)
            subTitleLabel.frame = .init(x: arrowImgV.x - 7 - tempSize.width, y: (height - 20) / 2.0, width: tempSize.width, height: tempSize.height)
            
            detailButton.frame = .init(x: subTitleLabel.x, y: (height - 25) / 2.0, width: arrowImgV.frame.maxX - subTitleLabel.x, height: 25)
        }else {
            subTitleLabel.frame = .zero
            arrowImgV.frame = .zero
            detailButton.frame = .zero
        }
    }
}

extension HCClassRoomHeaderReusableView {
    
    private func initUI() {
        bgImgV = UIImageView()
        bgImgV.layer.cornerRadius = 11.5
        bgImgV.clipsToBounds = true
        
        titleLabel = UILabel()
        titleLabel.font = .font(fontSize: 18, fontName: .PingFSemibold)
        titleLabel.textColor = RGB(51, 51, 51)
        
        subTitleLabel = UILabel()
        subTitleLabel.font = .font(fontSize: 14)
        subTitleLabel.textColor = RGB(153, 153, 153)
        
        arrowImgV = UIImageView.init(image: UIImage(named: "arrow_right_new"))
        arrowImgV.clipsToBounds = true
        
        detailButton = UIButton()
        detailButton.backgroundColor = .clear
        
        addSubview(bgImgV)
        addSubview(titleLabel)
        addSubview(subTitleLabel)
        addSubview(arrowImgV)
        addSubview(detailButton)
    }
}
