//
//  HCMineViewContainer.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/8.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCMineViewContainer: UIView {

    private var collectionView: UICollectionView!
    
    public var excuteAction: ((HCMineHeaderView.HCMineHeaderAction)->())?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initUI()
        collectionView.reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var model: HCPersonalCenterInfoModel = HCPersonalCenterInfoModel() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    public var userModel: HCUserModel = HCUserModel() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        collectionView.frame = bounds
    }
}

extension HCMineViewContainer {
  
    private func initUI() {
        backgroundColor = .white
        
        collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = backgroundColor
        collectionView.dataSource = self
        collectionView.delegate = self
        addSubview(collectionView)
        
        collectionView.register(HCMineHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HCMineHeaderView_identifier)
        collectionView.register(HCCollectionSectionTitleView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HCCollectionSectionTitleView_identifier)
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "footer")

        collectionView.register(HCMineEmptyConsultCell.self, forCellWithReuseIdentifier: HCMineEmptyConsultCell_identifier)
        collectionView.register(HCMenuItemCell.self, forCellWithReuseIdentifier: HCMenuItemCell_identifier)
        collectionView.register(HCMineEmptyHeathyDataCell.self, forCellWithReuseIdentifier: HCMineEmptyHeathyDataCell_identifier)
        collectionView.register(HCMineInServerCell.self, forCellWithReuseIdentifier: HCMineInServerCell_identifier)

    }
}

extension HCMineViewContainer: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return (model.progressServices.count > 0 ? model.progressServices.count : 1)
        case 1:
            return 4
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: UICollectionViewCell!
        if indexPath.section == 0 {
            if model.progressServices.count > 0 {
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: HCMineInServerCell_identifier, for: indexPath)
                (cell as? HCMineInServerCell)?.model = model.progressServices[indexPath.row]
            }else {
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: HCMineEmptyConsultCell_identifier, for: indexPath)
            }
        }else if indexPath.section == 1 {
            let modes: [HCMenuItemCellMode] = [.consult, .reservation, .order, .record]
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: HCMenuItemCell_identifier, for: indexPath)
            (cell as? HCMenuItemCell)?.mode = modes[indexPath.row]
        }else if indexPath.section == 2 {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: HCMineEmptyHeathyDataCell_identifier, for: indexPath)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            if model.progressServices.count > 0 {
                return .init(width: width, height: HCMineInServerCell_height)
            }
            return .init(width: width, height: HCMineEmptyConsultCell_height)
        }else if indexPath.section == 1 {
            return .init(width: width / 4.0, height: HCMenuItemCell_height)
        }else if indexPath.section == 2 {
            return .init(width: HCMineEmptyHeathyDataCell_height, height: HCMineEmptyHeathyDataCell_height)
        }
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            var header = UICollectionReusableView()
            if indexPath.section == 0 {
                header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HCMineHeaderView_identifier, for: indexPath)
                (header as! HCMineHeaderView).excuteAction = { [weak self] in self?.excuteAction?($0) }
                (header as! HCMineHeaderView).model = model
                (header as! HCMineHeaderView).userModel = userModel
            }else if indexPath.section == 1 {
                header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HCCollectionSectionTitleView_identifier, for: indexPath)
                (header as! HCCollectionSectionTitleView).title = "我的服务"
            }else if indexPath.section == 2 {
                header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HCCollectionSectionTitleView_identifier, for: indexPath)
                (header as! HCCollectionSectionTitleView).title = "健康档案"
            }
            return header
        }
        
        if kind == UICollectionView.elementKindSectionFooter {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footer", for: indexPath)
            footer.backgroundColor = RGB(245, 244, 247)
            return footer
        }

        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch section {
        case 0:
            return .init(width: width, height: HCMineHeaderView_height)
        case 1, 2:
            return .init(width: width, height: HCCollectionSectionTitleView_height)
        default:
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return section < 2 ? .init(width: width, height: 5) : .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch section {
        case 1:
            return .init(top: 20, left: 0, bottom: 15, right: 0)
        case 2:
            return .init(top: 20, left: 15, bottom: 15, right: 15)
        default:
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
