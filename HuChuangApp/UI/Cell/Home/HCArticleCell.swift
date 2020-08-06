//
//  HCArticleCell.swift
//  HuChuangApp
//
//  Created by yintao on 2019/11/23.
//  Copyright © 2019 sw. All rights reserved.
//  文章cell

import UIKit
import SnapKit

public let HCArticleCell_identifier = "HCArticleCell"
public let HCArticleCell_height: CGFloat = 108

class HCArticleCell: UICollectionViewCell {

    private var coverImgV: UIImageView!
    private var titleLabel: UILabel!
    private var collectionLabel: UILabel!
    private var readLabel: UILabel!
    private var sepLine: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        coverImgV = UIImageView()
        coverImgV.backgroundColor = RGB(245, 245, 245)
        coverImgV.contentMode = .scaleAspectFill
        coverImgV.clipsToBounds = true
        
        titleLabel = UILabel()
        titleLabel.textColor = RGB(51, 51, 51)
        titleLabel.font = .font(fontSize: 13, fontName: .PingFRegular)
        titleLabel.numberOfLines = 2
        
        collectionLabel = UILabel()
        collectionLabel.textColor = RGB(153, 153, 153)
        collectionLabel.font = .font(fontSize: 10, fontName: .PingFRegular)

        readLabel = UILabel()
        readLabel.textColor = RGB(153, 153, 153)
        readLabel.font = .font(fontSize: 10, fontName: .PingFRegular)
        
        sepLine = UIView()
        sepLine.backgroundColor = RGB(249, 249, 249)

        addSubview(coverImgV)
        addSubview(titleLabel)
        addSubview(collectionLabel)
        addSubview(readLabel)
        addSubview(sepLine)
        
        coverImgV.snp.makeConstraints {
            $0.left.equalTo(15)
            $0.top.equalTo(13)
            $0.bottom.equalTo(-13)
            $0.width.equalTo(110)
        }
        
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(coverImgV.snp.right).offset(10)
            $0.top.equalTo(coverImgV.snp.top)
            $0.right.equalTo(25)
        }
        
        readLabel.snp.makeConstraints {
            $0.right.equalTo(-17)
            $0.bottom.equalTo(coverImgV.snp.bottom)
        }
        
        collectionLabel.snp.makeConstraints {
            $0.right.equalTo(readLabel.snp.left).offset(-18)
            $0.bottom.equalTo(coverImgV.snp.bottom)
        }
        
        sepLine.snp.makeConstraints {
            $0.left.equalTo(15)
            $0.right.equalTo(-15)
            $0.bottom.equalTo(0)
            $0.height.equalTo(1)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var model: HCArticleItemModel! {
        didSet {
            coverImgV.setImage(model.picPath)
            titleLabel.text = model.title
            collectionLabel.text = model.collectCountText
            readLabel.text = model.readCountText
        }
    }
}
