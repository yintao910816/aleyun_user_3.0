//
//  HCLogic.swift
//  HuChuangApp
//
//  Created by yintao on 2020/12/10.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation

//MARK: 经期相关的计算
class HCToolCalculate {
    
    /// 找到对应日历 TYCalendarSectionModel
    public class func findCalendarSection(dateS: String, calendars: [TYCalendarSectionModel]) ->TYCalendarSectionModel? {
        return calendars.first(where: { $0.dateText == dateS.transform(mode: .yymm) })
    }
 
    /// 找到对应日历 TYCalendarSectionModel 中的 TYCalendarItem
    public class func findCalendarDay(dateS: String, calendars: [TYCalendarSectionModel]) ->TYCalendarItem? {
        if let section = findCalendarSection(dateS: dateS, calendars: calendars) {
            return section.items.first(where: { $0.dateText == dateS })
        }
        return nil
    }
    
    /// 找到该时间之后第一个月经开始时间
    public class func firstMensturaStart(with dateS: String, calendars: [TYCalendarSectionModel]) ->TYCalendarItem? {
        guard let date = dateS.stringFormatDate(mode: .yymmdd),
              let sectionD = findCalendarSection(dateS: dateS, calendars: calendars) else {
            return nil
        }
        
        let filterDay = sectionD.items.first { item -> Bool in
            if let d = item.dateText.stringFormatDate(mode: .yymmdd) {
                if date.dateCompare(date: d) == .orderedAscending {
                    return true
                }
            }
            return false
        }
        
        return filterDay
    }

    /// 判断是否一个计算周期的数据都没返回（未设置经期）
    public class func isNoSettingMenstrua(mensturaDatas: [[HCMenstruationModel]]) ->Bool {
        for itemArr in mensturaDatas {
            if itemArr.count > 0 {
                return false
            }
        }
        
        return true
    }
            
    /// 提示文字
    public class func earlyMensturaRemindText(newDateS: String, dateS: String) ->String {
        guard let newDate = newDateS.stringFormatDate(mode: .yymmdd),
              let date = dateS.stringFormatDate(mode: .yymmdd) else {
            return "您已在\(dateS)标记了月经开始日，确定将月经开始日期提前到\(newDateS)？"
        }
        
        var formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日"
        let dateStr = formatter.string(from: date)
        
        formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日"
        let newDateStr = formatter.string(from: newDate)

        return "您已在\(dateStr)标记了月经开始日，确定将月经开始日期提前到\(newDateStr)？"
    }
    
    /// 提示文字
    public class func cancelGoingForbidenRemindText() ->String {
        return "如果不是今天，请在结束那天选“是”；如果到今天还没结束，等到未来结束那天选“是”"
    }

}

//MARK: 处理后台返回经期数据
extension HCToolCalculate {
    
