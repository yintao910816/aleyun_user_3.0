//
//  HCRecordViewModel.swift
//  HuChuangApp
//
//  Created by sw on 2019/10/19.
//  Copyright © 2019 sw. All rights reserved.
//

import Foundation

import RxSwift

class HCRecordViewModel: BaseViewModel, VMNavigation {
    
    public let reloadUISubject = PublishSubject<Void>()
    public let exchangeUISubject = PublishSubject<Void>()
    /// 添加标记排卵日,添加同房记录,温度
    public let commitChangeSubject = PublishSubject<(HCMergeProOpType, String)>()
    /// 标记月经 (是否月经l第一天，时间)
    public let commitMergeWeekInfoSubject = PublishSubject<(Bool, String)>()
    /// 问医生
    public let expertConsultSubject = PublishSubject<Void>()
    /// 怀孕率数据
    private var prepareProbabilityDatas: [Float] = []
    private var prepareTimesDatas: [String] = []
    /// 当前周期数据
    public var currentCircleData: HCRecordItemDataModel!
    /// 下个周期数据
    public var nextCircleData: HCRecordItemDataModel!
    /// 上个周期数据
    public var lastCircleData: HCRecordItemDataModel!
    /// 三个周期数据
    private var circleDatas: [HCRecordItemDataModel] = []
    /// 底部操作cell
    private var cellActionItemDatasource: [HCRecordData] = []

    /// 所有cell数据
    public var datasource: [[HCRecordData]] = []
    /// 是否是对比的UI
    public var isContrast: Bool = false

    override init() {
        super.init()
        
        reloadSubject.subscribe(onNext: { [unowned self] in
            self.prepareActionData()
            self.requestRecordData()
        })
        .disposed(by: disposeBag)
        
        exchangeUISubject.subscribe(onNext: { [weak self] in
            self?.exchangeData()
        })
        .disposed(by: disposeBag)
        
        commitChangeSubject
            .subscribe(onNext: { [unowned self] in
            self.commitChange(type: $0.0, data: $0.1)
        })
        .disposed(by: disposeBag)
        
        commitMergeWeekInfoSubject
            .subscribe(onNext: { [unowned self] data in
                data.0 == true ? self.caculte(startDate: data.1) : self.caculte(lastDate: data.1)
            })
            .disposed(by: disposeBag)
        
        expertConsultSubject.subscribe(onNext: { 
            HCRecordViewModel.sbPush("HCMain", "expertConsultCtrl")
        })
            .disposed(by: disposeBag)

        NotificationCenter.default.rx.notification(NotificationName.User.LoginSuccess)
            .subscribe(onNext: { [weak self] data in
                self?.requestRecordData()
            })
            .disposed(by: disposeBag)
    }
    
    private func requestRecordData() {
        HCProvider.request(.getLast2This2NextWeekInfo)
            .map(models: HCRecordItemDataModel.self)
            .subscribe(onSuccess: { [weak self] data in
                self?.dealData(datas: data)
            }, onError: { [weak self] error in
                self?.hud.failureHidden(self?.errorMessage(error))
            })
            .disposed(by: disposeBag)
    }
    

    
    private func prepareActionData() {
        let model1 = HCCellActionItem()
        model1.title = "标记月经"
        model1.opType = .menstruationDate
        model1.itemWidth = 80
        
        let model2 = HCCellActionItem()
        model2.title = "标记排卵日"
        model2.opType = .ovulation
        model2.itemWidth = 90

        let model3 = HCCellActionItem()
        model3.title = "标记同房"
        model3.opType = .knewRecord
        model3.itemWidth = 80

        let model4 = HCCellActionItem()
        model4.title = "基础体温"
        model4.opType = .temperature
        model4.itemWidth = 80

        cellActionItemDatasource = [model1, model2, model3, model4]
    }
    
    /// 距离排卵日数据
    public var pailuanriLeft: NSAttributedString {
        get {
            return currentCircleData.calutePailuanLeft(nextCircle: nextCircleData)
        }
    }
}

extension HCRecordViewModel {
    
