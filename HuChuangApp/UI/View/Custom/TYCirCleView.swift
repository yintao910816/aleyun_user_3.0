//
//  TYCirCleView.swift
//  HuChuangApp
//
//  Created by yintao on 2019/11/22.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit

class TYCirCleView: UIView {

    private let lineWidth: CGFloat = 8
    
    private var percent: Float = 0
    
    private var titleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = .clear
        
        titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        titleLabel.font = .font(fontSize: 15, fontName: .PingFRegular)
        titleLabel.textColor = .white
        addSubview(titleLabel)
    }
        
    public func set(percent: Float) {
        self.percent = percent / 100.0
        let intPro: Int = Int((100.0 * percent) / 100.0)
        let title: String = "\(intPro)"

        let titleText = "\(title)%\n好孕率"
        
        let attr = titleText.attributed([NSRange.init(location: 0, length: title.count),
                                         NSRange.init(location: title.count, length: 1)],
                                        color: [.white, .white],
                                        font: [.font(fontSize: 20, fontName: .PingFSemibold),
                                               .font(fontSize: 12, fontName: .PingFRegular)])
        titleLabel.attributedText = attr
        
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
                
        let circleCenter = CGPoint.init(x: width/2.0, y: height/2.0)
        let radius: CGFloat = width/2.0 - lineWidth
        
        context.beginPath()
        context.setLineWidth(lineWidth)
        context.setStrokeColor(RGB(255, 255, 255, 0.4).cgColor)
                            
        let endAngle: CGFloat = 2 * CGFloat.pi
        context.addArc(center: circleCenter, radius: radius, startAngle: 0, endAngle: endAngle, clockwise: false)
        context.strokePath()
        
        // 外圆
        let startAngle : CGFloat = 1.5 * CGFloat.pi
        var arcEndAngle: CGFloat = CGFloat(percent * Float.pi)

        if percent > 0 {
            arcEndAngle = arcEndAngle >= 0.5 * CGFloat.pi ? arcEndAngle - 0.5 * CGFloat.pi : 2 * CGFloat.pi - arcEndAngle
        }else {
            arcEndAngle = startAngle
        }
        
        context.beginPath()
        context.setLineWidth(lineWidth)
        context.setStrokeColor(RGB(255, 255, 255).cgColor)

        context.addArc(center: circleCenter, radius: radius, startAngle: startAngle, endAngle: arcEndAngle, clockwise: false)
        context.strokePath()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.frame = bounds
    }
}
