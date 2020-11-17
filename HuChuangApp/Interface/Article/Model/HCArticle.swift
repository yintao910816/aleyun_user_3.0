//
//  HCArticle.swift
//  HuChuangApp
//
//  Created by yintao on 2020/11/17.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation

class HCShareArticleModel {
    var id: String = ""
    var title: String = ""
    var picPath: String = ""
    /// 分享链接
    var link: String = ""
    /// web链接
    var href: String = ""
}

extension HCShareArticleModel {
    /// cms文章详情model转分享模型
    public static func transformCmsModel(model: HCCmsDetailModel) ->HCShareArticleModel {
        let m = HCShareArticleModel()
        m.id = model.id
        m.title = model.title
        m.picPath = model.picPath
        m.link = model.hrefUrl
        m.href = model.hrefUrl
        return m
    }
}

class HCStoreAndStatusModel: HJModel {
    var store: Int = 0
    var status: Bool = false
}
