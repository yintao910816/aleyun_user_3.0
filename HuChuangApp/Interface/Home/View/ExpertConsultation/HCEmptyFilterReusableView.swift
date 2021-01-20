//
//  HCEmptyFilterReusableView.swift
//  HuChuangApp
//
//  Created by sw on 2021/1/20.
//  Copyright © 2021 sw. All rights reserved.
//

import UIKit

public let HCEmptyFilterReusableView_identifier = "HCEmptyFilterReusableView"
public let HCEmptyFilterReusableView_height: CGFloat = 190

class HCEmptyFilterReusableView: UICollectionReusableView {
 
    private var emptyImgV: UIImageView!
    private var remindTextLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        emptyImgV = UIImageView(image: UIImage(named: "empty_filter"))
        emptyImgV.contentMode = .scaleAspectFill
        
        remindTextLabel = UILabel()
        remindTextLabel.text = "该地区暂无医生服务，请咨询其他医生"
        remindTextLabel.font = .font(fontSize: 14)
        remindTextLabel.textColor = RGB(191, 191, 191)
        remindTextLabel.textAlignment = .center
        
        addSubview(emptyImgV)
        addSubview(remindTextLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        emptyImgV.frame = .init(x: (width - 175) / 2.0, y: 20, width: 175, height: 125)

        remindTextLabel.frame = .init(x: 30, y: emptyImgV.frame.maxY + 30, width: width - 60, height: 15)
        
    }
}
