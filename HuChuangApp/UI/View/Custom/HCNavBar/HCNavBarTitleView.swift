//
//  HCNavBarTitleView.swift
//  HuChuangApp
//
//  Created by yintao on 2020/7/21.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

enum HCNavBarTitleMode {
    /// 工具
    case tool
}

class HCNavBarTitleView: UIView {

    public var contentSize: CGSize = .zero
    public var titleContentView: HCNavBarTitleItemView!

    init(frame: CGRect, mode: HCNavBarTitleMode) {
        super.init(frame: frame)
        
        contentSize = frame.size
        
        switch mode {
        case .tool:
            titleContentView = HCToolNavBarTitleItemView.init(frame: frame, mode: mode)
        }
        addSubview(titleContentView)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override var intrinsicContentSize: CGSize {
        return contentSize
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleContentView.frame = bounds
    }
}

class HCNavBarTitleItemView: UIView {
    
    private var bgView: UIButton!
    private var titleLabel: UILabel!
    private var arrowImgV: UIImageView!

    public var titleClicked: (()->())?
    
    init(frame: CGRect, mode: HCNavBarTitleMode) {
        super.init(frame: frame)
        
        bgView = UIButton.init(type: .custom)
        bgView.backgroundColor = .clear
        bgView.addTarget(self, action: #selector(arrowClicekd), for: .touchUpInside)
        
        titleLabel = UILabel()
        titleLabel.text = ""
        titleLabel.textAlignment = .center
        titleLabel.backgroundColor = .clear
        titleLabel.font = .font(fontSize: 15, fontName: .PingFRegular)
        titleLabel.textColor = RGB(51, 51, 51)
        
        var arrowImg: UIImage?
        switch mode {
        case .tool:
            arrowImg = UIImage(named: "tool_nav_down_arrow")
        }
        arrowImgV = UIImageView.init(image: arrowImg)
        arrowImgV.isHidden = true
        
        addSubview(bgView)
        addSubview(titleLabel)
        addSubview(arrowImgV)
    }
          
    public func resetArrow() {
        arrowClicekd()
    }
    
    public var title: String = "" {
        didSet {
            titleLabel.text = title
            arrowImgV.isHidden = title.count == 0
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    public var titleFont: UIFont = .font(fontSize: 15) {
        didSet {
            titleLabel.font = titleFont
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    public var titleColor: UIColor = RGB(51, 51, 51) {
        didSet {
            titleLabel.textColor = titleColor
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let titleSize = titleLabel.sizeThatFits(.init(width: .greatestFiniteMagnitude, height: height))
        let arrowSize = arrowImgV.sizeThatFits(.init(width: CGFloat.greatestFiniteMagnitude, height: height))
        let titleX = (width - titleSize.width - 11 - 5) / 2.0
        
        let bgWidth = titleSize.width + 5 + arrowSize.width
        
        bgView.frame = .init(x: (width - bgWidth) / 2.0, y: 0, width: bgWidth, height: height)
        titleLabel.frame = .init(x: titleX, y: 0, width: titleSize.width, height: height)
        arrowImgV.frame = .init(x: titleLabel.frame.maxX + 5, y: (height - arrowSize.height) / 2.0, width: arrowSize.width, height: arrowSize.height)
    }
}

extension HCNavBarTitleItemView {
    
    @objc private func arrowClicekd() {
        if !bgView.isSelected {
            titleClicked?()
        }

        bgView.isSelected = !bgView.isSelected
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.arrowImgV.transform = .init(rotationAngle: self?.bgView.isSelected == true ? CGFloat.pi : 0)
        }
    }

}

//MARK: 工具
class HCToolNavBarTitleItemView: HCNavBarTitleItemView {
    
}
