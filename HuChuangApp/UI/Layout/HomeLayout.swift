//
//  HomeLayout.swift
//  HuChuangApp
//
//  Created by yintao on 2019/9/22.
//  Copyright © 2019 sw. All rights reserved.
//

import Foundation

class HomeLayout: BaseFlowLayout {
    
    private var lastFrame: CGRect = .zero
    private var attributeArray    = [UICollectionViewLayoutAttributes]()

    //MARK
    //MARK: paramter
    public var itemMinHeight: CGFloat = 0.0 {
        didSet{
            invalidateLayout()
        }
    }

    //MARK
    //MARK: layout
    override func prepare() {
        super.prepare()

        attributeArray.removeAll()
        lastFrame = CGRect.init(x: 0, y: delegate?.insetForSection(layout: self, section: 0).top ?? 0, width: 0, height: 0)

        // 总宽度
        let totalWidth = collectionView?.bounds.size.width ?? 0
        // 拿到所有分区
        let totalSections = collectionView?.numberOfSections ?? 0

        for section in 0..<totalSections {
            let totleItems = collectionView?.numberOfItems(inSection: section) ?? 0
            let edgeInsets = delegate?.insetForSection(layout: self, section: section) ?? UIEdgeInsets.zero
            // 垂直方向的间距
            var vSpace = delegate?.minimumInteritemSpacingForSection(layout: self, section: section)
            if vSpace == nil {
            
            }
            // item 总宽度
            let itemWidth = (totalWidth - edgeInsets.left - edgeInsets.right)

            for row in 0..<totleItems {
                
            }
        }
        
//        for index in 0..<totalItems {
//            var frame = CGRect.zero
//            let indexPath = IndexPath.init(row: index, section: 0)
//
//            let width = maxCurrentWidth(indexPath)
//            if width > itemWidth {
//                // 超过最大宽度，直接换行，计算行高
//                frame = CGRect.init(x: edgeInsets.left, y: lastFrame.maxY + lineSpacing, width: itemWidth, height: currentHeight(indexPath))
//            }else {
//
//                if (lastFrame.maxX + interSpacing + width + edgeInsets.right) > totalWidth {
//                    // 不能接在前一个后面，要换行
//                    frame = CGRect.init(x: edgeInsets.left, y: lastFrame.maxY + lineSpacing, width: width, height: itemMinHeight)
//                }else {
//                    frame = CGRect.init(x: lastFrame.maxX + interSpacing, y: lastFrame.origin.y, width: width, height: itemMinHeight)
//                }
//            }
//
//            let attribute = UICollectionViewLayoutAttributes.init(forCellWith: indexPath)
//            attribute.frame = frame
//            attributeArray.append(attribute)
//
//            lastFrame = frame
//        }

    }


    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var resultArray = [UICollectionViewLayoutAttributes]()

        for attributes in attributeArray {
            let rect1 = attributes.frame
            if rect.intersects(rect1) {
                resultArray.append(attributes)
            }
        }

        return resultArray
    }
    
}

//extension HomeLayout {
//    
//    /**
//     计算 item 宽度
//     */
//    fileprivate func maxCurrentWidth(_ indexPath: IndexPath) ->CGFloat {
//        let text: String? = delegate?.itemContent(layout: self, indexPath: indexPath) ?? ""
//        return (text!.getTexWidth(fontSize: font, height: itemMinHeight - 2*5) + 2*5)
//    }
//    
//    /**
//     计算 item 高度
//     */
//    fileprivate func currentHeight(_ indexPath: IndexPath) -> CGFloat {
//        let text: String? = delegate?.itemContent(layout: self, indexPath: indexPath) ?? ""
//        return (text!.getTextHeigh(fontSize: font, width: (collectionView?.width ?? 0) - edgeInsets.left - edgeInsets.right - 2*5) + 2*5)
//    }
//    
//}
