//
//  HCToolViewModel.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/13.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation
import RxSwift

private typealias MenstruationDataTup = (yjq:[HCMensturaDateInfo], safeBefore:[HCMensturaDateInfo], plq:[HCMensturaDateInfo], safeAfter:[HCMensturaDateInfo], plr:[HCMensturaDateInfo])

class HCToolViewModel: BaseViewModel, VMNavigation {
        
    /// 根据当前选择的月查询当前月的经期数据
    private var baseInfoDataModel: HCBaseInfoDataModel?
    /// 加载当前月的周期数据获取的三个月经期数据
    private var selectedMenstruasDic: [String: [HCMenstruationModel]] = [:]
    /// 用户设置的基础经期数据，用来推算经期
    private var baseMenstruation: HCMenstruationModel?
    
//    // 当月的日期取日，不要月
//    private let currentDayInt: Int = TYDateFormatter.getDay(date: Date())
    // 当前选中的日期取日，不要月
    private var selectedDayInt: Int!
    // 当前选中的日期，年-月-日
    private var selectedDate: String!
    public let listItemsSignal = Variable([HCListCellItem]())
    public let calendarDatasSignal = Variable([TYCalendarSectionModel]())
    // 当前第几页数据
    public var currentPage: Int = 0

    /// 选中某天
    public let dayItemSelectedSignal = PublishSubject<TYCalendarItem>()
    /// 修改体温
    public let editTemperatureSignal = PublishSubject<String>()
    /// 修改体重
    public let editWeightSignal = PublishSubject<String>()
    /// 重新选择了日期
    public let reloadMenstruaSignal = PublishSubject<String>()
    /// 导航栏标题变化
    public let navTitleChangeSignal = PublishSubject<String>()
    /// 滚动之后
    public let didScrollSignal = PublishSubject<Int>()
    ///
    public let switchChangeSignal = PublishSubject<(Bool, HCListCellItem)>()
    /// 返回今天
    public let backTodaySignal = PublishSubject<Void>()

    override init() {
        super.init()
                
        dayItemSelectedSignal
            .subscribe(onNext: { [unowned self] in
                self.reloadCellItems(model: $0)
            })
            .disposed(by: disposeBag)
        
        backTodaySignal
            .subscribe(onNext: { [unowned self] in
                let today = Date.formatCurrentDate(mode: .yymmdd)
                if today != selectedDate {
                    selectedDayInt = TYDateFormatter.getDay(date: Date())
                    selectedDate = today
                    currentPage = calendarDatasSignal.value.firstIndex(where: { $0.dateText == selectedDate.transform(mode: .yymm) }) ?? 0
                    navTitleChangeSignal.onNext(selectedDate)
                    requestGetBaseInfoByDate(date: selectedDate)
                }else {
                    NoticesCenter.alert(message: "已经回今天了")
                }
            })
            .disposed(by: disposeBag)

        switchChangeSignal
            .subscribe(onNext: { [unowned self] in
                if $0.1.title == "爱爱" {
                    requestMergePro(dateStr: selectedDate, isOn: $0.0)
                }else if $0.1.title == "大姨妈来了" || $0.1.title == "大姨妈走了" {
                    if let dayItem = self.selectedDayItem {
                        switch dayItem.yjRemindMode {
                        case .coming:
                            self.requestUpdateMenstruationDate()
                        case .going:
                            requestSettingMenstruationEndDate()
                        case .early:
                            NoticesCenter.alert(title: "提示", message: dayItem.yjRemindMode.remindText(dayItem: dayItem) ?? "提前默认为空", cancleTitle: "取消", okTitle: "确定") { [unowned self] in
                                let datas = listItemsSignal.value
                                datas[0].isOn = false
                                listItemsSignal.value = datas
                            } callBackOK: { [weak self] in
                                self?.requestUpdateMenstruationDate()
                            }
                        case .cancelGoingForbiden, .forbidenComming, .forbidenGoing:
                            NoticesCenter.alert(title: "提示", message: dayItem.yjRemindMode.remindText(dayItem: dayItem) ?? "默认为空", callBackOK:  {
                                let datas = listItemsSignal.value
                                listItemsSignal.value = datas
                            })
                        }
                    }else {
                        NoticesCenter.alert(message: "未找到选择日期")
                    }
                }
            })
            .disposed(by: disposeBag)
        
        didScrollSignal
            .subscribe(onNext: { [unowned self] page in
                if page < calendarDatasSignal.value.count, page != currentPage {
                    let lastPage = currentPage
                    currentPage = page
                    let sectionData = calendarDatasSignal.value[page]
                    
                    let days = TYDateFormatter.calculateDays(forMonth: sectionData.dateText)
                    if days >= selectedDayInt {
                        selectedDate = sectionData.createDateText(day: selectedDayInt)
                    }else {
                        selectedDayInt = days
                        selectedDate = sectionData.createDateText(day: days)
                    }
                    
                    navTitleChangeSignal.onNext(selectedDate)

                    let identifier: DateIdentifier.month = page < lastPage ? .previous : .next
                    if prepareAddCalendarDatas(dateString: selectedDate, identifier: identifier) == true {
                        requestGetBaseInfoByDate(date: selectedDate)
                    }
                }
            })
            .disposed(by: disposeBag)

        editTemperatureSignal
            .subscribe(onNext: { [unowned self] in self.requestSaveOrUpdateTemperature(temperature: $0) })
            .disposed(by: disposeBag)

        editWeightSignal
            .subscribe(onNext: { [unowned self] in self.requestSaveOrUpdateWeight(weight: $0) })
            .disposed(by: disposeBag)

        reloadMenstruaSignal
            .subscribe(onNext: { [unowned self] in self.requestGetBaseInfoByDate(date: $0) })
            .disposed(by: disposeBag)

        reloadSubject
            .subscribe(onNext: { [unowned self] in
                requestGetMenstruationBasis()
            })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(NotificationName.Menstruation.SuccessBaseSetting, object: nil)
            .subscribe(onNext: { [weak self] in
                guard let strongSelf = self else { return }
                if let menstruaModel = $0.object as? HCMenstruationModel {
                    strongSelf.baseMenstruation = menstruaModel
                    strongSelf.prepareCellItems()
                    strongSelf.requestGetBaseInfoByDate(date: strongSelf.selectedDate)
                }
            })
            .disposed(by: disposeBag)
            
    }
    
