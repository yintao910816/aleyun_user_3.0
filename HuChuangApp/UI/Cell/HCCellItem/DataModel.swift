//
//  DataModel.swift
//  HuChuangApp
//
//  Created by yintao on 2019/9/30.
//  Copyright © 2019 sw. All rights reserved.
//

import Foundation

enum CellIconType {
    case local
    case network
    case userIcon
}

struct HCListCellItem {
    
    var title: String = ""
    var titleIcon: String = ""
    var titleIconSize: CGSize = .init(width: 25, height: 25)
    
    var attrbuiteTitle: NSAttributedString = NSAttributedString.init()
    
    var detailTitle: String = ""
    var detailIcon: String = ""
    var detailIconSize: CGSize = .init(width: 25, height: 25)

    var iconType: CellIconType = .local
    
    var titleColor: UIColor = RGB(60, 60, 60)
    var detailTitleColor: UIColor = RGB(173, 173, 173)
        
    // 输入框
    var inputSize: CGSize = .init(width: 100, height: 25)
    var placeholder: String = ""
    var inputEnable: Bool = true
    
    // 右边按钮
    var detailButtonSize:CGSize = .zero
    var detailButtonTitle: String = ""
    
    var cellHeight: CGFloat = 50
    var shwoArrow: Bool = true
    
    var cellIdentifier: String = ""
    
    /// 是否是退出登录
    var isLoginOut: Bool = false
    /// sb中界面跳转标识
    var segue: String = ""
    
    /// 按钮cell文字有边框时设置值
    var buttonBorderColor: CGColor? = nil
    var buttonEdgeInsets: UIEdgeInsets = .zero
}
