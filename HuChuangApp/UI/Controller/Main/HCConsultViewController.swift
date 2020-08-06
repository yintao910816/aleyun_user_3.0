//
//  HCConsultViewController.swift
//  HuChuangApp
//
//  Created by sw on 02/02/2019.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

class HCConsultViewController: BaseViewController {

    @IBOutlet weak var searchBar: TYSearchBar!
    @IBOutlet weak var searchBarHeightCns: NSLayoutConstraint!
    
    @IBOutlet weak var askCornerView: UIView!
    @IBOutlet weak var askShadowView: UIView!

    @IBOutlet weak var consultCornerView: UIView!
    @IBOutlet weak var consultShadowView: UIView!

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var findDoctorOutlet: UIButton!
    
    var viewModel: ConsultViewModel!
    
    @IBAction func actions(_ sender: UIButton) {
        HCHelper.pushLocalH5(type: .doctorCs)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func setupUI() {
        searchBar.searchPlaceholder = "搜索"
        searchBar.tfBgColor = RGB(247, 247, 247)
        searchBar.hasBottomLine = true
        searchBar.tfSearchIcon = "nav_search_gray"

        tableView.rowHeight = HCConsultListCell_Height
        
        searchBar.tapInputCallBack = { [unowned self] in
            self.navigationController?.pushViewController(HCSearchViewController(), animated: true)
        }
                
        askShadowView.setCornerAndShaow()
        consultShadowView.setCornerAndShaow()

        tableView.register(HCConsultListCell.self, forCellReuseIdentifier: HCConsultListCell_idetifier)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if searchBarHeightCns.constant == 44 {
            if #available(iOS 11.0, *) {
                searchBarHeightCns.constant += view.safeAreaInsets.top
                searchBar.safeArea = view.safeAreaInsets
            } else {
                searchBarHeightCns.constant += 20
                searchBar.safeArea = .init(top: 20, left: 0, bottom: 0, right: 0)
            }
        }
    }
    override func rxBind() {
        super.rxBind()
        
        findDoctorOutlet.rx.tap.asDriver()
            .drive(onNext: { [unowned self] in
                self.performSegue(withIdentifier: "expertConsultSegue", sender: nil)
            })
            .disposed(by: disposeBag)
        
        viewModel = ConsultViewModel.init()
        
        viewModel.datasource.asDriver()
            .drive(tableView.rx.items(cellIdentifier: HCConsultListCell_idetifier, cellType: HCConsultListCell.self)) { _,model,cell  in
                cell.model = model
                cell.consultCallBack = {
//                    self?.performSegue(withIdentifier: "picAndTextSegue", sender: $0)
                    HCHelper.pushH5(href: "\(H5Type.doctorCs.getLocalUrl())&userId=\($0.userId)")
                }
        }
        .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(HCDoctorItemModel.self)
            .asDriver()
            .drive(onNext: {
//                self.performSegue(withIdentifier: "doctorInfoSegue", sender: $0)
//                HCHelper.pushH5(href: "\(H5Type.doctorHome.getLocalUrl())&userId=\($0.userId)")
                let ctrl = HCDoctorHomeController()
                ctrl.prepare(parameters: HCDoctorHomeController.preprare(model: $0))
                self.navigationController?.pushViewController(ctrl, animated: true)
            })
            .disposed(by: disposeBag)
                
        // 上下拉刷新绑定
        tableView.prepare(viewModel, showFooter: false)
                
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        viewModel.reloadSubject.onNext(Void())
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "picAndTextSegue" {
            segue.destination.prepare(parameters: ["model": sender!])
        }else if segue.identifier == "doctorInfoSegue" {
            segue.destination.prepare(parameters: ["userId": (sender as! HCDoctorItemModel).userId])
        }
    }
}

extension HCConsultViewController: UITableViewDelegate {
 
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.backgroundColor = .white
        label.textColor = RGB(51, 51, 15)
        label.font = .font(fontSize: 16, fontName: .PingFRegular)
        label.text = "  名医推荐"
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
}
