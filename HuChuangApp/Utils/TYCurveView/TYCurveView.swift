//
//  TYCurveView.swift
//  HuChuangApp
//
//  Created by yintao on 2019/12/11.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit
import RxSwift

class TYCurveView: UIView {
    private let disposeBag = DisposeBag()

    private var scrollView: UIScrollView!
    private var curveView: UIView!
    private var bezierLineLayer: CAShapeLayer!
    
    private var probabilityLabel: UILabel!
    private var sepLine: UIView!
    
    private var lineView: TYColorLineView!
    private var timeView: TYCurveTimeView!
    
    private var titleBgView: UIView!
    private var titleLable: UILabel!
    private var fullScreenButton: UIButton!
    private var markLabel: UILabel!
    private var noConentRemindLabel: UILabel!
    
    private var curveTimeBgView: UIView!
    private var remindBgView: UIView!

    private var pointsArray: [CGPoint] = []
    
    private var probabilityDatas: [Float] = []
    private var timesDatas: [String] = []
    private var nowIdx: Int = 0
    private var isCircleSet: Bool = false
    
    /// 标题
    private var titleViewHeight: CGFloat = 25
    /// 时间
    private var curvelTimeViewHeight: CGFloat = 55
    /// 备注曲线颜色
    private var remindViewHeight: CGFloat = 45
    
    private var curvelViewWidth: CGFloat = 0
    private var curvelViewHeight: CGFloat = 190
    
    private var lineHeight: CGFloat = 10
    
