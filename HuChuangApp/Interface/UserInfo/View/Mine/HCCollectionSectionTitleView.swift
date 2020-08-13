//
//  HCCollectionSectionTitleView.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/8.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

public let HCCollectionSectionTitleView_identifier = "HCCollectionSectionTitleView"
public let HCCollectionSectionTitleView_height: CGFloat = 35

class HCCollectionSectionTitleView: UICollectionReusableView {
    
    private var titleLabel: UILabel!
    private var detailButton: UIButton!
    
    public var detailClickedAction: ((String)->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }
    
    public var detailTitle: String = "" {
        didSet {
            detailButton.setTitle(detailTitle, for: .normal)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        var tempSize = titleLabel.sizeThatFits(.init(width: CGFloat(MAXFLOAT), height: 22))
        titleLabel.frame = .init(x: 15, y: (height - 22) / 2.0, width: tempSize.width, height: 22)
        
        if detailTitle.count > 0 {
            tempSize = detailButton.sizeThatFits(.init(width: CGFloat(MAXFLOAT), height: 20))
            detailButton.frame = .init(x: width  - 15 - tempSize.width, y: (height - 20) / 2.0, width: tempSize.width, height: 20)
        }
    }
}

extension HCCollectionSectionTitleView {
    
    private func initUI() {
        backgroundColor = .white
        
        titleLabel = UILabel()
        titleLabel.font = .font(fontSize: 16, fontName: .PingFSemibold)
        titleLabel.textColor = RGB(51, 51, 51)
        
        detailButton = UIButton()
        detailButton.titleLabel?.font = .font(fontSize: 14)
        detailButton.setTitleColor(RGB(153, 153, 153), for: .normal)
        detailButton.addTarget(self, action: #selector(detailClicked), for: .touchUpInside)
        
        addSubview(titleLabel)
        addSubview(detailButton)
    }
    
    @objc private func detailClicked() {
        detailClickedAction?(title)
    }
}
