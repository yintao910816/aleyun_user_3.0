//
//  HCMyInServerContainer.swift
//  HuChuangApp
//
//  Created by yintao on 2020/11/26.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCMyInServerContainer: UIView {

    private var collectionView: UICollectionView!
    private var emptyView: HCListEmptyView!

    public var excuteMyServerAction: ((HCPersonalProgressServiceModel)->())?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        collectionView = UICollectionView.init(frame: bounds, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = backgroundColor
        collectionView.dataSource = self
        collectionView.delegate = self
        addSubview(collectionView)
        
        emptyView = HCListEmptyView(frame: bounds)
        
        collectionView.register(HCMineInServerCell.self, forCellWithReuseIdentifier: HCMineInServerCell_identifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var progressServices: [HCPersonalProgressServiceModel] = [] {
        didSet {
            if progressServices.count == 0 {
                if emptyView.superview == nil {
                    addSubview(emptyView)
                }
            }else {
                if emptyView.superview != nil {
                    emptyView.removeFromSuperview()
                }
            }
            
            collectionView.reloadData()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        collectionView.frame = bounds
        emptyView.frame = bounds
    }

}

extension HCMyInServerContainer: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return progressServices.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HCMineInServerCell_identifier, for: indexPath)
        (cell as? HCMineInServerCell)?.model = progressServices[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: width, height: HCMineInServerCell_height)
    }
            
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        excuteMyServerAction?((progressServices[indexPath.row]))
    }
}