    public var selectedDayItem: TYCalendarItem? {
        get {
            guard selectedDate != nil else { return nil }
            
            if let date = selectedDate.stringFormatDate(mode: .yymm),
               let sectionData = calendarDatasSignal.value.first(where: { $0.dateText == date.formatDate(mode: .yymm) }) {
                return sectionData.items.first(where: { $0.dateText == selectedDate })
            }
            return nil
        }
    }
}

extension HCToolViewModel {
    
    /// 获取经期周期相关基础数据
    private func requestGetMenstruationBasis() {
        HCProvider.request(.getMenstruationBasis)
            .map(result: HCMenstruationModel.self)
            .subscribe(onSuccess: { [weak self] in
                self?.baseMenstruation = $0.data
                if self?.baseMenstruation == nil {
                    NoticesCenter.alert(title: "提示", message: "设置经期基础数据才能预测经期", cancleTitle: "取消", okTitle: "去设置") {
                        
                    } callBackOK: {
                        HCToolViewModel.push(HCMenstruationSettingViewController.self, nil)
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
                        self?.resetMenstrua()
                    }
                }else {
                    self?.resetMenstrua()
                }
            }) { [weak self] in
                self?.resetMenstrua()
                self?.hud.failureHidden(self?.errorMessage($0))
            }
            .disposed(by: disposeBag)
    }
    
    private func resetMenstrua() {
        if selectedDate == nil {
            /// 首次设置
            selectedDayInt = TYDateFormatter.getDay(date: Date())
            selectedDate = Date.formatCurrentDate(mode: .yymmdd)
            currentPage = 1
            
            selectedMenstruasDic[HCToolCalculate.getKey(dateStr: selectedDate, identifier: .previous)] = []
            selectedMenstruasDic[HCToolCalculate.getKey(dateStr: selectedDate)] = []
            selectedMenstruasDic[HCToolCalculate.getKey(dateStr: selectedDate, identifier: .next)] = []

            navTitleChangeSignal.onNext(selectedDate)
            prepareMenstruaItems()
        }

        prepareCellItems()
        
        requestGetBaseInfoByDate(date: selectedDate)
    }
    
    // 获取经期数据
    private func requestGetBaseInfoByDate(date: String) {
        guard let dateDate = date.stringFormatDate(mode: .yymmdd) else {
            hud.failureHidden("时间格式化失败")
            return
        }
                        
        hud.noticeLoading()
        let firstDate = dateDate.startOfCurrentMonth()
        HCProvider.request(.getBaseInfoByDate(date: firstDate.formatDate(mode: .yymmdd)))
            .map(model: HCBaseInfoDataModel.self)
            .subscribe { [weak self] in
                self?.baseInfoDataModel = $0
                self?.formatMenstruation(baseInfo: $0)
                self?.hud.noticeHidden()
            } onError: { [weak self] in
                self?.hud.failureHidden(self?.errorMessage($0))
            }
            .disposed(by: disposeBag)
    }
    
