//
//  HCHomeViewController.swift
//  HuChuangApp
//
//  Created by sw on 02/02/2019.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit
import RxDataSources
import RxCocoa

class HCHomeViewController: BaseViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private var viewModel: HomeViewModel!
    
    private var searchBar: TYSearchBar!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
        if viewModel != nil { viewModel.refreshUnreadPublish.onNext(Void()) }
    }
    
    override func setupUI() {
        if #available(iOS 11, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        }
        
        searchBar = TYSearchBar.init(frame: .init(x: 0, y: 0, width: view.width, height: TYSearchBar.baseHeight))
        searchBar.searchPlaceholder = "搜索"
        searchBar.rightItemIcon = "nav_notice"
        view.addSubview(searchBar)
        
        searchBar.tapInputCallBack = { [unowned self] in
            self.navigationController?.pushViewController(HCSearchViewController(), animated: true)
        }
        
        searchBar.rightItemTapBack = {
            HCHelper.pushLocalH5(type: .noticeAndMessage)
        }
        
        collectionView.register(HCHomeCollectionHeaderReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: HCHomeCollectionHeaderReusableView_identifier)
        collectionView.register(HCArticleCell.self, forCellWithReuseIdentifier: HCArticleCell_identifier)

        let layout = UICollectionViewFlowLayout.init()
        layout.sectionInset = .zero
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collectionView.collectionViewLayout = layout
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func rxBind() {
        viewModel = HomeViewModel()
                                
        collectionView.prepare(viewModel)
                
        viewModel.refreshCollectionView
            .subscribe(onNext: { [weak self] in
                self?.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
        
        collectionView.rx.contentOffset.asDriver()
            .drive(onNext: { [unowned self] offset in
                let alph = 1 - offset.y / self.searchBar.height
                self.searchBar.alpha = alph < 0 ? 0 : alph
            })
            .disposed(by: disposeBag)
        
        collectionView.headerRefreshing()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if #available(iOS 11.0, *) {
            searchBar.frame = .init(x: 0, y: 0, width: view.width, height: TYSearchBar.baseHeight + view.safeAreaInsets.top)
            searchBar.safeArea = view.safeAreaInsets
        } else {
            searchBar.frame = .init(x: 0, y: 0, width: view.width, height: TYSearchBar.baseHeight + 20)
            searchBar.safeArea = .init(top: 20, left: 0, bottom: 0, right: 0)
        }
    }
}

extension HCHomeViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.width, height: HCArticleCell_height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch section {
        case 0:
            return .init(width: view.width, height: 374)
        default:
            return .zero
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.articleModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HCArticleCell_identifier, for: indexPath) as! HCArticleCell
        cell.model = viewModel.articleModels[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            switch indexPath.section {
            case 0:
                let header = (collectionView.dequeueReusableSupplementaryView(ofKind:  UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: HCHomeCollectionHeaderReusableView_identifier,
                for: indexPath) as! HCHomeCollectionHeaderReusableView)
                
                header.model = viewModel.pregnancyProbabilityData
                
                viewModel.bannerModelObser.asObservable()
                    .bind(to: header.bannerObser)
                    .disposed(by: disposeBag)
                
                header.clickedMoreCallBack = {
                    NotificationCenter.default.post(name: NotificationName.UILogic.gotoClassRoom, object: nil)
                }
                
                header.gotoPageHomeCallBack = { [weak self] in
                    self?.viewModel.gotoPageHomeSubject.onNext(Void())
                }
                
                header.gotoRecordCallBack = { 
                    NotificationCenter.default.post(name: NotificationName.UILogic.gotoRecord, object: nil)
                }

                return header
            default:
                return UICollectionReusableView()
            }
        }
        
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let ctrl = HCArticleDetailViewController()
        ctrl.prepare(parameters: HCArticleDetailViewController.preprare(model: viewModel.articleModels[indexPath.row]))
        navigationController?.pushViewController(ctrl, animated: true)
    }
}
