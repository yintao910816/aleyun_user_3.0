//
//  AppLaunchView.swift
//  StoryReader
//
//  Created by 020-YinTao on 2017/7/31.
//  Copyright © 2017年 020-YinTao. All rights reserved.
//

import UIKit

class AppLaunchView: UIView {

    fileprivate var imageSource: [String]!
    
    override init(frame: CGRect) {
        let aframe = UIScreen.main.bounds
        super.init(frame: aframe)

//        imageSource = UIDevice.current.isX == true ? ["guide_x_01", "guide_x_02", "guide_x_03", "guide_x_04", "guide_x_05"]
//            : ["guide_01", "guide_02", "guide_03", "guide_04", "guide_05"]
        imageSource = ["launch_01", "launch_02"]

        addSubview(scroll)
        addImageView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        PrintLog("释放了 \(self)")
    }
    //MARK:
    //MARK: public
    public func show() {
        let awindow = UIApplication.shared.delegate?.window!
        awindow?.addSubview(self)
        awindow?.bringSubviewToFront(self)
        
        userDefault.lanuchStatue = vLaunch
    }
    
    //MARK:
    //MARK: private
    private func addImageView() {
        for idx in 0..<imageSource.count {
            let path = imageSource[idx]
//            let imgView = UIImageView.init(image: UIImage.init(contentsOfFile: path))
            let imgView = UIImageView.init(image: UIImage.init(named: path))
            let x = bounds.width * CGFloat(idx)
            imgView.frame = CGRect.init(x: x, y: 0, width: bounds.width, height: bounds.height)
            imgView.contentMode = .scaleAspectFill
            imgView.clipsToBounds = true
            scroll.addSubview(imgView)
            
            if idx == imageSource.count - 1 {
                imgView.isUserInteractionEnabled = true
                imgView.addGestureRecognizer(tapGes)
            }
        }
    }
    
    // 隐藏引导页
    @objc private func hiddenSelf() {
        let animotion = CABasicAnimation.init(keyPath: "opacity")
        animotion.delegate = self
        animotion.fromValue = NSNumber.init(value: 1.0)
        animotion.toValue   = NSNumber.init(value: 0.0)
        animotion.duration  = 0.2
        //以下两行同时设置才能保持移动后的位置状态不变
        animotion.fillMode = CAMediaTimingFillMode.forwards
        animotion.isRemovedOnCompletion = false
        layer.add(animotion, forKey: "GuideView")
    }
    
    //MARK:
    //MARK: lazy
    lazy var scroll: UIScrollView = {
        let _scroll = UIScrollView.init(frame: self.bounds)
        _scroll.showsHorizontalScrollIndicator = false
        _scroll.isPagingEnabled = true
        _scroll.bounces         = false
        _scroll.contentSize     = CGSize.init(width: self.bounds.size.width * CGFloat(self.imageSource.count), height: self.bounds.size.height)
        return _scroll
    }()
    
    lazy var tapGes: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(hiddenSelf))
        return tap
    }()

}

extension AppLaunchView: CAAnimationDelegate {
    
    //MARK:
    //MARK: CAAnimationDelegate
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        imageSource.removeAll()
        removeFromSuperview()
        layer.removeAllAnimations()
    }
    
}
