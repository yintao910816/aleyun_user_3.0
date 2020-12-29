//
//  HCPicConsultRecordViewController.swift
//  HuChuangApp
//
//  Created by yintao on 2020/8/23.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCPicConsultRecordViewController: HCSlideItemController {

    private var tableView: UITableView!
    private var viewModel: HCMyPicRecordViewModel!
    
    public var pushH5CallBack:((HCConsultItemModel)->())?

    override func setupUI() {
        tableView = UITableView.init(frame: view.bounds, style: .grouped)
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        tableView.register(HCConsultRecordCell.self, forCellReuseIdentifier: HCConsultRecordCell_identifier)
    }
    
    override func rxBind() {
        viewModel = HCMyPicRecordViewModel()
        tableView.prepare(viewModel)
        
        viewModel.datasource.asDriver()
            .drive(onNext: { [weak self] _ in self?.tableView.reloadData() })
            .disposed(by: disposeBag)
        
        
        tableView.headerRefreshing()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
    }
}

extension HCPicConsultRecordViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.datasource.value.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return HCConsultRecordCell_height
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (tableView.dequeueReusableCell(withIdentifier: HCConsultRecordCell_identifier) as! HCConsultRecordCell)
        cell.model = viewModel.datasource.value[indexPath.section]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section < viewModel.datasource.value.count - 1 {
            return 10
        }
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section < viewModel.datasource.value.count - 1 {
            let view = UIView()
            view.backgroundColor = RGB(243, 243, 243)
            return view
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        pushH5CallBack?(viewModel.datasource.value[indexPath.section])
    }
}
