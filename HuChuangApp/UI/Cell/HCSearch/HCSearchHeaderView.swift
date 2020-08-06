//
//  HCSearchHeaderView.swift
//  HuChuangApp
//
//  Created by yintao on 2019/12/17.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit

public let HCSearchHeaderView_identifier = "HCSearchHeaderView"
public let HCSearchHeaderView_height: CGFloat = 55
public let HCSearchHeaderView_small_height: CGFloat = 45

class HCSearchHeaderView: UIView {

    private var titleLabel: UILabel!
    private var moreButton: UIButton!
    private var topSepLine: UIView!

    public var clickedMoreCallBack: (()->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        topSepLine = UIView()
        topSepLine.backgroundColor = RGB(249, 249, 249)
        
        titleLabel = UILabel()
        titleLabel.backgroundColor = .clear
        titleLabel.font = .font(fontSize: 16)
        titleLabel.textColor = RGB(51, 51, 51)
        
        moreButton = UIButton()
        moreButton.setTitle("更多 >", for: .normal)
        moreButton.titleLabel?.font = .font(fontSize: 13)
        moreButton.setTitleColor(RGB(153, 153, 153), for: .normal)
        moreButton.addTarget(self, action: #selector(clickedMoreAction), for: .touchUpInside)
        
        addSubview(topSepLine)
        addSubview(titleLabel)
        addSubview(moreButton)
        
        topSepLine.snp.makeConstraints {
            $0.top.left.right.equalTo(0)
            $0.height.equalTo(10)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(topSepLine.snp.bottom)
            $0.left.equalTo(15)
            $0.bottom.equalTo(0)
        }

        moreButton.snp.makeConstraints {
            $0.top.equalTo(topSepLine.snp.bottom)
            $0.right.equalTo(-15)
            $0.bottom.equalTo(0)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func clickedMoreAction() {
        clickedMoreCallBack?()
    }
    
    public var showLine: Bool = true {
        didSet {
            topSepLine.snp.updateConstraints { $0.height.equalTo(showLine ? 10 : 0) }
        }
    }
    
    public var titleText: String! {
        didSet {
            titleLabel.text = titleText
        }
    }
}
