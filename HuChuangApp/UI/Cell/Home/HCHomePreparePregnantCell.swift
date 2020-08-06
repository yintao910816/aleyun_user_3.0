
//
//  HCHomePreparePregnantCell.swift
//  HuChuangApp
//
//  Created by yintao on 2019/9/22.
//  Copyright © 2019 sw. All rights reserved.
//  备孕建档cell

import UIKit

public let HCHomePreparePregnantCell_identifier = "HCHomePreparePregnantCell"

class HCHomePreparePregnantCell: UICollectionViewCell {

    @IBOutlet weak var contentOutlet: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        let string = "孕妈妈抱着早产儿感动得快哭了 一小时前 \r\r孕妈妈抱着早产儿感动得快哭了 一小时前 \r\r孕妈妈抱着早产儿感动得快哭了 一小时前"
        let attributeText = NSMutableAttributedString.init(string: string)
        attributeText.addAttributes([NSAttributedString.Key.foregroundColor: RGB(136, 136, 136)],
                                    range: .init(location: 15, length: 4))
        // 换行
        attributeText.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 5)],
                                    range: .init(location: 19, length: 3))

        attributeText.addAttributes([NSAttributedString.Key.foregroundColor: RGB(136, 136, 136)],
                                    range: .init(location: 37, length: 4))
        // 换行
        attributeText.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 5)],
                                    range: .init(location: 41, length: 3))

        attributeText.addAttributes([NSAttributedString.Key.foregroundColor: RGB(136, 136, 136)],
                                    range: .init(location: 59, length: 4))
        
        
        contentOutlet.attributedText = attributeText
    }

}
