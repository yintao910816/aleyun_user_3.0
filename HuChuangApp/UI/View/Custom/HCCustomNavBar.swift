//
//  HCCustomNavBar.swift
//  HuChuangApp
//
//  Created by yintao on 2019/11/30.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit

class HCCustomNavBar: UIView {

    private var backButton: TYClickedButton!
    private var titleLabel: UILabel!
    
    public var backCallBack: (()->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupUI()
    }
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    private func setupUI() {
        backButton = TYClickedButton()
        backButton.setImage(UIImage.init(named: "navigationButtonReturnClick"), for: .normal)
        backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        
        titleLabel = UILabel()
        titleLabel.font = .font(fontSize: 18)
        titleLabel.textColor = RGB(51, 51, 51)
        titleLabel.textAlignment = .center
        
        addSubview(backButton)
        addSubview(titleLabel)
        
        backButton.snp.makeConstraints {
            $0.left.equalTo(snp.left).offset(12)
            $0.centerY.equalTo(snp.centerY)
        }
        
        titleLabel.snp.makeConstraints {
            $0.center.equalTo(snp.center)
        }
    }
    
    @objc private func backAction() {
        backCallBack?()
    }
}
