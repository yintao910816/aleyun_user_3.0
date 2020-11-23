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
            return UIImage(named: "mine_wenzen")
        case .reservation:
            return UIImage(named: "mine_yuyue")
        case .order:
            return UIImage(named: "mine_order")
        case .record:
            return UIImage(named: "mine_record")
        }
    }
}

class HCMenuItemCell: UICollectionViewCell {
    
    private var icon: UIImageView!
    private var title: UILabel!
    private var subTitle: UILabel!
    
    private var iconY: CGFloat = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// 个人中心
    public var mode: HCMenuItemCellMode! {
        didSet {
            icon.image = mode.modeIcon
            title.text = mode.modeString
        }
    }
        
    /// 药品百科
    public var medicineItem: HCMedicineItemModel! {
        didSet {
            iconY = 8
            
            if layer.cornerRadius != 3 {
                layer.cornerRadius = 3
                clipsToBounds = true
                backgroundColor = .white
            }
            
            icon.setImage(medicineItem.introudcePic, .yaopinbaike)
            title.text = medicineItem.medicineName
            subTitle.text = medicineItem.aliasName
        }
    }
    
    public var titleFont: UIFont = .font(fontSize: 14) {
        didSet {
            title.font = titleFont
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    private func initUI() {
        icon = UIImageView()
        
        title = UILabel()
        title.textColor = RGB(102, 102, 102)
        title.font = .font(fontSize: 14)
        title.textAlignment = .center
        
        subTitle = UILabel()
        subTitle.textColor = RGB(153, 153, 153)
        subTitle.font = .font(fontSize: 14)
        subTitle.textAlignment = .center

        addSubview(icon)
        addSubview(title)
        addSubview(subTitle)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let titleSize: CGSize = title.sizeThatFits(.init(width: width, height: CGFloat(MAXFLOAT)))
        let subTitleSize: CGSize = subTitle.sizeThatFits(.init(width: width, height: CGFloat(MAXFLOAT)))
        var iconH: CGFloat = height - iconY - 10 - titleSize.height
        if subTitle.text?.count ?? 0 > 0 {
            iconH -= (subTitleSize.height + 5 + 10)
        }
        
        icon.frame = .init(x: (width - iconH) / 2.0, y: iconY, width: iconH, height: iconH)
        title.frame = .init(x: 0, y: icon.frame.maxY + 10, width: width, height: titleSize.height)
        if subTitle.text?.count ?? 0 > 0 {
            subTitle.frame = .init(x: 0, y: title.frame.maxY + 5, width: width, height: subTitleSize.height)
        }
    }
}

