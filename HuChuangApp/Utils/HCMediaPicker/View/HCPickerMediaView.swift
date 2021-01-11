//
//  HCPhotoPickerView.swift
//  HuChuangApp
//
//  Created by yintao on 2020/11/5.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCPickerMediaView: UIView {

    private var collectionView: UICollectionView!
    
    public var selectedImage:((UIImage)->())?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView.init(frame: frame, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        addSubview(collectionView)
        
        collectionView.register(HCPickerMediaCell.self, forCellWithReuseIdentifier: HCPickerMediaCell_identifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public var mediaDatas: [HCAsset] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        collectionView.frame = bounds
    }
}

extension HCPickerMediaView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mediaDatas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HCPickerMediaCell_identifier, for: indexPath)
        (cell as? HCPickerMediaCell)?.asset = (mediaDatas[indexPath.row] as! HCPhotoAsset)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 100, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let image = mediaDatas[indexPath.row].image {
            selectedImage?(image)
        }
    }
}

//MARK: cell
fileprivate let HCPickerMediaCell_identifier = "HCPickerMediaCell"
class HCPickerMediaCell: UICollectionViewCell {
    
    private var imageV: HCAssetImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageV = HCAssetImageView()
        imageV.contentMode = .scaleAspectFill
        imageV.clipsToBounds = true
        addSubview(imageV)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var asset: HCPhotoAsset! {
        didSet {
            imageV.image = nil
            imageV.asset = asset
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageV.frame = bounds
    }
}
