//
//  HCMyClassViewController.swift
//  HuChuangApp
//
//  Created by yintao on 2020/8/21.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCMyClassViewController: HCSlideItemController {

    private var tableView: UITableView!
    private var viewModel: HCCollectionCourseViewModel!
    
    override func setupUI() {
        tableView = UITableView.init(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        view.addSubview(tableView)
    }

    override func rxBind() {
        viewModel = HCCollectionCourseViewModel()
        tableView.prepare(viewModel)
        
        tableView.headerRefreshing()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
    }
}
