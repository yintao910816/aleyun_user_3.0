//
//  HCCurveCell.swift
//  HuChuangApp
//
//  Created by yintao on 2019/12/13.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit
import RxSwift

public let HCCurveCell_identifier = "HCCurveCell"
public let HCCurveCell_height: CGFloat = TYCurveView.viewHeight

class HCCurveCell: HCBaseRecordCell {
    
    private let disposeBag = DisposeBag()

    private var curveView: TYCurveView!
    
    public var fullScreenCallBack: (()->())?
    public var scrollViewDidScrollCallBack: ((CGFloat)->())?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        NotificationCenter.default.rx.notification(NotificationName.UserInterface.recordScroll)
            .subscribe(onNext: { [weak self] no in
                guard let data = no.object as? (CGFloat, HCCurveCell), let strongSelf = self else { return }
                if data.1 != strongSelf {
                    strongSelf.setOffsetX(data.0)
                }
            })
            .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var model: HCRecordData! {
        didSet {
            guard let proModel = model as? HCRecordItemDataModel else {
                return
            }
            
            if curveView != nil { curveView.removeFromSuperview() }
            
            curveView = TYCurveView.init(frame: bounds)
            curveView.backgroundColor = .white
            contentView.addSubview(curveView)
            
            curveView.scrollViewDidScrollCallBack = { [weak self] in self?.scrollViewDidScrollCallBack?($0) }
            
            curveView.fullScreenCallBack = { [unowned self] in
                self.fullScreenCallBack?()
            }

            curveView.setData(probabilityDatas: proModel.probabilityDatas,
                              itemDatas: proModel.lineItemDatas,
                              title: proModel.isContrast ? proModel.nowCircle : proModel.curelTitle,
                              nowIdx: proModel.isContrast ? 0 : proModel.nowDateIdxOfCircle,
                              isCircleSet: proModel.circleIsSet)
        }
    }
     
    public func setOffsetX(_ offsetX: CGFloat) {
        if curveView != nil {
            curveView.setOffsetX(offsetX)
        }
    }
}
