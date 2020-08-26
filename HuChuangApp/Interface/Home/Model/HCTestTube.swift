//
//  HCTestTube.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/26.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation

class HCGroupCmsArticleModel: HJModel {
    var articleVoList: [HCArticleVoListItemModel] = []
    var name: String = ""
}

class HCArticleVoListItemModel: HJModel {
    var id: String = ""
    var picPath: String = ""
    var readNumber: String = ""
    var store: String = ""
    var title: String = ""
}
