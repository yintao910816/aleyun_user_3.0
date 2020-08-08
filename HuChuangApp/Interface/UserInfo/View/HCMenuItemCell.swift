//
//  HCMenuItemCell.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/8.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

public let HCMenuItemCell_identifier = "HCMenuItemCell"
public let HCMenuItemCell_height: CGFloat = 55

enum HCMenuItemCellMode {
    /// 问诊
    case consult
    /// 预约
    case reservation
    /// 订单
    case order
    /// 记录
    case record
    
    public var modeString: String {
        switch self {
        case .consult:
            return "问诊"
        case .reservation:
            return "预约"
        case .order:
            return "订单"
        case .record:
            return "记录"
        }
    }
    
    public var modeIcon: UIImage? {
        switch self {
        case .consult:
            return UIImage(named: "gongjuxiang")
        case .reservation:
            return UIImage(named: "gongjuxiang")
        case .order:
            return UIImage(named: "gongjuxiang")
        case .record:
            return UIImage(named: "gongjuxiang")
        }
    }
}

class HCMenuItemCell: UICollectionViewCell {
    
    private var icon: UIImageView!
    private var title: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public var mode: HCMenuItemCellMode! {
        didSet {
            icon.image = mode.modeIcon
            title.text = mode.modeString
        }
    }
    
    private func initUI() {
        icon = UIImageView()
        
        title = UILabel()
        title.textColor = RGB(102, 102, 102)
        title.font = .font(fontSize: 14)
        title.textAlignment = .center
        
        addSubview(icon)
        addSubview(title)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        icon.frame = .init(x: (width - 25) / 2.0, y: 0, width: 25, height: 25)
        title.frame = .init(x: 0, y: icon.frame.maxY + 10, width: width, height: 20)
    }
}

