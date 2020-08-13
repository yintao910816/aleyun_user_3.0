//
//  HCHomeViewContainer.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/8.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCHomeViewContainer: UIView {

    private var collectionView: UICollectionView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initUI()
        
        collectionView.reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        collectionView.frame = bounds
    }

}

extension HCHomeViewContainer {
    
    private func initUI() {
        backgroundColor = .white
        
        collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = backgroundColor
        collectionView.dataSource = self
        collectionView.delegate = self
        addSubview(collectionView)
        
        collectionView.register(HCHomeHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HCHomeHeaderReusableView_identifier)
        collectionView.register(HCNewsReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HCNewsReusableView_identifier)

        collectionView.register(HCMenuItemShadowCell.self, forCellWithReuseIdentifier: HCMenuItemShadowCell_identifier)
        collectionView.register(HCMenuHorizontalCell.self, forCellWithReuseIdentifier: HCMenuHorizontalCell_identifier)
    }

}

extension HCHomeViewContainer: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 4
        case 1:
            return 6
        case 2:
            return 0
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: UICollectionViewCell!
        if indexPath.section == 0 {
            let modes: [HCMenuItemShadowCellMode] = [.testTubeEncyclopedia, .reproductiveCenter, .testTubeDiary, .drugEncyclopedia]
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: HCMenuItemShadowCell_identifier, for: indexPath)
            (cell as? HCMenuItemShadowCell)?.mode = modes[indexPath.row]
        }else if indexPath.section == 1 {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: HCMenuHorizontalCell_identifier, for: indexPath)
        }else if indexPath.section == 2 {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: HCMineEmptyHeathyDataCell_identifier, for: indexPath)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return .init(width: (width - 15 * 5) / 4.0, height: HCMenuItemShadowCell_height)
        }else if indexPath.section == 1 {
            return .init(width: (width - 20 * 2 - 10 * 2 - 1) / 3.0, height: HCMenuHorizontalCell_height)
        }else if indexPath.section == 2 {
            return .init(width: HCMineEmptyHeathyDataCell_height, height: HCMineEmptyHeathyDataCell_height)
        }
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            var header = UICollectionReusableView()
            if indexPath.section == 0 {
                header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HCHomeHeaderReusableView_identifier, for: indexPath)
            }else if indexPath.section == 2 {
                header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HCNewsReusableView_identifier, for: indexPath)
            }
            return header
        }

        return UICollectionReusableView()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch section {
        case 0:
            return .init(width: width, height: HCHomeHeaderReusableView_height)
        case 2:
            return .init(width: width, height: HCNewsReusableView_height)
        default:
            return .zero
        }
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
//        return section < 2 ? .init(width: width, height: 5) : .zero
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch section {
        case 0:
            return .init(top: 20, left: 15, bottom: 0, right: 15)
        case 1:
            return .init(top: 20, left: 20, bottom: 0, right: 20)
        case 2:
            return .init(top: 15, left: 20, bottom: 0, right: 15)

        default:
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch section {
        case 1:
            return 10
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        switch section {
        case 0:
            return 15
        case 1:
            return 10
        default:
            return 0
        }
    }

}
