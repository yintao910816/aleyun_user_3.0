//
//  HCNewsReusableView.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/13.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

public let HCNewsReusableView_identifier = "HCNewsReusableView"
public let HCNewsReusableView_height: CGFloat = 15 + HCCollectionSectionTitleView_height + 5 + 25

class HCNewsReusableView: UICollectionReusableView {
        
    private var titleHeader: HCCollectionSectionTitleView!
    private var menuView: HCMenuView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleHeader.frame = .init(x: 0, y: 15, width: width, height: HCCollectionSectionTitleView_height)
        menuView.frame = .init(x: 20, y: titleHeader.frame.maxY + 5, width: width - 40, height: 30)
    }
}

extension HCNewsReusableView {
    
    private func initUI() {
        backgroundColor = .white
        titleHeader = HCCollectionSectionTitleView()
        titleHeader.backgroundColor = backgroundColor
        titleHeader.title = "热门资讯"
        
        menuView = HCMenuView()
        menuView.datasource = createMenuItems()
        menuView.backgroundColor = backgroundColor
     
        addSubview(titleHeader)
        addSubview(menuView)
    }

    private func createMenuItems() ->[HCMenuItemModel] {
        var menus: [HCMenuItemModel] = []
        let titles: [String] = ["推荐", "试管之前", "体检建档", "降调促排"]
        
        for idx in 0..<titles.count {
            let item = HCMenuItemModel()
            item.titleText = titles[idx]
            item.isSelected = idx == 0
            item.contentHeight = 26
            
            menus.append(item)
        }
        
        return menus
    }
}