    public var fullScreenCallBack: (()->())?
    public var scrollViewDidScrollCallBack: ((CGFloat)->())?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupUI()
    }
    
    private func setupUI() {
        curvelViewWidth = width
        curvelViewHeight = TYCurveView.viewHeight - remindViewHeight - titleViewHeight
        
        titleBgView = UIView()
        titleBgView.backgroundColor = .clear
        
        titleLable = UILabel()
        titleLable.text = "好孕率趋势图"
        titleLable.backgroundColor = .clear
        titleLable.textColor = RGB(51, 51, 51)
        titleLable.font = .font(fontSize: 11)
        
        fullScreenButton = UIButton()
        fullScreenButton.setImage(UIImage(named: "record_button_screen"), for: .normal)
        fullScreenButton.addTarget(self, action: #selector(fullScreenAction), for: .touchUpInside)
        
        noConentRemindLabel = UILabel()
        noConentRemindLabel.textAlignment = .center
        noConentRemindLabel.text = "暂无数据..."
        noConentRemindLabel.font = .font(fontSize: 15)
        noConentRemindLabel.textColor = RGB(254, 192, 65)
        
        curveView = UIView()
        curveView.backgroundColor = .clear
        
        curveTimeBgView = UIView()
        curveTimeBgView.backgroundColor = .clear

        remindBgView = UIView()
        remindBgView.backgroundColor = RGB(240, 240, 240)
        
        markLabel = UILabel()
        markLabel.numberOfLines = 2
        markLabel.textColor = RGB(102, 102, 102)
        markLabel.font = .font(fontSize: 8)
        markLabel.textAlignment = .center
        markLabel.backgroundColor = .clear

        let text1 = "月经期    ".prepare(markColor: RGB(213, 89, 92), textColor: RGB(102, 102, 102), textFont: .font(fontSize: 8))
        let text2 = "安全期    ".prepare(markColor: RGB(84, 197, 141), textColor: RGB(102, 102, 102), textFont: .font(fontSize: 8))
        let text3 = "排卵期    ".prepare(markColor: RGB(255, 113, 17), textColor: RGB(102, 102, 102), textFont: .font(fontSize: 8))
        let text4 = "排卵日    ".prepare(markColor: HC_MAIN_COLOR, textColor: RGB(102, 102, 102), textFont: .font(fontSize: 8))
        let text5 = "建议同房".prepare(markImage: UIImage(named: "record_icon_love"), textColor: RGB(102, 102, 102), textFont: .font(fontSize: 8), isRound: false)
//        let text6 = NSAttributedString.init(string: "\n预测：半透明    实际：100%不透明")
        
        let attr = NSMutableAttributedString.init(attributedString: text1)
        attr.append(text2)
        attr.append(text3)
        attr.append(text4)
        attr.append(text5)
//        attr.append(text6)
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 10
        style.alignment = .center
        attr.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: .init(location: 0, length: attr.length))
        
        markLabel.attributedText = attr
                
        scrollView = UIScrollView.init()
        scrollView.bounces = false
        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        probabilityLabel = UILabel()
        probabilityLabel.textAlignment = .center
        probabilityLabel.font = .font(fontSize: 6)
        probabilityLabel.backgroundColor = RGB(84, 197, 141)
        probabilityLabel.textColor = .white
        probabilityLabel.layer.cornerRadius = 17
        probabilityLabel.clipsToBounds = true
        
        sepLine = UIView()
        sepLine.backgroundColor = RGB(204, 204, 204)
        
        lineView = TYColorLineView.init(frame: .init(x: 0, y: 0, width: width, height: lineHeight))
        lineView.backgroundColor = .white
        
        timeView = TYCurveTimeView()
        timeView.itemSize = .init(width: itemWidth, height: curvelTimeViewHeight - lineHeight)
        timeView.backgroundColor = .white
        
        addSubview(noConentRemindLabel)

        addSubview(scrollView)
        scrollView.addSubview(curveView)
        scrollView.addSubview(lineView)
        scrollView.addSubview(curveTimeBgView)
        curveTimeBgView.addSubview(timeView)

        addSubview(titleBgView)
        titleBgView.addSubview(titleLable)
        titleBgView.addSubview(fullScreenButton)
        addSubview(remindBgView)
        remindBgView.addSubview(markLabel)
        
        addSubview(sepLine)
        addSubview(probabilityLabel)
    }
    
    private func setProbability(probability: Float) {
        let intPro: Int = Int(100 * probability)
        let nextDayText = "\(intPro)%"
        probabilityLabel.attributedText = nextDayText.attributed(.init(location: 0, length: nextDayText.count - 1), .white, .font(fontSize: 18))
    }
    
    @objc private func fullScreenAction() {
        fullScreenCallBack?()
    }
    
    public class var viewHeight: CGFloat {
        get {
            return 300
        }
    }
    
    public var itemWidth: CGFloat = 40 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public var hiddenRemind: Bool = false {
        didSet {
            remindBgView.isHidden = hiddenRemind
        }
    }
    
    public var fullScreenImage: UIImage? {
        didSet {
            fullScreenButton.setImage(fullScreenImage, for: .normal)
        }
    }
    
    public var curvelContentTextHeight: CGFloat = 40.0
    
    public func setData(probabilityDatas: [Float], itemDatas: [TYLineItemModel], title: String, nowIdx: Int, isCircleSet: Bool) {
        self.isCircleSet = isCircleSet
        
        if isCircleSet {
            remindBgView.isHidden = false
            fullScreenButton.isHidden = false
            probabilityLabel.isHidden = false
            sepLine.isHidden = false
            noConentRemindLabel.isHidden = true
            
            self.probabilityDatas = probabilityDatas
            self.nowIdx = nowIdx

            self.titleLable.text = title
            setProbability(probability: probabilityDatas.first ?? 0.01)
            
            curvelViewWidth = CGFloat(probabilityDatas.count - 1) * itemWidth
            
            lineView.frame = .init(x: 0, y: curvelViewHeight - curvelTimeViewHeight - lineHeight,
                                   width: curvelViewWidth,
                                   height: lineHeight)
            lineView.set(itemDatas: itemDatas)

            timeView.frame = .init(x: itemWidth / 2.0, y: 0,
                                   width: curvelViewWidth,
                                   height: curvelTimeViewHeight - lineHeight)
            timeView.itemModels = itemDatas
            
            setNeedsDisplay()
            layoutIfNeeded()
        }else {
            remindBgView.isHidden = true
            fullScreenButton.isHidden = true
            probabilityLabel.isHidden = true
            sepLine.isHidden = true
            noConentRemindLabel.isHidden = false
        }
    }
    
    public func setOffsetX(_ offsetX: CGFloat) {
        if offsetX != scrollView.contentOffset.x {
            scrollView.setContentOffset(.init(x: offsetX, y: 0), animated: false)
            
            let scrollWidth: CGFloat = scrollView.contentOffset.x
            var intX: Int = Int(scrollWidth / itemWidth)
            let floatX: CGFloat = scrollWidth.truncatingRemainder(dividingBy: itemWidth)

            if floatX > itemWidth / 2.0 {
                intX += 1
            }
            
            if intX < probabilityDatas.count, intX >= 0 {
                setProbability(probability: probabilityDatas[intX])
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let noConentRemindLabelSize = noConentRemindLabel.sizeThatFits(.init(width: width, height: 30))
        noConentRemindLabel.frame = .init(x: (width - noConentRemindLabelSize.width) / 2.0,
                                          y: (height - titleViewHeight - noConentRemindLabelSize.height) / 2.0,
                                          width: noConentRemindLabelSize.width,
                                          height: noConentRemindLabelSize.height)
        
        titleBgView.frame = .init(x: 0, y: 0, width: width, height: titleViewHeight)
        let titleSize = titleLable.sizeThatFits(.init(width: titleBgView.width, height: titleBgView.height))
        titleLable.frame = .init(x: 15, y: (titleBgView.height - titleSize.height) / 2.0, width: titleSize.width, height: titleSize.height)
        let fullScreenImageSize = CGSize.init(width: titleBgView.height, height: titleBgView.height)
        fullScreenButton.frame = .init(x: titleBgView.width - 7 - fullScreenImageSize.width,
                                       y: (titleBgView.height - fullScreenImageSize.height) / 2.0,
                                       width: fullScreenImageSize.width,
                                       height: fullScreenImageSize.height)
        
        curveView.frame = .init(x: width / 2.0, y: 0,
                                width: curvelViewWidth,
                                height: curvelViewHeight - curvelTimeViewHeight)

        scrollView.frame = .init(x: 0, y: titleBgView.frame.maxY,
                                 width: width,
                                 height: curvelViewHeight)


        remindBgView.frame = .init(x: 0, y: scrollView.frame.maxY, width: width, height: remindViewHeight)
        markLabel.frame = .init(x: 30, y: 0, width: remindBgView.width - 60, height: remindViewHeight)
        
        probabilityLabel.frame = .init(x: (width - 33) / 2.0,
                                       y: titleBgView.frame.maxY,
                                       width: 34, height: 34)
        sepLine.frame = .init(x: (width - 1) / 2.0,
                              y: probabilityLabel.frame.maxY,
                              width: 1,
                              height: curveView.height - probabilityLabel.height + lineHeight / 2.0)
        
        lineView.frame = .init(x: width / 2.0, y: curveView.frame.maxY,
                               width: curvelViewWidth,
                               height: lineHeight)
        
        curveTimeBgView.frame = .init(x: width / 2.0 - itemWidth / 2.0,
                                      y: lineView.frame.maxY,
                                      width: curvelViewWidth + itemWidth,
                                      height: curvelTimeViewHeight - lineHeight)
        timeView.frame = curveTimeBgView.bounds
        
        scrollView.contentSize = .init(width: curveView.width  + width, height: curvelViewHeight)
        setOffsetX(CGFloat(nowIdx) * itemWidth)
    }
    
    override func draw(_ rect: CGRect) {
        guard probabilityDatas.count >= 4, isCircleSet else { return }
        
        transformPoint()
                
        var path = UIBezierPath.init()
        
        for idx in 0..<(pointsArray.count - 4) {
            let p1 = pointsArray[idx]
            let p2 = pointsArray[idx + 1]
            let p3 = pointsArray[idx + 2]
            let p4 = pointsArray[idx + 3]
            
            if idx == 0 {
                path.move(to: p2)
            }
                        
            getControlPoint(x0: p1.x, y0: p1.y,
                            x1: p2.x, y1: p2.y,
                            x2: p3.x, y2: p3.y,
                            x3: p4.x, y3: p4.y,
                            path: &path)
        }
        
        /** 将折线添加到折线图层上，并设置相关的属性 */
        bezierLineLayer = CAShapeLayer.init()
        bezierLineLayer.path = path.cgPath
        bezierLineLayer.strokeColor = HC_MAIN_COLOR.cgColor;
        bezierLineLayer.fillColor = UIColor.clear.cgColor;
        // 默认设置路径宽度为0，使其在起始状态下不显示
        bezierLineLayer.lineWidth = 2;
        bezierLineLayer.lineCap = CAShapeLayerLineCap.round;
        bezierLineLayer.lineJoin = CAShapeLayerLineJoin.round;

        curveView.layer.addSublayer(bezierLineLayer)
    }
}

extension TYCurveView {
    
    /// 将好运率数据转化为坐标
    private func transformPoint() {
        let leftMargin: CGFloat = itemWidth / 2.0
        let drawHeight = curvelViewHeight - curvelTimeViewHeight
        for idx in 0..<probabilityDatas.count {
            var x: CGFloat = 0.0
            let y = drawHeight - CGFloat(probabilityDatas[idx]) * drawHeight
            if idx == 0 { x = leftMargin }
            else { x = leftMargin + CGFloat(idx) * itemWidth }
                        
            pointsArray.append(.init(x: x, y: y - 30))
        }
        
        /// 添加首尾两个点, 用于求出第一条曲线和最后一条曲线控制点的坐标点
        pointsArray.insert(.init(x: 0, y: drawHeight - leftMargin), at: 0)
        pointsArray.append(.init(x: curvelViewWidth, y: drawHeight - leftMargin))
    }
    
    private func getControlPoint(x0: CGFloat, y0: CGFloat,
                                 x1: CGFloat, y1: CGFloat,
                                 x2: CGFloat, y2: CGFloat,
                                 x3: CGFloat, y3: CGFloat,
                                 path: inout UIBezierPath)
    {
        let smooth_value: CGFloat = 0.6
        var ctrl1_x: CGFloat = 0
        var ctrl1_y: CGFloat = 0
        var ctrl2_x: CGFloat = 0
        var ctrl2_y: CGFloat = 0
        let xc1 = (x0 + x1) / 2.0
        let yc1 = (y0 + y1) / 2.0
        let xc2 = (x1 + x2) / 2.0
        let yc2 = (y1 + y2) / 2.0
        let xc3 = (x2 + x3) / 2.0
        let yc3 = (y2 + y3) / 2.0
        let len1 = sqrt((x1-x0) * (x1-x0) + (y1-y0) * (y1-y0))
        let len2 = sqrt((x2-x1) * (x2-x1) + (y2-y1) * (y2-y1))
        let len3 = sqrt((x3-x2) * (x3-x2) + (y3-y2) * (y3-y2))
        let k1 = len1 / (len1 + len2)
        let k2 = len2 / (len2 + len3)
        let xm1 = xc1 + (xc2 - xc1) * k1
        let ym1 = yc1 + (yc2 - yc1) * k1
        let xm2 = xc2 + (xc3 - xc2) * k2
        let ym2 = yc2 + (yc3 - yc2) * k2
        ctrl1_x = xm1 + (xc2 - xm1) * smooth_value + x1 - xm1;
        ctrl1_y = ym1 + (yc2 - ym1) * smooth_value + y1 - ym1;
        ctrl2_x = xm2 + (xc2 - xm2) * smooth_value + x2 - xm2;
        ctrl2_y = ym2 + (yc2 - ym2) * smooth_value + y2 - ym2;
                        
        path.addCurve(to: .init(x: x2, y: y2),
                      controlPoint1: .init(x: ctrl1_x, y: ctrl1_y),
                      controlPoint2: .init(x: ctrl2_x, y: ctrl2_y))
    }

}

extension TYCurveView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollViewDidScrollCallBack?(scrollView.contentOffset.x)
        resetContentOffset(needScroll: false)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        resetContentOffset(needScroll: true)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            resetContentOffset(needScroll: true)
        }
    }
    
    private func resetContentOffset(needScroll: Bool) {
        let scrollWidth: CGFloat = scrollView.contentOffset.x
        let floatX: CGFloat = scrollWidth.truncatingRemainder(dividingBy: itemWidth)
        var intX: Int = Int(scrollWidth / itemWidth)
        if floatX > itemWidth / 2.0 {
            intX += 1
        }
        
        if intX < probabilityDatas.count, intX >= 0 {
            setProbability(probability: probabilityDatas[intX])
        }
        
        if needScroll {
            let offsetPoint: CGPoint = .init(x: CGFloat(intX) * itemWidth, y: 0)
            PrintLog(offsetPoint)
            scrollView.setContentOffset(offsetPoint, animated: true)
        }
    }
}
