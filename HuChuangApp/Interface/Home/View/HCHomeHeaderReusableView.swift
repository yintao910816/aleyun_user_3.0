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

    private var colorBgView: UIImageView!
    private var contentBgView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        colorBgView.frame = .init(x: 0, y: 0, width: width, height: 170)
        contentBgView.frame = .init(x: 15, y: height - 140, width: width - 30, height: 140)
        
        let menuItenW: CGFloat = contentBgView.width / 3.0
        for idx in 0..<3 {
            let menuBgView = contentBgView.viewWithTag(menuBgTag + idx)
            let menuIconView = menuBgView?.viewWithTag(menuIconTag + idx)
            let menuTitleLabel = menuBgView?.viewWithTag(menuTitleTag + idx)
            let menuSubTitleLabel = menuBgView?.viewWithTag(menuSubTitleTag + idx)

            let iconSize = CGSize.init(width: 40, height: 40)
            let titleSize = menuTitleLabel?.sizeThatFits(.init(width: menuItenW, height: CGFloat(MAXFLOAT))) ?? CGSize.zero
            let subTitleSize = menuSubTitleLabel?.sizeThatFits(.init(width: menuItenW, height: CGFloat(MAXFLOAT))) ?? CGSize.zero

            menuBgView?.frame = .init(x: CGFloat(idx) * menuItenW, y: 0, width: menuItenW, height: contentBgView.height)
            
            let totleH: CGFloat = iconSize.height + 5 + titleSize.height + 5 + subTitleSize.height
            let iconY = (contentBgView.height - totleH) / 2.0
            menuIconView?.frame = .init(origin: .init(x: (menuItenW - iconSize.width) / 2.0, y: iconY),
                                        size: iconSize)
            menuTitleLabel?.frame = .init(origin: .init(x: 0, y: (menuIconView?.frame.maxY ?? 0) + 5),
                                          size: titleSize)
            menuSubTitleLabel?.frame = .init(origin: .init(x: 0, y: (menuTitleLabel?.frame.maxY ?? 0) + 5),
                                          size: subTitleSize)
        }
    }
}

extension HCHomeHeaderReusableView {
    
    private func initUI() {
        colorBgView = UIImageView.init(image: nil)
        colorBgView.contentMode = .scaleAspectFill
        colorBgView.clipsToBounds = true
        colorBgView.backgroundColor = RGB(245, 245, 245)
        
        contentBgView = UIView()
        contentBgView.backgroundColor = .white
        
        configContentMenu()
        
        addSubview(colorBgView)
        addSubview(contentBgView)
    }
    
    private func configContentMenu() {
        let icons = ["", "", ""]
        let titles = ["去挂号", "专家问诊", "快速问诊"]
        let subTitles = ["海量生殖专家", "一对一咨询", "快问快答"]
        
        for idx in 0..<3 {
            let view = UIView()
            view.backgroundColor = contentBgView.backgroundColor
            view.tag = menuBgTag + idx
            
            let icon = UIImageView()
            icon.image = UIImage(named: icons[idx])
            icon.tag = menuIconTag + idx
            
            let titleLabel = UILabel()
            titleLabel.textAlignment = .center
            titleLabel.font = .font(fontSize: 18, fontName: .PingFSemibold)
            titleLabel.textColor = RGB(51, 51, 51)
            titleLabel.tag = menuTitleTag + idx
            titleLabel.text = titles[idx]
            
            let subTitleLabel = UILabel()
            subTitleLabel.textAlignment = .center
            subTitleLabel.font = .font(fontSize: 11)
            subTitleLabel.textColor = RGB(153, 153, 153)
            subTitleLabel.tag = menuSubTitleTag + idx
            subTitleLabel.text = subTitles[idx]
            
            contentBgView.addSubview(view)
            view.addSubview(icon)
            view.addSubview(titleLabel)
            view.addSubview(subTitleLabel)
        }
    }
}
