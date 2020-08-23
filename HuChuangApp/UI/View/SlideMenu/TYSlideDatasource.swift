//
//  TYSlideDatasource.swift
//  HuChuangApp
//
//  Created by sw on 2019/9/27.
//  Copyright © 2019 sw. All rights reserved.
//

import Foundation

struct TYSlideItemModel {
    var title: String = ""
    var textColor: UIColor = RGB(51, 51, 51)
    var selectedTextColor: UIColor = RGB(255, 102, 149)
    var lineColor: UIColor = .red
    var textFont: UIFont = .font(fontSize: 14, fontName: .PingFMedium)
    var lineWidth: CGFloat = 20
    
    var isSelected: Bool = false
    
    var dataModel: HomeColumnItemModel!
    
    public lazy var contentWidth: CGFloat = {
        return self.title.ty_textSize(font: self.textFont, width: CGFloat(MAXFLOAT), height: 30).width + 30
    }()
    
    public static func creatSimple(for titles: [String]) ->[TYSlideItemModel] {
        var dataModels: [TYSlideItemModel] = []
        for title in titles {
            var itemModel = TYSlideItemModel()
            itemModel.isSelected = dataModels.count == 0
            
            let columItem = HomeColumnItemModel()
            columItem.name = title
            itemModel.dataModel = columItem
            
            dataModels.append(itemModel)
        }
        return dataModels
    }
}

extension TYSlideItemModel {
    /// 课堂数据    
    internal static func mapData(models: [HomeColumnItemModel]) ->[TYSlideItemModel] {
        var datas: [TYSlideItemModel] = []
        
        for idx in 0..<models.count {
            var m = TYSlideItemModel()
            m.dataModel = models[idx]
            m.isSelected = idx == 0
            datas.append(m)
        }
        
        return datas
    }
    
    /// 搜藏数据
    internal static func createAttentionStoreData() ->[TYSlideItemModel] {
        return [TYSlideItemModel(title: "我的医生",
                                 textColor: RGB(153, 153, 153),
                                 selectedTextColor: HC_MAIN_COLOR,
                                 lineColor: HC_MAIN_COLOR,
                                 textFont: .font(fontSize: 16),
                                 isSelected: true),
                TYSlideItemModel(title: "我的课程",
                                 textColor: RGB(153, 153, 153),
                                 selectedTextColor: HC_MAIN_COLOR,
                                 lineColor: HC_MAIN_COLOR,
                                 textFont: .font(fontSize: 16),
                                 isSelected: false),
                TYSlideItemModel(title: "我的资讯",
                                 textColor: RGB(153, 153, 153),
                                 selectedTextColor: HC_MAIN_COLOR,
                                 lineColor: HC_MAIN_COLOR,
                                 textFont: .font(fontSize: 16),
                                 isSelected: false)]
    }
    
    /// 我的问诊数据
    internal static func createMyConsultData() ->[TYSlideItemModel] {
        return [TYSlideItemModel(title: "图文问诊",
                                 textColor: RGB(153, 153, 153),
                                 selectedTextColor: HC_MAIN_COLOR,
                                 lineColor: HC_MAIN_COLOR,
                                 textFont: .font(fontSize: 16),
                                 isSelected: true),
                TYSlideItemModel(title: "视频问诊",
                                 textColor: RGB(153, 153, 153),
                                 selectedTextColor: HC_MAIN_COLOR,
                                 lineColor: HC_MAIN_COLOR,
                                 textFont: .font(fontSize: 16),
                                 isSelected: false),
                TYSlideItemModel(title: "云门诊",
                                 textColor: RGB(153, 153, 153),
                                 selectedTextColor: HC_MAIN_COLOR,
                                 lineColor: HC_MAIN_COLOR,
                                 textFont: .font(fontSize: 16),
                                 isSelected: false)]
    }

    /// 我的预约
    internal static func createMyReservationData() ->[TYSlideItemModel] {
        return [TYSlideItemModel(title: "预约挂号",
                                 textColor: RGB(153, 153, 153),
                                 selectedTextColor: HC_MAIN_COLOR,
                                 lineColor: HC_MAIN_COLOR,
                                 textFont: .font(fontSize: 16),
                                 isSelected: true),
                TYSlideItemModel(title: "精准预约",
                                 textColor: RGB(153, 153, 153),
                                 selectedTextColor: HC_MAIN_COLOR,
                                 lineColor: HC_MAIN_COLOR,
                                 textFont: .font(fontSize: 16),
                                 isSelected: false)]
    }

    /// 搜索结果数据
    internal static func createSearchResultData() ->[TYSlideItemModel] {
        return [TYSlideItemModel(title: "专家",
                                 textColor: RGB(153, 153, 153),
                                 selectedTextColor: HC_MAIN_COLOR,
                                 lineColor: HC_MAIN_COLOR,
                                 textFont: .font(fontSize: 16),
                                 isSelected: true),
                TYSlideItemModel(title: "资讯",
                                 textColor: RGB(153, 153, 153),
                                 selectedTextColor: HC_MAIN_COLOR,
                                 lineColor: HC_MAIN_COLOR,
                                 textFont: .font(fontSize: 16),
                                 isSelected: false),
                TYSlideItemModel(title: "课程",
                                 textColor: RGB(153, 153, 153),
                                 selectedTextColor: HC_MAIN_COLOR,
                                 lineColor: HC_MAIN_COLOR,
                                 textFont: .font(fontSize: 16),
                                 isSelected: false),
                TYSlideItemModel(title: "直播",
                                 textColor: RGB(153, 153, 153),
                                 selectedTextColor: HC_MAIN_COLOR,
                                 lineColor: HC_MAIN_COLOR,
                                 textFont: .font(fontSize: 16),
                                 isSelected: false)]
    }
}

class HCSlideItemController: BaseViewController {
    
    public var pageIdx: Int = 0
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    public func reloadData(data: Any?) {
        
    }
    
    public func bind<T>(viewModel: RefreshVM<T>, canRefresh: Bool, canLoadMore: Bool, isAddNoMoreContent: Bool) {
        
    }
}
