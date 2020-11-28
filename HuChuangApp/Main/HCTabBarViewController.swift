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
        if #available(iOS 13.0, *) {
            tabBar.tintColor = RGB(51, 51, 51)
            tabBar.unselectedItemTintColor = RGB(51, 51, 51)
        }else {
            UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor : RGB(51, 51, 51)], for: .normal)
            UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor : RGB(51, 51, 51)], for: .selected)
        }

        let homeCtrl = HCHomeViewController()
        let homeNav = MainNavigationController.init(rootViewController: homeCtrl)
        homeNav.tabBarItem.title = "首页"
        homeNav.tabBarItem.image = UIImage(named: "tabBar_home_unselected")
        homeNav.tabBarItem.selectedImage = UIImage(named: "tabBar_home_selected")

//        let toolCtrl = HCToolViewController()
//        let toolNav = MainNavigationController.init(rootViewController: toolCtrl)
//        toolNav.tabBarItem.title = "工具"
//        toolNav.tabBarItem.image = UIImage(named: "tabBar_tool_unselected")
//        toolNav.tabBarItem.selectedImage = UIImage(named: "tabBar_tool_selected")
//        toolNav.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : RGB(51, 51, 51)], for: .normal)
//        toolNav.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : RGB(51, 51, 51)], for: .selected)

//        let classRoomCtrl = HCClassRoomViewController()
//        let classRoomNav = MainNavigationController.init(rootViewController: classRoomCtrl)
//        classRoomNav.tabBarItem.title = "课堂"
//        classRoomNav.tabBarItem.image = UIImage(named: "tabBar_classRoom_unselected")
//        classRoomNav.tabBarItem.selectedImage = UIImage(named: "tabBar_classRoom_selected")

        let mineCtrl = HCMineViewController()
        let mineNav = MainNavigationController.init(rootViewController: mineCtrl)
        mineCtrl.title = "个人中心"
        mineNav.tabBarItem.title = "我的"
        mineNav.tabBarItem.image = UIImage(named: "tabBar_mine_unselected")
        mineNav.tabBarItem.selectedImage = UIImage(named: "tabBar_mine_selected")
        
        viewControllers = [homeNav, mineNav]
//        viewControllers = [homeNav, toolNav, classRoomNav, mineNav]
    }
}

extension HCTabBarViewController: UITabBarControllerDelegate {
    
//    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
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
//    }
}
