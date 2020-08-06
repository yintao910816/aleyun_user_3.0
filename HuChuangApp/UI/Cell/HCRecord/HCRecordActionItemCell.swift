//
//  HCRecordActionItemCell.swift
//  HuChuangApp
//
//  Created by yintao on 2019/12/13.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit

public let HCRecordActionItemCell_height: CGFloat = 30
public let HCRecordActionItemCell_identifier: String = "HCRecordActionItemCell"

class HCRecordActionItemCell: HCBaseRecordCell {

    @IBOutlet weak var titleOutlet: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    override var model: HCRecordData! {
        didSet {
            guard let itemModel = model as? HCCellActionItem else {
                return
            }
            
            titleOutlet.text = itemModel.title
        }
    }
}
