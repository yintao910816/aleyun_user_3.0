//
//  HCMenstruationHistoryViewController.swift
//  HuChuangApp
//
//  Created by yintao on 2019/11/26.
//  Copyright © 2019 sw. All rights reserved.
//  月经史

import UIKit

class HCMenstruationHistoryViewController: BaseViewController {

    private var dataModel: HCHealthArchivesModel!
   
    @IBOutlet weak var operaBgView: UIView!
    @IBOutlet weak var menstruationHistoryOutlet: UIButton!
    @IBOutlet weak var maritalHistoryOutlet: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var saveOutlet: UIButton!
    @IBOutlet weak var saveButtonHeightCns: NSLayoutConstraint!
    
    private var viewModel: HCMenstruationHistoryViewModel!
    
    override func setupUI() {
        saveButtonHeightCns.constant += LayoutSize.fitTopArea
        operaBgView.layer.borderWidth = 1
        operaBgView.layer.borderColor = HC_MAIN_COLOR.cgColor
        
        tableView.rowHeight = HCListDetailInputCell_height
        tableView.register(HCListDetailInputCell.self, forCellReuseIdentifier: HCListDetailInputCell_identifier)
    }
    
    override func rxBind() {

        let menstruationHistoryDriver = menstruationHistoryOutlet.rx.tap.asDriver()
            .do(onNext: { [unowned self] in
                self.menstruationHistoryOutlet.isSelected = true
                self.maritalHistoryOutlet.isSelected = false
                
                self.menstruationHistoryOutlet.backgroundColor = HC_MAIN_COLOR
                self.maritalHistoryOutlet.backgroundColor = .white
            })
        
        let maritalHistoryDriver = maritalHistoryOutlet.rx.tap.asDriver()
            .do(onNext: { [unowned self] in
                self.menstruationHistoryOutlet.isSelected = false
                self.maritalHistoryOutlet.isSelected = true
                
                self.menstruationHistoryOutlet.backgroundColor = .white
                self.maritalHistoryOutlet.backgroundColor = HC_MAIN_COLOR
            })
                    
        viewModel = HCMenstruationHistoryViewModel.init(dataModel: dataModel,
                                                        tap: (menstruationHistoryTap: menstruationHistoryDriver, maritalHistoryTap: maritalHistoryDriver))
        
        viewModel.datasourceObser.asDriver()
            .drive(tableView.rx.items(cellIdentifier: HCListDetailInputCell_identifier, cellType: HCListDetailInputCell.self)) { _, model, cell in
                cell.model = model
        }
        .disposed(by: disposeBag)
        
        viewModel.reloadSubject.onNext(Void())
    }
    
    override func prepare(parameters: [String : Any]?) {
        dataModel = (parameters!["data"] as! HCHealthArchivesModel)
    }
}
