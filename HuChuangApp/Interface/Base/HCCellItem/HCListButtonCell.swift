//
//  HCListButtonCell.swift
//  HuChuangApp
//
//  Created by yintao on 2019/9/30.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit

public let HCListButtonCell_identifier = "HCListButtonCell"

class HCListButtonCell: HCBaseListCell {

    private var actionButton: UIButton!
    
    /// 当按钮有边框时设置克点击，用此回调响应点击事件
    public var clickCallBack: ((HCListCellItem)->())?
    
    override func loadView() {
        selectionStyle = .none
        
        titleLabel.isHidden = true
        arrowImgV.isHidden  = true
        bottomLine.isHidden = true
        
        actionButton = UIButton()
        actionButton.titleLabel?.textAlignment = .center
        actionButton.backgroundColor = .clear
        actionButton.titleLabel?.font = .font(fontSize: 15)
        actionButton.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)

        contentView.addSubview(actionButton)
        
        actionButton.snp.makeConstraints { $0.left.right.top.bottom.equalTo(0) }
    }
    
    @objc private func buttonClicked() {
        clickCallBack?(model)
    }
    
    override var model: HCListCellItem! {
        didSet {
            actionButton.setTitle(model.title, for: .normal)
            actionButton.setTitleColor(model.titleColor, for: .normal)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        actionButton.snp.updateConstraints { $0.edges.equalTo(model.buttonEdgeInsets) }
        
        if model.buttonBorderColor != nil {
            actionButton.layer.cornerRadius = (height - model.buttonEdgeInsets.top - model.buttonEdgeInsets.bottom) / 2.0
            actionButton.layer.borderColor = model.buttonBorderColor
            actionButton.layer.borderWidth = 1
            
            actionButton.isUserInteractionEnabled = true
        }else {
            actionButton.layer.borderColor = UIColor.clear.cgColor
            actionButton.isUserInteractionEnabled = false
        }
    }
}
