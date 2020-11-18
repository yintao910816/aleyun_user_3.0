
//
//  HCAccurateReservationController.swift
//  HuChuangApp
//
//  Created by yintao on 2020/8/23.
//  Copyright © 2020 sw. All rights reserved.
//  精准预约

import UIKit

class HCAccurateReservationController: HCSlideItemController {

    private var tableView: UITableView!
    private var viewModel: HCAccurateReservationViewModel!
        
    public var pushH5CallBack:((String)->())?
   
    override func setupUI() {
        tableView = UITableView.init(frame: view.bounds, style: .grouped)
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        tableView.register(HCAccurateReservationCell.self, forCellReuseIdentifier: HCAccurateReservationCell_identifier)
    }
    
    override func rxBind() {
        viewModel = HCAccurateReservationViewModel()
        
        tableView.prepare(viewModel)
        
        viewModel.isEmptyContentObser.value = true
    }
                
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
    }
}

extension HCAccurateReservationController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.datasource.value.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return HCAccurateReservationCell_height
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (tableView.dequeueReusableCell(withIdentifier: HCAccurateReservationCell_identifier) as! HCAccurateReservationCell)
        cell.model = viewModel.datasource.value[indexPath.row]
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
    }
}
