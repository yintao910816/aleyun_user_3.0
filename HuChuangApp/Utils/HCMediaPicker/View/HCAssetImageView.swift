//
//  HCAssetImageView.swift
//  HuChuangApp
//
//  Created by yintao on 2020/11/5.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCAssetImageView: UIImageView {

    public var asset: HCPhotoAsset? {
        didSet {
            if let img = asset?.image {
                image = img
            }else if let a = asset {
                HCAssetManager.loadImage(imageMode: .thumb, asset: a) { [weak self] in
                    self?.image = $0
                    self?.asset?.image = $0
                }
            }else {
                image = nil
            }
        }
    }
}
