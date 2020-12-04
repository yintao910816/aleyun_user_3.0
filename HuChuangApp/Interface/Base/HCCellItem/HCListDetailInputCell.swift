//
//  HCListDetailInputCell.swift
//  HuChuangApp
//
//  Created by sw on 2019/10/19.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit

public let HCListDetailInputCell_identifier = "HCListDetailInputCell"
public let HCListDetailInputCell_height: CGFloat = 50

class HCListDetailInputCell: HCBaseListCell {

    private var inputTf: UITextField!
    
    override func loadView() {
        arrowImgV.isHidden = true
        
        inputTf = UITextField()
        inputTf.font = .font(fontSize: 14)
        inputTf.textColor = .black
        inputTf.delegate = self
        contentView.addSubview(inputTf)
    }

    override var model: HCListCellItem! {
        didSet {
            super.model = model
            
            if inputTf.delegate == nil {
                inputTf.delegate = self
            }
            
            inputTf.textAlignment = model.detailInputTextAlignment
            inputTf.placeholder = model.placeholder
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        let inputX: CGFloat = model.shwoArrow ? (width - 15 - 8 - model.inputSize.width) : (width - model.inputSize.width)
        inputTf.frame = .init(x: inputX,
                              y: (height - model.inputSize.height) / 2,
                              width: model.inputSize.width,
                              height: model.inputSize.height)
    }
    
    deinit {
        inputTf.delegate = nil
        inputTf.removeFromSuperview()
    }
}

extension HCListDetailInputCell: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        model.detailTitle = textField.text ?? ""
    }
}
