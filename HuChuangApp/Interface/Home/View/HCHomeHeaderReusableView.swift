//
//  HCHomeHeaderReusableView.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/8.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

public let HCHomeHeaderReusableView_identifier = "HCHomeHeaderReusableView"
public let HCHomeHeaderReusableView_height: CGFloat = 220

class HCHomeHeaderReusableView: UICollectionReusableView {
   
    private let menuBgTag: Int = 100
    private let menuIconTag: Int = 200
    private let menuTitleTag: Int = 300
    private let menuSubTitleTag: Int = 400
    private let menuButtonTag: Int = 500

    private var colorBgView: UIImageView!
    
    private var cornerBgView: UIView!
    private var shadowBgView: UIView!
    
    public var funcItemClicked: ((HCFunctionsMenuModel)->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var funcMenuModels: [HCFunctionsMenuModel] = [] {
        didSet {
            configContentMenu()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        colorBgView.frame = .init(x: 0, y: 0, width: width, height: 170)
        cornerBgView.frame = .init(x: 15, y: height - 140, width: width - 30, height: 140)
        shadowBgView.frame = cornerBgView.frame
        
        if shadowBgView.layer.shadowPath == nil {
            shadowBgView.setCornerAndShaow(shadowOpacity: 0.05)
        }
        
        let menuItenW: CGFloat = cornerBgView.width / 3.0
        for idx in 0..<funcMenuModels.count {
            let menuBgView = cornerBgView.viewWithTag(menuBgTag + idx)
            let menuIconView = menuBgView?.viewWithTag(menuIconTag + idx)
            let menuTitleLabel = menuBgView?.viewWithTag(menuTitleTag + idx)
            let menuSubTitleLabel = menuBgView?.viewWithTag(menuSubTitleTag + idx)
            let menuButton = menuBgView?.viewWithTag(menuButtonTag + idx)

            let iconSize = CGSize.init(width: 40, height: 40)
            let titleSize = menuTitleLabel?.sizeThatFits(.init(width: menuItenW, height: CGFloat(MAXFLOAT))) ?? CGSize.zero
            let subTitleSize = menuSubTitleLabel?.sizeThatFits(.init(width: menuItenW, height: CGFloat(MAXFLOAT))) ?? CGSize.zero

            menuBgView?.frame = .init(x: CGFloat(idx) * menuItenW, y: 0, width: menuItenW, height: cornerBgView.height)
            
            let totleH: CGFloat = iconSize.height + 5 + titleSize.height + 5 + subTitleSize.height
            let iconY = (cornerBgView.height - totleH) / 2.0
            menuIconView?.frame = .init(origin: .init(x: (menuItenW - iconSize.width) / 2.0, y: iconY),
                                        size: iconSize)
            menuTitleLabel?.frame = .init(origin: .init(x: 0, y: (menuIconView?.frame.maxY ?? 0) + 5),
                                          size: .init(width: menuItenW, height: titleSize.height))
            menuSubTitleLabel?.frame = .init(origin: .init(x: 0, y: (menuTitleLabel?.frame.maxY ?? 0) + 5),
                                          size: .init(width: menuItenW, height: subTitleSize.height))
            
            menuButton?.frame = bounds
        }
    }
}

extension HCHomeHeaderReusableView {
    
    private func initUI() {
        colorBgView = UIImageView.init(image: UIImage(named: "home_header_bg"))
        colorBgView.contentMode = .scaleAspectFill
        colorBgView.clipsToBounds = true
        colorBgView.backgroundColor = RGB(245, 245, 245)
        
        shadowBgView = UIView()
        shadowBgView.backgroundColor = .clear

        cornerBgView = UIView()
        cornerBgView.backgroundColor = .white
        cornerBgView.layer.cornerRadius = 3
        cornerBgView.clipsToBounds = true

        configContentMenu()
        
        addSubview(colorBgView)
        addSubview(shadowBgView)
        insertSubview(cornerBgView, aboveSubview: shadowBgView)
    }
    
    private func configContentMenu() {
//        let icons = ["app_icon", "app_icon", "app_icon"]
//        let titles = ["去挂号", "专家问诊", "快速问诊"]
//        let subTitles = ["海量生殖专家", "一对一咨询", "快问快答"]
        
        for idx in 0..<funcMenuModels.count {
            let view = UIView()
            view.backgroundColor = cornerBgView.backgroundColor
            view.tag = menuBgTag + idx
            
            let icon = UIImageView()
            icon.setImage(funcMenuModels[idx].iconPath)
            icon.tag = menuIconTag + idx
            
            let titleLabel = UILabel()
            titleLabel.textAlignment = .center
            titleLabel.font = .font(fontSize: 18, fontName: .PingFSemibold)
            titleLabel.textColor = RGB(51, 51, 51)
            titleLabel.tag = menuTitleTag + idx
            titleLabel.text = funcMenuModels[idx].name
            
            let subTitleLabel = UILabel()
            subTitleLabel.textAlignment = .center
            subTitleLabel.font = .font(fontSize: 11)
            subTitleLabel.textColor = RGB(153, 153, 153)
            subTitleLabel.tag = menuSubTitleTag + idx
            subTitleLabel.text = funcMenuModels[idx].bak
            
            let button = UIButton()
            button.backgroundColor = .clear
            button.tag = menuButtonTag + idx
            button.addTarget(self, action: #selector(buttonAction(button:)), for: .touchUpInside)
            
            cornerBgView.addSubview(view)
            view.addSubview(icon)
            view.addSubview(titleLabel)
            view.addSubview(subTitleLabel)
            view.addSubview(button)
        }
        
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    @objc private func buttonAction(button: UIButton) {
        let idx = button.tag - menuButtonTag
        if idx < funcMenuModels.count{
            funcItemClicked?(funcMenuModels[idx])
        }
    }
}
