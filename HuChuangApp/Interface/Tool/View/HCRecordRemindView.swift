//
//  HCRecordRemindView.swift
//  HuChuangApp
//
//  Created by yintao on 2019/10/20.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit

public let HCRecordRemindView_height: CGFloat = 45

class HCRecordRemindView: UIView {
    
    private let texts: [String] = ["月经期", "预测经期", "安全期", "易孕期", "排卵日"]
    private let colors: [UIColor] = [RGB(255, 79, 120), RGB(254, 199, 203), RGB(109, 206, 111), RGB(195, 172, 230), RGB(239, 135, 198)]

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = RGB(245, 245, 245)
                
        for idx in 0..<texts.count {
            let img = UIImageView()
            img.tag = 200 + idx
            
            if texts[idx] == "排卵日" {
                img.image = UIImage(named: "tool_painuanri")
            }else {
                img.backgroundColor = colors[idx]
            }
            
            let contentLabel = UILabel()
            contentLabel.text = texts[idx]
            contentLabel.textColor = RGB(153, 153, 153)
            contentLabel.font = .font(fontSize: 12)
            contentLabel.tag = 300 + idx
            
            addSubview(img)
            addSubview(contentLabel)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        var lastMaxX: CGFloat = 0
        for idx in 0..<texts.count {
            let img = viewWithTag(200 + idx)
            let contentLabel = viewWithTag(300 + idx)
            
            let contentSize: CGSize = contentLabel?.sizeThatFits(.init(width: CGFloat(MAXFLOAT), height: 16)) ?? .zero
            
            if lastMaxX == 0 {
                img?.frame = .init(origin: .init(x: 12, y: (height - 12) / 2.0), size: .init(width: 12, height: 12))
            }else {
                img?.frame = .init(origin: .init(x: lastMaxX + 15, y: (height - 12) / 2.0), size: .init(width: 12, height: 12))
            }
            contentLabel?.frame = .init(origin: .init(x: (img?.frame.maxX ?? 0) + 3, y: (height - 16) / 2.0), size: contentSize)
            
            lastMaxX = contentLabel?.frame.maxX ?? 0
        }
    }
}
