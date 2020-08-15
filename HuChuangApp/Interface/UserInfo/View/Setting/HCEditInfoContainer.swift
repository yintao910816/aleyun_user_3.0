//
//  HCEditInfoContainer.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/13.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCEditInfoContainer: UIView {

    public var textField: UITextField!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        textField = UITextField()
        textField.borderStyle = .none
        textField.clearButtonMode = .whileEditing
        textField.placeholder = "请输入"
        textField.font = .font(fontSize: 15)
        
        addSubview(textField)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textField.frame = .init(x: 15, y: 0, width: width - 30, height: 50)
    }
}
