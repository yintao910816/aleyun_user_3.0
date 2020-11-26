//
//  HCServerMsgContainer.swift
//  HuChuangApp
//
//  Created by yintao on 2020/11/26.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class HCServerMsgContainer: UIView {

    private let disposeBag = DisposeBag()
    
    public var tableView: UITableView!
    public let dataSignal = PublishSubject<[HCMessageItemModel]>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = RGB(243, 243, 243)
        
        tableView = UITableView.init(frame: frame, style: .plain)
        tableView.separatorStyle = .none
        tableView.backgroundColor = backgroundColor
        tableView.rowHeight = HCServerMsgCell_height
        addSubview(tableView)
        
        tableView.register(HCServerMsgCell.self, forCellReuseIdentifier: HCServerMsgCell_identifier)
        
        dataSignal
            .bind(to: tableView.rx.items(cellIdentifier: HCServerMsgCell_identifier, cellType: HCServerMsgCell.self)) {
                _, model, cell in
                cell.model = model
            }
            .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        tableView.frame = bounds
    }
}
