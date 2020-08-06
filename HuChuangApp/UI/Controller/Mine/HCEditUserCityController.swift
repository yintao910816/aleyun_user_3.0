//
//  HCEditUserCityController.swift
//  HuChuangApp
//
//  Created by yintao on 2020/1/3.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCEditUserCityController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel: HCEditUserCityViewModel!
        
    override func setupUI() {
        title = "修改地区"
        
        tableView.rowHeight = TYCityCell_height
        tableView.register(TYCityCell.self, forCellReuseIdentifier: TYCityCell_identifier)
    }
    
    override func rxBind() {
        viewModel = HCEditUserCityViewModel()
        viewModel.allCitysDataObser.asDriver()
            .drive(onNext: { [weak self] _ in
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
                
        viewModel.popSubject
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.reloadSubject.onNext(Void())
    }
}

extension HCEditUserCityController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.sectionTitles[section]
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return viewModel.sectionTitles
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.allCitysDataObser.value.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.backgroundColor = RGB(249, 249, 249)
        label.textColor = RGB(10, 10, 10)
        label.font = .font(fontSize: 14)
        label.text = "     \(viewModel.sectionTitles[section])"
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.allCitysDataObser.value[section].list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TYCityCell_identifier) as! TYCityCell
        cell.model = viewModel.allCitysDataObser.value[indexPath.section].list[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.finishEdit.onNext(viewModel.allCitysDataObser.value[indexPath.section].list[indexPath.row])
    }
}
