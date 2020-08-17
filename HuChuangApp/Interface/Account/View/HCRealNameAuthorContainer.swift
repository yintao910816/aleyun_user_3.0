//
//  HCRealNameAuthorContainer.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/17.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCRealNameAuthorContainer: UIView {

    private var listData: [HCListCellItem] = []

    private var remindBg: UIView!
    private var remindLabel: UILabel!
    private var tableView: UITableView!
    public var commitButton: UIButton!
    
    public var didSelected: ((IndexPath)->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func reloadData(data: [HCListCellItem]) {
        listData = data
        tableView.reloadData()
    }
    
    public func reloadItem(indexPath: IndexPath, content: String) {
        listData[indexPath.row].detailTitle = content
        tableView.reloadData()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        remindBg.frame = .init(x: 0, y: 0, width: width, height: 25)
        remindLabel.frame = .init(x: 10, y: 0, width: remindBg.width - 20, height: remindBg.height)
        commitButton.frame = .init(x: 0, y: height - 49, width: width, height: 49)
        tableView.frame = .init(x: 0, y: remindBg.frame.maxY, width: width, height: height - remindBg.height - commitButton.height)
    }
}

extension HCRealNameAuthorContainer {
    
    private func initUI() {
        remindBg = UIView()
        remindBg.backgroundColor = RGB(231, 243, 254)
        
        remindLabel = UILabel()
        remindLabel.font = .font(fontSize: 11)
        remindLabel.textColor = RGB(91, 113, 145)
        remindLabel.text = "*国家卫健委要求，就医行为必须实名登记"
        
        tableView = UITableView.init(frame: bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        
        commitButton = UIButton()
        commitButton.setTitle("保存", for: .normal)
        commitButton.backgroundColor = HC_MAIN_COLOR
        commitButton.setTitleColor(.white, for: .normal)
        commitButton.titleLabel?.font = .font(fontSize: 16)

        tableView.register(HCListDetailInputCell.self, forCellReuseIdentifier: HCListDetailInputCell_identifier)
        tableView.register(HCListSexCell.self, forCellReuseIdentifier: HCListSexCell_identifier)
        tableView.register(HCListDetailCell.self, forCellReuseIdentifier: HCListDetailCell_identifier)

        addSubview(remindBg)
        remindBg.addSubview(remindLabel)
        addSubview(tableView)
        addSubview(commitButton)
    }
}

extension HCRealNameAuthorContainer: UITableViewDelegate, UITableViewDataSource {
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return listData[indexPath.row].cellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = listData[indexPath.row]
        let cell = (tableView.dequeueReusableCell(withIdentifier: model.cellIdentifier) as! HCBaseListCell)
        cell.model = model
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 2 || indexPath.row == 3 {
            didSelected?(indexPath)
        }
        
        endEditing(true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        endEditing(true)
    }
}
