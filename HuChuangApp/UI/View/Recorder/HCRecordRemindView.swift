//
//  HCRecordRemindView.swift
//  HuChuangApp
//
//  Created by yintao on 2019/10/20.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit

class HCRecordRemindView: UIView {

    private var remindLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = RGB(245, 245, 245)
        
        remindLabel = UILabel()
        remindLabel.textAlignment = .center
        remindLabel.font = .font(fontSize: 12)
        remindLabel.textColor = RGB(68, 68, 68)
        remindLabel.backgroundColor = .clear
        addSubview(remindLabel)
        
        let text = "·月经·排卵期·预测排卵日·标记排卵日·建议同房·已同房"
        let attr = NSMutableAttributedString.init(string: text)
        attr.addAttributes([NSAttributedString.Key.foregroundColor:RGB(254, 191, 210),
                            NSAttributedString.Key.font: UIFont.font(fontSize: 30, fontName: .PingFSemibold)],
                           range: .init(location: 0, length: 1))
        
        attr.addAttributes([NSAttributedString.Key.foregroundColor:RGB(254, 191, 210),
                            NSAttributedString.Key.font: UIFont.font(fontSize: 30, fontName: .PingFSemibold)],
                           range: .init(location: 3, length: 1))

        attr.addAttributes([NSAttributedString.Key.foregroundColor:RGB(254, 191, 210),
                            NSAttributedString.Key.font: UIFont.font(fontSize: 30, fontName: .PingFSemibold)],
                           range: .init(location: 7, length: 1))

        attr.addAttributes([NSAttributedString.Key.foregroundColor:RGB(254, 191, 210),
                            NSAttributedString.Key.font: UIFont.font(fontSize: 30, fontName: .PingFSemibold)],
                           range: .init(location: 13, length: 1))

        attr.addAttributes([NSAttributedString.Key.foregroundColor:RGB(254, 191, 210),
                            NSAttributedString.Key.font: UIFont.font(fontSize: 30, fontName: .PingFSemibold)],
                           range: .init(location: 19, length: 1))

        attr.addAttributes([NSAttributedString.Key.foregroundColor:RGB(254, 191, 210),
                            NSAttributedString.Key.font: UIFont.font(fontSize: 30, fontName: .PingFSemibold)],
                           range: .init(location: 24, length: 1))

        remindLabel.attributedText = attr
        
        remindLabel.snp.makeConstraints {
            $0.left.equalTo(12)
            $0.right.equalTo(-12)
            $0.top.bottom.equalTo(0)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
