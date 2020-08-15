//
//  HCAccountSettingContainer.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/13.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCAccountSettingContainer: UIView {

    private var listData: [HCListCellItem] = []
    private var tableView: UITableView!

    public var didSelected: ((HCListCellItem)->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initUI()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

extension HCAccountSettingContainer {
    
    private func initUI() {
        tableView = UITableView.init(frame: bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        
        tableView.register(HCListDetailCell.self, forCellReuseIdentifier: HCListDetailCell_identifier)
        tableView.register(HCListDetailIconCell.self, forCellReuseIdentifier: HCListDetailIconCell_identifier)

        addSubview(tableView)
    }
}

extension HCAccountSettingContainer: UITableViewDelegate, UITableViewDataSource {
        
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
