//
//  VideoCallUserCell.swift
//  HuChuangApp
//
//  Created by yintao on 2020/11/6.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class VideoCallUserCell: UICollectionViewCell {
   
    var userModel = CallingUserModel() {
        didSet {
            configModel(model: userModel)
        }
    }
    
    func configModel(model: CallingUserModel) {
        let noModel = model.userId.count == 0
        if !noModel {
            if userModel.userId != V2TIMManager.sharedInstance()?.getLoginUser() ?? "" {
                if let render = HCConsultVideoCallController.getRenderView(userId: userModel.userId) {
                    if render.superview != self {
                        render.removeFromSuperview()
                        DispatchQueue.main.async {
                            render.frame = self.bounds
                        }
                        addSubview(render)
                        render.userModel = userModel
                    }
                } else {
                    print("error")
                }
            }
        }
    }
}