    public class func transformMenstruationList(currentDate: String,
                                                realyMenstrua: HCMenstruationModel?,
                                                menstruaList: [[HCMenstruationModel]],
                                                baseMenstruation: HCMenstruationModel?) ->(menstruasDic: [String: [HCMenstruationModel]], reloadSectionKeys: [String]) {
        guard let baseMenstrua = baseMenstruation else {
            return (menstruasDic: [:], reloadSectionKeys: [])
        }
        
        if menstruaList.count < 3 {
            return (menstruasDic: [:], reloadSectionKeys: [])
        }
        
        if menstruaList[0].count == 0 && menstruaList[1].count == 0 && menstruaList[2].count == 0 {
            return (menstruasDic: [:], reloadSectionKeys: [])
        }
        
        var listDic: [Int: [HCMenstruationModel]] = [:]
        // 上一个设置了月经周期的
        listDic[1] = menstruaList[0]
        // 当前显示月份
        listDic[2] = menstruaList[1]
        // 下一个设置了月经周期的
        listDic[3] = menstruaList[2]
        
        let key1 = getKey(dateStr: currentDate, identifier: .previous)
        let key2 = getKey(dateStr: currentDate)
        let key3 = getKey(dateStr: currentDate, identifier: .next)
        var resultDic: [String: [HCMenstruationModel]] = [:]
        
        let isFind1 = isFind(menstruaModels: listDic[1]!, month: key1)
//        let isFind2 = isFind(menstruaModels: listDic[2]!, month: key2)
        let isFind3 = isFind(menstruaModels: listDic[3]!, month: key3)
        
        let realyMonth = isRealyMonth(dateStr: currentDate)

        if listDic[2]!.count != 0 {
            // 当前显示月设置了月经周期
            resultDic[key2] = listDic[2]!
            if isFind1 {
                resultDic[key1] = listDic[1]!
                if isFind3 {
                    resultDic[key3] = listDic[3]!
                }else {
                    resultDic[key3] = [createMenstruation(model: baseMenstrua,
                                                          menstruationDate: resultDic[key2]!.last!.menstruationDate,
                                                          mode: realyMonth ? .normal : .allSafe,
                                                          isRealyMonth: false,
                                                          isAfter: true)]
                }
            }else {
                /// 上一个月肯定不是真实的当前月
                resultDic[key1] = [createMenstruation(model: baseMenstrua,
                                                      menstruationDate: resultDic[key2]!.first!.menstruationDate,
                                                      mode: .onlyPLQ,
                                                      isRealyMonth: false,
                                                      isAfter: false)]

                if isFind3 {
                    resultDic[key3] = listDic[3]!
                }else {
                    if isRealyMonth(dateStr: "\(key3)-01") {
                        let mens3 = createMenstruation(model: baseMenstrua,
                                                       menstruationDate: "\(key2)-01",
                                                       mode: .normal,
                                                       isRealyMonth: true,
                                                       isAfter: true,
                                                       discareMenstruationDate: true)
                        resultDic[key3] = [mens3]
                    }else {
                        resultDic[key3] = [createMenstruation(model: baseMenstrua,
                                                              menstruationDate: resultDic[key2]!.last!.menstruationDate,
                                                              mode: realyMonth ? .normal : .allSafe,
                                                              isRealyMonth: false,
                                                              isAfter: true)]
                    }
                }
            }
        }else if isFind1 {
            resultDic[key1] = listDic[1]!
            resultDic[key2] = [createMenstruation(model: baseMenstrua,
                                                  menstruationDate: resultDic[key1]!.last!.menstruationDate,
                                                  mode: isAfterTodayMonth(dateStr: key2) ? .normal : .allSafe,
                                                  isRealyMonth: realyMonth,
                                                  isAfter: true)]
            if isFind3 {
                resultDic[key2]?.first?.mode = .onlyPLQ
                resultDic[key3] = listDic[3]!
                resultDic[key2]?.first?.menstruationCycle = TYDateCalculate.numberOfDays(startStr: resultDic[key2]!.last!.menstruationDate, endStr: resultDic[key3]!.first!.menstruationDate, mode: .yymmdd) - 1
            }else {
                resultDic[key3] = [createMenstruation(model: baseMenstrua,
                                                      menstruationDate: resultDic[key2]!.last!.menstruationDate,
                                                      mode: realyMonth ? .normal : .allSafe,
                                                      isRealyMonth: realyMonth,
                                                      isAfter: true)]
            }
        }else if isFind3 {
            resultDic[key3] = listDic[3]!
            resultDic[key2] = [createMenstruation(model: baseMenstrua,
                                                  menstruationDate: resultDic[key3]!.first!.menstruationDate,
                                                  mode: .onlyPLQ,
                                                  isRealyMonth: false,
                                                  isAfter: false)]
            resultDic[key1] = [createMenstruation(model: baseMenstrua,
                                                  menstruationDate: resultDic[key2]!.first!.menstruationDate,
                                                  mode: listDic[1]!.count > 0 ? .allSafe : .none,
                                                  isRealyMonth: false,
                                                  isAfter: false)]
        }else {
            if realyMonth {
                let realyMens = createRealyMens(baseMens: baseMenstrua)
                resultDic[key2] = [realyMens]
                resultDic[key1] = [createMenstruation(model: baseMenstrua,
                                                      menstruationDate: realyMens.menstruationDate,
                                                      mode: .onlyPLQ,
                                                      isRealyMonth: false,
                                                      isAfter: false)]
                resultDic[key3] = [createMenstruation(model: baseMenstrua,
                                                      menstruationDate: realyMens.menstruationDate,
                                                      mode: .normal,
                                                      isRealyMonth: false,
                                                      isAfter: true)]
            }else {
                let compare = TYDateCalculate.compare(dateStr: currentDate, other: Date().formatDate(mode: .yymmdd), mode: .yymmdd)
                if compare == .orderedAscending {
                    // 当前显示月在真实的月前面
                    if listDic[1]!.count > 0 {
                        let mens2 = createSimpleMens(baseMens: baseMenstrua, menstruationDate: "\(key2)-01", mode: .allSafe)
                        resultDic[key2] = [mens2]
                        let mens1 = createSimpleMens(baseMens: baseMenstrua, menstruationDate: "\(key1)-01", mode: .allSafe)
                        resultDic[key1] = [mens1]
                        
                        if isRealyMonth(dateStr: "\(key3)-01") {
                            let mens3 = createMenstruation(model: baseMenstrua,
                                                           menstruationDate: "\(key2)-01",
                                                           mode: .normal,
                                                           isRealyMonth: true,
                                                           isAfter: true,
                                                           discareMenstruationDate: true)
                            resultDic[key2]?.first?.mode = .onlyPLQ
                            resultDic[key3] = [mens3]
                        }else {
                            let mens3 = createSimpleMens(baseMens: baseMenstrua, menstruationDate: "\(key3)-01", mode: .allSafe)
                            resultDic[key3] = [mens3]
                        }
                    }else {
                        let mens2 = createSimpleMens(baseMens: baseMenstrua, menstruationDate: "\(key2)-01", mode: .none)
                        resultDic[key2] = [mens2]
                        let mens1 = createSimpleMens(baseMens: baseMenstrua, menstruationDate: "\(key1)-01", mode: .none)
                        resultDic[key1] = [mens1]
                        let mens3 = createSimpleMens(baseMens: baseMenstrua, menstruationDate: "\(key3)-01", mode: .none)
                        resultDic[key3] = [mens3]
                    }
                }else {
                    // 当前显示月在真实的月后面
                    let mens2 = createSelectedMensFromRealyMens(model: realyMenstrua!, selectedDate: currentDate)
                    resultDic[key2] = [mens2]
                    let mens3 = createMenstruation(model: baseMenstrua,
                                                   menstruationDate: mens2.menstruationDate,
                                                   mode: .normal,
                                                   isRealyMonth: false,
                                                   isAfter: true)
                    resultDic[key3] = [mens3]
                    let mens1 = createMenstruation(model: baseMenstrua,
                                                   menstruationDate: mens2.menstruationDate,
                                                   mode: .normal,
                                                   isRealyMonth: false,
                                                   isAfter: false)
                    resultDic[key1] = [mens1]
                }
            }
        }
                
//        if listDic[1]!.count == 0 {
//            if tupData2.isFind {
//                resultDic[key2] = listDic[2]!
//                resultDic[key1] = [createMenstruation(model: baseMenstrua,
//                                                      menstruationDate: tupData2.menstrua.menstruationDate,
//                                                      isAfter: false)]
//
//                if tupData3.isFind {
//                    resultDic[key3] = listDic[3]!
//                }else {
//                    resultDic[key3] = [createMenstruation(model: baseMenstrua,
//                                                          menstruationDate: listDic[2]!.last!.menstruationDate,
//                                                          isAfter: true)]
//                }
//            }else {
//                // 第一二条没有，第三条肯定有
//                resultDic[key3] = listDic[3]!
//                resultDic[key2] = [createMenstruation(model: baseMenstrua,
//                                                      menstruationDate: tupData3.menstrua.menstruationDate,
//                                                      isAfter: false)]
//            }
//        }else if listDic[2]!.count == 0 {
//            resultDic[key1] = listDic[1]!
//            let data2 = createMenstruation(model: baseMenstrua,
//                                           menstruationDate: listDic[1]!.last!.menstruationDate,
//                                           isAfter: true)
//            resultDic[key2] = [data2]
//
//            if tupData3.isFind {
//                resultDic[key3] = listDic[3]!
//            }else {
//                resultDic[key3] = [createMenstruation(model: baseMenstrua,
//                                                      menstruationDate: data2.menstruationDate,
//                                                      isAfter: true)]
//            }
//        }else if listDic[3]!.count == 0 {
//            resultDic[key1] = listDic[1]!
//            resultDic[key2] = listDic[2]!
//            resultDic[key3] = [createMenstruation(model: baseMenstrua,
//                                                  menstruationDate: listDic[2]!.last!.menstruationDate,
//                                                  isAfter: true)]
//        }else {
//            resultDic[key1] = listDic[1]!
//            resultDic[key2] = listDic[2]!
//            resultDic[key3] = listDic[3]!
//        }
        
        var hasMens0: Bool = false
        let key0 = getKey(dateStr: key1, identifier: .previous)
        if resultDic[key1]?.first?.isForecast == false {
            hasMens0 = true
            // 如果前面一个月设置了经期，才再往前面推一个月
            resultDic[key0] = [createMenstruation(model: baseMenstrua,
                                                  menstruationDate: listDic[1]!.first!.menstruationDate,
                                                  mode: .onlyPLQ,
                                                  isRealyMonth: false,
                                                  isAfter: false)]
        }
        
        // 修改本次周期相对于下次周期的间隔
        var allMens: [HCMenstruationModel] = []
        if hasMens0 {
            allMens.append(contentsOf: resultDic[key0]!)
            allMens.append(contentsOf: resultDic[key1]!)
            allMens.append(contentsOf: resultDic[key2]!)
            allMens.append(contentsOf: resultDic[key3]!)
        }else {
            allMens.append(contentsOf: resultDic[key1]!)
            allMens.append(contentsOf: resultDic[key2]!)
            allMens.append(contentsOf: resultDic[key3]!)
        }
        
        for idx in 0..<allMens.count {
            if idx + 1 < allMens.count {
                let days = TYDateCalculate.numberOfDays(startStr: allMens[idx].menstruationDate,
                                                        endStr: allMens[idx + 1].menstruationDate,
                                                        mode: .yymmdd)
                allMens[idx].menstruationCycle = days
            }
        }
        
        // 当前月后面的每一个月都要推算
//        let key4 = getKey(dateStr: key3, identifier: .next)
//        resultDic[key4] = [createMenstruation(model: baseMenstrua,
//                                              menstruationDate: resultDic[key3]!.last!.menstruationDate,
//                                              isAfter: true)]
        
        return (menstruasDic: resultDic, reloadSectionKeys: [key1, key2, key3])
    }
    
