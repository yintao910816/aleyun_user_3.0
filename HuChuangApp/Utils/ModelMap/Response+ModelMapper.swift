//
//  TResponse+ModelMapper.swift
//  StoryReader
//
//  Created by 020-YinTao on 2017/10/9.
//  Copyright © 2017年 020-YinTao. All rights reserved.
//

import Foundation
import Moya
import HandyJSON

public extension Response {
    
    internal func mapResponse() throws -> ResponseModel {
        guard let jsonDictionary = try mapJSON() as? NSDictionary else {
            throw MapperError.json(message: "json解析失败")
        }
        
        guard let serverModel = JSONDeserializer<ResponseModel>.deserializeFrom(dict: jsonDictionary) else {
            throw MapperError.json(message: "json解析失败")
        }
        
        if serverModel.code == RequestCode.success.rawValue {
            return serverModel
        }else {
            throw MapperError.server(message: serverModel.message)
        }
    }
    
    internal func map<T: HandyJSON>(model type: T.Type) throws -> T {
        guard let jsonDictionary = try mapJSON() as? NSDictionary else {
            throw MapperError.json(message: "json解析失败")
        }
        guard let serverModel = JSONDeserializer<DataModel<T>>.deserializeFrom(dict: jsonDictionary) else {
            throw MapperError.json(message: "json解析失败")
        }
        
        if serverModel.code == RequestCode.success.rawValue, let model = serverModel.data {
            return model
        }else {
            throw MapperError.server(message: serverModel.message)
        }
    }
    
    internal func map<T: HandyJSON>(model type: T.Type) throws -> [T] {
        guard let jsonDictionary = try mapJSON() as? NSDictionary else {
            throw MapperError.json(message: "json解析失败")
        }
        guard let serverModel = JSONDeserializer<DataModel<[T]>>.deserializeFrom(dict: jsonDictionary) else {
            throw MapperError.json(message: "json解析失败")
        }
    
        if serverModel.code == RequestCode.success.rawValue, let models = serverModel.data {
            return models
        }else {
            throw MapperError.server(message: serverModel.message)
        }
    }
    
    internal func map<T: HandyJSON>(result type: T.Type) throws -> DataModel<T> {
        guard let jsonDictionary = try mapJSON() as? NSDictionary else {
            throw MapperError.json(message: "json解析失败")
        }
        
        guard let serverModel = JSONDeserializer<DataModel<T>>.deserializeFrom(dict: jsonDictionary) else {
            throw MapperError.json(message: "json解析失败")
        }
        
        return serverModel
//        if serverModel.code == RequestCode.success.rawValue {
//            return serverModel
//        }else {
//            throw MapperError.server(message: serverModel.message)
//        }
    }
    
    internal func map<T: HandyJSON>(result type: T.Type) throws -> DataModel<[T]> {
        guard let jsonDictionary = try mapJSON() as? [String: Any] else {
            throw MapperError.json(message: "json解析失败")
        }
        
        guard let serverModel = JSONDeserializer<DataModel<[T]>>.deserializeFrom(dict: jsonDictionary) else {
            throw MapperError.json(message: "json解析失败")
        }

        if serverModel.code == RequestCode.success.rawValue {
            return serverModel
        }else {
            throw MapperError.server(message: serverModel.message)
        }
    }
   
    internal func map<T: HandyJSON>(model type: T.Type, transformKey: String, transformModelKey: String) throws -> [T] {
        guard let jsonDictionary = try mapJSON() as? [String: Any] else {
            throw MapperError.json(message: "json解析失败")
        }

        var newJson: [String : Any] = [:]
        for item in jsonDictionary {
            if item.key != "data" {
                newJson[item.key] = item.value
            }
        }
        
        var dataJson: [[String: Any]] = []
        var order: [String] = []
        if let d = jsonDictionary["data"] as? [String: Any] {
            order.append(contentsOf: d.keys)
            order = order.sorted(by: { (s1, s2) -> Bool in
                return s1 > s2
            })
            
            for idx in 0..<order.count {
                dataJson.append([transformKey: order[idx], transformModelKey: d[order[idx]]!])
            }            
        }
        
        newJson["data"] = dataJson
        
        guard let serverModel = JSONDeserializer<DataModel<[T]>>.deserializeFrom(dict: newJson) else {
            throw MapperError.json(message: "json解析失败")
        }
    
        if serverModel.code == RequestCode.success.rawValue, let models = serverModel.data {
            return models
        }else {
            throw MapperError.server(message: serverModel.message)
        }
    }
}

enum MapperError: Swift.Error {
    case ok(message: String?)
    case json(message: String?)
    case server(message: String?)
}

extension MapperError {
    
    public var message: String {
        switch self {
        case .ok(let text):
            return (text ?? "操作成功!")
        case .json(let text):
            return (text ?? "解析失败！")
        case .server(let text):
            return text ?? "错误：52000"
        }
    }
}
