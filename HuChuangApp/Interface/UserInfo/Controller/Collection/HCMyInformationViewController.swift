//
//  HCMyInformationViewController.swift
//  HuChuangApp
//
//  Created by yintao on 2020/8/21.
//  Copyright © 2020 sw. All rights reserved.
//  搜藏的资讯

import UIKit
import RxSwift
import RxDataSources

class HCMyInformationViewController: HCSlideItemController {

    private var collectionView: UICollectionView!
    private var viewModel: HCCollectionInformationViewModel!
    
    override func setupUI() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: view.width, height: HCRealTimeCell_height)
        layout.sectionInset = .zero
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collectionView = UICollectionView.init(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = view.backgroundColor
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        view.addSubview(collectionView)
        
        collectionView.register(HCRealTimeCell.self, forCellWithReuseIdentifier: HCRealTimeCell_identifier)
    }
    
    override func rxBind() {
        viewModel = HCCollectionInformationViewModel()
        collectionView.prepare(viewModel, isAddNoMoreContent: true)
        
        viewModel.datasource.asDriver()
            .drive(collectionView.rx.items(cellIdentifier: HCRealTimeCell_identifier, cellType: HCRealTimeCell.self)) { _, model, cell in
                cell.model = model
            }
            .disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(HCCmsArticleListModel.self)
            .bind(to: viewModel.articleDetailSignal)
            .disposed(by: disposeBag)

        collectionView.headerRefreshing()
    }
}
