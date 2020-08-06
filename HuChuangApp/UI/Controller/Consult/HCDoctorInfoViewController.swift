//
//  HCDoctorInfoViewController.swift
//  HuChuangApp
//
//  Created by yintao on 2019/12/4.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit

class HCDoctorInfoViewController: BaseViewController {

    @IBOutlet weak var topBar: HCCustomNavBar!
    @IBOutlet weak var tableView: UITableView!
    
    private var headerView: HCDoctorInfoHeaderView!
    
    private var userId: String = ""
    
    private var viewModel: HCDoctorInfoViewModel!
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func setupUI() {
        topBar.backCallBack = { [unowned self] in
            self.navigationController?.popViewController(animated: true)
        }
        
        headerView = HCDoctorInfoHeaderView.init(frame: .init(x: 0, y: 0, width: PPScreenW, height: 280))
        tableView.tableHeaderView = headerView
    }
    
    override func rxBind() {
        viewModel = HCDoctorInfoViewModel.init(userId: userId)
        
        viewModel.reloadUI
            .subscribe(onNext: { [weak self] data in
                self?.headerView.model = data
            })
            .disposed(by: disposeBag)
        
        viewModel.reloadSubject.onNext(Void())
    }
    
    override func prepare(parameters: [String : Any]?) {
        userId = parameters!["userId"] as! String
    }
}
