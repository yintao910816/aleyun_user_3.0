//
//  TYListMenuCell.swift
//  HuChuangApp
//
//  Created by yintao on 2019/11/29.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit

public let TYListMenuCell_identifier = "TYListMenuCell"

class TYListMenuCell: UICollectionViewCell {
    
    private var titleLabel: UILabel!
    private var titleIconImgV: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel = UILabel()
        titleLabel.textAlignment = .center
        contentView.addSubview(titleLabel)
        
        titleIconImgV = UIImageView()
        contentView.addSubview(titleIconImgV)
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public var model: TYListMenuModel! {
        didSet {
            titleLabel.font = model.titleFont
            titleLabel.textColor = model.titleColor
            titleLabel.text = model.title
            
            titleIconImgV.image = model.titleImage
            
            if let image = model.titleImage {
                let titleX: CGFloat = (width - model.titleWidth - model.iconMargin - image.size.width) / 2.0
                titleLabel.frame = .init(x: titleX, y: 0, width: model.titleWidth, height: height)
                
                titleIconImgV.frame = .init(x: titleLabel.frame.maxX + model.iconMargin, y: (height - image.size.height) / 2, width: image.size.width, height: image.size.height)
            }else {
                titleLabel.frame = .init(x: 0, y: 0, width: width, height: height)
            }
        }
    }
    
}
