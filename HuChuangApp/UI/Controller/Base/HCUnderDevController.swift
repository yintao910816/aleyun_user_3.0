//
//  HCUnderDevController.swift
//  HuChuangApp
//
//  Created by yintao on 2020/11/17.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCUnderDevController: BaseViewController {

    private var contentView: UIView!
    private var remindImgV: UIImageView!
    private var remindLabel: UILabel!
    
    private var remindText: String = "开发小哥哥正在努力研发中，敬请期待！"
    
    public class func ctrlCreat(remindText: String? = nil, navTitle: String)->HCUnderDevController {
        let ctr = HCUnderDevController.init(nibName: nil, bundle: nil, remindText: remindText)
        ctr.navigationItem.title = navTitle
        return ctr
    }
    
    init(nibName nibNameOrNil: String? = nil, bundle nibBundleOrNil: Bundle? = nil, remindText: String? = nil) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        if let rt = remindText, rt.count > 0 {
            self.remindText = rt
        }
    }
        
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func setupUI() {
        contentView = UIView()
        contentView.backgroundColor = view.backgroundColor
        
        remindImgV = UIImageView(image: UIImage.init(named: "underDev"))
        
        remindLabel = UILabel()
        remindLabel.textColor = RGB(154, 159, 180)
        remindLabel.font = .font(fontSize: 14)
        remindLabel.text = remindText
        remindLabel.textAlignment = .center
        
        view.addSubview(contentView)
        contentView.addSubview(remindImgV)
        contentView.addSubview(remindLabel)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let imgSize: CGSize = remindImgV.image?.size ?? .init(width: 160, height: 100)
        let contentH: CGFloat = imgSize.height + 35 + 20
        
        contentView.frame = .init(x: 0,
                                  y: (view.height - contentH) / 2,
                                  width: view.width,
                                  height: contentH)
        remindImgV.frame = .init(x: (contentView.width - imgSize.width) / 2.0,
                                 y: 0,
                                 width: imgSize.width,
                                 height: imgSize.height)
        remindLabel.frame = .init(x: 15,
                                  y: remindImgV.frame.maxY + 35,
                                  width: contentView.width - 30,
                                  height: 20)
    }
}
