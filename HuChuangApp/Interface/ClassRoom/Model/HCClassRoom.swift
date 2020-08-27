//
//  HCClassRoom.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/27.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation

class HCClassRoomSectionModel {
    
    var sectionInfo: HCClassRoomSectionInfo = HCClassRoomSectionInfo()
    var datas: [HCClassRoomDataProtocol] = []
    
    init(sectionInfo: HCClassRoomSectionInfo, datas: [HCClassRoomDataProtocol]) {
        self.sectionInfo = sectionInfo
        self.datas = datas
    }
}

class HCClassRoomSectionInfo {
    
    var sectionTitle: String = ""
    var detailTitle: String = ""
    var headerReuseIdentifier: String = ""
    var headerReuseSize: CGSize = .zero
    var sectionInset: UIEdgeInsets = .zero
    var cellIdentifier: String = ""
    
    var minimumLineSpacing: CGFloat = 0
    var minimumInteritemSpacing: CGFloat = 0
    var titleBgImg: UIImage? = nil
    
    init() { }
    
    init(sectionTitle: String = "",
         detailTitle: String = "",
         headerReuseIdentifier: String = "",
         headerReuseSize: CGSize = .zero,
         sectionInset: UIEdgeInsets = .init(top: 0, left: 15, bottom: 0, right: 15),
         cellIdentifier: String,
         minimumLineSpacing: CGFloat = 0,
         minimumInteritemSpacing: CGFloat = 0,
         titleBgImg: UIImage? = nil) {
        self.sectionTitle = sectionTitle
        self.detailTitle = detailTitle
        self.headerReuseIdentifier = headerReuseIdentifier
        self.headerReuseSize = headerReuseSize
        self.sectionInset = sectionInset
        self.cellIdentifier = cellIdentifier
        self.minimumLineSpacing = minimumLineSpacing
        self.minimumInteritemSpacing = minimumInteritemSpacing
        self.titleBgImg = titleBgImg
    }
}

protocol HCClassRoomDataProtocol {
    var itemSize: CGSize { get }
}


/// 乐孕直播
class HCClassRoomLiveVideoModel: HJModel, HCClassRoomDataProtocol {
    
    
    
    var itemSize: CGSize { return .init(width: PPScreenW, height: HCClassRoomLiveVideoCell_height) }
    
}

/// 好课上新
class HCClassRoomGoodModel: HJModel, HCClassRoomDataProtocol {
    
    var itemSize: CGSize { return HCClassRoomGoodCell_size }

}

/// 精选推荐
class HCClassRoomRecommendModel: HJModel, HCClassRoomDataProtocol {
    
    var itemSize: CGSize { return HCClassRoomRecommendCell_size }

}

/// 乐孕FM
class HCClassRoomFMModel: HJModel, HCClassRoomDataProtocol {
    
    var itemSize: CGSize { return .init(width: PPScreenW, height: HCClassRoomFMCell_height) }

}

/// 精选好课
class HCClassRoomGoodRecommendModel: HJModel, HCClassRoomDataProtocol {
    var itemSize: CGSize { return .init(width: PPScreenW, height: HCClassRoomGoodRecommendCell_height) }
}
