//
//  HCClassRoomBannerReusableView.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/27.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

public let HCClassRoomBannerReusableView_identifier = "HCClassRoomBannerReusableView"
public let HCClassRoomBannerReusableView_size: CGSize = .init(width: PPScreenW, height: 230)

class HCClassRoomBannerReusableView: HCClassRoomBaseReusableView {
        
    private var carouselView: CarouselView!
    private var titleView: HCClassRoomHeaderReusableView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var model: HCClassRoomSectionInfo! {
        didSet {
            titleView.setup(with: model.sectionTitle, subTitle: model.detailTitle, titleBgImg: model.titleBgImg)
        }
    }
    
    public var bannerModes: [HCBannerModel] = [] {
        didSet {
            carouselView.setData(source: bannerModes)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        carouselView.frame = .init(x: 15, y: 0, width: width - 30, height: 180)
        titleView.frame = .init(x: 0, y: carouselView.frame.maxY + 25, width: width, height: 25)
    }
}

extension HCClassRoomBannerReusableView {
    
    private func initUI() {
        carouselView = CarouselView()
        carouselView.layer.cornerRadius = 3

        titleView = HCClassRoomHeaderReusableView()
        
        addSubview(carouselView)
        addSubview(titleView)
    }
}