    // 修改体温
    private func requestSaveOrUpdateTemperature(temperature: String) {
//        hud.noticeLoading()
        HCProvider.request(.saveOrUpdateTemperature(temperature: temperature, temperatDate: selectedDate))
            .mapResponse()
            .subscribe { [weak self] _ in
//                self?.hud.noticeHidden()
                self?.reloadDayTemperature(temperature: temperature)
            } onError: { [weak self] in
                self?.hud.failureHidden(self?.errorMessage($0))
            }
            .disposed(by: disposeBag)
    }
    
    // 修改体重
    private func requestSaveOrUpdateWeight(weight: String) {
//        hud.noticeLoading()
        HCProvider.request(.saveOrUpdateWeight(weight: weight, measureDate: selectedDate))
            .mapResponse()
            .subscribe { [weak self] _ in
//                self?.hud.noticeHidden()
                self?.reloadDayWeight(weight: weight)
            } onError: { [weak self] in
                self?.hud.failureHidden(self?.errorMessage($0))
            }
            .disposed(by: disposeBag)
    }
    
    // 标记同房，排卵日暂时去掉
    private func requestMergePro(dateStr: String, isOn: Bool) {
        hud.noticeLoading()
        HCProvider.request(.mergePro(opType: .knewRecord, date: dateStr))
            .mapResponse()
            .subscribe { [weak self] _ in
                guard let strongSelf = self else { return }
                strongSelf.requestGetBaseInfoByDate(date: strongSelf.selectedDate)
            } onError: { [weak self] in
                guard let strongSelf = self else { return }
                let datas = strongSelf.listItemsSignal.value
                strongSelf.listItemsSignal.value = datas
                self?.hud.failureHidden(self?.errorMessage($0))
            }
            .disposed(by: disposeBag)
    }
    
    // 修改月经开始时间
    private func requestUpdateMenstruationDate() {
        hud.noticeLoading()
        HCProvider.request(.updateMenstruationDate(menstruationDate: selectedDate))
            .mapResponse()
            .subscribe { [weak self] _ in
                guard let strongSelf = self else { return }
                strongSelf.requestGetBaseInfoByDate(date: strongSelf.selectedDate)
            } onError: { [weak self] in
                guard let strongSelf = self else { return }
                let datas = strongSelf.listItemsSignal.value
                strongSelf.listItemsSignal.value = datas
                self?.hud.failureHidden(self?.errorMessage($0))
            }
            .disposed(by: disposeBag)
    }
    
    // 修改月经结束时间
    private func requestSettingMenstruationEndDate() {
        hud.noticeLoading()
        HCProvider.request(.settingMenstruationEndDate(menstruationEndDate: selectedDate))
            .mapResponse()
            .subscribe { [weak self] _ in
                guard let strongSelf = self else { return }
                strongSelf.requestGetBaseInfoByDate(date: strongSelf.selectedDate)
            } onError: { [weak self] in
                guard let strongSelf = self else { return }
                let datas = strongSelf.listItemsSignal.value
                strongSelf.listItemsSignal.value = datas
                self?.hud.failureHidden(self?.errorMessage($0))
            }
            .disposed(by: disposeBag)
    }
}

extension HCToolViewModel {
        
    // 列表数据
    private func prepareCellItems() {
        var items: [HCListCellItem] = []
        
        if baseMenstruation == nil {
            let titles: [String] = ["爱爱", "体温", "体重", "经期设置"]
            let titleIconss: [String] = ["tool_aiai", "tool_tiwen", "tool_weight", "tool_setting"]
            let identifiers: [String] = [HCListSwitchCell_identifier, HCListDetailCell_identifier, HCListDetailCell_identifier, HCListDetailCell_identifier]
            for idx in 0..<titles.count {
                let item = HCListCellItem()
                item.cellHeight = 55
                item.titleIcon = titleIconss[idx]
                item.title = titles[idx]
                item.titleFont = .font(fontSize: 18)
                item.titleColor = RGB(51, 51, 51)
                item.cellIdentifier = identifiers[idx]
                item.bottomLineMode = .title
                items.append(item)
            }
        }else {
            let titles: [String] = ["大姨妈来了", "爱爱", "体温", "体重", "经期设置"]
            let titleIconss: [String] = ["tool_dayima", "tool_aiai", "tool_tiwen", "tool_weight", "tool_setting"]
            let identifiers: [String] = [HCListSwitchCell_identifier, HCListSwitchCell_identifier, HCListDetailCell_identifier, HCListDetailCell_identifier, HCListDetailCell_identifier]
            for idx in 0..<titles.count {
                let item = HCListCellItem()
                item.cellHeight = 55
                item.titleIcon = titleIconss[idx]
                item.title = titles[idx]
                item.titleFont = .font(fontSize: 18)
                item.titleColor = RGB(51, 51, 51)
                item.cellIdentifier = identifiers[idx]
                item.bottomLineMode = .title
                items.append(item)
            }
        }
        
        listItemsSignal.value = items
    }
    
