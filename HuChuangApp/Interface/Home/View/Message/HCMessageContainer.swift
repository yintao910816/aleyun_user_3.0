//
//  HCAccountSettingContainer.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/13.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCMessageContainer: UIView {
    
    private var datasource: [HCMessageItemModel] = []
    public var collectionView: UICollectionView!
    
    public var didSelected: ((HCMessageItemModel)->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func reloadData(data: [HCMessageItemModel]) {
        datasource = data
        collectionView.reloadData()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        collectionView.frame = bounds
    }
}

extension HCMessageContainer {
    
    private func initUI() {
        backgroundColor = RGB(243, 243, 243)
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = .init(top: 10, left: 10, bottom: 0, right: 10)
        layout.minimumLineSpacing = 10

        collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = backgroundColor
        collectionView.dataSource = self
        collectionView.delegate = self
        addSubview(collectionView)
        
        collectionView.register(HCMessageCell.self, forCellWithReuseIdentifier: HCMessageCell_identifier)
    }
}

extension HCMessageContainer: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HCMessageCell_identifier, for: indexPath)
        (cell as? HCMessageCell)?.model = datasource[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: width - 20, height: HCMessageCell_height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
