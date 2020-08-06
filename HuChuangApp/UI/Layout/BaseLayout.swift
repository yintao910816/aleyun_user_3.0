//
//  BaseLayout.swift
//  HuChuangApp
//
//  Created by yintao on 2019/9/22.
//  Copyright © 2019 sw. All rights reserved.
//

import Foundation

class BaseFlowLayout: UICollectionViewFlowLayout {
    
    public weak var delegate: FlowLayoutDelegate?
    
}

extension BaseFlowLayout {
    
    /**
     计算 item 宽度
     */
    public func maxCurrentWidth(_ indexPath: IndexPath, _ fontSize: Float, _ height: CGFloat) ->CGFloat {
        let text: String? = delegate?.itemContent(layout: self, indexPath: indexPath) ?? ""
        return (text!.getTexWidth(fontSize: fontSize, height: height) + 2)
    }
    
    /**
     计算 item 高度
     */
    public func currentHeight(_ indexPath: IndexPath, _ width: CGFloat, _ fontSize: Float) -> CGFloat {
        let text: String? = delegate?.itemContent(layout: self, indexPath: indexPath) ?? ""
        return (text!.getTextHeigh(fontSize: fontSize, width: width) + 2)
    }
    
}

protocol FlowLayoutDelegate: NSObjectProtocol {
    
    func itemContent(layout: BaseFlowLayout, indexPath: IndexPath) ->String
    
    func insetForSection(layout: BaseFlowLayout,section: Int) -> UIEdgeInsets
    
    func minimumLineSpacingForSection(layout: BaseFlowLayout, section: Int) -> CGFloat?
    
    func minimumInteritemSpacingForSection(layout: BaseFlowLayout, section: Int) -> CGFloat?
    
    func referenceSizeForHeader(layout collectionViewLayout: BaseFlowLayout, section: Int) -> CGSize
    
    func referenceSizeForFooter(layout collectionViewLayout: BaseFlowLayout, section: Int) -> CGSize

}

extension FlowLayoutDelegate {
    
    func itemContent(layout: BaseFlowLayout, indexPath: IndexPath) ->String { return "" }

    func insetForSection(layout: BaseFlowLayout,section: Int) -> UIEdgeInsets { return .zero }
    
    func minimumLineSpacingForSection(layout: BaseFlowLayout, section: Int) -> CGFloat? { return nil }
    
    func minimumInteritemSpacingForSection(layout: BaseFlowLayout, section: Int) -> CGFloat? { return nil }
    
    func referenceSizeForHeader(layout collectionViewLayout: BaseFlowLayout, section: Int) -> CGSize { return .zero }
    
    func referenceSizeForFooter(layout collectionViewLayout: BaseFlowLayout, section: Int) -> CGSize { return .zero }

}
