//
//  HCAreaSelectedContainer.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/25.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCAreaSelectedContainer: UIView {

    private var provinceData: [HCAreaProvinceModel] = []
    private var cityData: [String: [HCAreaCityModel]] = [:]
    private var currentProvinceId: String = ""
    
    private var contentView: UIView!
    private var provinceTable: UITableView!
    private var cityTable: UITableView!
    
    public var provinceClicked: ((HCAreaProvinceModel)->())?
    public var cityClicked: (((HCAreaProvinceModel, HCAreaCityModel))->())?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func reloadProvince(data: [HCAreaProvinceModel]) {
        provinceData.append(contentsOf: data)
        currentProvinceId = data.count > 0 ? data[0].id : ""
        provinceTable.reloadData()
    }
    
    public func reloadCity(id: String, data: [HCAreaCityModel]) {
        cityData[id] = data
        cityTable.reloadData()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = bounds
        provinceTable.frame = .init(x: 0, y: 0, width: contentView.width / 3, height: contentView.height)
        cityTable.frame = .init(x: provinceTable.frame.maxX, y: 0,
                                width: contentView.width - provinceTable.width,
                                height: contentView.height)
    }
}

extension HCAreaSelectedContainer {
    
    private func initUI() {
        backgroundColor = RGB(10, 10, 10, 0.3)

        contentView = UIView()
        contentView.backgroundColor = .white
        
        provinceTable = UITableView.init(frame: .zero, style: .plain)
        provinceTable.backgroundColor = RGB(247, 247, 247)
        provinceTable.separatorStyle = .none
        provinceTable.dataSource = self
        provinceTable.delegate = self
        provinceTable.rowHeight = HCAreaCell_height
        provinceTable.showsVerticalScrollIndicator = false

        cityTable = UITableView.init(frame: .zero, style: .plain)
        cityTable.backgroundColor = .white
        cityTable.separatorStyle = .none
        cityTable.dataSource = self
        cityTable.delegate = self
        cityTable.rowHeight = HCAreaCell_height
        cityTable.showsVerticalScrollIndicator = false

        addSubview(contentView)
        contentView.addSubview(provinceTable)
        contentView.addSubview(cityTable)
        
        provinceTable.register(HCAreaCell.self, forCellReuseIdentifier: HCAreaCell_identifier)
        cityTable.register(HCAreaCell.self, forCellReuseIdentifier: HCAreaCell_identifier)
    }
    
    public func excuteAnimotion(_ animotion: Bool = true, complement:@escaping ((Bool)->())) {
        if animotion {
            UIView.animate(withDuration: 0.25, animations: {
                var rect = self.contentView.frame
                if self.contentView.y == 0 {
                    rect.origin.y = -self.contentView.height
                    self.contentView.frame = rect
                }else {
                    rect.origin.y = 0
                    self.contentView.frame = rect
                }
            }) { [weak self] flag in
                if flag {
                    complement(self?.contentView.y != 0)
                }
            }
        }else {
            var rect = self.contentView.frame
            if self.contentView.y == 0 {
                rect.origin.y = -self.contentView.height
                self.contentView.frame = rect
            }else {
                rect.origin.y = 0
                self.contentView.frame = rect
            }

            complement(contentView.y != 0)
        }
    }
}

extension HCAreaSelectedContainer: UITableViewDelegate, UITableViewDataSource {
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == provinceTable {
            return provinceData.count
        }
        return cityData[currentProvinceId]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HCAreaCell_identifier) as! HCAreaCell
        var title: String = ""
        var backgroundColor: UIColor? = nil
        if tableView == provinceTable {
            title = provinceData[indexPath.row].name
            backgroundColor = provinceData[indexPath.row].id == currentProvinceId ? .white : .clear
        }else {
            title = cityData[currentProvinceId]?[indexPath.row].name ?? ""
        }
        let titleColor = tableView == provinceTable ? RGB(51, 51, 51) : RGB(78, 78, 78)
        cell.configContent(title: title, titleColor: titleColor, backgroundColor: backgroundColor)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if tableView == provinceTable {
            currentProvinceId = provinceData[indexPath.row].id
            provinceTable.reloadData()
            provinceClicked?(provinceData[indexPath.row])
        }else {
            if let provinceModel = provinceData.first(where: { [weak self] in $0.id == self?.currentProvinceId }), let cityModel = cityData[currentProvinceId]?[indexPath.row] {
                
                let post = HCAreaCityModel()
                post.name = cityModel.name
                if cityModel.name == "全国" {
                    post.id = ""
                }else if let hotAreaModel = cityModel as? HCHotAreaCityModel {
                    post.id = hotAreaModel.code
                }else {
                    post.id = cityModel.id
                }
                cityClicked?((provinceModel, post))
            }
        }
    }
}

