//
//  MineCell.swift
//  HuChuangApp
//
//  Created by yintao on 2019/2/13.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit

public let HCMineCell_identifier = "HCMineCell"

class HCMineCell: UITableViewCell {
    
    private var titleIconV: UIImageView!
    private var titleLabel: UILabel!
    private var bottomLine: UIView!
    private var arrowIconV: UIImageView!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        contentView.backgroundColor = .white

        titleIconV = UIImageView()
        titleIconV.contentMode = .scaleAspectFill
        titleIconV.clipsToBounds = true
        
        titleLabel = UILabel()
        titleLabel.backgroundColor = .clear
        titleLabel.textColor = RGB(60, 60, 60)
        titleLabel.font = .font(fontSize: 15)
        
        arrowIconV = UIImageView()
        arrowIconV.contentMode = .scaleAspectFill
        arrowIconV.image = UIImage.init(named: "home_button_more")
        arrowIconV.clipsToBounds = true

        bottomLine = UIView()
        bottomLine.backgroundColor = RGB(245, 245, 245)
        
        contentView.addSubview(titleIconV)
        contentView.addSubview(titleLabel)
        contentView.addSubview(arrowIconV)
        contentView.addSubview(bottomLine)
        
        titleIconV.snp.makeConstraints{
            $0.left.equalTo(15)
            $0.centerY.equalTo(contentView.snp.centerY)
            $0.size.equalTo(CGSize.init(width: 30, height: 30))
        }
        
        titleLabel.snp.makeConstraints{
            $0.left.equalTo(titleIconV.snp.right).offset(6)
            $0.centerY.equalTo(contentView.snp.centerY)
        }
        
        arrowIconV.snp.makeConstraints{
            $0.right.equalTo(-15)
            $0.centerY.equalTo(contentView.snp.centerY)
        }

        bottomLine.snp.makeConstraints{
            $0.left.equalTo(15)
            $0.right.equalTo(-15)
            $0.bottom.equalTo(0)
            $0.height.equalTo(1)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var model: MenuListItemModel! {
        didSet {
            titleLabel.text = model.title
            
            if let icon = model.titleIcon {
                titleIconV.image = icon
                
                titleIconV.snp.updateConstraints{ $0.size.equalTo(CGSize.init(width: 30, height: 30)) }
                titleLabel.snp.updateConstraints{ $0.left.equalTo(titleIconV.snp.right).offset(6) }

            }else {
                titleIconV.image = nil

                titleIconV.snp.updateConstraints{ $0.size.equalTo(CGSize.zero) }
                titleLabel.snp.updateConstraints{ $0.left.equalTo(titleIconV.snp.right).offset(0) }
            }
        }
    }
}
