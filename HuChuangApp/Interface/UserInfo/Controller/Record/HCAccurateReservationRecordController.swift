//
//  HCAccurateReservationRecordController.swift
//  HuChuangApp
//
//  Created by yintao on 2020/8/23.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCAccurateReservationRecordController: HCSlideItemController {

    private var viewModel: HCAccurateReservationRecordViewModel!
    private var tableView: UITableView!

    override func setupUI() {
        tableView = UITableView.init(frame: view.bounds, style: .grouped)
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
//        tableView.delegate = self
//        tableView.dataSource = self
        view.addSubview(tableView)
    }
    
    override func rxBind() {
        viewModel = HCAccurateReservationRecordViewModel()
        tableView.prepare(viewModel)

        viewModel.isEmptyContentObser.value = true
    }
}
