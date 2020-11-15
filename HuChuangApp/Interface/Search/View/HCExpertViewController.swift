//
//  HCExpertViewController.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/27.
//  Copyright © 2020 sw. All rights reserved.
//  搜索 - 专家

import UIKit

class HCExpertViewController: HCSlideItemController {

    private var collectionView: UICollectionView!
    
    private var datasource: [HCDoctorListItemModel] = []
    
    public var cellDidselected: ((HCDoctorListItemModel)->())?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initUI() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.sectionInset = .init(top: 0, left: 0, bottom: 0, right: 0)

        collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        
        collectionView.register(HCDoctorListCell.self, forCellWithReuseIdentifier: HCDoctorListCell_identifier)
    }

    override func reloadData(data: Any?) {
        if let source = data as? [HCDoctorListItemModel] {
            datasource = source
            collectionView.reloadData()
        }
    }
    
    override func bind<T>(viewModel: RefreshVM<T>, canRefresh: Bool, canLoadMore: Bool, isAddNoMoreContent: Bool) {
        collectionView.prepare(viewModel, showFooter: canLoadMore, showHeader: canRefresh, isAddNoMoreContent: isAddNoMoreContent)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView.frame = view.bounds
    }
}

extension HCExpertViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.width, height: datasource[indexPath.row].getCellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HCDoctorListCell_identifier, for: indexPath) as! HCDoctorListCell
        cell.model = datasource[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        cellDidselected?(datasource[indexPath.row])
    }
}
