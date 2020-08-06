//
//  HCSettingFooterView.swift
//  HuChuangApp
//
//  Created by yintao on 2019/12/6.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit

class HCSettingFooterView: UIView {

    private var loginOutButton: UIButton!
    
    public var loginOutCallBack: (()->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear

        loginOutButton = UIButton()
        loginOutButton.setTitle("退出登录", for: .normal)
        loginOutButton.setTitleColor(HC_MAIN_COLOR, for: .normal)
        loginOutButton.titleLabel?.font = .font(fontSize: 16)
        loginOutButton.layer.cornerRadius = 23
        loginOutButton.layer.borderColor = HC_MAIN_COLOR.cgColor
        loginOutButton.layer.borderWidth = 1
        loginOutButton.backgroundColor = .clear
        loginOutButton.addTarget(self, action: #selector(loginOutAction), for: .touchUpInside)
        addSubview(loginOutButton)
        
        loginOutButton.snp.makeConstraints {
            $0.bottom.equalTo(0)
            $0.left.equalTo(20)
            $0.right.equalTo(-20)
            $0.height.equalTo(46)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func loginOutAction() {
        loginOutCallBack?()
    }
}
