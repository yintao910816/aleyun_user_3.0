//
//  HCBaseListCell.swift
//  HuChuangApp
//
//  Created by yintao on 2019/9/30.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit

public let HCBaseListCell_identifier = "HCBaseListCell"
class HCBaseListCell: UITableViewCell {

    public var titleLabel: UILabel!
    public var titleIcon: UIImageView!
    
    public var arrowImgV: UIImageView!
    public var bottomLine: UIView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        titleIcon = UIImageView()
        titleIcon.contentMode = .scaleAspectFill
        titleIcon.clipsToBounds = true
        
        titleLabel = UILabel()
        titleLabel.backgroundColor = .clear
        titleLabel.font = .font(fontSize: 15)
        
        arrowImgV = UIImageView.init(image: UIImage.init(named: "cell_right_arrow"))
        arrowImgV.backgroundColor = .clear
        arrowImgV.clipsToBounds = true

        bottomLine = UIView()
        bottomLine.backgroundColor = RGB(245, 245, 245)
        
        contentView.addSubview(titleIcon)
        contentView.addSubview(titleLabel)
        contentView.addSubview(arrowImgV)
        contentView.addSubview(bottomLine)
        
        titleIcon.snp.makeConstraints{
            $0.centerY.equalTo(contentView.snp.centerY)
            $0.size.equalTo(CGSize.init(width: 25, height: 25))
            $0.left.equalTo(contentView).offset(12)
        }
        
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(titleIcon.snp.right).offset(12)
            $0.centerY.equalTo(contentView.snp.centerY)
        }
        arrowImgV.snp.makeConstraints {
            $0.right.equalTo(-15)
            $0.centerY.equalTo(contentView.snp.centerY)
            $0.size.equalTo(CGSize.init(width: 8, height: 15))
        }

        bottomLine.snp.makeConstraints {
            $0.left.right.bottom.equalTo(0)
            $0.height.equalTo(1)
        }
        
        loadView()
    }
    
    /// 设置数据
    public var model: HCListCellItem! {
        didSet {
            if model.titleIcon.count > 0 {
                titleIcon.image = UIImage.init(named: model.titleIcon)
                titleIcon.snp.updateConstraints{
                    $0.size.equalTo(model.titleIconSize)
                }
                
                titleLabel.snp.updateConstraints {
                    $0.left.equalTo(titleIcon.snp.right).offset(12)
                }

            }else {
                titleIcon.image = nil
                titleIcon.snp.updateConstraints{
                    $0.size.equalTo(CGSize.zero)
                }
                
                titleLabel.snp.updateConstraints {
                    $0.left.equalTo(titleIcon.snp.right).offset(0)
                }
            }
            
            if model.attrbuiteTitle.length > 0 {
                titleLabel.attributedText = model.attrbuiteTitle
            }else {
                titleLabel.text = model.title
                titleLabel.textColor = model.titleColor
            }
            
            arrowImgV.isHidden = !model.shwoArrow
        }
    }
    
    /// 子类实现，添加UI
    public func loadView() { }
}
