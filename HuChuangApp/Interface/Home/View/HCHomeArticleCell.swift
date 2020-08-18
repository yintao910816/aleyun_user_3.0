//
//  HCHomeArticleCell.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/18.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

public let HCHomeArticleCell_identifier = "HCHomeArticleCell"
public let HCHomeArticleCell_height: CGFloat = 100

class HCHomeArticleCell: UICollectionViewCell {
    
    private var titleLable: UILabel!
    private var coverImg: UIImageView!
    private var viewNumIcon: UIImageView!
    private var viewNumLabel: UILabel!
    private var collectionNumIcon: UIImageView!
    private var collectionNumLabel: UILabel!
    private var bottomLine: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var model: HCCmsArticleModel! {
        didSet {
            coverImg.setImage(model.picPath)
            titleLable.text = model.title
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let coverH: CGFloat = height - 20
        let coverW: CGFloat = coverH * 4 / 3
        coverImg.frame = .init(x: width - 10 - coverW, y: 10, width: coverW, height: coverH)
        
        titleLable.frame = .init(x: 15, y: 10, width: coverImg.x - 15 - 10, height: 20)
        viewNumIcon.frame = .init(x: titleLable.x, y: height - 10 - 15, width: 15, height: 15)
        var tempSize = viewNumLabel.sizeThatFits(.init(width: CGFloat(MAXFLOAT), height: 15))
        viewNumLabel.frame = .init(x: viewNumIcon.frame.maxX + 5, y: viewNumIcon.y, width: tempSize.width, height: 15)
        
        tempSize = collectionNumLabel.sizeThatFits(.init(width: CGFloat(MAXFLOAT), height: 15))
        collectionNumIcon.frame = .init(x: viewNumLabel.frame.maxX + 25, y: viewNumLabel.y, width: 15, height: 15)
        collectionNumLabel.frame = .init(x: collectionNumIcon.frame.maxX + 5, y: collectionNumIcon.y, width: tempSize.width, height: 15)
        
        bottomLine.frame = .init(x: titleLable.x, y: height - 0.5, width: coverImg.frame.maxX - titleLable.x, height: 0.5)
    }
}

extension HCHomeArticleCell {
    
    private func initUI() {
        coverImg = UIImageView()
        coverImg.contentMode = .scaleAspectFill
        coverImg.clipsToBounds = true
        
        titleLable = UILabel()
        titleLable.textColor = RGB(51, 51, 51)
        titleLable.font = .font(fontSize: 16, fontName: .PingFSemibold)
        
        viewNumIcon = UIImageView()
        viewNumIcon.backgroundColor = .yellow
        
        viewNumLabel = UILabel()
        viewNumLabel.textColor = RGB(153, 153, 153)
        viewNumLabel.text = "0"
        viewNumLabel.font = .font(fontSize: 11)
        
        collectionNumIcon = UIImageView()
        collectionNumIcon.backgroundColor = .yellow
        
        collectionNumLabel = UILabel()
        collectionNumLabel.textColor = RGB(153, 153, 153)
        collectionNumLabel.font = .font(fontSize: 11)
        collectionNumLabel.text = "0"

        bottomLine = UIView()
        bottomLine.backgroundColor = RGB(245, 245, 245)
        
        addSubview(coverImg)
        addSubview(titleLable)
        addSubview(viewNumIcon)
        addSubview(viewNumLabel)
        addSubview(collectionNumIcon)
        addSubview(collectionNumLabel)
        addSubview(bottomLine)

    }
}
