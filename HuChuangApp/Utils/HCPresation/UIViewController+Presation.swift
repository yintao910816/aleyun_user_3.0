//
//  UIViewController+Presation.swift
//  HuChuangApp
//
//  Created by yintao on 2020/11/5.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation

extension UIViewController {
    
    private struct AssociatedKey {
        static var controllerHeight: String = "controllerHeight"
    }
    
    public var controllerHeight: CGFloat {
        get {
            if let h = objc_getAssociatedObject(self, &AssociatedKey.controllerHeight) as? NSNumber {
                return CGFloat(h.floatValue)
            }
            return 0
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.controllerHeight, NSNumber.init(value: Float(newValue)), .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
}

extension UIViewController: UIViewControllerTransitioningDelegate {
    
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return HCPresentBottom.init(presentedViewController: presented, presenting: presenting)
    }
    
    public func model(for controller: UIViewController, controllerHeight: CGFloat) {
        controller.modalPresentationStyle = .custom
        controller.controllerHeight = controllerHeight
        controller.transitioningDelegate = self
        present(controller, animated: true, completion: nil)
    }
}
