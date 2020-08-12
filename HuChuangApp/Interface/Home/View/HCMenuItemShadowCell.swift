//
//  HCMenuItemShadowCell.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/12.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

public let HCMenuItemShadowCell_identifier = "HCMenuItemShadowCell"
public let HCMenuItemShadowCell_height: CGFloat = 18 + 25 + 18 + 20 + 18

enum HCMenuItemShadowCellMode {
    /// 试管百科
    case testTubeEncyclopedia
    /// 生殖中心
    case reproductiveCenter
    /// 试管日记
    case testTubeDiary
    /// 药品百科
    case drugEncyclopedia
    
    public var modeString: String {
        switch self {
        case .testTubeEncyclopedia:
            return "试管百科"
        case .reproductiveCenter:
            return "生殖中心"
        case .testTubeDiary:
            return "试管日记"
        case .drugEncyclopedia:
            return "药品百科"
        }
    }
    
    public var modeIcon: UIImage? {
        switch self {
        case .testTubeEncyclopedia:
            return UIImage(named: "gongjuxiang")
        case .reproductiveCenter:
            return UIImage(named: "gongjuxiang")
        case .testTubeDiary:
            return UIImage(named: "gongjuxiang")
        case .drugEncyclopedia:
            return UIImage(named: "gongjuxiang")
        }
    }
}

class HCMenuItemShadowCell: UICollectionViewCell {
    
    private var icon: UIImageView!
    private var title: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public var mode: HCMenuItemShadowCellMode! {
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
        
        icon.frame = .init(x: (width - 25) / 2.0, y: 18, width: 25, height: 25)
        title.frame = .init(x: 0, y: icon.frame.maxY + 18, width: width, height: 20)
    }
}
