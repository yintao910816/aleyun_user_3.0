//
//  HCHomeGoodNewsReusableView.swift
//  HuChuangApp
//
//  Created by sw on 2019/10/2.
//  Copyright © 2019 sw. All rights reserved.
//  传好运header

import UIKit

public let HCHomeGoodNewsReusableView_idenfitier = "HCHomeGoodNewsReusableView"

class HCHomeGoodNewsReusableView: UICollectionReusableView {

    @IBOutlet var contentView: UICollectionReusableView!
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView = (Bundle.main.loadNibNamed("HCHomeGoodNewsReusableView", owner: self, options: nil)?.first as! UICollectionReusableView)
        addSubview(contentView)
        
        contentView.snp.makeConstraints{ $0.edges.equalTo(UIEdgeInsets.zero) }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