    // 添加标记排卵日,添加同房记录
    private func commitChange(type: HCMergeProOpType, data: String) {
        var dataParam: [String: Any] = [:]
        var date: String = ""
        if type == .temperature {
            hud.noticeLoading()
            dataParam["temperature"] = data
            date = TYDateCalculate.formatNowDateString()
        }else {
            if type == .ovulation {
                // 标记排卵日只能在当前周期
                let starDate = TYDateCalculate.date(for: currentCircleData.menstruationDate)
                let markDate = TYDateCalculate.date(for: data)
                let days = TYDateCalculate.numberOfDays(fromDate: starDate, toDate: markDate)
                if days >= currentCircleData.cycle || days < 0 {
                    NoticesCenter.alert(title: "提示", message: "只能在当前周期内标记排卵日")
                    return
                }
            }
            
            hud.noticeLoading()
            date = data
        }
        
        HCProvider.request(.mergePro(opType: type, date: date, data: dataParam))
            .mapResponse()
            .subscribe(onSuccess: { [weak self] res in
                if res.code == RequestCode.success.rawValue {
                    self?.requestRecordData()
                }else {
                    self?.hud.failureHidden(res.message)
                }
            }) { [weak self] error in
                self?.hud.failureHidden(self?.errorMessage(error))
        }
        .disposed(by: disposeBag)
    }
    
    // 添加/修改/删除,月经周期
    private func commitMergeWeekInfo(isNext: Bool, startDate: String, keepDays: Int) {
//        let id = isNext ? nextCircleData.id : currentCircleData.id
        // 不管修改当前周期还是下个周期id都是传当前周期
        let id = currentCircleData.id
        hud.noticeLoading()
        
        HCProvider.request(.mergeWeekInfo(id: id,
                                          startDate: startDate,
                                          keepDays: keepDays,
                                          next: isNext ? 1 : 0))
            .mapResponse()
            .subscribe(onSuccess: { [weak self] res in
                if res.code == RequestCode.success.rawValue {
                    self?.requestRecordData()
                }else {
                    self?.hud.failureHidden(res.message)
                }
            }) { [weak self] error in
                self?.hud.failureHidden(self?.errorMessage(error))
        }
        .disposed(by: disposeBag)
    }

}

extension HCRecordViewModel {
    
    // 选择第一天的计算
    private func caculte(startDate: String) {
        if startDate.count > 0 {
            let tempDays = TYDateCalculate.numberOfDays(toDate: startDate)
            if tempDays > 0 {
                // 选择月经只能选择在当日之前的时间
                NoticesCenter.alert(title: "提示", message: "标记日期不符合经期规律，请重新标记")
                return
            }

            let firstDate = TYDateCalculate.date(for: startDate)
                        
            let currentCircleDate = TYDateCalculate.date(for: currentCircleData.menstruationDate)
            let days = TYDateCalculate.numberOfDays(fromDate: currentCircleDate, toDate: firstDate)

            // 新设置的月经起始时间与原先设置的时间大于21天进入下一周期的设置
            if days >= 21 {
                NoticesCenter.alert(title: "提示", message: "标记日期与预测日期相差太大，是否进入下一周期", cancleTitle: "否", okTitle: "是") { [unowned self] in
                    self.commitMergeWeekInfo(isNext: true,
                                             startDate: startDate,
                                             keepDays: self.currentCircleData.keepDays)
                }

                return
            }

            // 标记月经第一天与当前月经第一天差值区间 -21到21
            if abs(days) < 21 {
                commitMergeWeekInfo(isNext: false, startDate: startDate, keepDays: currentCircleData.keepDays)
                return
            }
            
            NoticesCenter.alert(title: "提示", message: "标记日期不符合经期规律，请重新标记")
        }
    }
    
