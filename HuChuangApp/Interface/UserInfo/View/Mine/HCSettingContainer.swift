//
//  HCSettingContainer.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/19.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCSettingContainer: UIView {

    private var tableView: UITableView!
    
    public var didSelected: ((HCListCellItem)->())?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public var listData: [HCListCellItem] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        tableView.frame = bounds
        
    }

    private func initUI() {
        backgroundColor = RGB(243, 243, 243)
        
        let header = HCSettingHeader.init(frame: .init(x: 0, y: 0, width: PPScreenW, height: 140))
        header.backgroundColor = RGB(243, 243, 243)
        
        tableView = UITableView.init(frame: bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.tableHeaderView = header
        tableView.backgroundColor = RGB(243, 243, 243)
        
        tableView.register(HCListDetailCell.self, forCellReuseIdentifier: HCListDetailCell_identifier)

        addSubview(tableView)
    }
}

extension HCSettingContainer: UITableViewDelegate, UITableViewDataSource {
        
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
        
        didSelected?(listData[indexPath.row])
    }

}

class HCSettingHeader: UIView {
    
    private var appIcon: UIImageView!
    private var appVersionLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        appIcon.frame = .init(x: (width - 50) / 2.0, y: 30, width: 50, height: 50)
        appVersionLabel.frame = .init(x: 30, y: appIcon.frame.maxY + 10, width: width - 60, height: 20)
    }
    
    private func initUI() {
        appIcon = UIImageView(image: UIImage(named: "app_icon"))
        appIcon.layer.cornerRadius = 3
        appIcon.clipsToBounds = true
        
        appVersionLabel = UILabel()
        appVersionLabel.text = "爱乐孕\(Bundle.main.version)"
        appVersionLabel.font = .font(fontSize: 15)
        appVersionLabel.textColor = RGB(51, 51, 51)
        appVersionLabel.textAlignment = .center
        
        addSubview(appIcon)
        addSubview(appVersionLabel)
    }
}
