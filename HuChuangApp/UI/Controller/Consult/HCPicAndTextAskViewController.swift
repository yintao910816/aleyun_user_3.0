//
//  HCPicAndTextAskViewController.swift
//  HuChuangApp
//
//  Created by yintao on 2019/12/2.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit

class HCPicAndTextAskViewController: BaseViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var priceOutlet: UILabel!
    
    private var viewModel: HCPicAndTextAskViewModel!
    
    private var model: HCDoctorItemModel!

    override func setupUI() {
        let text = "¥\(model.price)"
        priceOutlet.attributedText = text.attributed(NSMakeRange(0, 1), HC_MAIN_COLOR, .font(fontSize: 11, fontName: .PingFSemibold))
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = .init(top: 15, left: 15, bottom: 35, right: 15)
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 15
        
        let size = (PPScreenW - 15 * 4 - 1) / 3.0
        layout.itemSize = .init(width: size , height: size)
        
        collectionView.collectionViewLayout = layout
        
        collectionView.register(HCAskCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: HCAskCollectionReusableView_identifier)
        collectionView.register(HCPicAndTextAskFooterReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: HCPicAndTextAskFooterReusableView_identifier)
        collectionView.register(HCAskCell.self, forCellWithReuseIdentifier: HCAskCell_identifier)
    }
    
    override func rxBind() {
        viewModel = HCPicAndTextAskViewModel()
        
        viewModel.reloadUISubject
            .subscribe(onNext: { [weak self] _ in
                self?.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
        
        viewModel.reloadSubject.onNext(Void())
    }
    
    override func prepare(parameters: [String : Any]?) {
        model = (parameters!["model"] as! HCDoctorItemModel)
    }
}

extension HCPicAndTextAskViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
   
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
        }else {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: HCPicAndTextAskFooterReusableView_identifier, for: indexPath)
            return footer
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: collectionView.width, height: HCAskCollectionReusableView_height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return HCPicAndTextAskFooterReusableView_size
    }

}