    // 选中或首次加载刷新列表detail和经期状态
    private func reloadCellItems(model: TYCalendarItem) {
        
        if model.isInMonth {
            selectedDayInt = model.day
            selectedDate = model.dateText

            navTitleChangeSignal.onNext(selectedDate)

            // 处理列表
            if let menustruaInfo = model.menstruationModel {
                let datas = listItemsSignal.value

                if let baseInfo = baseMenstruation {
                    let yjData = model.getYJInfo(menstruasDic: selectedMenstruasDic, baseMenstru: baseInfo)
                    datas[0].isOn = yjData.isOn
                    datas[0].title = yjData.mode.titleText
                    datas[1].isOn = menustruaInfo.knew
                    datas[2].detailTitle = menustruaInfo.temperature.count > 0 ? "\(menustruaInfo.temperature)°C" : ""
                    datas[3].detailTitle = menustruaInfo.weight.count > 0 ? "\(menustruaInfo.weight)kg" : ""
                }else {
                    datas[0].isOn = menustruaInfo.knew
                    datas[1].detailTitle = menustruaInfo.temperature.count > 0 ? "\(menustruaInfo.temperature)°C" : ""
                    datas[2].detailTitle = menustruaInfo.weight.count > 0 ? "\(menustruaInfo.weight)kg" : ""
                }
                listItemsSignal.value = datas
            }else {
                let datas = listItemsSignal.value
                datas[0].isOn = false
                datas[0].title = "大姨妈来了"
                datas[1].isOn = false
                datas[2].detailTitle = ""
                datas[3].detailTitle = ""
                listItemsSignal.value = datas
            }

            // 处理经期选中状态
            let mentruationDatas = calendarDatasSignal.value
            var sectionModel: TYCalendarSectionModel?
            
            for item in mentruationDatas {
                if item.isContain(date: selectedDate) {
                    sectionModel = item
                    break
                }
            }

            if let simpleSection = sectionModel {
                // 找到当前点击数据
                let selectedModelIdx = simpleSection.items.firstIndex{ $0.dateText == selectedDate }
                
                if let idx = selectedModelIdx, simpleSection.items[idx].isSelected == false {
                    // 找到之前选中数据
                    if let lastSelectedModelIdx = simpleSection.items.firstIndex(where: { $0.isSelected == true }) {
                        simpleSection.items[lastSelectedModelIdx].isSelected = false
                    }

                    // 找到当前点击，并且之前未选中
                    simpleSection.items[idx].isSelected = true

                    calendarDatasSignal.value = mentruationDatas
                }
            }

        }
    }
    
    // 经期数据 - 本月，上个月，下个月 (首次加载)
    private func prepareMenstruaItems() {
        let menstruationDatas = TYCalendarSectionModel.createMenturationDatas()
            
        for section in menstruationDatas {
            if let selectedDay = section.items.first(where: { $0.day == selectedDayInt }) {
                selectedDay.isSelected = true
            }else {
                section.items.last?.isSelected = true
            }
        }
        
        calendarDatasSignal.value = menstruationDatas
    }
    
    // 切换月份判断是否添加日期数据
    @discardableResult
    private func prepareAddCalendarDatas(dateString: String, identifier: DateIdentifier.month) ->Bool {
        guard let date = dateString.stringFormatDate(mode: .yymmdd) else {
            return false
        }
        
        guard let findDate = TYDateFormatter.getDate(fromData: date, identifier: identifier) else {
            return false
        }
        
        let findDateStr = findDate.formatDate(mode: .yymm)
        if (calendarDatasSignal.value.first(where: { $0.dateText == findDateStr }) != nil) {
            return true
        }
        
        if let signalSection = TYCalendarSectionModel.creatSignalCalendarData(date: date, identifier: identifier) {
           
            if let selectedDay = signalSection.items.first(where: { $0.day == selectedDayInt }) {
                selectedDay.isSelected = true
            }else {
                signalSection.items.last?.isSelected = true
            }

            var tempDatas = calendarDatasSignal.value
            if identifier == .previous {
                currentPage += 1
                tempDatas.insert(signalSection, at: 0)
            }else {
                tempDatas.append(signalSection)
            }
            
            calendarDatasSignal.value = tempDatas
            
            return true
        }
        return false
    }

    
    // 体重修改，刷新界面
    private func reloadDayWeight(weight: String) {
        
        // 日历
        let calendarDatas = calendarDatasSignal.value
        var sectionModel: TYCalendarSectionModel?
        
        for item in calendarDatas {
            if item.isContain(date: selectedDate) {
                sectionModel = item
                break
            }
        }
        
        if let dayItem = sectionModel?.items.first(where: { $0.dateText == selectedDate }) {
            dayItem.menstruationModel?.weight = weight
            dayItem.bottomRightIcon = (dayItem.menstruationModel?.isMark == true) ? UIImage(named: "mensturation_mark") : nil
        }
        
        calendarDatasSignal.value = calendarDatas

        // 列表
        let listData = listItemsSignal.value
        listData.first(where: { $0.title == "体重" })?.detailTitle = "\(weight)kg"
        listItemsSignal.value = listData
    }
    
