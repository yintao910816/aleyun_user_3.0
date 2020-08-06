//
//  HCHomePregnancyClassroomReusableView.swift
//  HuChuangApp
//
//  Created by sw on 2019/10/2.
//  Copyright © 2019 sw. All rights reserved.
//  孕柚课堂header

import UIKit

public let HCHomePregnancyClassroomReusableView_identifier = "HCHomePregnancyClassroomReusableView"
class HCHomePregnancyClassroomReusableView: UICollectionReusableView {

    @IBOutlet var contentView: UICollectionReusableView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView = (Bundle.main.loadNibNamed("HCHomePregnancyClassroomReusableView", owner: self, options: nil)?.first as! UICollectionReusableView)
        addSubview(contentView)
        
        contentView.snp.makeConstraints{ $0.edges.equalTo(UIEdgeInsets.zero) }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
