//
//  HCClassRoomContainer.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/27.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCClassRoomContainer: UIView {

    private var bannerDatas: [HCBannerModel] = []
    
    private var searchBar: TYSearchBar!
    
    public var collectionView: UICollectionView!
    
    public var tapInputCallBack: (()->())?
    public var rightItemTapBack: (()->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func reload(with sectionDatas: [HCClassRoomSectionModel], bannerDatas: [HCBannerModel]) {
        self.bannerDatas = bannerDatas
        self.sectionDatas = sectionDatas
    }
    
    public var sectionDatas: [HCClassRoomSectionModel] = [] {
        didSet {
            collectionView.reloadData()
        }
    }

        
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if #available(iOS 11.0, *) {
            searchBar.frame = .init(x: 0, y: 0, width: width, height: TYSearchBar.baseHeight + safeAreaInsets.top)
            searchBar.safeArea = safeAreaInsets
        } else {
            searchBar.frame = .init(x: 0, y: 0, width: width, height: TYSearchBar.baseHeight + 20)
            searchBar.safeArea = .init(top: 20, left: 0, bottom: 0, right: 0)
        }

        
        collectionView.frame = .init(x: 0, y: searchBar.frame.maxY, width: width, height: height - searchBar.frame.maxY)
    }
}

extension HCClassRoomContainer {
    
    private func initUI() {
        searchBar = TYSearchBar()
        searchBar.searchPlaceholder = "搜索"
        searchBar.rightItemIcon = "nav_message_gray"
        searchBar.inputBackGroundColor = RGB(243, 243, 243)
        searchBar.backgroundColor = .white
        
        collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = backgroundColor
        collectionView.dataSource = self
        collectionView.delegate = self

        addSubview(collectionView)
        addSubview(searchBar)
        
        searchBar.tapInputCallBack = { [unowned self] in self.tapInputCallBack?() }
        searchBar.rightItemTapBack = { [unowned self] in self.rightItemTapBack?() }
        
        collectionView.register(HCClassRoomBannerReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: HCClassRoomBannerReusableView_identifier)
        collectionView.register(HCClassRoomHeaderReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: HCClassRoomHeaderReusableView_identifier)
        
        collectionView.register(HCClassRoomLiveVideoCell.self, forCellWithReuseIdentifier: HCClassRoomLiveVideoCell_identifier)
        collectionView.register(HCClassRoomGoodCell.self, forCellWithReuseIdentifier: HCClassRoomGoodCell_identifier)
        collectionView.register(HCClassRoomRecommendCell.self, forCellWithReuseIdentifier: HCClassRoomRecommendCell_identifier)
        collectionView.register(HCClassRoomFMCell.self, forCellWithReuseIdentifier: HCClassRoomFMCell_identifier)
        collectionView.register(HCClassRoomGoodRecommendCell.self, forCellWithReuseIdentifier: HCClassRoomGoodRecommendCell_identifier)
    }
}

extension HCClassRoomContainer: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        sectionDatas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sectionDatas[section].datas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = sectionDatas[indexPath.section].datas[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: sectionDatas[indexPath.section].sectionInfo.cellIdentifier, for: indexPath)
        (cell as? HCClassRoomBaseCell)?.model = model
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let sectionModel = sectionDatas[indexPath.section].sectionInfo
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                         withReuseIdentifier: sectionModel.headerReuseIdentifier,
                                                                         for: indexPath) as! HCClassRoomBaseReusableView
            if let bannerHeader = header as? HCClassRoomBannerReusableView {
                bannerHeader.bannerModes = bannerDatas
            }
            header.model = sectionDatas[indexPath.section].sectionInfo
            return header
        }
        
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let sectionModel = sectionDatas[section].sectionInfo
        return sectionModel.headerReuseSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionDatas[section].sectionInfo.sectionInset
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionDatas[section].sectionInfo.minimumLineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return sectionDatas[section].sectionInfo.minimumInteritemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return sectionDatas[indexPath.section].datas[indexPath.row].itemSize
    }
    
}
