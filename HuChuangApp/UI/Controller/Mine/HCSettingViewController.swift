//
//  HCSettingViewController.swift
//  HuChuangApp
//
//  Created by yintao on 2019/12/6.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit
import RxDataSources

class HCSettingViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var footer: HCSettingFooterView!
    
    private var viewModel: HCSettingViewModel!
    
    override func setupUI() {
        footer = HCSettingFooterView.init(frame: .init(x: 0, y: 0, width: PPScreenW, height: 190))
        footer.loginOutCallBack = {
            HCHelper.presentLogin(presentVC: self, isPopToRoot: true) {
                NotificationCenter.default.post(name: NotificationName.UserInterface.selectedHomeTabBar, object: nil)
            }
        }
        tableView.tableFooterView = footer
        
        tableView.register(HCListDetailCell.self, forCellReuseIdentifier: HCBaseListCell_identifier)
        tableView.register(HCListSwitchCell.self, forCellReuseIdentifier: HCListSwitchCell_identifier)
    }
    
    override func rxBind() {
        viewModel = HCSettingViewModel()
        
        let datasource = RxTableViewSectionedReloadDataSource<SectionModel<Int, HCListCellItem>>.init(configureCell: { _,tb,indexPath,model -> HCBaseListCell in
            let cell = (tb.dequeueReusableCell(withIdentifier: model.cellIdentifier) as! HCBaseListCell)
            cell.model = model
            return cell
        })
        
        viewModel.listDataObser.asDriver()
            .drive(tableView.rx.items(dataSource: datasource))
            .disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)

        viewModel.reloadSubject.onNext(Void())
    }
}

extension HCSettingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.cellModel(for: indexPath).cellHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            NoticesCenter.alert(message: "开发中。。。")
        }else if indexPath.row == 1 {
            NoticesCenter.alert(message: "清除成功！")
        }
    }
}
