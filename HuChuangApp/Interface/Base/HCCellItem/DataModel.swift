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

//MARK: 底部分割线对齐方式
enum HCBottomLineMode {
    /// 顶到最左边
    case noSpace
    /// 与titleIcon对齐
    case icon
    /// 与title对齐
    case title
}

class HCListCellItem {
    
    var title: String = ""
    var titleFont: UIFont = .font(fontSize: 15)
    var titleIcon: String = ""
    var titleIconSize: CGSize = .init(width: 25, height: 25)
    
    var attrbuiteTitle: NSAttributedString = NSAttributedString.init()
    
    var detailTitle: String = ""
    var detailIcon: String = ""
    var detailIconSize: CGSize = .init(width: 25, height: 25)

    var iconType: CellIconType = .local
    
    var titleColor: UIColor = RGB(51, 51, 51)
    var detailTitleColor: UIColor = RGB(173, 173, 173)
       
    /// 开关是否打开
    var isOn: Bool = false

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
    
    var detailInputTextAlignment: NSTextAlignment = .left
    
    var bottomLineMode: HCBottomLineMode = .noSpace
}
