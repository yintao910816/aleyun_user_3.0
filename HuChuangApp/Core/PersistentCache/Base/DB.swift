//
//  DBConfig.swift
//  StoryReader
//
//  Created by 020-YinTao on 2017/2/22.
//  Copyright © 2017年 020-YinTao. All rights reserved.
//

import Foundation

//MARK
//MARK: 数据基本配置
let dbPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!

let dbName = "hcdb.sqlite3"

let dbFullPath = "\(dbPath)/\(dbName)"

struct DBUtls {
    
}

//MARK
//MARK: 数据库表名

let userTB                = "HCUserTable"
// 搜索
let searchKeyWordTB         = "HCsearchKeyWordTable"