    // 体温修改，刷新界面
    private func reloadDayTemperature(temperature: String) {
        
        // 日历
        let calendarDatas = calendarDatasSignal.value
        var sectionModel: TYCalendarSectionModel?
        
        for item in calendarDatas {
            if item.isContain(date: selectedDate) {
                sectionModel = item
                break
            }
        }
        
        if let dayItem = sectionModel?.items.first(where: { $0.dateText == selectedDate }) {
            dayItem.menstruationModel?.temperature = temperature
            dayItem.bottomRightIcon = (dayItem.menstruationModel?.isMark == true) ? UIImage(named: "mensturation_mark") : nil
        }
        
        calendarDatasSignal.value = calendarDatas

        // 列表
        let listData = listItemsSignal.value
        listData.first(where: { $0.title == "体重" })?.detailTitle = "\(temperature)°C"
        listItemsSignal.value = listData
    }

        
    // 将获取的每天的model对应到日历控件
    private func mapBaseInfoModel(calendarDatas: [TYCalendarSectionModel], baseInfos: [HCBaseInfoItemModel]) {
        
        var sectionModel: TYCalendarSectionModel?
        
        for item in calendarDatas {
            if item.isContain(date: selectedDate) {
                sectionModel = item
                break
            }
        }
        
        if let simplData = sectionModel {
            // 重置之前设置的数据
            for item in simplData.items {
                item.menstruationModel = nil
            }
            
            for idx in simplData.daysNotInMonthBefore..<simplData.items.count {
                simplData.items[idx].isSelected = simplData.items[idx].dateText == selectedDate
                
                let fixIdx: Int = idx - simplData.daysNotInMonthBefore
                if fixIdx < baseInfos.count {
                    simplData.items[idx].menstruationModel = baseInfos[fixIdx]
                    
                    simplData.items[idx].topRightIcon = baseInfos[fixIdx].knew == true ? UIImage(named: "aiai_red") : nil
                    simplData.items[idx].bottomRightIcon = baseInfos[fixIdx].isMark == true ? UIImage(named: "mensturation_mark") : nil
                }
            }
        }
    }
    
    // 将处理好的月经期数据对应到日历模型
    private func map(mensturationDatasDic: [String: MenstruationDataTup],
                     menstruasDic: [String: [HCMenstruationModel]],
                     calendarDatas: [TYCalendarSectionModel]) {
                
        let map: ((([TYCalendarItem], MenstruationDataTup, String))->()) = { data in
            
            // 重置之前设置的数据
            for item in data.0 {
                item.mensturationMode = .none
                item.bottomLeftIcon = nil
                item.bottomRightIcon = (item.menstruationModel?.isMark == true) ? UIImage(named: "mensturation_mark") : nil
                item.topRightIcon = (item.menstruationModel?.knew == true) ? UIImage(named: "aiai_red") : nil
            }
            
            let yjqArr = data.1.yjq
            let safeArr = data.1.safeBefore + data.1.safeAfter
            let plqArr = data.1.plq
            let plrArr = data.1.plr
                        
            for item in safeArr {
                if let day = data.0.first(where: { $0.dateText == item.date.formatDate(mode: .yymmdd) }) {
                    day.mensturationMode = .aqq
                }
            }
            
            for item in plqArr {
                if let day = data.0.first(where: { $0.dateText == item.date.formatDate(mode: .yymmdd) }) {
                    day.mensturationMode = .plq
                }
            }

            for item in plrArr {
                if let day = data.0.first(where: { $0.dateText == item.date.formatDate(mode: .yymmdd) }) {
                    day.mensturationMode = .plr
                    day.bottomLeftIcon = UIImage(named: "tool_painuanri")
                }
            }
            
            for idx in 0..<yjqArr.count {
                if let day = data.0.first(where: { $0.dateText == yjqArr[idx].date.formatDate(mode: .yymmdd) }) {
                    day.mensturationMode = .yjq
//                    PrintLog("设置月经：\(day.dateText)")

                    if day.menstruationModel?.knew == true {
                        day.topRightIcon = UIImage(named: "aiai_pink")
                    }
                    
                    if day.menstruationModel?.menstruationStart == true {
                        PrintLog("月经开始：\(day.dateText)")
                        day.bottomLeftIcon = UIImage(named: "yjq_start")
                    }else if day.menstruationModel?.menstruationEnd == true {
                        PrintLog("月经结束：\(day.dateText)")
                        day.bottomLeftIcon = UIImage(named: "yjq_end")
                    }else {
                        day.bottomLeftIcon = nil
                    }
                }
            }
        }

        for item in mensturationDatasDic {
            if let sectionModel = calendarDatas.first(where: { $0.dateText == item.key }) {
                PrintLog("找到月: \(sectionModel.dateText)")
                map((sectionModel.items, item.value, item.key))
            }
        }
    }
    
