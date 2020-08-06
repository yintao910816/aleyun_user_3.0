//
//  HCAskCell.swift
//  HuChuangApp
//
//  Created by yintao on 2019/11/24.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit

public let HCAskCell_identifier = "HCAskCell"

class HCAskCell: UICollectionViewCell {
    
    private var imgV: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupUI()
    }
    
    private func setupUI() {
        imgV = UIImageView()
        imgV.contentMode = .scaleAspectFill
        imgV.clipsToBounds = true
        
        contentView.addSubview(imgV)
        
        imgV.snp.makeConstraints { $0.edges.equalTo(UIEdgeInsets.zero) }
    }
    
    public var model: HCAskPicModel! {
        didSet {
            imgV.image = model.image
        }
    }
}