    // 找到该月的第一个经期数据
    private class func isFind(menstruaModels: [HCMenstruationModel], month: String) ->Bool {
        for item in menstruaModels {
            if TYDateCalculate.dayContains(in: month, day: item.menstruationDate) == true {
                return true
            }
        }
        return false
    }
    
    private class func createMenstruation(model: HCMenstruationModel,
                                          menstruationDate: String,
                                          mode: HCForecastMenstruaMode,
                                          isRealyMonth: Bool,
                                          isAfter: Bool,
                                          discareMenstruationDate: Bool = false) ->HCMenstruationModel {
        let result = HCMenstruationModel()
        result.menstruationCycle = model.menstruationCycle
        result.menstruationDuration = model.menstruationDuration
        result.isForecast = true
        result.mode = mode
        
        if isRealyMonth {
            let today = Date().formatDate(mode: .yymmdd)
            let days = TYDateCalculate.numberOfDays(startStr: menstruationDate,
                                                    endStr: today,
                                                    mode: .yymmdd)
            if days >= model.menstruationCycle || discareMenstruationDate {
                result.menstruationDate = today
                let endDate = TYDateCalculate.getDate(currentDate: Date(),
                                                      days: model.menstruationDuration,
                                                      isAfter: true)
                result.menstruationEndDate = endDate.formatDate(mode: .yymmdd)
            }else {
                let menstruationDate = TYDateCalculate.getDate(currentDate: menstruationDate.stringFormatDate(mode: .yymmdd)!,
                                                               days: model.menstruationCycle,
                                                               isAfter: isAfter)
                result.menstruationDate = menstruationDate.formatDate(mode: .yymmdd)
                let endDate = TYDateCalculate.getDate(currentDate: menstruationDate,
                                                      days: model.menstruationDuration,
                                                      isAfter: true)
                result.menstruationEndDate = endDate.formatDate(mode: .yymmdd)
            }
        }else {
            let date = menstruationDate.stringFormatDate(mode: .yymmdd)!
            let menstruaDate = TYDateCalculate.getDate(currentDate: date,
                                                       days: model.menstruationCycle,
                                                       isAfter: isAfter)
            result.menstruationDate = menstruaDate.formatDate(mode: .yymmdd)

            let menstruaEndDate = TYDateCalculate.getDate(currentDate: menstruaDate,
                                                          days: model.menstruationDuration,
                                                          isAfter: true)
            result.menstruationEndDate = menstruaEndDate.formatDate(mode: .yymmdd)
        }
        return result
    }
    
