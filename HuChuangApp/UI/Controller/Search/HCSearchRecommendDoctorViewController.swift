//
//  HCRecommendDoctorViewController.swift
//  HuChuangApp
//
//  Created by sw on 2019/10/3.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit

class HCSearchRecommendDoctorViewController: HCSlideItemController {

    private var tableView: UITableView!
        
    private var datasource: [HCSearchDoctorItemModel] = []
    public var didSelectedCallBack:((HCSearchDoctorItemModel)->())?

    override func setupUI() {
        tableView = UITableView.init(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)

        tableView.snp.makeConstraints { $0.edges.equalTo(UIEdgeInsets.zero) }

        tableView.register(HCSearchDoctorCell.self, forCellReuseIdentifier: HCSearchDoctorCell_idetifier)
    }

    override func reloadData(data: Any?) {
        if let dataModels = data as? [HCSearchDoctorItemModel] {
            datasource.removeAll()
            datasource.append(contentsOf: dataModels)
            tableView.reloadData()
        }
    }
    
    override func bind<T>(viewModel: RefreshVM<T>, canRefresh: Bool, canLoadMore: Bool, isAddNoMoreContent: Bool) {
        
        tableView.prepare(viewModel, showFooter: canLoadMore, showHeader: canRefresh, isAddNoMoreContent: isAddNoMoreContent)
    }
}

extension HCSearchRecommendDoctorViewController: UITableViewDelegate, UITableViewDataSource {
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
               
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return HCSearchDoctorCell_Height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (tableView.dequeueReusableCell(withIdentifier: HCSearchDoctorCell_idetifier) as! HCSearchDoctorCell)
        cell.model = datasource[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        didSelectedCallBack?(datasource[indexPath.row])
    }
}
