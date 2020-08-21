//
//  HCCouponContainer.swift
//  HuChuangApp
//
//  Created by yintao on 2020/8/21.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCCouponContainer: UIView {

    private var collectionView: UICollectionView!

    private var bottomView: UIView!
    private var changeStatusButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public var couponDatas: [HCCouponModel]! {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bottomView.frame = .init(x: 0, y: height - 45, width: width, height: 45)
        changeStatusButton.frame = .init(x: (width - 90)/2.0, y: 5, width: 90, height: 30)
        collectionView.frame = .init(x: 0, y: 0, width: width, height: height - 45)
    }
}

extension HCCouponContainer {

    private func initUI() {
        backgroundColor = RGB(243, 243, 243)
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = .init(top: 10, left: 15, bottom: 0, right: 15)
        layout.minimumLineSpacing = 10
        
        collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = backgroundColor
        collectionView.dataSource = self
        collectionView.delegate = self

        bottomView = UIView()
        bottomView.backgroundColor = .clear
        
        changeStatusButton = UIButton()
        changeStatusButton.setTitle("查看不可用卷", for: .normal)
        changeStatusButton.setTitle("查看可用卷", for: .selected)
        changeStatusButton.setTitleColor(RGB(255, 79, 120), for: .normal)
        changeStatusButton.titleLabel?.font = .font(fontSize: 12)

        addSubview(collectionView)
        addSubview(bottomView)
        bottomView.addSubview(changeStatusButton)
        
        collectionView.register(HCCouponCell.self, forCellWithReuseIdentifier: HCCouponCell_identifier)
    }
}

extension HCCouponContainer: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return couponDatas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HCCouponCell_identifier, for: indexPath)
        (cell as? HCCouponCell)?.model = couponDatas[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: width - 30, height: HCCouponCell_height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