    private class func createSelectedMensFromRealyMens(model: HCMenstruationModel, selectedDate: String) ->HCMenstruationModel {
        let days = TYDateCalculate.numberOfDays(startStr: model.menstruationDate,
                                                endStr: selectedDate,
                                                mode: .yymmdd)
        let count: Int = days / model.menstruationCycle
        let realyMenstruaDate = model.menstruationDate.stringFormatDate(mode: .yymmdd)!
        let menstruaDate = TYDateCalculate.getDate(currentDate: realyMenstruaDate,
                                                   days: count * model.menstruationCycle,
                                                   isAfter: true)
        let menstruaEndDate = TYDateCalculate.getDate(currentDate: menstruaDate,
                                                      days: model.menstruationDuration,
                                                      isAfter: true)
        
        let result = HCMenstruationModel()
        result.menstruationCycle = model.menstruationCycle
        result.menstruationDuration = model.menstruationDuration
        result.isForecast = true
        result.mode = .normal
        result.menstruationDate = menstruaDate.formatDate(mode: .yymmdd)
        result.menstruationEndDate = menstruaEndDate.formatDate(mode: .yymmdd)
        return result
    }
    
    private class func createRealyMens(baseMens: HCMenstruationModel) ->HCMenstruationModel {
        let result = HCMenstruationModel()
        result.menstruationCycle = baseMens.menstruationCycle
        result.menstruationDuration = baseMens.menstruationDuration
        result.isForecast = true
        result.mode = .normal
        result.menstruationDate = Date().formatDate(mode: .yymmdd)
        result.menstruationEndDate = TYDateCalculate.getDate(currentDate: Date(),
                                                             days: baseMens.menstruationDuration,
                                                             isAfter: true).formatDate(mode: .yymmdd)
        return result
    }

