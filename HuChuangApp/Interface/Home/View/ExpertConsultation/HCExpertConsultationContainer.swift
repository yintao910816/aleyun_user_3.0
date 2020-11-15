//
//  HCExpertConsultationContainer.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/25.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation

class HCExpertConsultationContainer: UIView {
    
    private var bannberDatas: [HCBannerModel] = []
    private var statisticsDoctorHopitalModel: HCStatisticsDoctorHopitalModel = HCStatisticsDoctorHopitalModel()
    private var doctorListDatas: [HCDoctorListItemModel] = []
    private var slideMenuData: [TYSlideItemModel] = []
    
    public var collectionView: UICollectionView!
    
    public var menuSelect: ((Int)->())?
    public var cellDidSelected: ((HCDoctorListItemModel)->())?

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setupHeader(bannberDatas: [HCBannerModel],
                            statisticsDoctorHopitalModel: HCStatisticsDoctorHopitalModel,
                            doctorListDatas: [HCDoctorListItemModel],
                            slideMenuData: [TYSlideItemModel]) {
    
        self.bannberDatas = bannberDatas
        self.statisticsDoctorHopitalModel = statisticsDoctorHopitalModel
        self.doctorListDatas = doctorListDatas
        self.slideMenuData = slideMenuData
        
        collectionView.isHidden = false
        collectionView.reloadData()
    }
    
    public var colDatasource: [HCDoctorListItemModel] = [] {
        didSet {
            collectionView.reloadData()
        }
    }

    public func reloadSlideMenuData(slideMenuData: [TYSlideItemModel]) {
        self.slideMenuData = slideMenuData
        collectionView.reloadData()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        collectionView.frame = bounds
    }
}

extension HCExpertConsultationContainer {
    
    private func initUI() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.sectionInset = .init(top: 0, left: 0, bottom: 0, right: 0)

        collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isHidden = true
        addSubview(collectionView)
        
        collectionView.register(HCDoctorListCell.self, forCellWithReuseIdentifier: HCDoctorListCell_identifier)
        collectionView.register(HCExpertConsultationReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: HCExpertConsultationReusableView_identifier)
    }
}

extension HCExpertConsultationContainer: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colDatasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: width, height: colDatasource[indexPath.row].getCellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HCDoctorListCell_identifier, for: indexPath) as! HCDoctorListCell
        cell.model = colDatasource[indexPath.row]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if indexPath.section == 0, kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HCExpertConsultationReusableView_identifier, for: indexPath) as! HCExpertConsultationReusableView
            header.setupHeader(bannberDatas: bannberDatas,
                               statisticsDoctorHopitalModel: statisticsDoctorHopitalModel,
                               doctorListDatas: doctorListDatas,
                               slideMenuData: slideMenuData)
            header.menuSelect = { [weak self] in self?.menuSelect?($0) }
            header.cellDidSelected = { [weak self] in self?.cellDidSelected?($0) }
            return header
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: width, height: HCExpertConsultationReusableView_height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        cellDidSelected?(colDatasource[indexPath.row])
    }
}
