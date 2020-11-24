//
//  HCHospitalListContainer.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/26.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCHospitalListContainer: UIView {

    private var searchBar: TYSearchBar!
    private var slideMenu: TYSlideMenu!
    public var tableView: UITableView!
    
    public var menuSelect: ((Int)->())?
    public var beginSearch: ((String)->())?
    public var cellDidSelected: ((HCHospitalListItemModel)->())?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var menuItems: [TYSlideItemModel] = [] {
        didSet {
            slideMenu.datasource = menuItems
        }
    }
    
    public var hospitalDatas: [HCHospitalListItemModel] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        searchBar.frame = .init(x: 0, y: 10, width: width, height: 45)
        slideMenu.frame = .init(x: 0, y: searchBar.frame.maxY + 10, width: width, height: 50)
        tableView.frame = .init(x: 0, y: slideMenu.frame.maxY, width: width, height: height - slideMenu.frame.maxY)
    }
}

extension HCHospitalListContainer {
    
    private func initUI() {
        searchBar = TYSearchBar()
        searchBar.coverButtonEnable = false
        searchBar.backgroundColor = .white
        searchBar.viewConfig = TYSearchBarConfig.createSZZX()
        searchBar.beginSearch = { [weak self] in self?.beginSearch?($0) }

        slideMenu = TYSlideMenu()
        slideMenu.menuSelect = { [weak self] in self?.menuSelect?($0) }
        
        tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        
        addSubview(slideMenu)
        addSubview(tableView)
        addSubview(searchBar)
        
        tableView.register(HCHospitalListCell.self, forCellReuseIdentifier: HCHospitalListCell_identifier)
    }
}

extension HCHospitalListContainer: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hospitalDatas.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return HCHospitalListCell_height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HCHospitalListCell_identifier) as! HCHospitalListCell
        cell.model = hospitalDatas[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        cellDidSelected?(hospitalDatas[indexPath.row])
    }
}
