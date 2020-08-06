//
//  TYCityFilterView.swift
//  HuChuangApp
//
//  Created by yintao on 2019/12/19.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TYCityFilterView: UIView {

    private var tableView: UITableView!
    
    private let disposeBag = DisposeBag()
    private var titlesIndex: [String] = []
    
    public let datasource = Variable([HCAllCityItemModel]())
    public var didSelectedCallBack: ((HCCityItemModel)->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        setupUI()
        rxBind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        tableView = UITableView.init(frame: .zero, style: .plain)
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.rowHeight = TYCityCell_height
        tableView.delegate = self
        tableView.dataSource = self
        addSubview(tableView)
        
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {

        }
        
        tableView.register(TYCityCell.self, forCellReuseIdentifier: TYCityCell_identifier)
        
        tableView.snp.makeConstraints { $0.edges.equalTo(UIEdgeInsets.zero) }
    }
    
    private func rxBind() {
        datasource.asDriver()
            .drive(onNext: { [weak self] _ in
                self?.dealTitleIndex()
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    private func dealTitleIndex() {
        for item in datasource.value {
            titlesIndex.append(item.key)
        }
    }
}

extension TYCityFilterView {
    
    public func excuteAnimotion(_ animotion: Bool = true) {
        if animotion {
            UIView.animate(withDuration: 0.25) {
                if self.transform.ty == 0 {
                    self.transform = CGAffineTransform.init(translationX: 0, y: -self.height)
                }else {
                    self.transform = CGAffineTransform.identity
                }
            }
        }else {
            if self.transform.ty == 0 {
                self.transform = CGAffineTransform.init(translationX: 0, y: -self.height)
            }else {
                self.transform = CGAffineTransform.identity
            }
        }
    }
}

extension TYCityFilterView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return datasource.value[section].key
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return titlesIndex
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return datasource.value.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.backgroundColor = RGB(249, 249, 249)
        label.textColor = RGB(10, 10, 10)
        label.font = .font(fontSize: 14)
        label.text = "     \(titlesIndex[section])"
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.value[section].list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TYCityCell_identifier) as! TYCityCell
        cell.model = datasource.value[indexPath.section].list[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        didSelectedCallBack?(datasource.value[indexPath.section].list[indexPath.row])
    }
}

public let TYCityCell_identifier = "TYCityCell"
public let TYCityCell_height: CGFloat = 45

class TYCityCell: UITableViewCell {
    
    private var lineView: UIView!
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .white
        
        textLabel?.font = .font(fontSize: 15)
        textLabel?.textColor = RGB(68, 68, 68)
        
        lineView = UIView()
        lineView.backgroundColor = RGB(249, 249, 249)
        contentView.addSubview(lineView)
        
        lineView.snp.makeConstraints {
            $0.left.right.bottom.equalTo(0)
            $0.height.equalTo(1)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var model: HCCityItemModel! {
        didSet {
            self.textLabel?.text = model.name
        }
    }
}
