//
//  HCNavBarOrderRecordModeView.swift
//  HuChuangApp
//
//  Created by yintao on 2020/7/21.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCNavBarOrderRecordModeView: HCNavBarFloatView {
    
    private var contentView: UIView!
    private var collectionView: UICollectionView!
    private var tapGes: UITapGestureRecognizer!
    
    private var datasource: [HCNavBarOrderRecordModel] = []
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        datasource = HCNavBarOrderRecordModel.createDatas()
        
        contentView = UIView()
        contentView.clipsToBounds = true
        contentView.backgroundColor = RGB(0, 0, 0, 0.7)
        
        let layout = TYSearchRecordLayout()
        layout.layoutDelegate = self
        
        collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(HCNavBarOrderRecordCell.self,
                                forCellWithReuseIdentifier: HCNavBarOrderRecordCell_identifier)
        
        addSubview(contentView)
        contentView.addSubview(collectionView)
        
        tapGes = UITapGestureRecognizer.init(target: self, action: #selector(tapAction))
        tapGes.delegate = self
        contentView.addGestureRecognizer(tapGes)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @objc private func tapAction() {
        viewPresent()
    }
    
    override func viewDisAppear() {
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            self?.collectionView.transform = .init(translationX: 0, y: -(self?.collectionView.height ?? 0))
            self?.alpha = 0
        }) { [weak self] in
            if $0 {
                self?.removeFromSuperview()
            }
        }
    }
    
    public func viewPresent(with animotion: Bool = true) {
        if superview == nil {
            UIApplication.shared.keyWindow?.addSubview(self)
            
            if animotion {
                UIView.animate(withDuration: 0.25) { [weak self] in
                    self?.collectionView.transform = .identity
                    self?.alpha = 1
                }
            }else {
                collectionView.transform = .identity
                alpha = 1
            }
        }else {
            if animotion {
                UIView.animate(withDuration: 0.25, animations: { [weak self] in
                    self?.collectionView.transform = .init(translationX: 0, y: -(self?.collectionView.height ?? 0))
                    self?.alpha = 0
                }) { [weak self] in
                    if $0 {
                        self?.removeFromSuperview()
                    }
                }
            }else {
                collectionView.transform = .init(translationX: 0, y: collectionView.height)
                alpha = 0
                removeFromSuperview()
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = bounds
        collectionView.frame = .init(x: 0, y: 0, width: width, height: 117)
    }
}

extension HCNavBarOrderRecordModeView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: (width - 50 - 1) / 3.0, height: 40)
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: HCNavBarOrderRecordCell_identifier, for: indexPath) as! HCNavBarOrderRecordCell)
        cell.model = datasource[indexPath.row]
        return cell
    }
        
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
}

extension HCNavBarOrderRecordModeView: TYSearchRecordLayoutDelegate {
    
    func itemSize(for indexPath: IndexPath, layout: TYSearchRecordLayout) -> CGSize {
        return .init(width: (width - 50 - 1) / 3.0, height: 40)
    }
    
    func referenceSize(forHeader insSection: Int, layout: TYSearchRecordLayout) -> CGSize {
        return .zero
    }
    
    func minimumLineSpacing(in section: Int, layout: TYSearchRecordLayout) -> CGFloat {
        return 7
    }
    
    func minimumInterSpacing(in section: Int, layout: TYSearchRecordLayout) -> CGFloat {
        return 10
    }
    
    func sectionInset(in section: Int, layout: TYSearchRecordLayout) -> UIEdgeInsets {
        return .init(top: 15, left: 15, bottom: 0, right: 15)
    }
    
}

extension HCNavBarOrderRecordModeView: UIGestureRecognizerDelegate {
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return !collectionView.frame.contains(gestureRecognizer.location(in: contentView))
    }
}
