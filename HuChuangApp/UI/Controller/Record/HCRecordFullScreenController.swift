//
//  HCRecordFullScreenController.swift
//  HuChuangApp
//
//  Created by yintao on 2019/12/23.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit

class HCRecordFullScreenController: BaseViewController {

    private var bgView: UIView!
    private var curveView: TYCurveView!
    private var markLabel: UILabel!

    public var model: HCRecordItemDataModel!
    
    override func setupUI() {
        hiddenBottomBg = true
        
        let appDelegate = UIApplication.shared.delegate as! HCAppDelegate
        appDelegate.allowRotation = true
        UIDevice.switchNewOrientation(.landscapeLeft)
        
        bgView = UIView.init(frame: view.bounds)
        bgView.backgroundColor = .white
        view.addSubview(bgView)
        
        markLabel = UILabel()
        markLabel.numberOfLines = 2
        markLabel.textColor = RGB(102, 102, 102)
        markLabel.font = .font(fontSize: 8)
        markLabel.textAlignment = .right
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
        style.alignment = .right
        attr.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: .init(location: 0, length: attr.length))
        
        markLabel.attributedText = attr
        
        bgView.addSubview(markLabel)
        
        markLabel.snp.makeConstraints {
            $0.right.equalTo(0)
            $0.top.equalTo(0)
        }

        curveView = TYCurveView.init(frame: view.bounds)
        curveView.backgroundColor = .white
        curveView.hiddenRemind = true
        curveView.fullScreenImage = UIImage(named: "record_button_screenback")
        bgView.addSubview(curveView)
        
        curveView.fullScreenCallBack = { [unowned self] in
            let appDelegate = UIApplication.shared.delegate as! HCAppDelegate
            appDelegate.allowRotation = false
            UIDevice.switchNewOrientation(.portrait)

            self.dismiss(animated: true, completion: nil)
        }
        
        curveView.setData(probabilityDatas: model.probabilityDatas,
                          itemDatas: model.lineItemDatas,
                          title: model.isContrast ? model.nowCircle : model.curelTitle,
                          nowIdx: model.nowDateIdxOfCircle,
                          isCircleSet: model.circleIsSet)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        var insets = UIEdgeInsets.zero
        if #available(iOS 11.0, *) {
            insets = view.safeAreaInsets
        }
        
        bgView.frame = view.bounds
        
        markLabel.snp.updateConstraints {
            $0.top.equalTo(insets.top + 30)
            $0.right.equalTo(-(insets.right + 30))
        }
        
        curveView.frame = .init(x: insets.left,
                                y: view.height - TYCurveView.viewHeight - insets.bottom,
                                width: view.width - insets.left - insets.right,
                                height: TYCurveView.viewHeight)
    }
    
}
