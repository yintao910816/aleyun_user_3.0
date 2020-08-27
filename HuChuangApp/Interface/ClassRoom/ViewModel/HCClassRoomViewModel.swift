//
//  HCClassRoomViewModel.swift
//  HuChuangApp
//
//  Created by sw on 2019/9/28.
//  Copyright © 2019 sw. All rights reserved.
//

import Foundation
import RxSwift

class HCClassRoomViewModel: BaseViewModel {
    
    public let reloadSignal = PublishSubject<([HCClassRoomSectionModel], [HCBannerModel])>()
    
    override init() {
        super.init()
        
        reloadSubject.subscribe(onNext: { [unowned self] in self.test() })
            .disposed(by: disposeBag)
    }
    
    private func test() {
        let data = [HCClassRoomSectionModel.init(sectionInfo: HCClassRoomSectionInfo.init(sectionTitle: "孕乐直播",
                                                                                          detailTitle: "更多直播",
                                                                                          headerReuseIdentifier: HCClassRoomBannerReusableView_identifier,
                                                                                          headerReuseSize: HCClassRoomBannerReusableView_size,
                                                                                          cellIdentifier: HCClassRoomLiveVideoCell_identifier,
                                                                                          titleBgImg: UIImage(named: "circle_red")),
                                                 datas: [HCClassRoomLiveVideoModel(), HCClassRoomLiveVideoModel()]),
                    HCClassRoomSectionModel.init(sectionInfo: HCClassRoomSectionInfo.init(sectionTitle: "好课上新",
                                                                                          detailTitle: "",
                                                                                          headerReuseIdentifier: HCClassRoomHeaderReusableView_identifier,
                                                                                          headerReuseSize: HCClassRoomHeaderReusableView_size,
                                                                                          cellIdentifier: HCClassRoomGoodCell_identifier,
                                                                                          titleBgImg: UIImage(named: "circle_yellow")),
                                                 datas: [HCClassRoomGoodModel(), HCClassRoomGoodModel()]),
                    HCClassRoomSectionModel.init(sectionInfo: HCClassRoomSectionInfo.init(sectionTitle: "精选推荐",
                                                                                          detailTitle: "",
                                                                                          headerReuseIdentifier: HCClassRoomHeaderReusableView_identifier,
                                                                                          headerReuseSize: HCClassRoomHeaderReusableView_size,
                                                                                          cellIdentifier: HCClassRoomGoodRecommendCell_identifier,
                                                                                          titleBgImg: UIImage(named: "circle_green")),
                                                 datas: [HCClassRoomGoodRecommendModel(), HCClassRoomGoodRecommendModel()]),
                    HCClassRoomSectionModel.init(sectionInfo: HCClassRoomSectionInfo.init(sectionTitle: "乐孕FM",
                                                                                          detailTitle: "查看更多",
                                                                                          headerReuseIdentifier: HCClassRoomHeaderReusableView_identifier,
                                                                                          headerReuseSize: HCClassRoomHeaderReusableView_size,
                                                                                          cellIdentifier: HCClassRoomFMCell_identifier,
                                                                                          titleBgImg: UIImage(named: "circle_blue")),
                                                 datas: [HCClassRoomFMModel(), HCClassRoomFMModel()]),
                    HCClassRoomSectionModel.init(sectionInfo: HCClassRoomSectionInfo.init(sectionTitle: "精选好课",
                                                                                          detailTitle: "",
                                                                                          headerReuseIdentifier: HCClassRoomHeaderReusableView_identifier,
                                                                                          headerReuseSize: HCClassRoomHeaderReusableView_size,
                                                                                          cellIdentifier: HCClassRoomGoodRecommendCell_identifier,
                                                                                          titleBgImg: UIImage(named: "circle_purple")),
                                                 datas: [HCClassRoomGoodRecommendModel(), HCClassRoomGoodRecommendModel()])]
        
        
        reloadSignal.onNext((data, [HCBannerModel(), HCBannerModel()]))
    }
}
