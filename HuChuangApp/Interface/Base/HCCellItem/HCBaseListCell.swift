//
//  HCBaseListCell.swift
//  HuChuangApp
//
//  Created by yintao on 2019/9/30.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit

public let HCBaseListCell_identifier = "HCBaseListCell"
class HCBaseListCell: UITableViewCell {

    public var titleLabel: UILabel!
    public var titleIcon: UIImageView!
    
    public var arrowImgV: UIImageView!
    public var bottomLine: UIView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        PrintLog("已释放：\(self)")
    }
    
    private func setupView() {
        titleIcon = UIImageView()
        titleIcon.contentMode = .scaleAspectFill
        titleIcon.clipsToBounds = true
        
        titleLabel = UILabel()
        titleLabel.backgroundColor = .clear
        titleLabel.font = .font(fontSize: 15)
        
        arrowImgV = UIImageView.init(image: UIImage.init(named: "cell_right_arrow"))
        arrowImgV.backgroundColor = .clear
        arrowImgV.clipsToBounds = true

        bottomLine = UIView()
        bottomLine.backgroundColor = RGB(245, 245, 245)
        
        contentView.addSubview(titleIcon)
        contentView.addSubview(titleLabel)
        contentView.addSubview(arrowImgV)
        contentView.addSubview(bottomLine)
                
        loadView()
    }
    
    /// 设置数据
    public var model: HCListCellItem! {
        didSet {
            titleLabel.font = model.titleFont
            titleLabel.textColor = model.titleColor
            
            if model.titleIcon.count > 0 {
                titleIcon.image = UIImage.init(named: model.titleIcon)
            }else {
                titleIcon.image = nil
            }
            
            if model.attrbuiteTitle.length > 0 {
                titleLabel.attributedText = model.attrbuiteTitle
            }else {
                titleLabel.text = model.title
                titleLabel.textColor = model.titleColor
            }
            
            arrowImgV.isHidden = !model.shwoArrow
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var tempSize: CGSize = .zero
        let maxTitleIconSize = CGSize(width: 25, height: height - 30)
        let leftX: CGFloat = 12
        if model.titleIcon.count > 0 {
            if titleIcon.superview == nil {
                contentView.addSubview(titleIcon)
            }
            
            titleIcon.image = UIImage.init(named: model.titleIcon)
            tempSize = titleIcon.sizeThatFits(.init(width: CGFloat.greatestFiniteMagnitude,
                                                    height: maxTitleIconSize.height))
            titleIcon.frame = .init(x: leftX + max(0, (maxTitleIconSize.width - tempSize.width)) / 2,
                                    y: (height - tempSize.height) / 2,
                                    width: tempSize.width,
                                    height: tempSize.height)
            
            let titleX: CGFloat = (leftX + 25 + 15) > titleIcon.frame.maxX ? (leftX + 25 + 15) : titleIcon.frame.maxX + 10
            tempSize = titleLabel.sizeThatFits(.init(width: CGFloat.greatestFiniteMagnitude, height: height - 30))
            titleLabel.frame = .init(x: titleX,
                                     y: (height - tempSize.height) / 2,
                                     width: tempSize.width,
                                     height: tempSize.height)
        }else {
            titleIcon.image = nil
            titleIcon.removeFromSuperview()

            tempSize = titleLabel.sizeThatFits(.init(width: CGFloat.greatestFiniteMagnitude, height: height - 30))
            titleLabel.frame = .init(x: leftX,
                                     y: (height - tempSize.height) / 2,
                                     width: tempSize.width,
                                     height: tempSize.height)
        }
        
        arrowImgV.frame = .init(x: width - 15 - 8, y: (height - 15)/2, width: 8, height: 15)
        
        switch model.bottomLineMode {
        case .noSpace:
            bottomLine.frame = .init(x: 0, y: height - 0.5, width: width, height: 0.5)
        case .icon:
            bottomLine.frame = .init(x: titleIcon.x, y: height - 0.5, width: width - titleIcon.x, height: 0.5)
        case .title:
            bottomLine.frame = .init(x: titleLabel.x, y: height - 0.5, width: width - titleLabel.x, height: 0.5)
        }
    }
    
    /// 子类实现，添加UI
    public func loadView() { }
}
