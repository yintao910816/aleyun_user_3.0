//
//  HCCourseViewController.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/27.
//  Copyright © 2020 sw. All rights reserved.
//  搜索 - 课程

import UIKit

class HCCourseViewController: HCSlideItemController {
   
    public var collectionView: UICollectionView!

    public var viewModel: HCCourseSearchViewModel!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if viewModel.datasource.value.count == 0 {
            viewModel.requestData(true)
        }
    }

    private func initUI() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.sectionInset = .init(top: 0, left: 0, bottom: 0, right: 0)

        collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        view.addSubview(collectionView)
        
        collectionView.register(HCCourseCell.self, forCellWithReuseIdentifier: HCCourseCell_identifier)
    }

    override func rxBind() {
        viewModel = HCCourseSearchViewModel()
        
        collectionView.prepare(viewModel, showFooter: true, showHeader: true, isAddNoMoreContent: true)
                
        viewModel.datasource.asDriver()
            .drive(collectionView.rx.items(cellIdentifier: HCCourseCell_identifier, cellType: HCCourseCell.self)) { _, model, cell in
                cell.courseModel = model
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

extension HCCourseViewController: UICollectionViewDelegateFlowLayout {
            
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.width, height: HCCourseCell_height)
    }
        
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
////        cellDidselected?(datasource[indexPath.row])
//    }
}
