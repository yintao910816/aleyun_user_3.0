//
//  HCTestTubeCell.swift
//  HuChuangApp
//
//  Created by yintao on 2020/11/17.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

public let HCTestTubeCell_identifier: String = "HCTestTubeCell"

class HCTestTubeCell: UICollectionViewCell {

    private var bgImgV: UIImageView!
    private var titleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        bgImgV = UIImageView()
        bgImgV.contentMode = .scaleAspectFill
        bgImgV.clipsToBounds = true
        
//        titleLabel = UILabel()
//        titleLabel.textColor = RGB(142, 152, 195)
//        titleLabel.font = .font(fontSize: 13, fontName: .PingFSemibold)
        
        addSubview(bgImgV)
//        bgImgV.addSubview(titleLabel)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public var model: HCCmsArticleListModel! {
        didSet {
            bgImgV.setImage(model.picPath)
//            titleLabel.text = model.title
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bgImgV.frame = bounds
//        titleLabel.frame = .init(x: 5, y: 10, width: bgImgV.width - 10, height: 15)
    }
}