    private func resetBaseCalendar(calendarDatas: [TYCalendarSectionModel]) {
                
        for item in calendarDatas {
            for day in item.items {
                day.mensturationMode = .none
                day.bottomLeftIcon = nil
                day.bottomRightIcon = (day.menstruationModel?.isMark == true) ? UIImage(named: "mensturation_mark") : nil

                if day.menstruationModel?.knew == true {
                    day.topRightIcon = UIImage(named: "aiai_red")
                }
            }
        }
    }


    // 处理日期控件中未设置经期状态的日期
    private func mapNoneMensturationStatu(allMenustruaDataDic: [String: MenstruationDataTup],
                                          calendarSections: [TYCalendarSectionModel],
                                          reloadSectionKeys: [String]) {
        var allMenustruaDatas: [HCMensturaDateInfo] = []
        for item in allMenustruaDataDic {
            allMenustruaDatas.append(contentsOf: item.value.yjq)
            allMenustruaDatas.append(contentsOf: item.value.safeBefore)
            allMenustruaDatas.append(contentsOf: item.value.plq)
            allMenustruaDatas.append(contentsOf: item.value.plr)
            allMenustruaDatas.append(contentsOf: item.value.safeAfter)
        }
        
        var allDayItems: [TYCalendarItem] = []
        let reloadSections = calendarSections.filter({ reloadSectionKeys.contains($0.dateText) })
        for item in reloadSections {
            PrintLog("容错有经期数据的月中未设置经期状态的日：\(item.dateText)")
            allDayItems.append(contentsOf: item.items.filter({ $0.mensturationMode == .none }))
        }
        
        for item in allDayItems {
            if let dateInfo = allMenustruaDatas.first(where: { $0.date.formatDate(mode: .yymmdd) == item.dateText }) {
                // 只设置经期相关，当日的标记相关数据不替换
                item.mensturationMode = dateInfo.mensturationMode
                if dateInfo.bottomLeftIcon != nil {
                    item.bottomLeftIcon = dateInfo.bottomLeftIcon
                }
            }
        }
    }
        
    // 推算每个月经期所处阶段
    private func formatMenstruation(baseInfo: HCBaseInfoDataModel) {
        let calendarDatas = calendarDatasSignal.value
        
        if baseInfo.menstruationList.count == 3 {
            selectedMenstruasDic[HCToolCalculate.getKey(dateStr: selectedDate, identifier: .previous)] = baseInfo.menstruationList[0]
            selectedMenstruasDic[HCToolCalculate.getKey(dateStr: selectedDate)] = baseInfo.menstruationList[1]
            selectedMenstruasDic[HCToolCalculate.getKey(dateStr: selectedDate, identifier: .next)] = baseInfo.menstruationList[2]
        }else {
            selectedMenstruasDic[HCToolCalculate.getKey(dateStr: selectedDate, identifier: .previous)] = []
            selectedMenstruasDic[HCToolCalculate.getKey(dateStr: selectedDate)] = []
            selectedMenstruasDic[HCToolCalculate.getKey(dateStr: selectedDate, identifier: .next)] = []
        }
                
        let mensturationListTup = HCToolCalculate.transformMenstruationList(currentDate: selectedDate,
                                                                            menstruaList: baseInfo.menstruationList,
                                                                            baseMenstruation: baseMenstruation)

        let mensturationListDic = mensturationListTup.menstruasDic
        let reloadSectionKeys = mensturationListTup.reloadSectionKeys
        
        if baseInfoDataModel!.menstruationList.count == 3 {
            if baseInfoDataModel!.menstruationList[0].count == 0 {
                let key = HCToolCalculate.getKey(dateStr: selectedDate, identifier: .previous)
                baseInfoDataModel!.menstruationList[0] = mensturationListDic[key] ?? []
            }
            
            if baseInfoDataModel!.menstruationList[1].count == 0 {
                let key = HCToolCalculate.getKey(dateStr: selectedDate)
                baseInfoDataModel!.menstruationList[1] = mensturationListDic[key] ?? []
            }
            
            if baseInfoDataModel!.menstruationList[2].count == 0 {
                let key = HCToolCalculate.getKey(dateStr: selectedDate, identifier: .next)
                baseInfoDataModel!.menstruationList[2] = mensturationListDic[key] ?? []
            }
        }
        
        if mensturationListDic.count == 0 || calendarDatas.count < 3 {
            mapBaseInfoModel(calendarDatas: calendarDatas, baseInfos: baseInfo.baseInfo)
            resetBaseCalendar(calendarDatas: calendarDatas)
            calendarDatasSignal.value = calendarDatas
            return
        }
        
        var menstruaTupsDic: [String: MenstruationDataTup] = [:]
        for item in mensturationListDic {
            let compare = TYDateCalculate.compare(dateStr: item.key.transform(mode: .yymm),
                                                  other: Date().formatDate(mode: .yymm),
                                                  mode: .yymm)
            menstruaTupsDic[item.key] = monthMensturationDates(menstruations: item.value,
                                                               isBeforeToday: compare == .orderedAscending)
        }
        
        mapBaseInfoModel(calendarDatas: calendarDatas, baseInfos: baseInfo.baseInfo)
        
        map(mensturationDatasDic: menstruaTupsDic, menstruasDic: mensturationListDic, calendarDatas: calendarDatas)
        
        mapNoneMensturationStatu(allMenustruaDataDic: menstruaTupsDic,
                                 calendarSections: calendarDatas,
                                 reloadSectionKeys: reloadSectionKeys)
                
        
        calendarDatasSignal.value = calendarDatas
        
        if currentPage < calendarDatasSignal.value.count {
            let sectionModel = calendarDatasSignal.value[currentPage]
            if let dayItem = sectionModel.items.first(where: { $0.dateText == selectedDate }) {
                reloadCellItems(model: dayItem)
            }
        }
    }
    