    // 选择最后一天的计算
    private func caculte(lastDate: String) {
        if lastDate.count > 0 {
            let tempDays = TYDateCalculate.numberOfDays(toDate: lastDate)
            if tempDays > 0 {
                // 选择月经只能选择在当日之前的时间
                NoticesCenter.alert(title: "提示", message: "标记日期不符合经期规律，请重新标记")
                return
            }

            let lastDate = TYDateCalculate.date(for: lastDate)
            let currentCircleDate = TYDateCalculate.date(for: currentCircleData.menstruationDate)
            let days = TYDateCalculate.numberOfDays(fromDate: currentCircleDate, toDate: lastDate)

            // 标记月经最后一天小与当前月经第一天
            if days < 0 {
                NoticesCenter.alert(title: "提示", message: "月经结束日期应该大于月经起始日期")
                return
            }
            
            // 月经周期最多7天
            if days > 7 {
                NoticesCenter.alert(title: "提示", message: "标记日期不符合经期规律，请重新标记")
                return
            }
            
            self.commitMergeWeekInfo(isNext: false,
                                     startDate: currentCircleData.menstruationDate,
                                     keepDays: days)
        }
    }
    
    private func exchangeData() {
        isContrast = !isContrast
        datasource.removeAll()
        
        circleDatas = circleDatas.map { [unowned self] data -> HCRecordItemDataModel in
            data.isContrast = self.isContrast
            return data
        }
        
        lastCircleData.isContrast = isContrast
        currentCircleData.isContrast = isContrast
        nextCircleData.isContrast = isContrast

        if isContrast {
            datasource.append(circleDatas)
        }else {
            datasource.append([currentCircleData])
            datasource.append(cellActionItemDatasource)
        }
        
        reloadUISubject.onNext(Void())
    }
        
    private func dealData(datas: [HCRecordItemDataModel]) {
        guard datas.count == 3 else { return }

        circleDatas.removeAll()
        
        var idx = 0
        for var item in datas {
            if item.cycle > 0 && item.keepDays > 0 && item.menstruationDate.count > 0 {
                formatCircle(data: &item, idx: idx)
                if idx == 0 {
                    lastCircleData = item
                    lastCircleData.circleIsSet = true
                }else if idx == 1 {
                    currentCircleData = item
                    currentCircleData.circleIsSet = true
                }else if idx == 2 {
                    nextCircleData = item
                    nextCircleData.circleIsSet = true
                }
            }else {
                PrintLog("非法数据")
                if idx == 0 {
                    lastCircleData = item
                    lastCircleData.circleIsSet = false
                }else if idx == 1 {
                    currentCircleData = item
                    currentCircleData.circleIsSet = false
                }else if idx == 2 {
                    nextCircleData = item
                    nextCircleData.circleIsSet = false
                }
            }
            
            circleDatas.append(item)

            idx += 1
        }
        
        datasource.removeAll()
        datasource.append([currentCircleData])
        datasource.append(cellActionItemDatasource)
        
        reloadUISubject.onNext(Void())
        
        hud.noticeHidden()
    }
    
