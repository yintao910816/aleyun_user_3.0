//
//  HCTool.swift
//  HuChuangApp
//
//  Created by yintao on 2020/12/4.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation

enum HCMenstruationMode {
    ///
    case none
    /// 月经期
    case yjq
    /// 安全期
    case aqq
    /// 排卵期
    case plq
    /// 排卵日
    case plr
    
    public var color: UIColor {
        get {
            switch self {
//            case .none:
//                return RGB(51, 51, 51)
            case .yjq:
                return .white
            case .aqq, .none:
                return RGB(109, 206, 111)
            case .plq, .plr:
                return RGB(195, 172, 230)
            }
        }
    }
    
}

class HCMensturaDateInfo: NSObject {
    public var date: Date = Date()
    public var mensturationMode: HCMenstruationMode = .none
    public var topRightIcon: UIImage?
    public var bottomLeftIcon: UIImage?
    public var bottomRightIcon: UIImage?
    
    public class func transform(dates: [Date], mensturationMode: HCMenstruationMode) ->[HCMensturaDateInfo] {
        var datas: [HCMensturaDateInfo] = []
        
        for idx in 0..<dates.count {
            let dateInfo = HCMensturaDateInfo()
            dateInfo.mensturationMode = mensturationMode
            dateInfo.date = dates[idx]
            
            if mensturationMode == .yjq {
                dateInfo.bottomLeftIcon = idx == 0 ? UIImage(named: "yjq_start") : idx == dates.count - 1 ? UIImage(named: "yjq_end") : nil
            }else if mensturationMode == .plr {
                dateInfo.bottomLeftIcon = UIImage(named: "tool_painuanri")
            }
            datas.append(dateInfo)
        }
        return datas
    }
    
    public class func transform(date: Date, mensturationMode: HCMenstruationMode) ->HCMensturaDateInfo {
        let dateInfo = HCMensturaDateInfo()
        dateInfo.mensturationMode = mensturationMode
        dateInfo.date = date
        
        if mensturationMode == .plr {
            dateInfo.bottomLeftIcon = UIImage(named: "tool_painuanri")
        }
        return dateInfo
    }

}


class HCBaseInfoDataModel: HJModel {
    var baseInfo: [HCBaseInfoItemModel] = []
    var menstruationList: [[HCMenstruationModel]] = []
    
    public func transformMenstruationList(currentDate: String) ->(menstruasDic: [String: [HCMenstruationModel]], reloadSectionKeys: [String]) {
        if menstruationList.count < 3 {
            return (menstruasDic: [:], reloadSectionKeys: [])
        }
        
        if menstruationList[0].count == 0 && menstruationList[1].count == 0 && menstruationList[2].count == 0 {
            return (menstruasDic: [:], reloadSectionKeys: [])
        }

        var listDic: [Int: [HCMenstruationModel]] = [:]
        listDic[1] = menstruationList[0]
        listDic[2] = menstruationList[1]
        listDic[3] = menstruationList[2]
        
        let key1 = getKey(dateStr: currentDate, identifier: .previous)
        let key2 = getKey(dateStr: currentDate)
        let key3 = getKey(dateStr: currentDate, identifier: .next)
        var resultDic: [String: [HCMenstruationModel]] = [:]

        let tupData1 = getFirstMenstruaData(menstruaModels: listDic[1]!)
        let tupData2 = getFirstMenstruaData(menstruaModels: listDic[2]!)
        let tupData3 = getFirstMenstruaData(menstruaModels: listDic[3]!)

        if listDic[1]!.count == 0 {
            if tupData2.isFind {
                resultDic[key2] = listDic[2]!
                resultDic[key1] = [createMenstruation(model: tupData2.menstrua, isAfter: false)]

                if tupData3.isFind {
                    resultDic[key3] = listDic[3]!
                }else {
                    resultDic[key3] = [createMenstruation(model: tupData2.menstrua, isAfter: true)]
                }
            }else {
                // 第一二条没有，第三条肯定有
                resultDic[key3] = listDic[3]!
                let data2 = createMenstruation(model: tupData3.menstrua, isAfter: false)
                resultDic[key2] = [data2]
                resultDic[key1] = [createMenstruation(model: data2, isAfter: false)]
            }
        }else if listDic[2]!.count == 0 {
            resultDic[key1] = listDic[1]!
            let data2 = createMenstruation(model: tupData1.menstrua, isAfter: true)
            resultDic[key2] = [data2]
                
            if tupData3.isFind {
                resultDic[key3] = listDic[3]!
            }else {
                resultDic[key3] = [createMenstruation(model: data2, isAfter: true)]
            }
        }else if listDic[3]!.count == 0 {
            resultDic[key1] = listDic[1]!
            resultDic[key2] = listDic[2]!
            resultDic[key3] = [createMenstruation(model: tupData2.menstrua, isAfter: true)]
        }else {
            resultDic[key1] = listDic[1]!
            resultDic[key2] = listDic[2]!
            resultDic[key3] = listDic[3]!
        }
        
        let key0 = getKey(dateStr: key1, identifier: .previous)
        resultDic[key0] = [createMenstruation(model: resultDic[key1]!.first!, isAfter: false)]
        
        let key4 = getKey(dateStr: key3, identifier: .next)
        resultDic[key4] = [createMenstruation(model: resultDic[key3]!.last!, isAfter: true)]

        return (menstruasDic: resultDic, reloadSectionKeys: [key1, key2, key3])
    }
    
    // 找到该月的第一个经期数据
    private func getFirstMenstruaData(menstruaModels: [HCMenstruationModel]) ->(isFind: Bool, menstrua: HCMenstruationModel) {
        if menstruaModels.count > 0 {
            return (true, menstruaModels.first!)
        }
        return (false, HCMenstruationModel())
    }
    
    private func createMenstruation(model: HCMenstruationModel, isAfter: Bool) ->HCMenstruationModel {
        let result = HCMenstruationModel()
        result.menstruationCycle = model.menstruationCycle
        result.menstruationDuration = model.menstruationDuration
        let menstruaDate = TYDateCalculate.getDate(currentDate: TYDateCalculate.date(for: model.menstruationDate),
                                                   days: model.menstruationCycle,
                                                   isAfter: isAfter)
        result.menstruationDate = menstruaDate.formatDate(mode: .yymmdd)
        return result
    }
    
    private func getKey(dateStr: String, identifier: DateIdentifier.month? = nil) ->String {
        let indexDate = dateStr.stringFormatDate(mode: .yymm)!
        if let ider = identifier {
            let date = TYDateFormatter.getDate(fromData: indexDate, identifier: ider)!
            return date.formatDate(mode: .yymm)
        }
        return indexDate.formatDate(mode: .yymm)
    }
}

class HCBaseInfoItemModel: HJModel {
    var knew: Bool = false
    var menstruationEnd: Bool = false
    var menstruationStart: Bool = false
    var stature: String = ""
    var temperature: String = ""
    var type: Int = 0
    var weight: String = ""
    
    public var isMark: Bool {
        get {
            return temperature.count > 0 || weight.count > 0
        }
    }
}

class HCMenstruationModel: HJModel {
    var bak: String = ""
    var createDate: String = ""
    var creates: String = ""
    var id: String = ""
    var memberId: String = ""
    var menstruationCycle: Int = 0
    var menstruationDate: String = ""
    var menstruationDuration: Int = 0
    var menstruationEndDate: String = ""
    var menstruationWeekEndDate: String = ""
    var modifyDate: String = ""
    var modifys: String = ""
    var ovulationDate: String = ""
    var safePeriodDate: String = ""
}
