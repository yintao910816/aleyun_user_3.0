
//
//  HCHomeConsultingVolumeCell.swift
//  HuChuangApp
//
//  Created by yintao on 2019/9/22.
//  Copyright © 2019 sw. All rights reserved.
//  首页咨询卷

import UIKit

public let HCHomeConsultingVolumeCell_idenfiter = "HCHomeConsultingVolumeCell"
class HCHomeConsultingVolumeCell: UICollectionViewCell {

    @IBOutlet private weak var coverOutlet: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = .gray
    }

}