    private func formatCircle(data: inout HCRecordItemDataModel, idx: Int) {
        data.nowCircle = idx == 0 ? "上个周期" : idx == 1 ? "本周期" : "下个周期"

        // 转化排卵日数据为Date
        var tempOvulationDates: [Date] = []
        // 标记排卵日只取第一个
        let tempOvulationList = data.ovulationList.count > 1 ? [data.ovulationList.last!] : data.ovulationList
        for item in tempOvulationList {
            tempOvulationDates.append(TYDateCalculate.date(for: item.ovulationDate))
        }
        data.ovulationDates = tempOvulationDates
        
        /// ---月经期推算
        // 第一天
        let starYj = TYDateCalculate.date(for: data.menstruationDate)
        // 最后一天
        let endYj = TYDateCalculate.getDate(currentDate: starYj, days: data.keepDays - 1, isAfter: true)
        let yjArr: [Date] = TYDateCalculate.getDates(startDate: starYj, endDate: endYj)

        /// --- 排卵期日期推算
        let circleEndDate = TYDateCalculate.getDate(currentDate: starYj, days: data.cycle - 1, isAfter: true)
        // 排卵日
        let plaDate = TYDateCalculate.getDate(currentDate: circleEndDate, days: 14, isAfter: false)
        data.pailuan = plaDate
        // 排卵期第一天 排卵日a往前推5天
        let starPlqDate = TYDateCalculate.getDate(currentDate: plaDate, days: 5, isAfter: false)
        // 排卵期最后一天 排卵日a往后推4天
        let endPlqDate = TYDateCalculate.getDate(currentDate: plaDate, days: 4, isAfter: true)
        let plqArr: [Date] = TYDateCalculate.getDates(startDate: starPlqDate, endDate: endPlqDate)
        
        /// ---排卵期后安全期日期推算
        // 第一天
        let starSafeAfterDate = TYDateCalculate.getDate(currentDate: endPlqDate, days: 1, isAfter: true)
        let safeAfterArr: [Date] = TYDateCalculate.getDates(startDate: starSafeAfterDate, endDate: circleEndDate)

        /// ---排卵期前安全期日期推算
        // 第一天
        let starSafeBefore = TYDateCalculate.getDate(currentDate: endYj, days: 1, isAfter: true)
        // 最后一天
        let endSafeBefore = TYDateCalculate.getDate(currentDate: starPlqDate, days: 1, isAfter: false)
        let safeBeforeArr: [Date] = TYDateCalculate.getDates(startDate: starSafeBefore, endDate: endSafeBefore)

        var allDates: [Date] = []
        allDates.append(contentsOf: yjArr)
        allDates.append(contentsOf: safeBeforeArr)
        allDates.append(contentsOf: plqArr)
        allDates.append(contentsOf: safeAfterArr)
        
        // 怀孕几率数据
        var probabilityDatas: [Float] = []
        
        // 月经期怀孕几率
        for _ in 0..<yjArr.count {
            probabilityDatas.append(0.01)
        }

        // 排卵期前的安全期怀孕几率
        var beforeSafeProbabilityDatas: [Float] = [0.05,0.06,0.08,0.09,0.11,0.13,0.14]
        if safeBeforeArr.count > 0 {
            if beforeSafeProbabilityDatas.count >= safeBeforeArr.count {
                let star: Int = beforeSafeProbabilityDatas.count - safeBeforeArr.count
                beforeSafeProbabilityDatas = Array(beforeSafeProbabilityDatas[star..<beforeSafeProbabilityDatas.count])
            }else {
                let count = safeBeforeArr.count - beforeSafeProbabilityDatas.count
                var starPro: Float = 0.14
                for i in 0..<count {
                    starPro += (Float(i) * 0.01)
                    beforeSafeProbabilityDatas.append(starPro)
                }
            }
            probabilityDatas.append(contentsOf: beforeSafeProbabilityDatas)
        }
        
        // 排卵期怀孕几率
        probabilityDatas.append(contentsOf: [0.15,0.20,0.25,0.30,0.35,0.32,0.27,0.22,0.18,0.15])

        // 排卵期后的安全期怀孕几率
        var afterSafeProbabilityDatas: [Float] = [0.14,0.12,0.11,0.09,0.07,0.06,0.05]
        if afterSafeProbabilityDatas.count >= safeAfterArr.count {
            afterSafeProbabilityDatas = Array(afterSafeProbabilityDatas[0..<safeAfterArr.count])
        }else {
            let count = safeAfterArr.count - afterSafeProbabilityDatas.count
            var starPro: Float = 0.05
            for _ in 0..<count {
                starPro -= 0.01
                starPro = max(0, starPro)
                afterSafeProbabilityDatas.append(starPro)
            }
        }
        probabilityDatas.append(contentsOf: afterSafeProbabilityDatas)

        
        data.probabilityDatas = probabilityDatas
        
        var yjPoints: [TYPointItemModel] = []
        let alphTimeBgColor = HC_MAIN_COLOR
        for date in yjArr {
            let timeBgColor: UIColor = tempOvulationDates.contains(date) ? alphTimeBgColor : .clear
            let com = TYDateCalculate.getDataComponent(date: date)
            let m = TYPointItemModel(borderColor: .clear,
                                     time: "\(com.month!).\(com.day!)",
                                     timeBgColor: timeBgColor)
            yjPoints.append(m)
        }

        var safeBeforePoints: [TYPointItemModel] = []
        for date in safeBeforeArr {
            let timeBgColor: UIColor = tempOvulationDates.contains(date) ? alphTimeBgColor : .clear
            let com = TYDateCalculate.getDataComponent(date: date)
            let m = TYPointItemModel(borderColor: .clear,
                                     time: "\(com.month!).\(com.day!)",
                                     timeBgColor: timeBgColor)
            safeBeforePoints.append(m)
        }

        var plqPoints: [TYPointItemModel] = []
        var idx: Int = 0
        for date in plqArr {
            var timeBgColor = tempOvulationDates.contains(date) ? alphTimeBgColor : .clear
            if date == plaDate {
                timeBgColor = RGB(253, 119, 146, 0.2)
            }
            let com = TYDateCalculate.getDataComponent(date: date)
            var m = TYPointItemModel(borderColor: .clear,
                                     time: "\(com.month!).\(com.day!)",
                                     timeBgColor: timeBgColor)
            if idx % 2 == 0 {
                // 排卵期隔天标记建议同房
                m.isMark = true
                m.markIcon = UIImage(named: "record_icon_love")
            }

            plqPoints.append(m)
            idx += 1
        }

        var safeAfterPoints: [TYPointItemModel] = []
        for date in safeAfterArr {
            let timeBgColor: UIColor = tempOvulationDates.contains(date) ? alphTimeBgColor : .clear
            let com = TYDateCalculate.getDataComponent(date: date)
            var m = TYPointItemModel(borderColor: .clear,
                                     time: "\(com.month!).\(com.day!)",
                                     timeBgColor: timeBgColor)
            if date == safeAfterArr.first {
                m.isMark = true
                m.markIcon = UIImage(named: "record_icon_love")
            }
            safeAfterPoints.append(m)
        }
        
        if safeBeforeArr.count > 0 {
            data.lineItemDatas = [TYLineItemModel(color: RGB(213, 89, 92),
                                                  lineCount: yjArr.count,
                                                  pointDatas: yjPoints),
                                  TYLineItemModel(color: RGB(84, 197, 141),
                                                  lineCount: safeBeforeArr.count,
                                                  pointDatas: safeBeforePoints),
                                  TYLineItemModel(color: RGB(255, 113, 17),
                                                  lineCount: plqArr.count,
                                                  pointDatas: plqPoints),
                                  TYLineItemModel(color: RGB(84, 197, 141),
                                                  lineCount: safeAfterArr.count,
                                                  pointDatas: safeAfterPoints)]            
        }else {
            data.lineItemDatas = [TYLineItemModel(color: RGB(213, 89, 92),
                                                  lineCount: yjArr.count,
                                                  pointDatas: yjPoints),
                                  TYLineItemModel(color: RGB(255, 113, 17),
                                                  lineCount: plqArr.count,
                                                  pointDatas: plqPoints),
                                  TYLineItemModel(color: RGB(84, 197, 141),
                                                  lineCount: safeAfterArr.count,
                                                  pointDatas: safeAfterPoints)]
        }
           
        let currentDate = TYDateCalculate.formatNowDate()
        // 所处阶段
        var jieduanString = NSAttributedString.init()
        // 怀孕几率
        var jilvString = NSAttributedString.init()
        
        if let day = yjArr.firstIndex(of: currentDate) {
            let dayString = "\(day + 1)"
            var text = "所处阶段：月经期第\(dayString)天"
            jieduanString = text.attributed([.init(location: 5, length: 3),
                                             .init(location: 9, length: dayString.count)],
                                            color: [HC_MAIN_COLOR, HC_MAIN_COLOR],
                                            font: [.font(fontSize: 12), .font(fontSize: 12)])
            
            let intPro: Int = Int(probabilityDatas[day] * 100)
            let stringPro = "\(intPro)"
            text = "怀孕几率：\(stringPro)%"
            jilvString = text.attributed(.init(location: 5,
                                               length: stringPro.count),
                                         HC_MAIN_COLOR,
                                         .font(fontSize: 12))
        }else if let day = safeBeforeArr.firstIndex(of: currentDate) {
            let dayString = "\(day + 1)"
            var text = "所处阶段：安全期第\(dayString)天"
            jieduanString = text.attributed([.init(location: 5, length: 3),
                                             .init(location: 9, length: dayString.count)],
                                            color: [HC_MAIN_COLOR, HC_MAIN_COLOR],
                                            font: [.font(fontSize: 12), .font(fontSize: 12)])
            
            PrintLog((probabilityDatas[day + yjArr.count]))
            let intPro: Int = Int(probabilityDatas[day + yjArr.count] * 100)
            let stringPro = "\(intPro)"
            text = "怀孕几率：\(stringPro)%"
            jilvString = text.attributed(.init(location: 5,
                                               length: stringPro.count),
                                         HC_MAIN_COLOR,
                                         .font(fontSize: 12))
        }else if let day = plqArr.firstIndex(of: currentDate) {
            let dayString = "\(day + 1)"
            var text = "所处阶段：排卵期第\(dayString)天"
            jieduanString = text.attributed([.init(location: 5, length: 3),
                                             .init(location: 9, length: dayString.count)],
                                            color: [HC_MAIN_COLOR, HC_MAIN_COLOR],
                                            font: [.font(fontSize: 12), .font(fontSize: 12)])
            
            let intPro: Int = Int(probabilityDatas[day + yjArr.count + safeBeforeArr.count] * 100)
            let stringPro = "\(intPro)"
            text = "怀孕几率：\(stringPro)%"
            jilvString = text.attributed(.init(location: 5,
                                               length: stringPro.count),
                                         HC_MAIN_COLOR,
                                         .font(fontSize: 12))
        }else if let day = safeAfterArr.firstIndex(of: currentDate) {
            let dayString = "\(day + 1)"
            var text = "所处阶段：安全期第\(dayString)天"
            jieduanString = text.attributed([.init(location: 5, length: 3),
                                             .init(location: 9, length: dayString.count)],
                                            color: [HC_MAIN_COLOR, HC_MAIN_COLOR],
                                            font: [.font(fontSize: 12), .font(fontSize: 12)])
            
            let intPro: Int = Int(probabilityDatas[day + yjArr.count + safeBeforeArr.count + plqArr.count] * 100)
            let stringPro = "\(intPro)"
            text = "怀孕几率：\(stringPro)%"
            jilvString = text.attributed(.init(location: 5,
                                               length: stringPro.count),
                                         HC_MAIN_COLOR,
                                         .font(fontSize: 12))
        }
        
        data.newLv = jieduanString
        data.probability = jilvString
                
        // 计算当前天在周期的第几天
        var tempDateArr: [Date] = []
        tempDateArr.append(contentsOf: yjArr)
        tempDateArr.append(contentsOf: safeBeforeArr)
        tempDateArr.append(contentsOf: plqArr)
        tempDateArr.append(contentsOf: safeAfterArr)

        let currentNowDate = TYDateCalculate.formatNowDate()
        if let idx = tempDateArr.firstIndex(of: currentNowDate) {
            data.nowDateIdxOfCircle = idx
        }
    }
}

