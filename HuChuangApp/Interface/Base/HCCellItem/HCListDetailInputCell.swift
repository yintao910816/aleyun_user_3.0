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
        
        inputTf.snp.makeConstraints {
            $0.right.equalTo(arrowImgV.snp.right).offset(15 + 8)
            $0.size.equalTo(CGSize.init(width: 100, height: 25))
            $0.centerY.equalTo(contentView.snp.centerY)
        }
    }

    override var model: HCListCellItem! {
        didSet {
            super.model = model
            
            if inputTf.delegate == nil {
                inputTf.delegate = self
            }
            
            inputTf.textAlignment = model.detailInputTextAlignment
            inputTf.placeholder = model.placeholder
            
            inputTf.snp.updateConstraints {
                $0.right.equalTo(arrowImgV.snp.right).offset(model.shwoArrow ? 15 + 8 : 0)
                $0.size.equalTo(model.inputSize)
            }
        }
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
