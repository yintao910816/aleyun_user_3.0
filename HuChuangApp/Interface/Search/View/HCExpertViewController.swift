//
//  HCExpertViewController.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/27.
//  Copyright © 2020 sw. All rights reserved.
//  搜索 - 专家

import UIKit

import RxDataSources

class HCExpertViewController: HCSlideItemController {

    public var collectionView: UICollectionView!
    
    public var viewModel: HCDoctorSearchViewModel!

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
        view.addSubview(collectionView)
        
        collectionView.register(HCDoctorListCell.self, forCellWithReuseIdentifier: HCDoctorListCell_identifier)
    }
    
    override func rxBind() {
        viewModel = HCDoctorSearchViewModel()
        
        collectionView.prepare(viewModel, showFooter: true, showHeader: true, isAddNoMoreContent: true)
                
        viewModel.datasource.asDriver()
            .drive(collectionView.rx.items(cellIdentifier: HCDoctorListCell_identifier, cellType: HCDoctorListCell.self)) { _, model, cell in
                cell.model = model
            }
            .disposed(by: disposeBag)
        
        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
        
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView.frame = view.bounds
    }
}

extension HCExpertViewController: UICollectionViewDelegateFlowLayout {
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.width, height: viewModel.datasource.value[indexPath.row].getCellHeight)
    }
}
