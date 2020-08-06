//
//  HCHomeGoodNewsCell.swift
//  HuChuangApp
//
//  Created by sw on 2019/10/2.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit

public let HCHomeGoodNewsCell_identifier = "HCHomeGoodNewsCell"

class HCHomeGoodNewsCell: UICollectionViewCell {

    @IBOutlet private weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        let layout = UICollectionViewFlowLayout()
        layout.itemSize = HCHomeGoodNewsCellItemCell.itemSize
        layout.sectionInset = .init(top: 20, left: 15, bottom: 30, right: 15)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        collectionView.collectionViewLayout = layout
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib.init(nibName: "HCHomeGoodNewsCellItemCell", bundle: Bundle.main),
                                forCellWithReuseIdentifier: HCHomeGoodNewsCellItemCell_identifier)
    }

}

extension HCHomeGoodNewsCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: HCHomeGoodNewsCellItemCell_identifier, for: indexPath) as! HCHomeGoodNewsCellItemCell)
        return cell
    }
    
}
