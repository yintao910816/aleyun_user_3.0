//
//  HCMenuHorizontalCell.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/12.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

public let HCMenuHorizontalCell_identifier = "HCMenuHorizontalCell"
public let HCMenuHorizontalCell_height: CGFloat = 40

//enum HCMenuHorizontalCellMode {
//    /// 试管百科
//    case testTubeEncyclopedia
//    /// 生殖中心
//    case reproductiveCenter
//    /// 试管日记
//    case testTubeDiary
//    /// 药品百科
//    case drugEncyclopedia
//
//    public var modeString: String {
//        switch self {
//        case .testTubeEncyclopedia:
//            return "试管百科"
//        case .reproductiveCenter:
//            return "生殖中心"
//        case .testTubeDiary:
//            return "试管日记"
//        case .drugEncyclopedia:
//            return "药品百科"
//        }
//    }
//
//    public var modeIcon: UIImage? {
//        switch self {
//        case .testTubeEncyclopedia:
//            return UIImage(named: "gongjuxiang")
//        case .reproductiveCenter:
//            return UIImage(named: "gongjuxiang")
//        case .testTubeDiary:
//            return UIImage(named: "gongjuxiang")
//        case .drugEncyclopedia:
//            return UIImage(named: "gongjuxiang")
//        }
//    }
//}

class HCMenuHorizontalCell: UICollectionViewCell {
    
    private var icon: UIImageView!
    private var title: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

//    public var mode: HCMenuItemShadowCellMode! {
//        didSet {
//            icon.image = mode.modeIcon
//            title.text = mode.modeString
//        }
//    }
    
    private func initUI() {
        icon = UIImageView()
        icon.image = UIImage(named: "gongjuxiang")
        
        title = UILabel()
        title.textColor = RGB(51, 51, 51)
        title.font = .font(fontSize: 14)
        title.textAlignment = .center
        title.text = "测试"
        
        addSubview(icon)
        addSubview(title)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        icon.frame = .init(x: 0, y: (height - 15) / 2.0, width: 15, height: 15)
        title.frame = .init(x: icon.frame.maxX + 5, y: (height - 20) / 2.0, width: width - icon.frame.maxX - 5 - 5, height: 20)
    }

}
