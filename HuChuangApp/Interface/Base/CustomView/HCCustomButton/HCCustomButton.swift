//
//  HCCustomButton.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/8.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCCustomTextButton: UIView {

    private var titleLabel: UILabel!
    
    private var firstString: String = ""
    private var secondString: String = ""

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setupText(first: String, second: String) {
        firstString = first
        secondString = second
        let string = NSMutableAttributedString.init(string: "\(firstString)\n\(secondString)")
        string.addAttributes([NSAttributedString.Key.foregroundColor : RGB(51, 51, 51),
                              NSAttributedString.Key.font : UIFont.font(fontSize: 20)],
                             range: NSRange.init(location: 0, length: firstString.count))
        titleLabel.attributedText = string
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.frame = bounds
    }
}

extension HCCustomTextButton {
    
    private func initUI() {
        titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.textColor = RGB(153, 153, 153)
        titleLabel.font = .font(fontSize: 14)
        titleLabel.textAlignment = .center
        addSubview(titleLabel)
    }
}