extension HCRecordViewModel {
    
    public func referenceSize(forHeader section: Int) ->CGSize {
        if datasource.count == 1 {
            return .init(width: PPScreenW, height: HCExchangeReusableView_height)
        }else if datasource.count == 2 {
            return section == 0 ? .init(width: PPScreenW, height: HCRecordUserInfoReusableView_height) : .init(width: PPScreenW, height: HCRecordSuggestReusableView_height)
        }
        return .zero
    }
    
    public func inset(_ section: Int) -> UIEdgeInsets {
        if datasource.count == 1 {
            return .init(top: 0, left: 0, bottom: 0, right: 0)
        }else if datasource.count == 2 {
            return section == 0 ? .init(top: 0, left: 0, bottom: 0, right: 0) : .init(top: 0, left: 20, bottom: 0, right: 20)
        }
        return .zero
    }
    
    public func minimumLineSpacing(_ section: Int) ->CGFloat {
        if datasource.count == 1 {
            return 0
        }else if datasource.count == 2 {
            return section == 0 ? 0 : 10
        }
        return 0
    }
    
    public func minimumInteritemSpacing(_ section: Int) ->CGFloat {
        if datasource.count == 1 {
            return 0
        }else if datasource.count == 2 {
            return section == 0 ? 0 : 30
        }
        return 0
    }
    
    public func supplementaryIdentifier(for section: Int) ->String {
        if datasource.count == 1 {
            return HCExchangeReusableView_identifier
        }else if datasource.count == 2 {
            return section == 0 ? HCRecordUserInfoReusableView_identifier : HCRecordSuggestReusableView_identifier
        }
        return ""
    }
}
