//
//  UINavigationController+BarButtonItem.swift
//  StoryReader
//
//  Created by 020-YinTao on 2017/6/2.
//  Copyright © 2017年 020-YinTao. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

extension UIViewController {
    
    public final func addBarItem(normal normalImage: String? = nil,
                                 highlighted highlightedImage: String? = nil,
                                 title itemTitle: String? = nil,
                                 titleColor color: UIColor? = UIColor.white,
                                 right isRight: Bool = true,
                                 edgeLeft: CGFloat = 0,
                                 edgeRight: CGFloat = 0,
                                 _ action: @escaping () ->Void) {
        let button = createButton(normalImage, highlightedImage, itemTitle, color, edgeLeft: edgeLeft, edgeRight: edgeRight)
        isRight == true ? (navigationItem.rightBarButtonItem = UIBarButtonItem(customView:button))
            : (navigationItem.leftBarButtonItem = UIBarButtonItem(customView:button))
        
        button.rx
            .controlEvent(.touchUpInside)
            .asDriver()
            .drive(onNext: { action() })
            .disposed(by: DisposeBag())
    }
    
    public final func addBarItem(normal normalImage: String? = nil,
                                 highlighted highlightedImage: String? = nil,
                                 title itemTitle: String? = nil,
                                 titleColor color: UIColor? = UIColor.white,
                                 right isRight: Bool = true,
                                 edgeLeft: CGFloat = 0,
                                 edgeRight: CGFloat = 0) ->Driver<Void> {
        let button = createButton(normalImage, highlightedImage, itemTitle, color, edgeLeft: edgeLeft, edgeRight: edgeRight)
        isRight == true ? (navigationItem.rightBarButtonItem = UIBarButtonItem(customView:button))
            : (navigationItem.leftBarButtonItem = UIBarButtonItem(customView:button))
        
        return button.rx.tap.asDriver()
    }
    
    private func createButton(_ normalImage: String?,
                              _ highlightedImage: String?,
                              _ itemTitle: String?,
                              _ titleColor: UIColor?,
                              edgeLeft: CGFloat,
                              edgeRight: CGFloat) ->UIButton {
        let button : UIButton = UIButton(type : .system)
        if normalImage?.isEmpty == false {
            button.setImage(UIImage(named :normalImage!)?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        if highlightedImage?.isEmpty == false {
            button.setImage(UIImage(named :highlightedImage!)?.withRenderingMode(.alwaysOriginal), for: .highlighted)
        }
        if itemTitle?.isEmpty == false {
            button.setTitle(itemTitle, for: .normal)
            button.setTitleColor(titleColor, for: .normal)
        }
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.sizeToFit()
        
        let edgeTop: CGFloat = max((44 - button.height) / 2, 0)
        button.contentEdgeInsets =  .init(top: edgeTop, left: edgeLeft, bottom: edgeTop, right: edgeRight)

        PrintLog("item 大小：\(button.frame)")
        
        return button
    }
}
