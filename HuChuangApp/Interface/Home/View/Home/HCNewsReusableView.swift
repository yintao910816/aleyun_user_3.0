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
    
    private var datasource: [HCMenuItemModel] = []
    
    public var menuChanged: ((HCMenuItemModel)->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func reloadMenuItems(items: [HCCmsCmsChanelListModel], page: Int) {
        datasource.removeAll()
        
        for idx in 0..<items.count {
            let item = HCMenuItemModel()
            item.titleText = items[idx].name
            item.isSelected = page == idx
            item.contentHeight = 26
            item.itemId = items[idx].id
            
            datasource.append(item)
        }
        
        menuView.datasource = datasource
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
        menuView.backgroundColor = backgroundColor
        
        menuView.menuChanged = { [weak self] in self?.menuChanged?($0) }
     
        addSubview(titleHeader)
        addSubview(menuView)
    }
}