    private func monthMensturationDates(menstruations: [HCMenstruationModel], isBeforeToday: Bool) ->MenstruationDataTup {
        var yjqDateInfos: [HCMensturaDateInfo] = []
        var safeBeforeDateInfos: [HCMensturaDateInfo] = []
        var plqDateInfos: [HCMensturaDateInfo] = []
        var safeAfterDateInfos: [HCMensturaDateInfo] = []
        var plrDateInfos: [HCMensturaDateInfo] = []

        for item in menstruations {
            let tup = monthOneMensturation(menstruationDate: item.menstruationDate,
                                           menstruationDuration: item.menstruationDuration,
                                           menstruationCycle: item.menstruationCycle,
                                           needYj: (item.isForecast && !isBeforeToday) || !item.isForecast)
            
            if let yjStart = tup.yjq.first?.date {
                yjqDateInfos = yjqDateInfos.filter { da -> Bool in
                    let compareRes = da.date.dateCompare(date: yjStart)
                    if compareRes == .orderedDescending || compareRes == .orderedSame {
                        PrintLog("去除了月经期: \(da.date.formatDate(mode: .yymmdd))")
                        return false
                    }
                    return true
                }
                
                safeBeforeDateInfos = safeBeforeDateInfos.filter { da -> Bool in
                    let compareRes = da.date.dateCompare(date: yjStart)
                    if compareRes == .orderedDescending || compareRes == .orderedSame {
                        PrintLog("去除了排卵期前安全期: \(da.date.formatDate(mode: .yymmdd))")
                        return false
                    }
                    return true
                }

                plqDateInfos = plqDateInfos.filter { da -> Bool in
                    let compareRes = da.date.dateCompare(date: yjStart)
                    if compareRes == .orderedDescending || compareRes == .orderedSame {
                        PrintLog("去除了排卵期: \(da.date.formatDate(mode: .yymmdd))")
                        return false
                    }
                    return true
                }

                safeAfterDateInfos = safeAfterDateInfos.filter { da -> Bool in
                    let compareRes = da.date.dateCompare(date: yjStart)
                    if compareRes == .orderedDescending || compareRes == .orderedSame {
                        PrintLog("去除了排卵期后安全期: \(da.date.formatDate(mode: .yymmdd))")
                        return false
                    }
                    return true
                }

                plrDateInfos = plrDateInfos.filter { da -> Bool in
                    let compareRes = da.date.dateCompare(date: yjStart)
                    if compareRes == .orderedDescending || compareRes == .orderedSame {
                        PrintLog("去除了排卵日: \(da.date.formatDate(mode: .yymmdd))")
                        return false
                    }
                    return true
                }
            }
            
            yjqDateInfos.append(contentsOf: tup.yjq)
            safeBeforeDateInfos.append(contentsOf: tup.safeBefore)
            plqDateInfos.append(contentsOf: tup.plq)
            safeAfterDateInfos.append(contentsOf: tup.safeAfter)
            plrDateInfos.append(contentsOf: tup.plr)
        }
                
        yjqDateInfos = deduplicates(datas: yjqDateInfos)
        safeBeforeDateInfos = deduplicates(datas: safeBeforeDateInfos)
        plqDateInfos = deduplicates(datas: plqDateInfos)
        safeAfterDateInfos = deduplicates(datas: safeAfterDateInfos)
        plrDateInfos = deduplicates(datas: plrDateInfos)
        
        return (yjq:yjqDateInfos, safeBefore:safeBeforeDateInfos, plq:plqDateInfos, safeAfter:safeAfterDateInfos, plr:plrDateInfos)
    }
    
