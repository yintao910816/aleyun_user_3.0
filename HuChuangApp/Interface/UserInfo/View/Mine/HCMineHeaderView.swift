//
//  HCMineHeaderView.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/8.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

public let HCMineHeaderView_identifier = "HCMineHeaderView"
public let HCMineHeaderView_height: CGFloat = 165 + HCCollectionSectionTitleView_height

class HCMineHeaderView: UICollectionReusableView {
  
    enum HCMineHeaderAction {
        /// 认证
        case verify
        /// 点击头像
        case avatar
        /// 优惠卷
        case coupon
        /// 服务包
        case serverBags
        /// 收藏
        case attentionStore
        /// 查看全部进行中的服务
        case allInServer
    }
    
    private var avatarButton: UIButton!
    private var phoneLabel: UILabel!
    private var verifyButton: UIButton!
    /// 优惠卷
    private var couponButton: HCCustomTextButton!
    /// 服务包
    private var serverButton: HCCustomTextButton!
    /// 搜藏
    private var collectionButton: HCCustomTextButton!
    
    private var bottomTitleView: HCCollectionSectionTitleView!

    public var excuteAction: ((HCMineHeaderAction)->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var model: HCPersonalCenterInfoModel = HCPersonalCenterInfoModel() {
        didSet {
            couponButton.setupText(first: "\(model.coupon)", second: "优惠卷")
            serverButton.setupText(first: "\(model.servicePack)", second: "服务包")
            collectionButton.setupText(first: "\(model.attentionStore)", second: "收藏")
        }
    }
    
    public var userModel: HCUserModel = HCUserModel() {
        didSet {
            avatarButton.setImage(userModel.headPath, userModel.userIconType)
            phoneLabel.text = userModel.mobileInfo
            verifyButton.isHidden = userModel.realNameStatus == 1
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        avatarButton.frame = .init(x: 15, y: 20, width: 60, height: 60)
        verifyButton.frame = .init(x: width - 15 - 66, y: avatarButton.frame.minY + (60 - 28) / 2.0 , width: 66, height: 28)
        
        let phoneLabelWidth: CGFloat = verifyButton.frame.minX - avatarButton.frame.maxX - 30.0
        phoneLabel.frame = .init(x: avatarButton.frame.maxX + 15,
                                 y: avatarButton.frame.minY + (60 - 22) / 2.0,
                                 width: phoneLabelWidth,
                                 height: 22)
        
        let w: CGFloat = width / 3.0
        couponButton.frame = .init(x: 0, y: avatarButton.frame.maxY + 15, width: w, height: 50)
        serverButton.frame = .init(x: w, y: avatarButton.frame.maxY + 15, width: w, height: 50)
        collectionButton.frame = .init(x: w * 2, y: avatarButton.frame.maxY + 15, width: w, height: 50)
        
        bottomTitleView.frame = .init(x: 0, y: couponButton.frame.maxY + 20, width: width, height: HCCollectionSectionTitleView_height)
    }
}

extension HCMineHeaderView {
    
    private func initUI() {
        backgroundColor = RGB(255, 244, 251)
        
        avatarButton = UIButton()
        avatarButton.layer.cornerRadius = 30
        avatarButton.clipsToBounds = true
        avatarButton.setBackgroundImage(UIImage.init(named: "default_user_icon"), for: .normal)
        avatarButton.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)

        phoneLabel = UILabel()
        phoneLabel.textColor = RGB(51, 51, 51)
        phoneLabel.font = .font(fontSize: 16)
        
        verifyButton = UIButton()
        verifyButton.isHidden = true
        verifyButton.setImage(UIImage(named: "account_authentication"), for: .normal)
        verifyButton.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        
        couponButton = HCCustomTextButton()
        couponButton.setupText(first: "0", second: "优惠卷")
        couponButton.actionCallBack = { [weak self] in self?.excuteAction?(.coupon) }

        serverButton = HCCustomTextButton()
        serverButton.setupText(first: "0", second: "服务包")
        serverButton.actionCallBack = { [weak self] in self?.excuteAction?(.serverBags) }

        collectionButton = HCCustomTextButton()
        collectionButton.setupText(first: "0", second: "收藏")
        collectionButton.actionCallBack = { [weak self] in self?.excuteAction?(.attentionStore) }
        
        bottomTitleView = HCCollectionSectionTitleView()
        bottomTitleView.title = "进行中的服务"
        bottomTitleView.detailTitle = "查看全部"
        bottomTitleView.detailClickedAction = { [unowned self] _ in self.excuteAction?(.allInServer) }

        addSubview(avatarButton)
        addSubview(phoneLabel)
        addSubview(verifyButton)
        addSubview(couponButton)
        addSubview(serverButton)
        addSubview(collectionButton)
        addSubview(bottomTitleView)
    }
    
    @objc private func buttonAction(_ button: UIButton) {
        if button == verifyButton {
            excuteAction?(.verify)
        }else if button == avatarButton {
            excuteAction?(.avatar)
        }
    }
}
