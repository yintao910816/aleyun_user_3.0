//
//  HCToolViewContainer.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/13.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCToolViewContainer: UIView {

    private var listData: [HCListCellItem] = []
    
    private var calendarView: HCCalendarView!
    private var tableView: UITableView!
    
    public var didSelected: ((HCListCellItem)->())?
    
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
    
    private func setupUI() {
        let frame = UIScreen.main.bounds
        calendarView = HCCalendarView.init(frame: .init(x: 0, y: 0, width: frame.width, height: viewHeight))
        
        tableView = UITableView.init(frame: bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.tableHeaderView = calendarView
        
        tableView.register(HCListSwitchCell.self, forCellReuseIdentifier: HCListSwitchCell_identifier)
        tableView.register(HCListDetailNewTypeCell.self, forCellReuseIdentifier: HCListDetailNewTypeCell_identifier)

        addSubview(tableView)
    }
    
    public func reloadData(data: [HCListCellItem]) {
        listData = data
        tableView.reloadData()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        tableView.frame = bounds
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        didSelected?(listData[indexPath.row])
    }

}
