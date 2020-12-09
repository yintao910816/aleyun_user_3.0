//
//  UIView+_Rx.swift
//  StoryReader
//
//  Created by 020-YinTao on 2017/4/18.
//  Copyright © 2017年 020-YinTao. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

extension Reactive where Base: UIView {

    ///
    public var alpha: Binder<Bool> {
        return Binder(self.base) { view, enable in
            view.alpha = enable ? 1.0 : 0.5
        }
    }
    
}

extension Reactive where Base: UIControl {

    public var rx_selected: Binder<Bool> {
        return Binder(self.base) { control, selected in
            control.isSelected = selected
        }
    }
}

extension Reactive where Base: UIBarButtonItem {

    public var rx_enable: Binder<Bool> {
        return Binder(self.base) { item, enable in
            item.isEnabled = enable
            if let button = item.customView as? UIButton {
                button.setTitleColor(enable ? HC_MAIN_COLOR : RGB(51, 51, 51), for: .normal)
            }else {
                item.tintColor = enable ? HC_MAIN_COLOR : RGB(51, 51, 51)
            }
        }
    }
}

extension Reactive where Base: UITextField {

    public var isSecureTextEntry: Binder<Bool> {
        return Binder(self.base) { tf, secure in
            tf.isSecureTextEntry = secure
        }
    }
}

extension Reactive where Base: UIImageView {

    public var image: Binder<UIImage?> {
        return Binder(self.base) { imageView, image in
            imageView.image = image
        }
    }
    
    func image(forStrategy model: ImageStrategy = .userIconWomen) -> Binder<String?> {
        return Binder(self.base) { view, url in
            view.setImage(url, model)
        }
    }
}

extension Reactive where Base: UIButton {
    
    public var image: Binder<UIImage?> {
        return Binder(self.base) { view, image in
            view.setImage(image, for: .normal)
        }
    }
    
    func image(forStrategy model: ImageStrategy = .userIconWomen) -> Binder<String> {
        return Binder(self.base) { view, url in
            view.setImage(url, model)
        }
    }
}

extension Reactive where Base: UINavigationController {
    
    public var navgationBarItemTitle: Binder<(Bool, String)> {
        return Binder(self.base) { navigationController, param in
            PrintLog("当前位置设置为：\(param.1)")
            if param.0 == true {
                navigationController.navigationItem.rightBarButtonItem?.title = param.1
            }else {
                navigationController.navigationItem.leftBarButtonItem?.title = param.1
            }
        }
    }
}

