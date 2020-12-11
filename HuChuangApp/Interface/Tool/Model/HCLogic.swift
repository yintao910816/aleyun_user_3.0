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
        listDic[1] = menstruaList[0]
        listDic[2] = menstruaList[1]
        listDic[3] = menstruaList[2]
        
        let key1 = getKey(dateStr: currentDate, identifier: .previous)
        let key2 = getKey(dateStr: currentDate)
        let key3 = getKey(dateStr: currentDate, identifier: .next)
        var resultDic: [String: [HCMenstruationModel]] = [:]
        
        //        let tupData1 = getFirstMenstruaData(menstruaModels: listDic[1]!)
        let tupData2 = getFirstMenstruaData(menstruaModels: listDic[2]!)
        let tupData3 = getFirstMenstruaData(menstruaModels: listDic[3]!)
        
        if listDic[1]!.count == 0 {
            if tupData2.isFind {
                resultDic[key2] = listDic[2]!
                resultDic[key1] = [createMenstruation(model: baseMenstrua,
                                                      menstruationDate: tupData2.menstrua.menstruationDate,
                                                      isAfter: false)]
                
                if tupData3.isFind {
                    resultDic[key3] = listDic[3]!
                }else {
                    resultDic[key3] = [createMenstruation(model: baseMenstrua,
                                                          menstruationDate: listDic[2]!.last!.menstruationDate,
                                                          isAfter: true)]
                }
            }else {
                // 第一二条没有，第三条肯定有
                resultDic[key3] = listDic[3]!
                resultDic[key2] = [createMenstruation(model: baseMenstrua,
                                                      menstruationDate: tupData3.menstrua.menstruationDate,
                                                      isAfter: false)]
            }
        }else if listDic[2]!.count == 0 {
            resultDic[key1] = listDic[1]!
            let data2 = createMenstruation(model: baseMenstrua,
                                           menstruationDate: listDic[1]!.last!.menstruationDate,
                                           isAfter: true)
            resultDic[key2] = [data2]
            
            if tupData3.isFind {
                resultDic[key3] = listDic[3]!
            }else {
                resultDic[key3] = [createMenstruation(model: baseMenstrua,
                                                      menstruationDate: data2.menstruationDate,
                                                      isAfter: true)]
            }
        }else if listDic[3]!.count == 0 {
            resultDic[key1] = listDic[1]!
            resultDic[key2] = listDic[2]!
            resultDic[key3] = [createMenstruation(model: baseMenstrua,
                                                  menstruationDate: listDic[2]!.last!.menstruationDate,
                                                  isAfter: true)]
        }else {
            resultDic[key1] = listDic[1]!
            resultDic[key2] = listDic[2]!
            resultDic[key3] = listDic[3]!
        }
        
        if resultDic[key1]?.first?.isForecast == false {
            // 如果前面一个月设置了经期，才再往前面推一个月
            let key0 = getKey(dateStr: key1, identifier: .previous)
            resultDic[key0] = [createMenstruation(model: baseMenstrua,
                                                  menstruationDate: resultDic[key1]!.first!.menstruationDate,
                                                  isAfter: false)]
        }
        
        // 当前月后面的每一个月都要推算
        let key4 = getKey(dateStr: key3, identifier: .next)
        resultDic[key4] = [createMenstruation(model: baseMenstrua,
                                              menstruationDate: resultDic[key3]!.last!.menstruationDate,
                                              isAfter: true)]
        
        return (menstruasDic: resultDic, reloadSectionKeys: [key1, key2, key3])
    }
    
    // 找到该月的第一个经期数据
    private class func getFirstMenstruaData(menstruaModels: [HCMenstruationModel]) ->(isFind: Bool, menstrua: HCMenstruationModel) {
        if menstruaModels.count > 0 {
            return (true, menstruaModels.first!)
        }
        return (false, HCMenstruationModel())
    }
    
    private class func createMenstruation(model: HCMenstruationModel, menstruationDate: String, isAfter: Bool) ->HCMenstruationModel {
        let result = HCMenstruationModel()
        result.menstruationCycle = model.menstruationCycle
        result.menstruationDuration = model.menstruationDuration
        result.isForecast = true
        
        let date = menstruationDate.stringFormatDate(mode: .yymmdd)!
        let menstruaDate = TYDateCalculate.getDate(currentDate: date,
                                                   days: model.menstruationCycle,
                                                   isAfter: isAfter)
        result.menstruationDate = menstruaDate.formatDate(mode: .yymmdd)

        let menstruaEndDate = TYDateCalculate.getDate(currentDate: menstruaDate,
                                                      days: model.menstruationDuration,
                                                      isAfter: true)
        result.menstruationEndDate = menstruaEndDate.formatDate(mode: .yymmdd)
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
