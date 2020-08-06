//
//  HCHomeConsultingVolumeReusableView.swift
//  HuChuangApp
//
//  Created by yintao on 2019/9/22.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit

public let HCHomeConsultingVolumeReusableView_identifier = "HCHomeConsultingVolumeReusableView"

class HCHomeConsultingVolumeReusableView: UICollectionReusableView {

    @IBOutlet var contentView: UICollectionReusableView!
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView = (Bundle.main.loadNibNamed("HCHomeConsultingVolumeReusableView", owner: self, options: nil)?.first as! UICollectionReusableView)
        addSubview(contentView)
        
        contentView.snp.makeConstraints{ $0.edges.equalTo(UIEdgeInsets.zero) }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