    private class func createSimpleMens(baseMens: HCMenstruationModel,
                                        menstruationDate: String,
                                        mode: HCForecastMenstruaMode) ->HCMenstruationModel {
        let result = HCMenstruationModel()
        result.menstruationCycle = baseMens.menstruationCycle
        result.menstruationDuration = baseMens.menstruationDuration
        result.isForecast = true
        result.mode = mode
        result.menstruationDate = menstruationDate
        result.menstruationEndDate = TYDateCalculate.getDate(currentDate: menstruationDate.stringFormatDate(mode: .yymmdd)!,
                                                             days: baseMens.menstruationDuration,
                                                             isAfter: true).formatDate(mode: .yymmdd)
        return result
    }
    
    public class func getKey(dateStr: String, identifier: DateIdentifier.month? = nil) ->String {
        let indexDate = dateStr.stringFormatDate(mode: .yymm)!
        if let ider = identifier {
            let date = TYDateFormatter.getDate(fromData: indexDate, identifier: ider)!
            return date.formatDate(mode: .yymm)
        }
        return indexDate.formatDate(mode: .yymm)
    }
    
    public class func isRealyMonth(dateStr: String) ->Bool {
        return TYDateCalculate.currentMonthContais(dateString: dateStr)
    }
    
    public class func isAfterTodayMonth(dateStr: String) ->Bool {
        let compare = TYDateCalculate.compare(dateStr: Date().formatDate(mode: .yymm),
                                              other: dateStr,
                                              mode: .yymm)
        return (compare == .orderedAscending || compare == .orderedSame)
    }
}

//MARK: 相关规则
/**
 * 6、两次月经间隔必须大于5天
 * 7、无法设置当前日期之后的月经
 * 8、修改月经开始时间，若选择开始时间，
 * 与原月经开始时间大于【设置月经持续时间+5】天，
 * 则新生成一个月经周期，若小于等于5天，
 * 则提示【您已在xx月XX号标记了月经开始日，确定将月经开始日期提前到【当前选择的日期】？
 * 点击【确定】确认选择，点击【取消】不修改
 * 9、修改月经结束时间，
 * ①今天日期距离本次月经开始日期小于等于已设置的月经周期，
 * 则修改结束时间时，直接把月经结束时间修改为今天，并每天增加
 * ②今天日期距离本次月经日期大于已设置的月经周期，
 * 点击修改月经结束日期时，提示【如果不是今天，请在结束那天选择“是”，如果到今天还没结束，等到未来结束那天选择“是”。
 */
