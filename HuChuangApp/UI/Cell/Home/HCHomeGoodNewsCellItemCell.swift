//
//  HCHomeGoodNewsCellItemCell.swift
//  HuChuangApp
//
//  Created by sw on 2019/10/2.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit

public let HCHomeGoodNewsCellItemCell_identifier = "HCHomeGoodNewsCellItemCell"

class HCHomeGoodNewsCellItemCell: UICollectionViewCell {

    @IBOutlet weak var coverOutlet: UIImageView!
    @IBOutlet weak var nickNameOutlet: UILabel!
    @IBOutlet weak var desOutlet: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        coverOutlet.backgroundColor = .gray
    }

    public class var itemSize: CGSize {
        return .init(width: 90, height: 150)
    }
}
