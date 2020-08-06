//
//  HCFindDoctorViewController.swift
//  HuChuangApp
//
//  Created by sw on 2019/9/25.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit

import RxDataSources

class HCFindDoctorViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var headerView: FindDoctorHeaderView!
    
    private var viewModel: HCFindDoctorViewModel!

    override func setupUI() {
        setContentInsetAdjustmentBehaviorNever(contentView: tableView)
    
        headerView = FindDoctorHeaderView.init(frame: .init(x: 0, y: 0, width: view.width, height: FindDoctorHeaderView.viewHeight()))
        tableView.tableHeaderView = headerView
        
        tableView.register(HCListDetailCell.self, forCellReuseIdentifier: HCListDetailCell_identifier)
        tableView.register(HCListButtonCell.self, forCellReuseIdentifier: HCListButtonCell_identifier)
        tableView.register(HCListDetailNewTypeCell.self, forCellReuseIdentifier: HCListDetailNewTypeCell_identifier)
    }
    
    override func rxBind() {
        viewModel = HCFindDoctorViewModel()
                
        let datasource = RxTableViewSectionedReloadDataSource<SectionModel<Int, HCListCellItem>>.init(configureCell: { _,tb,indexPath,model -> HCBaseListCell in
            let cell = (tb.dequeueReusableCell(withIdentifier: model.cellIdentifier) as! HCBaseListCell)
            cell.model = model
            return cell
        })
        
        viewModel.datasource.asDriver()
            .drive(tableView.rx.items(dataSource: datasource))
            .disposed(by: disposeBag)

        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
}

extension HCFindDoctorViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.cellModel(for: indexPath).cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if indexPath.row == 0 {
            let picker = HCPickerView.init()
            picker.view.frame = view.bounds
            picker.datasource = ["5", "7", "15", "20", "30"]

            addChildViewController(picker)
        }else {
            let datePicker = HCDatePickerViewController()
            datePicker.titleDes = "最近一次月经来潮时间"
            addChildViewController(datePicker)

            datePicker.finishSelected = { date in

            }
        }
    }
}
