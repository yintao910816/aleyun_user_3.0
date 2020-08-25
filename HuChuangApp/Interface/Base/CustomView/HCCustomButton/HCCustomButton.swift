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
    private var button: UIButton!
    
    private var firstString: String = ""
    private var secondString: String = ""
    
    public var actionCallBack: (()->())?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setupText(first: String,
                          second: String,
                          firstTitleFont: UIFont = .font(fontSize: 20, fontName: .PingFSemibold),
                          secondTitleFont: UIFont = .font(fontSize: 14),
                          firstTitleColor: UIColor = RGB(51, 51, 51),
                          secondTitleColor: UIColor = RGB(153, 153, 153),
                          backGroundColor: UIColor = .clear) {
        self.backgroundColor = backGroundColor
        titleLabel.textColor = firstTitleColor
        titleLabel.font = firstTitleFont
        
        firstString = first
        secondString = second
        
        let string = NSMutableAttributedString.init(string: "\(firstString)\n\(secondString)")
        
        string.addAttributes([NSAttributedString.Key.foregroundColor : firstTitleColor,
                              NSAttributedString.Key.font : firstTitleFont],
                             range: NSRange.init(location: 0, length: firstString.count))
        
        string.addAttributes([NSAttributedString.Key.foregroundColor : secondTitleColor,
                              NSAttributedString.Key.font : secondTitleFont],
                             range: NSRange.init(location: firstString.count + 1, length: secondString.count))
        titleLabel.attributedText = string
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.frame = bounds
        button.frame = bounds
    }
}

extension HCCustomTextButton {
    
    private func initUI() {
        titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.textColor = RGB(153, 153, 153)
        titleLabel.font = .font(fontSize: 14)
        titleLabel.textAlignment = .center
        
        button = UIButton()
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(clicked), for: .touchUpInside)
        
        addSubview(titleLabel)
        addSubview(button)
    }
    
    @objc private func clicked() {
        actionCallBack?()
    }
}
