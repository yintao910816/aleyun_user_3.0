//
//  HCPresentBottom.swift
//  HuChuangApp
//
//  Created by yintao on 2020/11/5.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCPresentBottom: UIPresentationController {
    
    private lazy var blackView: UIView = {
        let view = UIView.init(frame: self.containerView?.bounds ?? UIScreen.main.bounds)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return view
    }()
    
    public var controllerHeight: CGFloat = 0
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        
        controllerHeight = presentedViewController.controllerHeight == 0 ? UIScreen.main.bounds.size.height : presentedViewController.controllerHeight;
    }
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        
        blackView.alpha = 0
        containerView?.addSubview(blackView)
        UIView.animate(withDuration: 0.25) { self.blackView.alpha = 1 }
    }
    
    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        UIView.animate(withDuration: 0.25) { self.blackView.alpha = 0 }
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        super.dismissalTransitionDidEnd(completed)
        
        if completed {
            blackView.removeFromSuperview()
        }
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        let containerSize = containerView?.bounds.size ?? UIScreen.main.bounds.size
        return .init(x: 0, y: containerSize.height - controllerHeight, width: containerSize.width, height: controllerHeight)
    }
    
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        
        blackView.frame = containerView?.bounds ?? UIScreen.main.bounds
    }
}
