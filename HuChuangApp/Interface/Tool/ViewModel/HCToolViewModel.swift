//
//  HCToolViewModel.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/13.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation
import RxSwift
import Moya

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
    /// 删除体温或体重
    public let delTemperatureOrWeightSignal = PublishSubject<Int>()

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
    
    private var isRemindNoMenstruaSetting: Bool = false

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
                    let sectionData = calendarDatasSignal.value[page]
                    
                    let days = TYDateFormatter.calculateDays(forMonth: sectionData.dateText)
                    var currentDateStr: String = ""
                    if days >= selectedDayInt {
                        currentDateStr = sectionData.createDateText(day: selectedDayInt)
                    }else {
                        currentDateStr = sectionData.createDateText(day: days)
                    }

                    navTitleChangeSignal.onNext(currentDateStr)

                    if prepareAddSelectedCalendarDatas(dateString: currentDateStr) {
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

        delTemperatureOrWeightSignal
            .subscribe(onNext: { [unowned self] in self.requestDelTemperatureOrWeight(type: $0) })
            .disposed(by: disposeBag)

        reloadMenstruaSignal
            .subscribe(onNext: { [unowned self] in
                if prepareAddSelectedCalendarDatas(dateString: $0) {
                    navTitleChangeSignal.onNext(selectedDate)
                    requestGetBaseInfoByDate(date: $0)
                }
            })
            .disposed(by: disposeBag)

        reloadSubject
            .subscribe(onNext: { [unowned self] in
                if !HCHelper.userIsLogin() {
                    HCHelper.presentLogin()
                }else {
                    requestGetMenstruationBasis(isClear: true)
                }
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
            
        NotificationCenter.default.rx.notification(NotificationName.User.LoginSuccess, object: nil)
            .subscribe(onNext: { [weak self] _ in
                self?.isRemindNoMenstruaSetting = false
                self?.requestGetMenstruationBasis(isClear: true)
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
    private func requestGetMenstruationBasis(isClear: Bool) {
        HCProvider.request(.getMenstruationBasis)
            .map(result: HCMenstruationModel.self)
            .subscribe(onSuccess: { [weak self] in
                self?.baseMenstruation = $0.data
                if self?.baseMenstruation == nil {
                    let appDelegate = UIApplication.shared.delegate as? HCAppDelegate
                    let tabVC = appDelegate?.window?.rootViewController as? HCTabBarViewController
                    if tabVC?.selectedIndex == 1, self?.isRemindNoMenstruaSetting == false {
                        NoticesCenter.alert(title: "提示", message: "设置经期基础数据才能预测经期", cancleTitle: "取消", okTitle: "去设置") {
                            
                        } callBackOK: {
                            HCToolViewModel.push(HCMenstruationSettingViewController.self, nil)
                        }
                        self?.isRemindNoMenstruaSetting = true
                    }
                    
                    self?.resetMenstrua(isClear: isClear, needHud: false)
                }else {
                    self?.resetMenstrua(isClear: isClear)
                }
            }) { [weak self] in
                self?.resetMenstrua(isClear: isClear)
                if let err = $0 as? MoyaError,
                   err.response?.statusCode == RequestCode.invalid.rawValue {
                    
                }else {
                    self?.hud.failureHidden(self?.errorMessage($0))
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func resetMenstrua(isClear: Bool, needHud: Bool = true) {
        if selectedDate == nil || isClear {
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
        
        requestGetBaseInfoByDate(date: selectedDate, needHud: needHud)
    }
    
    // 获取经期数据
    private func requestGetBaseInfoByDate(date: String, needHud: Bool = true) {
        guard let dateDate = date.stringFormatDate(mode: .yymmdd) else {
            hud.failureHidden("时间格式化失败")
            return
        }
                        
        if needHud {
            hud.noticeLoading()
        }
        
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
    
    // 删除体温或体重
    private func requestDelTemperatureOrWeight(type: Int) {
        HCProvider.request(.delTemperatureOrWeight(type: type, date: selectedDate))
            .mapResponse()
            .subscribe { [weak self] _ in
                if type == 1 {
                    self?.reloadDayTemperature(temperature: "")
                }else {
                    self?.reloadDayWeight(weight: "")
                }
            } onError: { [weak self] in
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
            let identifiers: [String] = [HCListCustomSwitchCell_identifier, HCListDetailCell_identifier, HCListDetailCell_identifier, HCListDetailCell_identifier]
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
            let identifiers: [String] = [HCListCustomSwitchCell_identifier, HCListCustomSwitchCell_identifier, HCListDetailCell_identifier, HCListDetailCell_identifier, HCListDetailCell_identifier]
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
        
    // 月份变化判断是否添加日期数据
    private func prepareAddSelectedCalendarDatas(dateString: String) ->Bool {
        guard let date = dateString.stringFormatDate(mode: .yymmdd) else {
            return false
        }
        
        guard let findPreDate = TYDateFormatter.getDate(fromData: date, identifier: .previous) else {
            return false
        }
        
        guard let findNextDate = TYDateFormatter.getDate(fromData: date, identifier: .next) else {
            return false
        }

        var isChange: Bool = false
        var addCalendars: [TYCalendarSectionModel] = []
        
        let findDateStr = date.formatDate(mode: .yymm)
        if (calendarDatasSignal.value.first(where: { $0.dateText == findDateStr }) == nil),
           let section = TYCalendarSectionModel.creatSignalCalendarData(date: date) {
            isChange = true
            addCalendars.append(section)
        }
        
        let findPreDateStr = findPreDate.formatDate(mode: .yymm)
        if (calendarDatasSignal.value.first(where: { $0.dateText == findPreDateStr }) == nil),
           let section = TYCalendarSectionModel.creatSignalCalendarData(date: findPreDate) {
            isChange = true
            addCalendars.append(section)
        }

        let findNextDateStr = findNextDate.formatDate(mode: .yymm)
        if (calendarDatasSignal.value.first(where: { $0.dateText == findNextDateStr }) == nil),
           let section = TYCalendarSectionModel.creatSignalCalendarData(date: findNextDate) {
            isChange = true
            addCalendars.append(section)
        }

        var calendarDatas: [TYCalendarSectionModel] = []
        calendarDatas.append(contentsOf: calendarDatasSignal.value)

        if isChange == true {
            calendarDatas.append(contentsOf: addCalendars)
            
            calendarDatas = calendarDatas.sorted(by: { (s1, s2) -> Bool in
                if TYDateCalculate.compare(dateStr: s1.dateText, other: s2.dateText, mode: .yymm) == .orderedDescending {
                    return false
                }
                return true
            })
        }
        
        if let idx = calendarDatas.firstIndex(where: { $0.dateText == dateString.transform(mode: .yymm) }) {
            calendarDatas.first(where: { $0.dateText == selectedDate.transform(mode: .yymm) })?.items.first(where: { $0.dateText == selectedDate })?.isSelected = false
            calendarDatas.first(where: { $0.dateText == dateString.transform(mode: .yymm) })?.items.first(where: { $0.dateText == dateString })?.isSelected = true

            currentPage = idx
            selectedDayInt = TYDateFormatter.getDay(date: date)
            selectedDate = dateString
            
            calendarDatasSignal.value = calendarDatas
            
            return true
        }else {
            return false
        }
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
        let text = weight.count > 0 ? "\(weight)kg" : ""
        let listData = listItemsSignal.value
        listData.first(where: { $0.title == "体重" })?.detailTitle = text
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
        let text = temperature.count > 0 ? "\(temperature)°C" : ""
        let listData = listItemsSignal.value
        listData.first(where: { $0.title == "体温" })?.detailTitle = text
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
                
//        let map: ((([TYCalendarItem], MenstruationDataTup, String))->()) = { data in
//
//            // 重置之前设置的数据
//            for item in data.0 {
//                item.mensturationMode = .none
//                item.bottomLeftIcon = nil
//                item.bottomRightIcon = (item.menstruationModel?.isMark == true) ? UIImage(named: "mensturation_mark") : nil
//                item.topRightIcon = (item.menstruationModel?.knew == true) ? UIImage(named: "aiai_red") : nil
//                item.isForecast = false
//            }
//
//            let yjqArr = data.1.yjq
//            let safeArr = data.1.safeBefore + data.1.safeAfter
//            let plqArr = data.1.plq
//            let plrArr = data.1.plr
//
//            for item in safeArr {
//                PrintLog("---------- \(item.date.formatDate(mode: .yymmdd)) -- \(data.0.first?.dateText)")
//                if let day = data.0.first(where: { $0.dateText == item.date.formatDate(mode: .yymmdd) }) {
//                    day.mensturationMode = item.mensturationMode
//                }else {
//                    PrintLog("未找到安全期期时间：\(item.date.formatDate(mode: .yymmdd))")
//                }
//            }
//
//            for item in plqArr {
//                if let day = data.0.first(where: { $0.dateText == item.date.formatDate(mode: .yymmdd) }) {
//                    day.mensturationMode = item.mensturationMode
//                }else {
//                    PrintLog("未找到排卵期时间：\(item.date.formatDate(mode: .yymmdd))")
//                }
//            }
//
//            for item in plrArr {
//                if let day = data.0.first(where: { $0.dateText == item.date.formatDate(mode: .yymmdd) }) {
//                    day.mensturationMode = item.mensturationMode
//                    day.bottomLeftIcon = day.mensturationMode == .plr ? UIImage(named: "tool_painuanri") : nil
//                }else {
//                    PrintLog("未找到排卵日时间：\(item.date.formatDate(mode: .yymmdd))")
//                }
//            }
//
//            for idx in 0..<yjqArr.count {
//                if let day = data.0.first(where: { $0.dateText == yjqArr[idx].date.formatDate(mode: .yymmdd) }) {
//                    day.mensturationMode = yjqArr[idx].mensturationMode
////                    PrintLog("设置月经：\(day.dateText)")
//
//                    day.isForecast = yjqArr[idx].isForecast
//
//                    if day.menstruationModel?.knew == true {
//                        day.topRightIcon = UIImage(named: "aiai_pink")
//                    }
//
//                    if day.menstruationModel?.menstruationStart == true {
//                        PrintLog("月经开始：\(day.dateText)")
//                        day.bottomLeftIcon = UIImage(named: "yjq_start")
//                    }else if day.menstruationModel?.menstruationEnd == true {
//                        PrintLog("月经结束：\(day.dateText)")
//                        day.bottomLeftIcon = UIImage(named: "yjq_end")
//                    }else {
//                        day.bottomLeftIcon = nil
//                    }
//                }else {
//                    PrintLog("未找到月经周期时间：\(yjqArr[idx].date.formatDate(mode: .yymmdd))")
//                }
//            }
//        }

        let map: (((TYCalendarItem, HCMensturaDateInfo))->()) = { data in
//            PrintLog("匹配周期数据: \(data.0.dateText) -- \(data.1.mensturationMode)")
            // 重置之前设置的数据
            data.0.mensturationMode = .none
            data.0.bottomLeftIcon = nil
            data.0.bottomRightIcon = (data.0.menstruationModel?.isMark == true) ? UIImage(named: "mensturation_mark") : nil
            data.0.topRightIcon = (data.0.menstruationModel?.knew == true) ? UIImage(named: "aiai_red") : nil
            
            data.0.mensturationMode = data.1.mensturationMode
            data.0.isForecast = data.1.isForecast

            switch data.0.mensturationMode {
            case .plr:
                data.0.bottomLeftIcon = UIImage(named: "tool_painuanri")
            case .yjq:
                if data.0.menstruationModel?.menstruationStart == true {
                    PrintLog("月经开始：\(data.0.dateText)")
                    data.0.bottomLeftIcon = UIImage(named: "yjq_start")
                }else if data.0.menstruationModel?.menstruationEnd == true {
                    PrintLog("月经结束：\(data.0.dateText)")
                    data.0.bottomLeftIcon = UIImage(named: "yjq_end")
                }else {
                    data.0.bottomLeftIcon = nil
                }
                
                if data.0.menstruationModel?.knew == true {
                    data.0.topRightIcon = data.0.isForecast == true ? UIImage(named: "aiai_red") : UIImage(named: "aiai_pink")
                }else {
                    data.0.topRightIcon = nil
                }
            default:
                break
            }
        }

        var allDayItems: [TYCalendarItem] = []
        for item in menstruasDic {
            if let sectionModel = calendarDatas.first(where: { $0.dateText == item.key }) {
                PrintLog("找到月11: \(sectionModel.dateText)")
                sectionModel.menstruation = item.value.first
                allDayItems.append(contentsOf: sectionModel.items)
            }else {
                PrintLog("未找到月111: \(item.key)")
            }
        }

        var dateInfoArr: [HCMensturaDateInfo] = []
        for item in mensturationDatasDic {
            let yjqArr = item.value.yjq
            let safeArr = item.value.safeBefore + item.value.safeAfter
            let plqArr = item.value.plq
            let plrArr = item.value.plr

            dateInfoArr.append(contentsOf: yjqArr)
            dateInfoArr.append(contentsOf: safeArr)
            dateInfoArr.append(contentsOf: plqArr)
            dateInfoArr.append(contentsOf: plrArr)
        }
        
        for item in dateInfoArr {
            if let dayItem = allDayItems.first(where: { $0.dateText == item.date.formatDate(mode: .yymmdd) }) {
                map((dayItem, item))
            }else {
                
            }
        }
        
//        for item in mensturationDatasDic {
//            if let sectionModel = calendarDatas.first(where: { $0.dateText == item.key }) {
//                PrintLog("找到月: \(sectionModel.dateText)")
//                map((sectionModel.items, item.value, item.key))
//            }else {
//                PrintLog("未找到月: \(item.key)")
//            }
//        }
    }
    
    private func resetBaseCalendar(calendarDatas: [TYCalendarSectionModel]) {
                
        for item in calendarDatas {
            for day in item.items {
                day.mensturationMode = .none
                day.bottomLeftIcon = nil
//                day.bottomRightIcon = (day.menstruationModel?.isMark == true) ? UIImage(named: "mensturation_mark") : nil
                day.bottomRightIcon = nil
                
//                if day.menstruationModel?.knew == true {
//                    day.topRightIcon = UIImage(named: "aiai_red")
//                }
                day.topRightIcon = nil
            }
        }
    }


    // 处理日期控件中未设置经期状态的日期
    private func mapNoneMensturationStatu(allMenustruaDataDic: [String: MenstruationDataTup],
                                          calendarSections: [TYCalendarSectionModel],
                                          reloadSectionKeys: [String]) {
        var allMenustruaDatas: [HCMensturaDateInfo] = []
        var allPlrDatas: [HCMensturaDateInfo] = []

        for item in allMenustruaDataDic {
            allMenustruaDatas.append(contentsOf: item.value.yjq)
            allMenustruaDatas.append(contentsOf: item.value.safeBefore)
            allMenustruaDatas.append(contentsOf: item.value.plq)
            allMenustruaDatas.append(contentsOf: item.value.plr)
            allMenustruaDatas.append(contentsOf: item.value.safeAfter)
            
            allPlrDatas.append(contentsOf: item.value.plr)
        }
        
        let reloadSections = calendarSections.filter({ reloadSectionKeys.contains($0.dateText) })
        
        for section in reloadSections {
            let reloadItems = section.items.filter({ $0.mensturationMode == .none })
            for item in reloadItems {
                if let dateInfo = allMenustruaDatas.first(where: { $0.date.formatDate(mode: .yymmdd) == item.dateText }) {
                    PrintLog("容错有经期数据的月中未设置经期状态的日：\(item.dateText) - \(section.dateText)")
                    // 只设置经期相关，当日的标记相关数据不替换
                    item.mensturationMode = dateInfo.mensturationMode
                    item.isForecast = dateInfo.isForecast
                    if let plrDateInfo = allPlrDatas.first(where: { $0.date.formatDate(mode: .yymmdd) == item.dateText }) {
                        PrintLog("容错排卵日：\(item.dateText) - \(section.dateText)")
                        item.bottomLeftIcon = plrDateInfo.bottomLeftIcon
                    }else {
                        if dateInfo.bottomLeftIcon != nil {
                            item.bottomLeftIcon = dateInfo.bottomLeftIcon
                        }
                    }
                }else {
                    if let mode = section.menstruation?.mode {
                        PrintLog("未找到容错有经期数据：\(item.dateText) --- \(mode)")
                        item.mensturationMode = mode == .none ? .none : .aqq
                    }else {
                        PrintLog("未找到容错有经期数据111：\(item.dateText)")
                        item.mensturationMode = .none
                    }
                    item.isForecast = true
                    item.bottomLeftIcon = nil
                }
            }
        }        
    }
        
    // 推算每个月经期所处阶段
    private func formatMenstruation(baseInfo: HCBaseInfoDataModel) {
        let calendarDatas = calendarDatasSignal.value
        resetBaseCalendar(calendarDatas: calendarDatas)

        if baseInfo.menstruationList.count == 3 {
            selectedMenstruasDic[HCToolCalculate.getKey(dateStr: selectedDate, identifier: .previous)] = baseInfo.menstruationList[0]
            selectedMenstruasDic[HCToolCalculate.getKey(dateStr: selectedDate)] = baseInfo.menstruationList[1]
            selectedMenstruasDic[HCToolCalculate.getKey(dateStr: selectedDate, identifier: .next)] = baseInfo.menstruationList[2]
        }else {
            selectedMenstruasDic[HCToolCalculate.getKey(dateStr: selectedDate, identifier: .previous)] = []
            selectedMenstruasDic[HCToolCalculate.getKey(dateStr: selectedDate)] = []
            selectedMenstruasDic[HCToolCalculate.getKey(dateStr: selectedDate, identifier: .next)] = []
        }
         
        let realyMonthMens = calendarDatas.first(where: { $0.dateText == Date().formatDate(mode: .yymm) })?.menstruation
        let mensturationListTup = HCToolCalculate.transformMenstruationList(currentDate: selectedDate,
                                                                            realyMenstrua: realyMonthMens,
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
            calendarDatasSignal.value = calendarDatas
            return
        }
        
        var menstruaTupsDic: [String: MenstruationDataTup] = [:]
        for item in mensturationListDic {
            menstruaTupsDic[item.key] = monthMensturationDates(menstruations: item.value)
        }

//        menstruaTupsDic[selectedDate.transform(mode: .yymm)] = monthMensturationDates(menstruations: mensturationListDic[selectedDate.transform(mode: .yymm)]!)

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
    
    private func monthMensturationDates(menstruations: [HCMenstruationModel]) ->MenstruationDataTup {
        var yjqDateInfos: [HCMensturaDateInfo] = []
        var safeBeforeDateInfos: [HCMensturaDateInfo] = []
        var plqDateInfos: [HCMensturaDateInfo] = []
        var safeAfterDateInfos: [HCMensturaDateInfo] = []
        var plrDateInfos: [HCMensturaDateInfo] = []

        for item in menstruations {
            let tup = monthOneMensturation(menstruationDate: item.menstruationDate,
                                           menstruationDuration: item.menstruationDuration,
                                           menstruationCycle: item.menstruationCycle,
                                           mode: item.mode,
                                           isForecast: item.isForecast)
            
//            if let yjStart = tup.yjq.first?.date {
//                yjqDateInfos = yjqDateInfos.filter { da -> Bool in
//                    let compareRes = da.date.dateCompare(date: yjStart)
//                    if compareRes == .orderedDescending || compareRes == .orderedSame {
//                        PrintLog("去除了月经期: \(da.date.formatDate(mode: .yymmdd))")
//                        return false
//                    }
//                    return true
//                }
//
//                safeBeforeDateInfos = safeBeforeDateInfos.filter { da -> Bool in
//                    let compareRes = da.date.dateCompare(date: yjStart)
//                    if compareRes == .orderedDescending || compareRes == .orderedSame {
//                        PrintLog("去除了排卵期前安全期: \(da.date.formatDate(mode: .yymmdd))")
//                        return false
//                    }
//                    return true
//                }
//
//                plqDateInfos = plqDateInfos.filter { da -> Bool in
//                    let compareRes = da.date.dateCompare(date: yjStart)
//                    if compareRes == .orderedDescending || compareRes == .orderedSame {
//                        PrintLog("去除了排卵期: \(da.date.formatDate(mode: .yymmdd))")
//                        return false
//                    }
//                    return true
//                }
//
//                safeAfterDateInfos = safeAfterDateInfos.filter { da -> Bool in
//                    let compareRes = da.date.dateCompare(date: yjStart)
//                    if compareRes == .orderedDescending || compareRes == .orderedSame {
//                        PrintLog("去除了排卵期后安全期: \(da.date.formatDate(mode: .yymmdd))")
//                        return false
//                    }
//                    return true
//                }
//
//                plrDateInfos = plrDateInfos.filter { da -> Bool in
//                    let compareRes = da.date.dateCompare(date: yjStart)
//                    if compareRes == .orderedDescending || compareRes == .orderedSame {
//                        PrintLog("去除了排卵日: \(da.date.formatDate(mode: .yymmdd))")
//                        return false
//                    }
//                    return true
//                }
//            }
            
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
                                      mode: HCForecastMenstruaMode,
                                      isForecast: Bool) ->MenstruationDataTup {
        
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
        yjInfoArr.append(contentsOf: HCMensturaDateInfo.transform(dates: yjArr,
                                                                  mensturationMode: mode.transformMode(mode: .yjq),
                                                                  isForecast: isForecast))
        
        /// --- 排卵期日期推算
        // 下次月经来的第一天
        let nextMenstruationDate = TYDateCalculate.getDate(currentDate: starYj, days: menstruationCycle, isAfter: true)
        // 排卵日 - 下次月经来的第一天往前推14天就是排卵日
        let plaDate = TYDateCalculate.getDate(currentDate: nextMenstruationDate, days: 14, isAfter: false)
        plrInfoArr.append(HCMensturaDateInfo.transform(date: plaDate,
                                                       mensturationMode: mode.transformMode(mode: .plr),
                                                       isForecast: isForecast))
        
        // 排卵期第一天 排卵日a往前推5天
        let starPlqDate = TYDateCalculate.getDate(currentDate: plaDate, days: 5, isAfter: false)
        // 排卵期最后一天 排卵日a往后推4天
        let endPlqDate = TYDateCalculate.getDate(currentDate: plaDate, days: 4, isAfter: true)
        let plqArr: [Date] = TYDateCalculate.getDates(startDate: starPlqDate, endDate: endPlqDate)
        plqInfoArr.append(contentsOf: HCMensturaDateInfo.transform(dates: plqArr,
                                                                   mensturationMode: mode.transformMode(mode: .plq),
                                                                   isForecast: isForecast))
                
        /// ---排卵期后安全期日期推算
        // 第一天
        let starSafeAfterDate = TYDateCalculate.getDate(currentDate: endPlqDate, days: 1, isAfter: true)
        let safeAfterArr: [Date] = TYDateCalculate.getDates(startDate: starSafeAfterDate,
                                                            endDate: TYDateCalculate.getDate(currentDate: nextMenstruationDate,
                                                                                             days: 1,
                                                                                             isAfter: false))
        safeAfterInfoArr.append(contentsOf: HCMensturaDateInfo.transform(dates: safeAfterArr,
                                                                         mensturationMode: mode.transformMode(mode: .aqq),
                                                                         isForecast: isForecast))
        
        /// ---排卵期前安全期日期推算
        // 第一天
        let starSafeBefore = TYDateCalculate.getDate(currentDate: endYj, days: 1, isAfter: true)
        // 最后一天
        let endSafeBefore = TYDateCalculate.getDate(currentDate: starPlqDate, days: 1, isAfter: false)
        let safeBeforeArr = TYDateCalculate.getDates(startDate: starSafeBefore, endDate: endSafeBefore)
        safeBeforeInfoArr.append(contentsOf: HCMensturaDateInfo.transform(dates: safeBeforeArr,
                                                                          mensturationMode: mode.transformMode(mode: .aqq),
                                                                          isForecast: isForecast))
        
        if mode == .normal {
            // 排在当前日期之后的经期都设置预测
            for item in yjInfoArr {
                if item.date.compare(Date()) == .orderedDescending {
                    item.isForecast = true
                }
            }
            
            if let yjEndDate = yjInfoArr.last?.date {
                var copySafeBefore: [HCMensturaDateInfo] = []
                for item in safeBeforeInfoArr {
                    if item.date.compare(yjEndDate) == .orderedDescending {
                        copySafeBefore.append(item)
                    }else {
                        PrintLog("去除安全期包含在月经期中的部分: \(item.date.formatDate(mode: .yymmdd))")
                    }
                }
                safeBeforeInfoArr = copySafeBefore
            }

            if let yjEndDate = yjInfoArr.last?.date {
                var copyPLQ: [HCMensturaDateInfo] = []
                for item in plqInfoArr {
                    if item.date.compare(yjEndDate) == .orderedDescending {
                        copyPLQ.append(item)
                    }else {
                        PrintLog("去除排卵期包含在月经期中的部分: \(item.date.formatDate(mode: .yymmdd))")
                    }
                }
                plqInfoArr = copyPLQ
            }

            if let yjEndDate = yjInfoArr.last?.date {
                var copyPLR: [HCMensturaDateInfo] = []
                for item in plrInfoArr {
                    if item.date.compare(yjEndDate) == .orderedDescending {
                        copyPLR.append(item)
                    }else {
                        PrintLog("去除排卵日包含在月经期中的部分: \(item.date.formatDate(mode: .yymmdd))")
                    }
                }
                plrInfoArr = copyPLR
            }

            if let yjEndDate = yjInfoArr.last?.date {
                var copySafeAfter: [HCMensturaDateInfo] = []
                for item in safeAfterInfoArr {
                    if item.date.compare(yjEndDate) == .orderedDescending {
                        copySafeAfter.append(item)
                    }else {
                        PrintLog("去除安全期包含在月经期中的部分: \(item.date.formatDate(mode: .yymmdd))")
                    }
                }
                safeAfterInfoArr = copySafeAfter
            }
        }
        
        return (yjq:yjInfoArr, safeBefore:safeBeforeInfoArr, plq:plqInfoArr, safeAfter:safeAfterInfoArr, plr:plrInfoArr)
    }

    
}
