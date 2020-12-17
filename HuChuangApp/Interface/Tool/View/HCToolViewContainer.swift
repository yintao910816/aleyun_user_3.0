//
//  HCToolViewContainer.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/13.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

import RxSwift

class HCToolViewContainer: UIView {

    private let disposeBag = DisposeBag()
    
    private var listData: [HCListCellItem] = []
    private var calendarDatas: [TYCalendarSectionModel] = []
    private var currentPage: Int = 0
    
    private var calendarView: HCCalendarView!
    private var tableView: UITableView!
    private var forecastRemindView: HCForecastRemindView!
    
    public var didSelected: ((HCListCellItem)->())?
    public let dayItemSelectedSignal = PublishSubject<TYCalendarItem>()
    public let didScrollSignal = PublishSubject<Int>()
    public let switchChangeSignal = PublishSubject<(Bool, HCListCellItem)>()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func reloadData(data: [HCListCellItem], selectedDayItem: TYCalendarItem?) {
        listData = data
        if data.count > 0 {
            tableView.tableFooterView = nil
        }else {
            if forecastRemindView == nil {
                forecastRemindView = HCForecastRemindView.init(frame: .init(x: 0, y: 0, width: tableView.width, height: height - (tableView.tableHeaderView?.height ?? 0)))
            }else {
                forecastRemindView.frame = .init(x: 0, y: 0, width: tableView.width, height: height - (tableView.tableHeaderView?.height ?? 0))
            }
            forecastRemindView.model = selectedDayItem
            tableView.tableFooterView = forecastRemindView
        }
        tableView.reloadData()
    }
    
    public func reloadCalendar(calendarDatas: [TYCalendarSectionModel], currentPage: Int) {
        self.calendarDatas = calendarDatas
        self.currentPage = currentPage
        
        if calendarView == nil, let _ = calendarDatas.first {
            calendarView = HCCalendarView.init(frame: .init(x: 0, y: 0, width: tableView.width, height: 0))
            calendarView.itemSelectedSignal
                .bind(to: dayItemSelectedSignal)
                .disposed(by: disposeBag)
            calendarView.didScrollSignal
                .bind(to: didScrollSignal)
                .disposed(by: disposeBag)
            calendarView.heightChangeSignal
                .subscribe(onNext: { [unowned self] in
                    self.calendarView.frame = .init(x: 0, y: 0, width: self.tableView.width, height: $0)
                    self.tableView.tableHeaderView = calendarView
                })
                .disposed(by: disposeBag)
        }
        
        if currentPage < calendarDatas.count {
            let sectinoData = calendarDatas[currentPage]
            calendarView.frame = .init(x: 0, y: 0, width: tableView.width, height: HCCalendarView.viewHeight(itemCount: sectinoData.items.count))
            calendarView.reloadDatas(sectionData: calendarDatas, currentPage: currentPage)
            
            tableView.tableHeaderView = calendarView
        }else {
            tableView.tableHeaderView = nil
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        tableView.frame = bounds
    }
    
    private func setupUI() {
        
        tableView = UITableView.init(frame: bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        
        tableView.register(HCListCustomSwitchCell.self, forCellReuseIdentifier: HCListCustomSwitchCell_identifier)
        tableView.register(HCListDetailCell.self, forCellReuseIdentifier: HCListDetailCell_identifier)

        addSubview(tableView)
    }

}

extension HCToolViewContainer: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? HCRecordRemindView_height : 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let view = HCRecordRemindView(frame: .init(x: 0, y: 0, width: tableView.width, height: HCRecordRemindView_height))
            return view
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return listData[indexPath.row].cellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = listData[indexPath.row]
        let cell = (tableView.dequeueReusableCell(withIdentifier: model.cellIdentifier) as! HCBaseListCell)
        cell.model = model
        cell.clickedSwitchCallBack = { [unowned self] in self.switchChangeSignal.onNext($0) }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        didSelected?(listData[indexPath.row])
    }

}
