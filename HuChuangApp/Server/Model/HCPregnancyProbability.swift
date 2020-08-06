//
//  HCPregnancyProbability.swift
//  HuChuangApp
//
//  Created by sw on 2019/12/9.
//  Copyright © 2019 sw. All rights reserved.
//

import Foundation

class HCPregnancyProbabilityModel: HJModel {
    /// 今日 —怀孕几率（%）
    var todayProbability: Float = 0
    /// 明日 —怀孕几率（%）
    var tomorrowProbability: Float = 0
    var menstruationDate: String = ""
    var keepDays: Int = 0
    var cycle: Int = 0
    /// 排卵日
    var ovulationDate: String = ""
    /// 提示
    var tips: String = ""
    
    func caculateOvulationDate() ->NSAttributedString {
        let intDays = TYDateCalculate.numberOfDays(toDate: ovulationDate)
        var days = ""
        var paiNuanText = ""
        var range = NSMakeRange(0, 0)
        if intDays >= 0 {
            days = "\(intDays)"
            paiNuanText = "距离排卵日还有\(days)天"
            range = .init(location: 7, length: days.count)
        }else {
            let aday = TYDateCalculate.getDate(currentDate: TYDateCalculate.date(for: menstruationDate),
                                               days: cycle,
                                               isAfter: true)
            
            days = "\(TYDateCalculate.numberOfDays(fromDate: TYDateCalculate.formatNowDate(), toDate: aday))"
            paiNuanText = "距离下一个排卵日还有\(days)天"
            range = .init(location: 10, length: days.count)
        }
        
        return paiNuanText.attributed(range, .white, .font(fontSize: 21, fontName: .PingFMedium))
    }
}

/// 记录数据
class HCRecordItemDataModel: HJModel, HCRecordData {
    var cycle: Int = 0
    var id: Int = 0
    var keepDays: Int = 0
    /// 月经起始日期
    var menstruationDate: String = ""
    var pregnantTypeId: Int = 0
    /// 标记的同房数据
    var knewRecordList: [HCKnewRecordItemModel] = []
    /// 标记的排卵日数据
    var ovulationList: [HCOvulationItemModel] = []

    /// 计算出的相关周期数据
    /// 转化出来的排卵日Date数据
    var ovulationDates: [Date] = []
    // 所处阶段
    var newLv: NSAttributedString = NSAttributedString.init()
    // 怀孕几率
    var probability: NSAttributedString = NSAttributedString.init()
    // 预测排卵日
    var pailuan: Date?
    // 所处哪个周期
    var nowCircle: String = ""
    var curelTitle: String = "好孕率趋势图"
    // 是否是对比数据
    var isContrast: Bool = false
    // 是否已经设置过周期相关数据
    var circleIsSet: Bool = false
    // 周期中当前天在第几个
    var nowDateIdxOfCircle: Int = 0
    
    /// 画曲线数据
    public var probabilityDatas: [Float] = []
//    /// 坐标时间 月.日
//    public var timeDatas: [String] = []
    /// 画线数据 - 线条颜色
    public var lineItemDatas: [TYLineItemModel] = []
//    /// 画线数据 - 画点
//    public var pointDatas: [TYPointItemModel] = []

    var cellIdentifier: String { return HCCurveCell_identifier }
    var width: CGFloat { return PPScreenW }
    var height: CGFloat { return HCCurveCell_height }
    var isCircleSet: Bool { return circleIsSet }
    
    // 距离排卵日
    public func calutePailuanLeft(nextCircle: HCRecordItemDataModel) ->NSAttributedString {
        var daysText = "未知"
        var text = "距离排卵日：\(daysText)"
        var pailuanri = NSAttributedString.init()
        guard let curPailuan = pailuan else {
            pailuanri = text.attributed(.init(location: 6, length: daysText.count),
                                        HC_MAIN_COLOR, .font(fontSize: 12))

            return pailuanri
        }
        
        let days = TYDateCalculate.numberOfDays(toDate: curPailuan)
        if days > 0 {
            daysText = "\(days)"
            text = "距离排卵日：\(daysText)天"
            pailuanri = text.attributed(.init(location: 6, length: daysText.count),
                                        HC_MAIN_COLOR, .font(fontSize: 12))
        }else {
            guard let nextPailuan = nextCircle.pailuan else {
                pailuanri = text.attributed(.init(location: 6, length: daysText.count),
                                            HC_MAIN_COLOR, .font(fontSize: 12))

                return pailuanri
            }
            
            let days = TYDateCalculate.numberOfDays(toDate: nextPailuan)
            daysText = "\(days)"
            text = "距离下一个排卵日：\(daysText)天"
            pailuanri = text.attributed(.init(location: 9, length: daysText.count),
                                        HC_MAIN_COLOR, .font(fontSize: 12))
        }

        return pailuanri
    }
}

/// 标记的同房数据
class HCKnewRecordItemModel: HJModel {
    var bak: String = ""
    var createDate: String = ""
    var creates: String = ""
    var id: Int = 0
    var knewDate: String = ""
    var memberId: Int = 0
    var modifyDate: String = ""
    var modifys: String = ""
}

class HCOvulationItemModel: HJModel {
    var bak: String = ""
    var createDate: String = ""
    var creates: String = ""
    var id: Int = 0
    var memberId: Int = 0
    var modifyDate: String = ""
    var modifys: String = ""
    var ovulationDate: String = "";
}

class HCCellActionItem: HCRecordData {
    var title: String = ""
    var opType: HCMergeProOpType = .knewRecord
    var itemWidth: CGFloat = 0
    
    var cellIdentifier: String { return HCRecordActionItemCell_identifier }
    var width: CGFloat { return itemWidth }
    var height: CGFloat { return 30 }
}

protocol HCRecordData {
    var width: CGFloat { get }
    var height: CGFloat { get }
    var cellIdentifier: String { get }
    var isCircleSet: Bool { get }
}

extension HCRecordData {
    var isCircleSet: Bool {
        get {
            return false
        }
    }
}
