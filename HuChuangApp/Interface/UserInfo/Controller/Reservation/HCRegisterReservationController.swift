//
//  HCRegisterReservationController.swift
//  HuChuangApp
//
//  Created by yintao on 2020/8/23.
//  Copyright © 2020 sw. All rights reserved.
//  预约挂号

import UIKit

class HCRegisterReservationController: HCSlideItemController {

    private var viewModel: HCRegisterReservationViewModel!
    private var tableView: UITableView!
    
    override func setupUI() {
        tableView = UITableView.init(frame: view.bounds, style: .plain)
        tableView.separatorStyle = .none
        view.addSubview(tableView)
    }
    
    override func rxBind() {
        viewModel = HCRegisterReservationViewModel()
        tableView.prepare(viewModel)
        
        viewModel.isEmptyContentObser.value = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
    }
}