    private func deduplicates(datas: [HCMensturaDateInfo]) ->[HCMensturaDateInfo] {
        var result: [HCMensturaDateInfo] = []
        for item in datas {
            if result.first(where: { $0.date == item.date }) == nil {
                result.append(item)
            }
        }
        return result
    }
    
    private func monthOneMensturation(menstruationDate: String,
                                      menstruationDuration: Int,
                                      menstruationCycle: Int,
                                      needYj: Bool) ->MenstruationDataTup {
        
        var yjInfoArr: [HCMensturaDateInfo] = []
        var plrInfoArr: [HCMensturaDateInfo] = []
        var plqInfoArr: [HCMensturaDateInfo] = []
        var safeAfterInfoArr: [HCMensturaDateInfo] = []
        var safeBeforeInfoArr: [HCMensturaDateInfo] = []
        
        /// ---月经期推算
        // 第一天
        let starYj = TYDateCalculate.date(for: menstruationDate)
        // 最后一天
        let endYj = TYDateCalculate.getDate(currentDate: starYj, days: menstruationDuration - 1, isAfter: true)
        let yjArr: [Date] = TYDateCalculate.getDates(startDate: starYj, endDate: endYj)
        yjInfoArr.append(contentsOf: HCMensturaDateInfo.transform(dates: yjArr, mensturationMode: .yjq))
        
        /// --- 排卵期日期推算
        // 下次月经来的第一天
        let nextMenstruationDate = TYDateCalculate.getDate(currentDate: starYj, days: menstruationCycle, isAfter: true)
        // 排卵日 - 下次月经来的第一天往前推14天就是排卵日
        let plaDate = TYDateCalculate.getDate(currentDate: nextMenstruationDate, days: 14, isAfter: false)
        plrInfoArr.append(HCMensturaDateInfo.transform(date: plaDate, mensturationMode: .plr))
        
        // 排卵期第一天 排卵日a往前推5天
        let starPlqDate = TYDateCalculate.getDate(currentDate: plaDate, days: 5, isAfter: false)
        // 排卵期最后一天 排卵日a往后推4天
        let endPlqDate = TYDateCalculate.getDate(currentDate: plaDate, days: 4, isAfter: true)
        let plqArr: [Date] = TYDateCalculate.getDates(startDate: starPlqDate, endDate: endPlqDate)
        plqInfoArr.append(contentsOf: HCMensturaDateInfo.transform(dates: plqArr, mensturationMode: .plq))
        
        if needYj {
            // 去除排卵期包含在月经期中的部分
            for yjItem in yjInfoArr {
                if let idx = plqInfoArr.firstIndex(where: { $0.date == yjItem.date }) {
                    PrintLog("去除排卵期包含在月经期中的部分: \(yjItem.date.formatDate(mode: .yymmdd))")
                    plqInfoArr.remove(at: idx)
                }
            }
        }else {
            yjInfoArr.removeAll()
        }
        
        /// ---排卵期后安全期日期推算
        // 第一天
        let starSafeAfterDate = TYDateCalculate.getDate(currentDate: endPlqDate, days: 1, isAfter: true)
        let safeAfterArr: [Date] = TYDateCalculate.getDates(startDate: starSafeAfterDate,
                                                            endDate: TYDateCalculate.getDate(currentDate: nextMenstruationDate,
                                                                                             days: 1,
                                                                                             isAfter: false))
        safeAfterInfoArr.append(contentsOf: HCMensturaDateInfo.transform(dates: safeAfterArr, mensturationMode: .aqq))
        
        /// ---排卵期前安全期日期推算
        // 第一天
        let starSafeBefore = TYDateCalculate.getDate(currentDate: endYj, days: 1, isAfter: true)
        // 最后一天
        let endSafeBefore = TYDateCalculate.getDate(currentDate: starPlqDate, days: 1, isAfter: false)
        let safeBeforeArr = TYDateCalculate.getDates(startDate: starSafeBefore, endDate: endSafeBefore)
        safeBeforeInfoArr.append(contentsOf: HCMensturaDateInfo.transform(dates: safeBeforeArr, mensturationMode: .aqq))
        
        return (yjq:yjInfoArr, safeBefore:safeBeforeInfoArr, plq:plqInfoArr, safeAfter:safeAfterInfoArr, plr:plrInfoArr)
    }

    
}
