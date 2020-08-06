//
//  HCEditAvatarHeaderView.swift
//  HuChuangApp
//
//  Created by yintao on 2019/11/30.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit

public let HCEditAvatarHeaderView_height: CGFloat = 175

class HCEditAvatarHeaderView: UIView {

    private var avatarButton: UIButton!
    private var remindLabel: UILabel!
    
    public var tapIconCallBack: (()->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupUI()
    }
    
    public var avatar: UIImage? {
        didSet {
            avatarButton.setImage(avatar, for: .normal)
        }
    }
    
    public var avatarURL: String? {
        didSet {
            avatarButton.setImage(avatarURL)
        }
    }
    
    public var avatarImage: UIImage? {
        didSet {
            avatarButton.setImage(avatarImage, for: .normal)
        }
    }
    
    private func setupUI() {
        backgroundColor = .white
        
        avatarButton = UIButton()
        avatarButton.backgroundColor = RGB(249, 249, 249)
        avatarButton.imageView?.contentMode = .scaleAspectFill
        avatarButton.clipsToBounds = true
        avatarButton.layer.cornerRadius = 45
        avatarButton.addTarget(self, action: #selector(avatarTapAction), for: .touchUpInside)
        
        remindLabel = UILabel()
        remindLabel.textColor = RGB(153, 153, 153)
        remindLabel.font = .font(fontSize: 14)
        remindLabel.text = "点击修改头像"
        
        addSubview(avatarButton)
        addSubview(remindLabel)
        
        avatarButton.snp.makeConstraints {
            $0.centerX.equalTo(snp.centerX)
            $0.centerY.equalTo(snp.centerY).offset(-12)
            $0.size.equalTo(CGSize.init(width: 90, height: 90))
        }
        
        remindLabel.snp.makeConstraints {
            $0.centerX.equalTo(snp.centerX)
            $0.top.equalTo(avatarButton.snp.bottom).offset(10)
        }
    }
    
    @objc private func avatarTapAction() {
        tapIconCallBack?()
    }
}
