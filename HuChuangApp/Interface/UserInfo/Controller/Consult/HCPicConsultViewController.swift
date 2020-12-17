//
//  HCPicConsultViewController.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/22.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCPicConsultViewController: HCSlideItemController {

    public var tableView: UITableView!
        
    private var datasource: [HCConsultItemModel] = []

    public var pushH5CallBack:(((HCMyConsultDetailMode, HCConsultItemModel))->())?
   
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initUI() {
        tableView = UITableView.init(frame: .zero, style: .grouped)
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        tableView.register(HCPicConsultCell.self, forCellReuseIdentifier: HCPicConsultCell_identifier)
    }
    
    override func reloadData(data: Any?) {
        if let dataModels = data as? [HCConsultItemModel] {
            datasource.removeAll()
            datasource.append(contentsOf: dataModels)
            tableView.reloadData()
        }
    }
    
    override func bind<T>(viewModel: RefreshVM<T>, canRefresh: Bool, canLoadMore: Bool, isAddNoMoreContent: Bool) {
        
        tableView.prepare(viewModel, showFooter: canLoadMore, showHeader: canRefresh, isAddNoMoreContent: isAddNoMoreContent)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
    }
}

extension HCPicConsultViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        datasource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return HCPicConsultCell_height
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (tableView.dequeueReusableCell(withIdentifier: HCPicConsultCell_identifier) as! HCPicConsultCell)
        cell.model = datasource[indexPath.section]
        cell.actionCallBack = { [unowned self] in self.pushH5CallBack?((HCMyConsultDetailMode.chat, $0)) }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section < datasource.count - 1 {
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
        if section < datasource.count - 1 {
            let view = UIView()
            view.backgroundColor = RGB(243, 243, 243)
            return view
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        pushH5CallBack?((HCMyConsultDetailMode.order, datasource[indexPath.row]))
    }
}
