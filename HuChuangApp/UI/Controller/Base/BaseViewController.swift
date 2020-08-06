//
//  BaseNavigationController.swift
//  HuChuangApp
//
//  Created by sw on 02/02/2019.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BaseViewController: UIViewController {

    lazy var disposeBag: DisposeBag = { return DisposeBag() }()
        
    /// 导航栏和安全区域部分
    private var navBgView: UIView!
    private var bottomSafeBgView: UIView!
    
    public var navBarColor: UIColor = .white
    
    override func viewDidLoad() {
        super.viewDidLoad()

        edgesForExtendedLayout = .top
        setContentInsetAdjustmentBehaviorNever()
              
        view.backgroundColor = .white
        
        navBgView = UIView()
        navBgView.backgroundColor = .white
        view.insertSubview(navBgView, at: 0)
        
        bottomSafeBgView = UIView()
        bottomSafeBgView.isHidden = true
        bottomSafeBgView.backgroundColor = RGB(84, 197, 141)
        view.insertSubview(bottomSafeBgView, at: 1)

        setupUI()
        rxBind()
    }

    public var bottomSafeBgColor: UIColor? {
        didSet {
            bottomSafeBgView.backgroundColor = RGB(84, 197, 141)
        }
    }
    
    public var hiddenNavBg: Bool = false {
        didSet {
            navBgView.isHidden = hiddenNavBg
        }
    }
    
    public var hiddenBottomBg: Bool = false {
        didSet {
            bottomSafeBgView.isHidden = hiddenBottomBg
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var safeTopHeight = navigationController?.navigationBar.height ?? 0.0
        var safeBottomHeight: CGFloat = 0
        if #available(iOS 11, *) {
            safeTopHeight += view.safeAreaInsets.top
            safeBottomHeight = view.safeAreaInsets.bottom
        }
        navBgView.frame = .init(x: 0, y: 0, width: view.width, height: safeTopHeight)
        bottomSafeBgView.frame = .init(x: 0, y: view.height - safeBottomHeight, width: view.width, height: safeBottomHeight)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    final func setContentInsetAdjustmentBehaviorNever(contentView: UIScrollView? = nil) {
        if #available(iOS 11.0, *) {
            contentView?.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor = navBarColor

        if UIApplication.shared.statusBarStyle != .lightContent {
            UIApplication.shared.statusBarStyle = .lightContent
        }

        if UIApplication.shared.isStatusBarHidden == true {
            UIApplication.shared.isStatusBarHidden = false
        }
        navigationController?.setNavigationBarHidden(false, animated: animated)
//        let imageView = findHarilineImageViewUnder(view: (self.navigationController?.navigationBar)!)
//        imageView.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        fixTabBar()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if navigationController?.viewControllers.contains(self) == false {
//            toDeinit()
//            view.toDeinit()
        }
    }
    
    func findHarilineImageViewUnder(view: UIView) -> UIImageView {
        if view.isKind(of: UIImageView.self) && view.bounds.height <= 1.0{
            return view as! UIImageView
        } else {
            for subview in view.subviews {
                let imageView = self.findHarilineImageViewUnder(view: subview)
                
                return imageView
                
            }
        }
        return UIImageView()
    }

    deinit {
        PrintLog("\(self) ---- 已释放")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
