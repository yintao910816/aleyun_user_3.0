//
//  HCListDetailInputCell.swift
//  HuChuangApp
//
//  Created by sw on 2019/10/19.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit
import RxSwift

public let HCListDetailInputCell_identifier = "HCListDetailInputCell"
public let HCListDetailInputCell_height: CGFloat = 50

class HCListDetailInputCell: HCBaseListCell {

    private var inputTf: UITextField!
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        arrowImgV.isHidden = true
        
        inputTf = UITextField()
        inputTf.font = .font(fontSize: 14)
        inputTf.textColor = .black
        inputTf.delegate = self
        contentView.addSubview(inputTf)
        
        NotificationCenter.default.rx.notification(UITextField.textDidChangeNotification, object: nil)
            .subscribe(onNext: { [weak self] _ in
                PrintLog("文本输入框文字变化：\(self?.inputTf.text ?? "")")

                if self?.model != nil {
                    self?.model.textSignal.value = self?.inputTf.text ?? ""
                }
            })
            .disposed(by: disposeBag)
    }

    override var model: HCListCellItem! {
        didSet {
            super.model = model
            
            if inputTf.delegate == nil {
                inputTf.delegate = self
            }
            
            inputTf.text = model.detailTitle
            inputTf.textAlignment = model.detailInputTextAlignment
            inputTf.placeholder = model.placeholder
            
            model.textSignal.value = model.detailTitle
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        let inputX: CGFloat = model.shwoArrow ? (width - 15 - 8 - 7 - model.inputSize.width) : (width - 15 - model.inputSize.width)
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
