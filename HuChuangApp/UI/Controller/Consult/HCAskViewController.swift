//
//  HCAskViewController.swift
//  HuChuangApp
//
//  Created by yintao on 2019/11/24.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit

class HCAskViewController: BaseViewController {

    @IBOutlet weak var submitOutlet: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var navHeightCns: NSLayoutConstraint!
    
    private var viewModel: HCAskViewModel!
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func setupUI() {
        navHeightCns.constant += LayoutSize.fitTopArea
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = .init(top: 15, left: 15, bottom: 0, right: 15)
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 15
        
        let size = (PPScreenW - 15 * 4 - 1) / 3.0
        layout.itemSize = .init(width: size , height: size)
        
        collectionView.collectionViewLayout = layout
        
        collectionView.register(HCAskCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: HCAskCollectionReusableView_identifier)
        collectionView.register(HCAskCell.self, forCellWithReuseIdentifier: HCAskCell_identifier)
    }
    
    override func rxBind() {
        viewModel = HCAskViewModel()
        
        viewModel.reloadUISubject
            .subscribe(onNext: { [weak self] _ in
                self?.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
        
        viewModel.reloadSubject.onNext(Void())
    }
  
    @IBAction func actions(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension HCAskViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HCAskCell_identifier, for: indexPath) as! HCAskCell
        cell.model = viewModel.modelForItemAt(indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HCAskCollectionReusableView_identifier, for: indexPath) as! HCAskCollectionReusableView
            header.addArchivesCallBack = { [weak self] in
                self?.performSegue(withIdentifier: "healthyInfoSegue", sender: nil)
            }
            return header
        }
        
        return UICollectionReusableView()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: collectionView.width, height: HCAskCollectionReusableView_height)
    }

}
