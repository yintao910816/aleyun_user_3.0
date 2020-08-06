//
//  HCHomePregnancyClassroomCellItemCell.swift
//  HuChuangApp
//
//  Created by sw on 2019/10/2.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit

public let HCHomePregnancyClassroomCellItemCell_identifier = "HCHomePregnancyClassroomCellItemCell"
class HCHomePregnancyClassroomCellItemCell: UICollectionViewCell {

    @IBOutlet weak var titleOutlet: UILabel!

    var model: HCHomePregnancyClassroomMenuModel! {
        didSet {
            if titleOutlet.layer.cornerRadius != model.itemSize.height / 2.0 {
                titleOutlet.layer.cornerRadius = model.itemSize.height / 2.0
            }
            
            titleOutlet.font = model.font
            titleOutlet.text = model.title
            
            titleOutlet.textColor = model.isSelected ? model.selectedTextColor : model.textColor
            titleOutlet.backgroundColor = model.isSelected ? model.selectedBackGroudColor : model.backGroundColor
        }
    }
}
