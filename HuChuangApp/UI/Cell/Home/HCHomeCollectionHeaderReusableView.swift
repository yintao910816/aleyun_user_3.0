//
//  HCHomeCollectionHeaderReusableView.swift
//  HuChuangApp
//
//  Created by yintao on 2019/9/22.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit
import RxSwift

public let HCHomeCollectionHeaderReusableView_identifier = "HCHomeCollectionHeaderReusableView"

class HCHomeCollectionHeaderReusableView: UICollectionReusableView {

    @IBOutlet private var contentView: UICollectionReusableView!
    @IBOutlet private weak var carouselView: CarouselView!
    @IBOutlet weak var goDoctorOutlet: UIButton!
    @IBOutlet weak var paiNuanOutlet: UILabel!
    @IBOutlet weak var nextDayOutlet: UILabel!
    @IBOutlet weak var circleView: TYCirCleView!
    
    private var disposeBag = DisposeBag()

    public let bannerObser = PublishSubject<[HomeBannerModel]>()
    public var clickedMoreCallBack: (()->())?
    public var gotoPageHomeCallBack: (()->())?
    public var gotoRecordCallBack: (()->())?

    @IBAction func actions(_ sender: UIButton) {
        if sender.tag == 200 {
            // 更多
            clickedMoreCallBack?()
        }else if sender.tag == 201 {
            // 点击去爱乐孕治疗
            gotoPageHomeCallBack?()
        }
    }
    
    @objc private func tapGesAction(_ sender: UITapGestureRecognizer) {
        gotoRecordCallBack?()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView = (Bundle.main.loadNibNamed("HCHomeCollectionHeaderReusableView", owner: self, options: nil)?.first as! UICollectionReusableView)
        addSubview(contentView)
        
        goDoctorOutlet.layer.borderColor = UIColor.white.cgColor
        goDoctorOutlet.layer.borderWidth = 2
        
        contentView.snp.makeConstraints{ $0.edges.equalTo(UIEdgeInsets.zero) }
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapGesAction(_:)))
        (viewWithTag(1000))?.addGestureRecognizer(tap)
        
        rxBind()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func rxBind() {
        let paiNuanText = "距离排卵日还有0天"
        paiNuanOutlet.attributedText = paiNuanText.attributed(.init(location: 7, length: 2), .white, .font(fontSize: 21, fontName: .PingFMedium))
        
        let nextDayText = "明日好运率0%"
        nextDayOutlet.attributedText = nextDayText.attributed(.init(location: 5, length: 2), .white, .font(fontSize: 21, fontName: .PingFMedium))

        bannerObser
            .subscribe(onNext: { [weak self] data in
                self?.carouselView.setData(source: data)
            })
            .disposed(by: disposeBag)        
    }
    
    public var model: HCPregnancyProbabilityModel! {
        didSet {
            circleView.set(percent: model.todayProbability)
            paiNuanOutlet.attributedText = model.caculateOvulationDate()
            
            let intPro: Int = Int((100.0 * model.tomorrowProbability) / 100.0)
            let nextDayText = "明日好运率\(intPro)%"
            nextDayOutlet.attributedText = nextDayText.attributed(.init(location: 5, length: nextDayText.count - 5), .white, .font(fontSize: 21, fontName: .PingFMedium))
        }
    }
}
