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

    private var menuItems: [HCFunctionsMenuModel] = []
    private var cmsChanelListModel: [HCCmsCmsChanelListModel] = []
    private var articleDatas: [HCCmsArticleListModel] = []
    private var cmsRecommendDatas: [HCCmsRecommendModel] = []
    private var pageIdx: Int = 0
    
    public var menuChanged: ((HCMenuItemModel)->())?
    public var articleClicked: ((HCCmsArticleListModel)->())?
    public var funcItemClicked: ((HCFunctionsMenuModel)->())?
    public var cmsRecommendItemClicked: ((HCCmsRecommendModel)->())?

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
   
    public func reloadData(menuItems: [HCFunctionsMenuModel], cmsChanelListModel: [HCCmsCmsChanelListModel], cmsModes: [HCCmsRecommendModel], page: Int) {
        pageIdx = page
        self.menuItems = menuItems
        self.cmsChanelListModel = cmsChanelListModel
        self.cmsRecommendDatas = cmsModes
        
        collectionView.reloadData()
    }
    
    public func reloadArticleDatas(datas: [HCCmsArticleListModel], page: Int){
        pageIdx = page
        articleDatas = datas
        collectionView.reloadData()
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
        collectionView.register(HCRealTimeCell.self, forCellWithReuseIdentifier: HCRealTimeCell_identifier)
    }

}

extension HCHomeViewContainer: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            if menuItems.count > 3 {
                return menuItems.count - 3
            }
            return 0
        case 1:
            return cmsRecommendDatas.count
        case 2:
            return articleDatas.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: UICollectionViewCell!
        if indexPath.section == 0 {
//            let modes: [HCMenuItemShadowCellMode] = [.testTubeEncyclopedia, .reproductiveCenter, .testTubeDiary, .drugEncyclopedia]
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: HCMenuItemShadowCell_identifier, for: indexPath)
            (cell as? HCMenuItemShadowCell)?.funcModel = menuItems[indexPath.row + 3]
        }else if indexPath.section == 1 {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: HCMenuHorizontalCell_identifier, for: indexPath)
            (cell as? HCMenuHorizontalCell)?.mode = cmsRecommendDatas[indexPath.row]
        }else if indexPath.section == 2 {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: HCRealTimeCell_identifier, for: indexPath)
            (cell as? HCRealTimeCell)?.model = articleDatas[indexPath.row]
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return .init(width: (width - 15 * 5) / 4.0, height: HCMenuItemShadowCell_height)
        }else if indexPath.section == 1 {
//            return .init(width: cmsRecommendDatas[indexPath.row].itemW, height: HCMenuHorizontalCell_height)
            return .init(width: (width - 20 * 2 - 10 * 2 - 1) / 3.0, height: HCMenuHorizontalCell_height)
        }else if indexPath.section == 2 {
            return .init(width: width, height: HCRealTimeCell_height)
        }
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            var header = UICollectionReusableView()
            if indexPath.section == 0 {
                header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HCHomeHeaderReusableView_identifier, for: indexPath)
                if menuItems.count > 3 {
                    (header as? HCHomeHeaderReusableView)?.funcMenuModels = Array(menuItems[0..<3])
                }else {
                    (header as? HCHomeHeaderReusableView)?.funcMenuModels = menuItems
                }
                (header as? HCHomeHeaderReusableView)?.funcItemClicked = { [weak self] in self?.funcItemClicked?($0) }
            }else if indexPath.section == 2 {
                if cmsChanelListModel.count > 0 {
                    header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HCNewsReusableView_identifier, for: indexPath)
                    (header as? HCNewsReusableView)?.reloadMenuItems(items: cmsChanelListModel, page: pageIdx)
                    (header as? HCNewsReusableView)?.menuChanged = { [weak self] in self?.menuChanged?($0) }
                }
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
            if cmsChanelListModel.count > 0 {
                return .init(width: width, height: HCNewsReusableView_height)
            }
            return .zero
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

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            funcItemClicked?(menuItems[3 + indexPath.row])
        case 1:
            cmsRecommendItemClicked?(cmsRecommendDatas[indexPath.row])
        case 2:
            articleClicked?(articleDatas[indexPath.row])
        default:
            break
        }
    }
}
