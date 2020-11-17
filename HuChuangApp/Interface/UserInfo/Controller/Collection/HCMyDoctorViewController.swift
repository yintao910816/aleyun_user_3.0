//
//  HCMyDoctorViewController.swift
//  HuChuangApp
//
//  Created by yintao on 2020/8/21.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCMyDoctorViewController: HCSlideItemController {
    
    private var viewModel: HCCollectionDoctorViewModel!
    private var collectionView: UICollectionView!

    public var cellDidSelected: ((HCDoctorListItemModel)->())?
    
    override func setupUI() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: view.width, height: HCCollectionDoctorListCell_height)
        layout.sectionInset = .zero
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collectionView = UICollectionView.init(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = view.backgroundColor
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        view.addSubview(collectionView)
        
        collectionView.register(HCCollectionDoctorListCell.self,
                                forCellWithReuseIdentifier: HCCollectionDoctorListCell_identifier)
    }
    
    override func rxBind() {
        viewModel = HCCollectionDoctorViewModel()
        collectionView.prepare(viewModel, isAddNoMoreContent: true)
        
        viewModel.datasource.asDriver()
            .drive(collectionView.rx.items(cellIdentifier: HCCollectionDoctorListCell_identifier, cellType: HCCollectionDoctorListCell.self)) { _, model, cell in
                cell.model = model
            }
            .disposed(by: disposeBag)
                
        collectionView.rx.modelSelected(HCDoctorListItemModel.self)
            .subscribe(onNext: { [unowned self] in
                self.cellDidSelected?($0)
            })
            .disposed(by: disposeBag)
        
        collectionView.headerRefreshing()
    }
}
