//
//  UIKit+Extension.swift
//  StoryReader
//
//  Created by 020-YinTao on 2017/5/8.
//  Copyright © 2017年 020-YinTao. All rights reserved.
//

import UIKit

extension NSObject {
    
    public var visibleViewController: UIViewController? {
        get {
            guard let rootVC = UIApplication.shared.delegate?.window??.rootViewController else{
                return nil
            }
            return getVisibleViewController(from: rootVC)
        }
    }
    
    private func getVisibleViewController(from: UIViewController?) ->UIViewController? {
        if let nav = from as? UINavigationController {
//            return getVisibleViewController(from:nav.visibleViewController)
            return getVisibleViewController(from:nav.viewControllers.last)
        }else if let tabBar = from as? UITabBarController {
            return getVisibleViewController(from: tabBar.selectedViewController)
        }else {
            guard let presentedVC = from?.presentedViewController else {
                return from
            }
            return getVisibleViewController(from: presentedVC)
        }
        
    }
    
}

extension UIViewController {
    
    /**
     1）调用容器视图控制器的addChildViewController:，此方法是将子视图控制器添加到容器视图控制器，告诉UIKit父视图控制器现在要管理子视图控制器和它的视图。
     2）调用 addSubview: 方法，将子视图控制器的根视图加在父视图控制器的视图层级上。这里需要设置子视图控制器中根视图的位置和大小。
     3）布局子视图控制器的根视图。
     4）调用 didMoveToParentViewController:，告诉子视图控制器其根视图的被持有情况。也就是需要先把子视图控制器的根视图添加在父视图中的视图层级中。
     
     在调用 addChildViewController: 时，系统会先调用 willMoveToParentViewController:
     然后再将子视图控制器添加到父视图控制器中。
     但是系统不会自动调用 didMoveToParentViewController: 方法需要手动调用
     为何呢？
     视图控制器是有转场动画的，动画完成后才应该去调用 didMoveToParentViewController: 方法。
     */
    final func addChildViewController(_ childVC: UIViewController) {
        addChild(childVC)
        childVC.view.frame = view.bounds
        view.addSubview(childVC.view)
        childVC.didMove(toParent: self)
    }

    /**
     1）调用子视图控制器的willMoveToParentViewController:，参数为 nil，让子视图做好被移除的准备。
     2）移除子视图控制器的根视图在添加时所作的任何的约束布局。
     3）调用 removeFromSuperview 将子视图控制器的根视图从视图层次结构中移除。
     4）调用 removeFromParentViewController 来告知结束父子关系。
     5）在调用 removeFromParentViewController 时会调用子视图控制器的 didMoveToParentViewController: 方法，参数为 nil。
     */
    final func removeChildViewController(_ childVC: UIViewController) {
        childVC.willMove(toParent: nil)
        childVC.view.removeFromSuperview()
        childVC.removeFromParent()
    }
    
    final func removeFromParaentViewController() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}
