//
//  TYSearchRecordData.swift
//  HuChuangApp
//
//  Created by sw on 2019/10/9.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit
import SQLite

class TYSearchRecordModel {
    
    public var uid: String = userDefault.uid
    public var keyWord: String = ""
    
    init() { }
    
    convenience init(keyWord: String) {
        self.init()
        
        self.uid = userDefault.uid
        self.keyWord = keyWord
    }
    
    public var contentSize: CGSize {
        get {
            let w = keyWord.getTexWidth(fontSize: 12, height: 30, fontName: FontName.PingFMedium.rawValue) + 30
            return .init(width: w, height: 30)
        }
    }
}

private let uidEx = Expression<String>("uid")
private let keyWordEx = Expression<String>("keyWord")

extension TYSearchRecordModel: DBOperation {
    
    static func dbBind(_ builder: TableBuilder) {
        builder.column(uidEx)
        builder.column(keyWordEx)
    }
    
    static func insert(keyWord: String) {
        let setters = reloadSetters(keyWord: keyWord)
        // 插入数据之前先查询本地数据库是否存在该用户
        let filier = (uidEx == userDefault.uid)
        DBQueue.share.insterOrUpdateQueue(filier, setters, searchKeyWordTB, TYSearchRecordModel.self)
    }
    
    public class func selected(result: @escaping (([TYSearchRecordModel]?) ->Void)) {
        let filier = (uidEx == userDefault.uid)
        DBQueue.share.selectQueue(filier, searchKeyWordTB, TYSearchRecordModel.self) { table in
            result(mapModel(table))
        }
    }
    
    public class func clearSearchRecords() {
        let filier = (uidEx == userDefault.uid)
        DBQueue.share.deleteRowQueue(filier, searchKeyWordTB, TYSearchRecordModel.self)
    }
    
    private static func reloadSetters(keyWord: String) ->[Setter] {
        return [uidEx <- userDefault.uid,
                keyWordEx <- keyWord]
    }
    
    private static func mapModel(_ query: Table?) ->[TYSearchRecordModel]? {
        do {
            guard let db = TYSearchRecordModel.db else {
                return nil
            }
            guard let t = query else {
                return nil
            }
            var datas = [TYSearchRecordModel]()
            for res in try db.prepare(t) {
                let model = TYSearchRecordModel.init(keyWord: res[keyWordEx])
                model.uid = res[uidEx]
                datas.append(model)
            }
            return datas
        } catch {
            PrintLog("查询数据失败")
        }
        
        return nil
    }

}

class TYSearchSectionModel {
    
    public var sectionTitle: String = ""
    public var showDelete: Bool = false

    public var recordDatas: [TYSearchRecordModel] = []
    
    public class func recordsCreate(datas: [TYSearchRecordModel]?) ->[TYSearchSectionModel] {
        var sectionDatas: [TYSearchSectionModel] = []
        
        if let records = datas, records.count > 0 {
            let sectionRecordModel = TYSearchSectionModel()
            sectionRecordModel.recordDatas = records
            sectionRecordModel.sectionTitle = "搜索记录"
            sectionRecordModel.showDelete = true
            sectionDatas.append(sectionRecordModel)
        }
        
        let sectionHotModel = TYSearchSectionModel()
        sectionHotModel.recordDatas = [TYSearchRecordModel.init(keyWord: "不孕不育"),
                                       TYSearchRecordModel.init(keyWord: "卵巢肿瘤"),
                                       TYSearchRecordModel.init(keyWord: "月经失调")]
        sectionHotModel.sectionTitle = "热门搜索"
        sectionHotModel.showDelete = false
        sectionDatas.append(sectionHotModel)
                
        return sectionDatas
    }
    
    public func addRecord(keyWord: String) {
        recordDatas.append(TYSearchRecordModel.init(keyWord: keyWord))
    }
    
    public class func creatSection(sectionTitle: String, showDelete: Bool) ->TYSearchSectionModel {
        let section = TYSearchSectionModel()
        section.sectionTitle = sectionTitle
        section.showDelete = showDelete
        return section
    }
}
