//
//  TYSearchRecordLayout.swift
//  HuChuangApp
//
//  Created by sw on 2019/10/9.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit

protocol HCCalendarLayoutDelegate: class {
    func rowsCount(for section: Int, layout: HCCalendarLayout) ->Int
    func sectionNum() ->Int
    func countInRow(for section: Int, layout: HCCalendarLayout) ->Int
    func minimumLineSpacing(in section: Int, layout: HCCalendarLayout) ->CGFloat
    func minimumInterSpacing(in section: Int, layout: HCCalendarLayout) ->CGFloat
    func itemSize(for indexPath: IndexPath, layout: HCCalendarLayout) ->CGSize
    func sectionInset(in section: Int, layout: HCCalendarLayout) ->UIEdgeInsets
}

class HCCalendarLayout: UICollectionViewFlowLayout {
    
    private var attributeArray     = [UICollectionViewLayoutAttributes]()
    private var nextItemX: CGFloat = 0.0
    private var nextRow            = 0
    private var createdItemNum     = 0
    
    public var layoutDelegate: HCCalendarLayoutDelegate?

    //MARK:
    //MARK: <##>
    override func prepare() {
        super.prepare()
        
        attributeArray.removeAll()
        //拿到每个分区所有item的个数
        let sectionNum = layoutDelegate?.sectionNum() ?? 0
        for section in 0 ..< sectionNum {
            let totalItems = collectionView?.numberOfItems(inSection: section) ?? 0
            for row in 0 ..< totalItems {
                let indexPath = IndexPath.init(row: row, section: section)
                let frame = setLayoutAttributes(section, row)
                
                let attribute = UICollectionViewLayoutAttributes.init(forCellWith: indexPath)
                attribute.frame = frame
                attributeArray.append(attribute)
            }
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var resultArray = [UICollectionViewLayoutAttributes]()
        for attributes in attributeArray {
            let rect1 = attributes.frame
            if rect1.intersects(rect) {
                resultArray.append(attributes)
            }
        }
        return resultArray
    }
    
    override var collectionViewContentSize: CGSize {
        let height = collectionView?.frame.height ?? 0
        let sectionNum = layoutDelegate?.sectionNum() ?? 0
        return CGSize.init(width: (collectionView?.frame.size.width ?? 0) * CGFloat(sectionNum), height: height)
    }
    
    //MARK:
    //MARK: <##>
    private func setLayoutAttributes(_ section: Int, _ row: Int) ->CGRect {
        guard let customDelegate = layoutDelegate else {
            return collectionView?.bounds ?? .zero
        }
        
        let countInRow = customDelegate.countInRow(for: section, layout: self)
        let customSize = customDelegate.itemSize(for: .init(row: row, section: section), layout: self)
        let customEdgeInsets = customDelegate.sectionInset(in: section, layout: self)
        let cusInteritemSpacing = customDelegate.minimumInterSpacing(in: section, layout: self)
        let cusLineSpacing = customDelegate.minimumLineSpacing(in: section, layout: self)
        
        let xCount = row % countInRow
        let yCount = row / countInRow

        var xPos = (collectionView?.frame.width ?? 0.0) * CGFloat(section) + customEdgeInsets.left + CGFloat(xCount) * customSize.width
        xPos += CGFloat(xCount) * cusInteritemSpacing
        
        var yPos = customEdgeInsets.top + CGFloat(yCount) * customSize.height
        yPos += CGFloat(yCount + 1) * cusLineSpacing + customEdgeInsets.bottom

        return CGRect.init(x: xPos, y: yPos, width: customSize.width, height: customSize.height)
    }
}
