//
//  UIImage+Color.swift
//  HuChuangApp
//
//  Created by sw on 2021/1/25.
//  Copyright © 2021 sw. All rights reserved.
//

import Foundation

extension UIImage {
    
    public static func image(with color: UIColor) ->UIImage? {
        let rect = CGRect(x:0,y:0,width:1,height:1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
