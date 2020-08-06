//
//  TYListMenuView.swift
//  HuChuangApp
//
//  Created by yintao on 2019/11/28.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit

enum TYListMenuViewType: Int {
    case none = 0
    case peoples = 1
    case price = 2
    case filiter = 3
    case city = 4
}

class TYListMenuView: UIView {

    private var collectionView: UICollectionView!
    private var sepLine: UIView!
    
    private var datasource: [TYListMenuModel] = []
    private var selectedIdx: Int = 0
    public var selectedCallBack: ((TYListMenuViewType)->())?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupUI()
    }
    
    public func setData(listData: [TYListMenuModel], selectedIdx: Int = 0) {
        self.selectedIdx = selectedIdx
        datasource = listData
        collectionView.reloadData()
    }
    
    // 选择城市修改标题
    public func cityChange(title: String) {
        if datasource.count > 0 {
            datasource[0].title = title
            collectionView.reloadData()
        }
    }
        
    private func setupUI() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        addSubview(collectionView)
        
        collectionView.register(TYListMenuCell.self, forCellWithReuseIdentifier: TYListMenuCell_identifier)
        
        sepLine = UIView()
        sepLine.backgroundColor = RGB(249, 249, 249)
        addSubview(sepLine)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        collectionView.frame = bounds
        sepLine.frame = .init(x: 0, y: height - 1, width: width, height: 1)
    }
}

extension TYListMenuView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TYListMenuCell_identifier, for: indexPath) as! TYListMenuCell
        cell.model = datasource[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let model = datasource[indexPath.row]
        if model.isAutoWidth {
            return .init(width: width / CGFloat(datasource.count), height: height)
        }
        
        let w = model.titleImage == nil ? (model.titleWidth + model.margin * 2) : (model.titleWidth + model.margin * 2 + model.iconMargin + model.titleImage!.size.width)
        return .init(width: w, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 1 || indexPath.row == 2 {
            let resetIdx = indexPath.row == 1 ? 2 : 1
            datasource[resetIdx].isSelected = nil
            datasource[indexPath.row].didClicked()
            selectedCallBack?(TYListMenuViewType(rawValue: indexPath.row)!)
        }else {
            datasource[indexPath.row].didClicked()
            if indexPath.row == 0 {
                selectedCallBack?(.city)
            }else if indexPath.row == 3 {
                selectedCallBack?(.filiter)
            }
        }
        
//        if indexPath.row != selectedIdx {
//            datasource[selectedIdx].didClicked(true)
//            datasource[indexPath.row].didClicked(false)
//
//            selectedIdx = indexPath.row
//        }else {
//            datasource[indexPath.row].didClicked(false)
//        }
        
        collectionView.reloadData()
    }
}
