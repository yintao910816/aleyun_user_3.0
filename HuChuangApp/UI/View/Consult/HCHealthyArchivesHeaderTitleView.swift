//
//  HCHealthyArchivesHeaderTitleView.swift
//  HuChuangApp
//
//  Created by yintao on 2019/11/26.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit

class HCHealthyArchivesHeaderTitleView: UIView {

    private var titleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = RGB(249, 249, 249)
        
        titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.textColor = RGB(204, 204, 204)
        titleLabel.font = .font(fontSize: 13)
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(15)
            $0.right.equalTo(-30)
            $0.centerY.equalTo(snp.centerY)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public var titleText: String = "" {
        didSet {
            titleLabel.text = titleText
        }
    }
}
