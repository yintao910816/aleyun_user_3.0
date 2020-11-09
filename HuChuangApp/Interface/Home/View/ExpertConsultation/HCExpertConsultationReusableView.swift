//
//  HCExpertConsultationReusableView.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/25.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

public let HCExpertConsultationReusableView_identifier = "HCExpertConsultationReusableView"
public let HCExpertConsultationReusableView_height: CGFloat = 515

class HCExpertConsultationReusableView: UICollectionReusableView {
        
    private var bannberDatas: [HCBannerModel] = []
    private var statisticsDoctorHopitalModel: HCStatisticsDoctorHopitalModel = HCStatisticsDoctorHopitalModel()
    private var doctorListDatas: [HCDoctorListItemModel] = []
    private var slideMenuData: [TYSlideItemModel] = []
    
    private var carouselView: CarouselView!
    /// 专家医师
    private var expertDoctorButton: HCCustomTextButton!
    /// 三甲医院
    private var thirdHospitalButton: HCCustomTextButton!
    /// 生殖中心
    private var reproductiveCenterButton: HCCustomTextButton!
    
    private var titleLabel: UILabel!
    
    private var collectionView: UICollectionView!
    
    private var sepLine: UIView!
    private var slideMenu: TYSlideMenu!

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
        
        carouselView.setData(source: bannberDatas)
        
        expertDoctorButton.setupText(first: statisticsDoctorHopitalModel.expertDoctor,
                                     second: "专家医师",
                                     firstTitleFont: .font(fontSize: 22, fontName: .PingFSemibold),
                                     secondTitleFont: .font(fontSize: 16),
                                     firstTitleColor: RGB(51, 51, 51),
                                     secondTitleColor: RGB(251, 180, 120),
                                     backGroundColor: RGB(254, 242, 232))
        
        thirdHospitalButton.setupText(first: statisticsDoctorHopitalModel.tripleA,
                                     second: "三甲医院",
                                     firstTitleFont: .font(fontSize: 22, fontName: .PingFSemibold),
                                     secondTitleFont: .font(fontSize: 16),
                                     firstTitleColor: RGB(51, 51, 51),
                                     secondTitleColor: RGB(115, 173, 246),
                                     backGroundColor: RGB(222, 233, 247))

        reproductiveCenterButton.setupText(first: statisticsDoctorHopitalModel.reproductiveCenter,
                                     second: "生殖中心",
                                     firstTitleFont: .font(fontSize: 22, fontName: .PingFSemibold),
                                     secondTitleFont: .font(fontSize: 16),
                                     firstTitleColor: RGB(51, 51, 51),
                                     secondTitleColor: RGB(252, 208, 69),
                                     backGroundColor: RGB(250, 243, 221))

        slideMenu.datasource = slideMenuData
        
        collectionView.reloadData()
    }
    
    public func reloadSlideMenuData(slideMenuData: [TYSlideItemModel]) {
        self.slideMenuData = slideMenuData
        self.slideMenu.datasource = slideMenuData
    }
    
    public func reloadDoctorList(doctorListDatas: [HCDoctorListItemModel]) {
        self.doctorListDatas = doctorListDatas
        collectionView.reloadData()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        carouselView.frame = .init(x: 15, y: 0, width: width - 30, height: 180)
        
        let buttonW: CGFloat = (width - 15 * 2 - 10 * 2) / 3.0
        expertDoctorButton.frame = .init(x: 15,
                                         y: carouselView.frame.maxY + 15,
                                         width: buttonW,
                                         height: 80)
        thirdHospitalButton.frame = .init(x: expertDoctorButton.frame.maxX + 10,
                                          y: expertDoctorButton.y,
                                          width: buttonW,
                                          height: 80)
        reproductiveCenterButton.frame = .init(x: thirdHospitalButton.frame.maxX + 10,
                                               y: expertDoctorButton.y,
                                               width: buttonW,
                                               height: 80)

        let titleLabelSize = titleLabel.sizeThatFits(.init(width: CGFloat(MAXFLOAT), height: 25))
        titleLabel.frame = .init(x: 15, y: expertDoctorButton.frame.maxY + 15, width: titleLabelSize.width, height: 25)
        
        collectionView.frame = .init(x: 15,
                                     y: titleLabel.frame.maxY + 15,
                                     width: width - 30,
                                     height: 98)
        
        sepLine.frame = .init(x: 0, y: collectionView.frame.maxY + 15, width: width, height: 10)
        
        slideMenu.frame = .init(x: 0, y: sepLine.frame.maxY, width: width, height: 50)
    }
}

extension HCExpertConsultationReusableView {
    
    private func initUI() {
        carouselView = CarouselView()
        carouselView.layer.cornerRadius = 3
        
        expertDoctorButton = HCCustomTextButton()
        expertDoctorButton.layer.cornerRadius = 3
        
        thirdHospitalButton = HCCustomTextButton()
        thirdHospitalButton.layer.cornerRadius = 3
        reproductiveCenterButton = HCCustomTextButton()
        reproductiveCenterButton.layer.cornerRadius = 3
        
        titleLabel = UILabel()
        titleLabel.text = "我的医生"
        titleLabel.font = .font(fontSize: 18, fontName: .PingFSemibold)
        titleLabel.textColor = RGB(51, 51, 51)
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 10
        layout.sectionInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = .init(width: 230, height: 98)
        layout.scrollDirection = .horizontal
        
        collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        
        sepLine = UIView()
        sepLine.backgroundColor = RGB(243, 243, 243)
        
        slideMenu = TYSlideMenu()
        slideMenu.menuSelect = { [weak self] in self?.menuSelect?($0) }
                
        addSubview(carouselView)
        addSubview(expertDoctorButton)
        addSubview(thirdHospitalButton)
        addSubview(reproductiveCenterButton)
        addSubview(titleLabel)
        addSubview(collectionView)
        addSubview(sepLine)
        addSubview(slideMenu)

        expertDoctorButton.setupText(first: "0",
                                     second: "专家医师",
                                     firstTitleFont: .font(fontSize: 22, fontName: .PingFSemibold),
                                     secondTitleFont: .font(fontSize: 16),
                                     firstTitleColor: RGB(51, 51, 51),
                                     secondTitleColor: RGB(251, 180, 120),
                                     backGroundColor: RGB(254, 242, 232))
        
        thirdHospitalButton.setupText(first: "0",
                                     second: "三甲医院",
                                     firstTitleFont: .font(fontSize: 22, fontName: .PingFSemibold),
                                     secondTitleFont: .font(fontSize: 16),
                                     firstTitleColor: RGB(51, 51, 51),
                                     secondTitleColor: RGB(115, 173, 246),
                                     backGroundColor: RGB(254, 242, 232))

        reproductiveCenterButton.setupText(first: "0",
                                     second: "生殖中心",
                                     firstTitleFont: .font(fontSize: 22, fontName: .PingFSemibold),
                                     secondTitleFont: .font(fontSize: 16),
                                     firstTitleColor: RGB(51, 51, 51),
                                     secondTitleColor: RGB(252, 208, 69),
                                     backGroundColor: RGB(254, 242, 232))
        
        collectionView.register(HCDoctorCardCell.self, forCellWithReuseIdentifier: HCDoctorCardCell_identifier)
    }
    
}

extension HCExpertConsultationReusableView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return doctorListDatas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return HCDoctorCardCell_size
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HCDoctorCardCell_identifier, for: indexPath) as! HCDoctorCardCell
        cell.model = doctorListDatas[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        cellDidSelected?(doctorListDatas[indexPath.row])
    }
}
