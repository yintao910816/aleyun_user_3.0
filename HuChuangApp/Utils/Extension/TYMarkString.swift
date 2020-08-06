//
//  TYMarkLabel.swift
//  HuChuangApp
//
//  Created by yintao on 2019/12/11.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit

// MARK: 绘制图片
extension UIImage {
        
    static func from(color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        context?.clip(to: .init(origin: .zero, size: size))
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }

    /**
     设置是否是圆角
     - parameter radius: 圆角大小
     - parameter size:   size
     - returns: 圆角图片
     */
    func roundCorner(radius:CGFloat,size:CGSize) -> UIImage {
      let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
      //开始图形上下文
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
      //绘制路线
        guard let ctx = UIGraphicsGetCurrentContext() else {
            return UIImage()
        }
        ctx.addPath(UIBezierPath(roundedRect: rect,
                                 byRoundingCorners: UIRectCorner.allCorners,
                                 cornerRadii: CGSize(width: radius, height: radius)).cgPath)
      //裁剪
        ctx.clip()
      //将原图片画到图形上下文
        self.draw(in: rect)
        ctx.drawPath(using: .fillStroke)
      let output = UIGraphicsGetImageFromCurrentImageContext();
      //关闭上下文
      UIGraphicsEndImageContext();
      return output ?? UIImage()
    }

}


extension String {
    
    public func prepare(markColor: UIColor, textColor: UIColor, textFont: UIFont) ->NSAttributedString {
        let image = UIImage.from(color: markColor, size: .init(width: 5, height: 5))
        return prepare(markImage: image, textColor: textColor, textFont: textFont, isRound: true)
    }

    public func prepare(markImage: UIImage?, textColor: UIColor, textFont: UIFont, isRound: Bool) ->NSAttributedString {
        let imageSize: CGFloat = 8
        let roundImage = markImage?.roundCorner(radius: isRound ? imageSize / 2.0 : 0.0, size: .init(width: imageSize, height: imageSize))
        
        let markLabelText = "  \(self)"
        let markAttribute = NSMutableAttributedString(string: markLabelText)
        
        if roundImage != nil {
            let markattch = NSTextAttachment() //定义一个attachment
            markattch.image = roundImage//初始化图片
            markattch.bounds = CGRect(x: 0, y: -1, width: imageSize, height: imageSize) //初始化图片的 bounds
            let markattchStr = NSAttributedString(attachment: markattch) // 将attachment  加入富文本中
            markAttribute.insert(markattchStr, at: 0)// 将markattchStr  加入原有文字的某个位置
            
            markAttribute.addAttribute(NSAttributedString.Key.foregroundColor,
                                       value:textColor, range: NSRange(location: markattchStr.length, length: markLabelText.count))
        }else {
            markAttribute.addAttribute(NSAttributedString.Key.foregroundColor,
                                       value:textColor, range: NSRange(location: 0,length: self.count))
        }
        
        return markAttribute
    }
}
