//
//  HCHomeAdvCell.swift
//  HuChuangApp
//
//  Created by yintao on 2019/9/22.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit

public let HCHomeAdvCell_identifier = "HCHomeAdvCell"

class HCHomeAdvCell: UICollectionViewCell {

    @IBOutlet private weak var coverOutlet: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = .gray
    }

}
