//
//  HCTabBarViewController.swift
//  HuChuangApp
//
//  Created by sw on 02/02/2019.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit
import RxSwift

class HCTabBarViewController: UITabBarController {

    private var lastSelectedIndex: Int = NSNotFound
    
    private let disposeBag = DisposeBag()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBar()
        
        NotificationCenter.default.rx.notification(NotificationName.UILogic.gotoClassRoom)
            .subscribe(onNext: { [weak self] data in
                self?.selectedIndex = 3
            })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(NotificationName.UserInterface.selectedHomeTabBar)
            .subscribe(onNext: { [weak self] data in
                self?.selectedIndex = 0
            })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(NotificationName.UILogic.gotoRecord)
            .subscribe(onNext: { [weak self] data in
                self?.selectedIndex = 2
            })
            .disposed(by: disposeBag)
    }

    private func setupTabBar() {
        let homeCtrl = HCHomeViewController()
        let homeNav = MainNavigationController.init(rootViewController: homeCtrl)
        homeNav.tabBarItem.title = "首页"
        homeNav.tabBarItem.image = nil
        homeNav.tabBarItem.selectedImage = nil
        
        let toolCtrl = HCToolViewController()
        let toolNav = MainNavigationController.init(rootViewController: toolCtrl)
        toolNav.tabBarItem.title = "工具"
        toolNav.tabBarItem.image = nil
        toolNav.tabBarItem.selectedImage = nil

        let classRoomCtrl = HCClassRoomViewController()
        let classRoomNav = MainNavigationController.init(rootViewController: classRoomCtrl)
        classRoomNav.tabBarItem.title = "课堂"
        classRoomNav.tabBarItem.image = nil
        classRoomNav.tabBarItem.selectedImage = nil
        
        let mineCtrl = HCMineViewController()
        let mineNav = MainNavigationController.init(rootViewController: mineCtrl)
        mineCtrl.title = "个人中心"
        mineNav.tabBarItem.title = "我的"
        mineNav.tabBarItem.image = nil
        mineNav.tabBarItem.selectedImage = nil

        viewControllers = [homeNav, toolNav, classRoomNav, mineNav]
    }
}

extension HCTabBarViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
//        if selectedIndex == 1 {
//            if lastSelectedIndex != 1
//            {
//                lastSelectedIndex = 1
//                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
//                    self.lastSelectedIndex = NSNotFound
//                }
//            }else if lastSelectedIndex == 1
//            {
//                NotificationCenter.default.post(name: NotificationName.UserInterface.tabBarSelectedTwice, object: true)
//                lastSelectedIndex = NSNotFound
//            }
//        }else
//        {
//            lastSelectedIndex = selectedIndex
//        }
    }
}
