//
//  HCRecorderView.swift
//  HuChuangApp
//
//  Created by sw on 2019/10/17.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit

class HCRecorderView: UIView {

    private var listData: [HCListCellItem] = []
    
    private var calendarView: TYCalendarView!
    private var tableView: UITableView!
    
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
        calendarView = TYCalendarView.init(frame: .init(x: 0, y: 0, width: frame.width, height: viewHeight))
        
        tableView = UITableView.init(frame: bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.tableHeaderView = calendarView
        
        tableView.register(HCListSwitchCell.self, forCellReuseIdentifier: HCListSwitchCell_identifier)
        tableView.register(HCListDetailInputCell.self, forCellReuseIdentifier: HCListDetailInputCell_identifier)
        tableView.register(HCListSwitchCell.self, forCellReuseIdentifier: HCListDetailButtonCell_identifier)
        tableView.register(HCBaseListCell.self, forCellReuseIdentifier: HCBaseListCell_identifier)

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

extension HCRecorderView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 50 : 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let view = HCRecordRemindView(frame: .init(x: 0, y: 0, width: tableView.width, height: 50))
            return view
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = listData[indexPath.row]
        let cell = (tableView.dequeueReusableCell(withIdentifier: model.cellIdentifier) as! HCBaseListCell)
        cell.model = model
        return cell
    }
    
    
}
