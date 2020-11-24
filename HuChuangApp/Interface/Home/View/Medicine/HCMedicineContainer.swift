//
//  HCTestTubeContainer.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/26.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCMedicineContainer: UIView {

    private var searchBar: TYSearchBar!
    public var collectionView: UICollectionView!
    
    public var cellDidSelected: ((HCMedicineItemModel) ->())?
    public var beginSearch: ((String)->())?

    public var datasource: [HCMedicineItemModel] = [] {
        didSet {
            collectionView.reloadData()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        searchBar.frame = .init(x: 0, y: 0, width: width, height: 55)
        collectionView.frame = .init(x: 0, y: searchBar.frame.maxY, width: width, height: height - searchBar.frame.maxY)
    }
}

extension HCMedicineContainer {
    
    private func initUI() {
        backgroundColor = RGB(245, 245, 245)
        
        searchBar = TYSearchBar()
        searchBar.coverButtonEnable = false
        searchBar.viewConfig = TYSearchBarConfig.createYPBK()
        searchBar.backgroundColor = .white
        searchBar.beginSearch = { [weak self] in self?.beginSearch?($0) }

        collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = backgroundColor
        collectionView.dataSource = self
        collectionView.delegate = self
        
        addSubview(collectionView)        
        addSubview(searchBar)
        
        collectionView.register(HCMenuItemCell.self, forCellWithReuseIdentifier: HCMenuItemCell_identifier)
    }
}

extension HCMedicineContainer: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HCMenuItemCell_identifier, for: indexPath) as! HCMenuItemCell
        cell.medicineItem = datasource[indexPath.row]
        cell.titleFont = .font(fontSize: 17, fontName: .PingFSemibold)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: (width - 1 - 15 * 2 - 10 * 2) / 3.0, height: 140)
    }
                
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 15, left: 15, bottom: 0, right: 15)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        cellDidSelected?(datasource[indexPath.row])
    }
}
