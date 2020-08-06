//
//  PageModel.swift
//  StoryReader
//
//  Created by 020-YinTao on 2016/12/9.
//  Copyright © 2016年 020-YinTao. All rights reserved.
//

import UIKit

class PageModel: NSObject {

    /// 当前页数
    public var currentPage  = 1
    /// 总共分页数
    public var totlePage    = 1
    /// 每页多少条数据
    public var pageSize     = 10
    // 总共数据条数
    public var totle        = 0
//
//    var offset: Int = 0
    
    public var hasNext: Bool {
        get {
            return currentPage < totlePage
        }
    }
    
    /// 发起请求传入的pageIndex
    internal func requestPage(refresh: Bool) ->Int {
        return refresh ? 1 : (currentPage + 1)
    }
    
//    /**
//     发起请求钱调用
//     */
//    public func setOffset(offset: Int) {
//        self.offset = offset
//    }
}
