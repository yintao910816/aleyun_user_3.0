//
//  TYCalendarView.swift
//  HuChuangApp
//
//  Created by sw on 2019/10/17.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit

import RxSwift

private let weekLabelTag: Int = 200

class HCCalendarView: UIView {

    private let disposeBag = DisposeBag()
    
    private var weekContainer: UIView!
    private var collectionView: UICollectionView!
    
    private var sectionData: [TYCalendarSectionModel] = []
    private var currentPage: Int = 0

    public let itemSelectedSignal = PublishSubject<TYCalendarItem>()
    public let heightChangeSignal = PublishSubject<CGFloat>()
    public let didScrollSignal = PublishSubject<Int>()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func reloadDatas(sectionData: [TYCalendarSectionModel], currentPage: Int) {
        self.sectionData = sectionData
        self.currentPage = currentPage
        collectionView.reloadData()
        
        let poision = CGPoint(x: collectionView.width * CGFloat(currentPage), y: 0)
        collectionView.setContentOffset(poision, animated: false)
    }

    
    private func setupUI() {
        clipsToBounds = true
        backgroundColor = RGB(245, 245, 245)
        
        weekContainer = UIView()
        weekContainer.backgroundColor = RGB(245, 245, 245)
        
        let weekData = ["日", "一", "二", "三", "四", "五", "六"]
        for idx in 0..<7 {
            let weekLabel = UILabel()
            weekLabel.font = .font(fontSize: 12, fontName: .PingFMedium)
            weekLabel.textColor = weekData[idx] == "日" || weekData[idx] == "六" ? RGB(255, 79, 120) : RGB(178, 178, 178)
            weekLabel.textAlignment = .center
            weekLabel.text = weekData[idx]
            weekLabel.tag = weekLabelTag + idx
            weekContainer.addSubview(weekLabel)
        }
                
        let layout = HCCalendarLayout()
        layout.layoutDelegate = self
        
        collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = RGB(245, 245, 245)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.dataSource = self
        collectionView.delegate = self
                
        collectionView.register(HCCalendarDayCell.self, forCellWithReuseIdentifier: HCCalendarDayCell_identifier)
        
        addSubview(weekContainer)
        addSubview(collectionView)
    }
    
    private func setTitle() {
        if let indexPath = collectionView.indexPathsForVisibleItems.first {
            let sectionModel = sectionData[indexPath.section]
            PrintLog("日期变化：\(sectionModel.year)年\(sectionModel.month)月")
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        weekContainer.frame = .init(x: 0, y: 0, width: width, height: 24)
        
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

extension HCCalendarView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sectionData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sectionData[section].items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: HCCalendarDayCell_identifier, for: indexPath) as! HCCalendarDayCell)
        cell.model = sectionData[indexPath.section].items[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        itemSelectedSignal.onNext(sectionData[indexPath.section].items[indexPath.row])
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        setTitle()
        didScrollSignal.onNext(pageNumber())
        let newHeight = HCCalendarView.viewHeight(itemCount: sectionData[pageNumber()].items.count)
        if newHeight != collectionView.height {
            PrintLog("日历控件高度变化")
            heightChangeSignal.onNext(newHeight)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            setTitle()
            didScrollSignal.onNext(pageNumber())
            let newHeight = HCCalendarView.viewHeight(itemCount: sectionData[pageNumber()].items.count)
            if newHeight != collectionView.height {
                PrintLog("日历控件高度变化")
                heightChangeSignal.onNext(newHeight)
            }
        }
    }
    
    private func pageNumber() ->Int {
        return Int(collectionView.contentOffset.x / collectionView.width)
    }
}

extension HCCalendarView: HCCalendarLayoutDelegate {
    
    func rowsCount(for section: Int, layout: HCCalendarLayout) ->Int {
        let itemCount = sectionData[section].items.count
        var lines: Int = itemCount / 7
        lines += (itemCount % 7) > 0 ? 1 : 0
        return lines
    }
    
    func sectionNum() ->Int {
        return sectionData.count
    }
    
    func countInRow(for section: Int, layout: HCCalendarLayout) ->Int {
        return 7
    }
    
    func minimumLineSpacing(in section: Int, layout: HCCalendarLayout) ->CGFloat {
        return 2.5
    }
    
    func minimumInterSpacing(in section: Int, layout: HCCalendarLayout) ->CGFloat {
        return 2.5
    }
    
    func itemSize(for indexPath: IndexPath, layout: HCCalendarLayout) ->CGSize {
        let totleW: CGFloat = collectionView.width - 2.5 * 6 - 4.5 * 2
        return .init(width: (totleW - 1) / 7.0, height: 50)
    }
    
    func sectionInset(in section: Int, layout: HCCalendarLayout) ->UIEdgeInsets {
        return .init(top: 0, left: 4.5, bottom: 0, right: 4.5)
    }
}


extension HCCalendarView {
    
    public class func viewHeight(itemCount: Int) ->CGFloat {
        var lines: Int = itemCount / 7
        lines += (itemCount % 7) > 0 ? 1 : 0
        return CGFloat(24 + lines * 50) + CGFloat(lines - 1) * 2.5 + 3
    }

}

