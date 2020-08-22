//
//  HCPicConsultViewController.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/22.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCPicConsultViewController: HCSlideItemController {

    private var tableView: UITableView!
        
    private var datasource: [HCPicConsultItemModel] = []

    public var pushH5CallBack:((String)->())?

    override func setupUI() {
        tableView = UITableView.init(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        tableView.register(HCClassRoomListCell.self, forCellReuseIdentifier: HCClassRoomListCell_identifier)
    }
    
    override func reloadData(data: Any?) {
        if let dataModels = data as? [HCPicConsultItemModel] {
            datasource.removeAll()
            datasource.append(contentsOf: dataModels)
            tableView.reloadData()
        }
    }
    
    override func bind<T>(viewModel: RefreshVM<T>, canRefresh: Bool, canLoadMore: Bool, isAddNoMoreContent: Bool) {
        
        tableView.prepare(viewModel, showFooter: canLoadMore, showHeader: canRefresh, isAddNoMoreContent: isAddNoMoreContent)
    }
}

extension HCPicConsultViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return HCClassRoomListCell_height
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (tableView.dequeueReusableCell(withIdentifier: HCClassRoomListCell_identifier) as! HCClassRoomListCell)
//        cell.searchCourseModel = datasource[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}