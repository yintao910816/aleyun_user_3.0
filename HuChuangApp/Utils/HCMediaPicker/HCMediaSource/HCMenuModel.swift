//
//  HCMenuModel.swift
//  HuChuangApp
//
//  Created by yintao on 2020/11/5.
//  Copyright © 2020 sw. All rights reserved.
//

enum HCConsultType: Int {
    /// 聊天咨询
    case chatConsult = 1
    /// 视频咨询
    case videoConsult = 2
    /// 精准预约
    case query = 4

    public var typeText: String {
        switch self {
        case .chatConsult:
            return "聊天咨询"
        case .videoConsult:
            return "视频咨询"
        case .query:
            return "精准预约"
        }
    }
    
    public var bgColor: UIColor {
        switch self {
        case .chatConsult:
            return RGB(75, 138, 239)
        case .videoConsult:
            return RGB(245, 154, 35)
        case .query:
            return RGB(109, 206, 110)
        }
    }
}

import Foundation

class HCPickerMenuSectionModel {
    public var items: [HCPickerMenuItemModel] = []
    public var sectionInsets: UIEdgeInsets = .init(top: 15, left: 15, bottom: 15, right: 15)
    public var countForFull: Int = 4
        
    init() { }

    convenience init(items: [HCPickerMenuItemModel],
                     sectionInsets: UIEdgeInsets = .init(top: 15, left: 15, bottom: 15, right: 15),
                     countForFull: Int = 4) {
        self.init()
        self.items = items
        self.sectionInsets = sectionInsets
        self.countForFull = countForFull
    }
}

class HCPickerMenuItemModel {
    public var iconImage: UIImage?
    public var cornerRadius: CGFloat = 10
    public var iconTitleMargin: CGFloat = 5

    public var titleFont: UIFont = .font(fontSize: 12)
    public var titleColor: UIColor = RGB(120, 127, 133)
    public var title: String = ""

    init() { }
    
    convenience init(iconImage: UIImage? = nil,
                     ornerRadius: CGFloat = 10,
                     titleFont: UIFont = .font(fontSize: 12),
                     titleColor: UIColor = RGB(120, 127, 133),
                     iconTitleMargin: CGFloat = 5,
                     title: String) {
        self.init()
        self.iconImage = iconImage
        self.cornerRadius = cornerRadius
        self.titleFont = titleFont
        self.titleColor = titleColor
        self.iconTitleMargin = iconTitleMargin
        self.title = title
    }
    
    public lazy var textHeight: CGFloat = {
        return self.title.ty_textSize(font: self.titleFont, width: 1000, height: CGFloat.greatestFiniteMagnitude).height
    }()
}

extension HCPickerMenuSectionModel {
    
    /// 医生咨询
    public static func createChatPicker(consultMode: HCConsultType) ->[HCPickerMenuSectionModel] {
        if consultMode == .videoConsult {
            return [HCPickerMenuSectionModel.init(items: [HCPickerMenuItemModel.init(iconImage: UIImage(named: "picker_video_call"),
                                                                                     title: "视频通话"),
                                                          HCPickerMenuItemModel.init(iconImage: UIImage(named: "picker_photo"),
                                                                                     title: "相册"),
                                                          HCPickerMenuItemModel.init(iconImage: UIImage(named: "picker_camera"),
                                                                                     title: "拍摄"),
                                                          HCPickerMenuItemModel.init(iconImage: UIImage(named: "picker_chat_history"),
                                                                                     title: "问诊历史")])]
        }else {
            return [HCPickerMenuSectionModel.init(items: [HCPickerMenuItemModel.init(iconImage: UIImage(named: "picker_photo"),
                                                                                     title: "相册"),
                                                          HCPickerMenuItemModel.init(iconImage: UIImage(named: "picker_camera"),
                                                                                     title: "拍摄"),
                                                          HCPickerMenuItemModel.init(iconImage: UIImage(named: "picker_chat_history"),
                                                                                     title: "问诊历史")])]
        }
    }
}
