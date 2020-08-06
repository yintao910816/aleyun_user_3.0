//
//  TYCalendarView.swift
//  HuChuangApp
//
//  Created by sw on 2019/10/17.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit

public let viewHeight: CGFloat = 45 + 45 + 50 * 6

private let weekLabelTag: Int = 200

class TYCalendarView: UIView {

    private var titleView: UIButton!
    private var weekContainer: UIView!
    private var collectionView: UICollectionView!
    
    // 暂时不能滚动
    private var sectionData: [TYCalendarSectionModel] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        sectionData.append(contentsOf: TYCalendarSectionModel.creatCalendarData(date: Date()))
        
        setupUI()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .white
        
        //
        titleView = UIButton()
        titleView.backgroundColor = .white
        titleView.setTitleColor(.black, for: .normal)

        //
        weekContainer = UIView()
        weekContainer.backgroundColor = RGB(245, 245, 245)
        
        let weekData = ["周日", "周一", "周二", "周三", "周四", "周五", "周六"]
        for idx in 0..<7 {
            let weekLabel = UILabel()
            weekLabel.font = .font(fontSize: 14)
            weekLabel.textColor = .black
            weekLabel.textAlignment = .center
            weekLabel.text = weekData[idx]
            weekLabel.tag = weekLabelTag + idx
            weekContainer.addSubview(weekLabel)
        }
        
        let weekItemWidth = (UIScreen.main.bounds.width - 1) / 7.0
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: weekItemWidth, height: 50)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = .zero
        
        collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(TYCalendarDayCell.self, forCellWithReuseIdentifier: TYCalendarDayCell_identifier)
        
        addSubview(titleView)
        addSubview(weekContainer)
        addSubview(collectionView)
        
        let sectionModel = sectionData[0]
        titleView.setTitle("\(sectionModel.year)年\(sectionModel.month)月", for: .normal)
    }
    
    private func setTitle() {
        if let indexPath = collectionView.indexPathsForVisibleItems.first {
            let sectionModel = sectionData[indexPath.section]
            titleView.setTitle("\(sectionModel.year)年\(sectionModel.month)月", for: .normal)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleView.frame = .init(x: 0, y: 0, width: width, height: 45)
        weekContainer.frame = .init(x: 0, y: titleView.frame.maxY, width: width, height: 45)
        
        let weekItemWidth = width / 7.0
        for idx in 0..<7 {
            let label = weekContainer.viewWithTag(weekLabelTag + idx)
            label?.frame = .init(x: weekItemWidth * CGFloat(idx), y: 0, width: weekItemWidth, height: weekContainer.height)
        }
        
        collectionView.frame = .init(x: 0, y: weekContainer.frame.maxY,
                                     width: width,
                                     height: height - weekContainer.frame.maxY)
    }
}

extension TYCalendarView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sectionData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sectionData[section].items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: TYCalendarDayCell_identifier, for: indexPath) as! TYCalendarDayCell)
        cell.model = sectionData[indexPath.section].items[indexPath.row]
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        setTitle()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            setTitle()
        }
    }
}
