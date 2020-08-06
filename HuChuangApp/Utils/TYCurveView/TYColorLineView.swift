//
//  TYColorLineView.swift
//  HuChuangApp
//
//  Created by yintao on 2019/12/14.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit

class TYColorLineView: UIView {

    private var lineView: UIView!
    
    private var itemDatas: [TYLineItemModel] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        
        lineView = UIView.init(frame: bounds)
        lineView.backgroundColor = .white
        addSubview(lineView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func set(itemDatas: [TYLineItemModel]) {
        self.itemDatas.removeAll()
        self.itemDatas.append(contentsOf: itemDatas)
        
        var rect = lineView.frame
        rect.size.width = width
        lineView.frame = rect
                
        setupLine()
    }
    
    private func setupLine() {
        var pointX: CGFloat = 0
        var markXWidth: CGFloat = 0
        for i in 0..<itemDatas.count {
            let data = itemDatas[i]
            let lineWidth = CGFloat(data.lineCount) * 40.0
            let line = UIView.init(frame: .init(x: pointX, y: lineView.height / 2.0, width: lineWidth, height: lineView.height / 2.0))
            line.backgroundColor = data.color
            lineView.addSubview(line)
            
            markXWidth = pointX
            pointX += lineWidth
            // 点
            let pointSize: CGFloat = lineView.height / 2.0
            var itemPointX: CGFloat = 0.0
            for idx in 0..<data.pointDatas.count {
                let pointV = UIImageView.init(frame: .init(x: itemPointX - pointSize / 2.0, y: 0, width: pointSize, height: pointSize))
                pointV.backgroundColor = data.pointDatas[idx].bgColor
                pointV.clipsToBounds = true
                pointV.layer.cornerRadius = pointSize / 2
                pointV.layer.borderColor = data.pointDatas[idx].borderColor.cgColor
                pointV.layer.borderWidth = 1
                line.addSubview(pointV)

                let itemModel = data.pointDatas[idx]
                if itemModel.isMark {
                    let markX = markXWidth + itemPointX
                    let markV = UIImageView.init(frame: .init(x: markX - pointSize / 2.0, y: 0, width: pointSize, height: pointSize))
                    markV.backgroundColor = .clear
                    markV.image = itemModel.markIcon
                    lineView.addSubview(markV)
                }
                
                itemPointX += 40
            }
        }
    }
    
//    private func setupLine() {
//        let linePath = UIBezierPath.init()
//        linePath.move(to: .init(x: 0, y: 0))
//        linePath.addLine(to: .init(x: width, y: 0))
//
//        var strokeStart: CGFloat = 0
//        for data in itemDatas {
//            let shapeLayer = CAShapeLayer()
//            shapeLayer.path = linePath.cgPath
//            shapeLayer.lineWidth = 2 * lineView.height
//            shapeLayer.fillColor = UIColor.clear.cgColor
//            shapeLayer.strokeColor = data.color.cgColor
//            shapeLayer.strokeStart = strokeStart
//
//            let strokeEnd: CGFloat = strokeStart + data.percentage
//            shapeLayer.strokeEnd = strokeEnd
//
//            lineView.layer.addSublayer(shapeLayer)
//
//            strokeStart = strokeEnd
//        }
//
//        let pointSize: CGFloat = 2 * lineView.height
//        let pointMargin: CGFloat = lineView.width / CGFloat(pointDatas.count)
//        var pointX: CGFloat = 0.0
//
//        PrintLog("点总数：\(pointDatas.count) - 点大小：\(pointSize)")
//
//        for data in pointDatas {
//            let pointV = UIImageView.init(frame: .init(x: pointX, y: -lineView.height, width: pointSize, height: pointSize))
//            PrintLog("点位置：\(pointV.frame)")
//
//            pointV.backgroundColor = .white
//            pointV.clipsToBounds = true
//            pointV.layer.cornerRadius = pointSize / 2
//            pointV.layer.borderColor = data.borderColor.cgColor
//            pointV.layer.borderWidth = 1
//            lineView.addSubview(pointV)
//
//            pointX += (pointMargin - pointSize / 2.0)
//        }
//    }
}

struct TYLineItemModel {
    /// 每一段的颜色
    var color: UIColor = .white
    /// 每一段所占据的总宽度百分比
    var percentage: CGFloat = 0
    var lineCount: Int = 0
    /// 每一段上面的时间点
    var pointDatas: [TYPointItemModel] = []
}

struct TYPointItemModel {
    var borderColor: UIColor = .clear
    var bgColor: UIColor = .white
    /// 每个点对应的时间
    var time: String = ""
    /// 时间背景色
    var timeBgColor: UIColor = .clear
    /// 是否特殊需要标记
    var isMark: Bool = false
    /// 特殊标记的图标
    var markIcon: UIImage?
}
