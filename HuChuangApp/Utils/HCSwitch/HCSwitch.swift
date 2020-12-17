//
//  HCSwitch.swift
//  HuChuangApp
//
//  Created by yintao on 2020/12/16.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

public let HCSwitchNormalSize: CGSize = .init(width: 70, height: 30)

class HCSwitch: UIButton {

    private var leftLabel: UILabel!
    private var rightLabel: UILabel!
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = RGB(238, 238, 238)
        layer.cornerRadius = 8
        clipsToBounds = true
        
        leftLabel = UILabel()
        leftLabel.text = leftTitle
        leftLabel.textAlignment = .center
        leftLabel.font = .font(fontSize: 13, fontName: .PingFMedium)
        leftLabel.textColor = normalTitleColor
        leftLabel.layer.cornerRadius = 8
        leftLabel.clipsToBounds = true
        leftLabel.backgroundColor = normalBgColor

        rightLabel = UILabel()
        rightLabel.text = rightTitle
        rightLabel.textAlignment = .center
        rightLabel.font = .font(fontSize: 13, fontName: .PingFMedium)
        rightLabel.textColor = selectedTitleColor
        rightLabel.layer.cornerRadius = 8
        rightLabel.clipsToBounds = true
        rightLabel.backgroundColor = selectedBgColor

        addSubview(leftLabel)
        addSubview(rightLabel)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    public var isOn: Bool = false {
        didSet {
            if isOn {
                leftLabel.backgroundColor = selectedBgColor
                rightLabel.backgroundColor = normalBgColor
                
                leftLabel.textColor = selectedTitleColor
                rightLabel.textColor = normalTitleColor
            }else {
                leftLabel.backgroundColor = normalBgColor
                rightLabel.backgroundColor = selectedBgColor
                
                leftLabel.textColor = normalTitleColor
                rightLabel.textColor = selectedTitleColor
            }
        }
    }

    public var leftTitle: String = "是" {
        didSet {
            leftLabel.text = leftTitle
        }
    }
    
    public var rightTitle: String = "否" {
        didSet {
            rightLabel.text = rightTitle
        }
    }
    
    public var selectedTitleColor: UIColor = .white {
        didSet {
            if isOn {
                rightLabel.textColor = normalTitleColor
                leftLabel.textColor = selectedTitleColor
            }else {
                rightLabel.textColor = selectedTitleColor
                leftLabel.textColor = normalTitleColor
            }
        }
    }
    
    public var normalTitleColor: UIColor = RGB(153, 153, 153) {
        didSet {
            if isOn {
                rightLabel.textColor = normalTitleColor
                leftLabel.textColor = selectedTitleColor
            }else {
                rightLabel.textColor = selectedTitleColor
                leftLabel.textColor = normalTitleColor
            }
        }
    }
    
    public var selectedBgColor: UIColor = RGB(255, 79, 120) {
        didSet {
            if isOn {
                rightLabel.backgroundColor = normalBgColor
                leftLabel.backgroundColor = selectedBgColor
            }else {
                rightLabel.backgroundColor = selectedBgColor
                leftLabel.backgroundColor = normalBgColor
            }
        }
    }
    
    public var normalBgColor: UIColor = RGB(238, 238, 238) {
        didSet {
            if isOn {
                rightLabel.backgroundColor = normalBgColor
                leftLabel.backgroundColor = selectedBgColor
            }else {
                rightLabel.backgroundColor = selectedBgColor
                leftLabel.backgroundColor = normalBgColor
            }
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        let w = width / 2.0
        
        leftLabel.frame = .init(x: 0, y: 0, width: w, height: height)
        rightLabel.frame = .init(x: leftLabel.frame.maxX, y: 0, width: w, height: height)
    }
}

extension HCSwitch {
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        let originPoint = touch.location(in: self)
        let lastIsOn = isOn
        isOn = originPoint.x <= width / 2
        
        if lastIsOn != isOn {
            sendActions(for: .valueChanged)
        }
    }
}
