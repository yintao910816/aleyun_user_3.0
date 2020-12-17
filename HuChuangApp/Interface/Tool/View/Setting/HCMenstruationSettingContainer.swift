//
//  HCMenstruationSettingContainer.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/14.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCMenstruationSettingContainer: UIView {

    private var tableView: UITableView!
    private var remindLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initUI()
    }

    public var listData: [HCMenstruationSettingSection] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        tableView.frame = bounds
        remindLabel.frame = .init(x: 0, y: height - 50, width: width, height: 50)
    }
}

extension HCMenstruationSettingContainer {
    
    private func initUI() {
        backgroundColor = .groupTableViewBackground
        
        tableView = UITableView.init(frame: bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .groupTableViewBackground
        
        remindLabel = UILabel()
        remindLabel.textColor = RGB(178, 178, 178)
        remindLabel.font = .font(fontSize: 12)
        remindLabel.textAlignment = .center
        remindLabel.backgroundColor = .clear
        remindLabel.text = "您所填写的生理信息仅用于经期记录、分析及预测"
                
        tableView.register(HCListSwitchCell.self, forCellReuseIdentifier: HCListSwitchCell_identifier)
        tableView.register(HCListDetailInputCell.self, forCellReuseIdentifier: HCListDetailInputCell_identifier)

        addSubview(tableView)
        addSubview(remindLabel)
    }
}

extension HCMenstruationSettingContainer: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return listData[section].sectionHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let contentView = UIView()
        contentView.backgroundColor = .groupTableViewBackground
        
        let label = UILabel.init(frame: .init(x: 15, y: 25, width: tableView.width - 30, height: 22))
        label.backgroundColor = .clear
        label.text = listData[section].sectinoTitle
        label.textColor = RGB(178, 178, 178)
        label.font = .font(fontSize: 16)
        contentView.addSubview(label)
        
        return contentView
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return listData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listData[section].itemDatas.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return listData[indexPath.section].itemDatas[indexPath.row].cellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = listData[indexPath.section].itemDatas[indexPath.row]
        let cell = (tableView.dequeueReusableCell(withIdentifier: model.cellIdentifier) as! HCBaseListCell)
        cell.model = model
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

//MARK:
//MARK: Model
class HCMenstruationSettingSection {
    var sectinoTitle: String = ""
    var sectionHeight: CGFloat = 25 + 22 + 10
    
    var itemDatas: [HCListCellItem] = []
    
    init(sectinoTitle: String, sectionHeight: CGFloat = 57, itemDatas: [HCListCellItem]) {
        self.sectinoTitle = sectinoTitle
        self.sectionHeight = sectionHeight
        self.itemDatas = itemDatas
    }
}
