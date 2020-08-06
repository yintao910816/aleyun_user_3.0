//
//  HCHealthyArchivesViewController.swift
//  HuChuangApp
//
//  Created by yintao on 2019/11/25.
//  Copyright © 2019 sw. All rights reserved.
//  健康档案

import UIKit
import RxDataSources

class HCHealthyArchivesViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottonButtonHeightCns: NSLayoutConstraint!
    
    @IBOutlet weak var bottomOutlet: UIButton!
    private var viewModel: HCHealthyArchivesViewModel!
    
    override func setupUI() {
        navigationItem.title = "基本信息"

        view.backgroundColor = RGB(249, 249, 249)
        
        let headerView = HCHealthyArchivesHeaderTitleView.init(frame: .init(x: 0, y: 0, width: view.width, height: 70))
        headerView.titleText = "您填写的档案仅您和医生可见，为了给您更准确的医疗服务，请您务必填写真实资料。"
        tableView.tableHeaderView = headerView
        
        tableView.rowHeight = HCListDetailInputCell_height
        tableView.register(HCListDetailInputCell.self, forCellReuseIdentifier: HCListDetailInputCell_identifier)
    }
    
    override func rxBind() {
        bottonButtonHeightCns.constant += LayoutSize.fitTopArea
        
        bottomOutlet.rx.tap.asDriver()
            .drive(onNext: { [unowned self] in
                self.performSegue(withIdentifier: "menstruationHistorySegue", sender: nil)
            })
            .disposed(by: disposeBag)
        
        viewModel = HCHealthyArchivesViewModel()
        
        viewModel.datasourceObser.asDriver()
            .drive(tableView.rx.items(cellIdentifier: HCListDetailInputCell_identifier, cellType: HCListDetailInputCell.self)) { _, model, cell in
                cell.model = model
        }
        .disposed(by: disposeBag)
        
        viewModel.reloadSubject.onNext(Void())
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "menstruationHistorySegue" {
            segue.destination.prepare(parameters: ["data": viewModel.prepareData()])
        }
    }
}
