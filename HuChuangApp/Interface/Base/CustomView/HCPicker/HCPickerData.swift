//
//  HCPickerData.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/17.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation

struct HCPickerSectionData {
    var items: [HCPickerItemModel] = []
    
    
    /// 创建体温数据
    public static func createTemperatureDatas() ->[HCPickerSectionData] {
        var intPart: [HCPickerItemModel] = []
        var floatPart: [HCPickerItemModel] = []
        let staticItem: [HCPickerItemModel] = [HCPickerItemModel(title: "°C")]

        for idx in 35...43 {
            intPart.append(HCPickerItemModel(title: "\(idx)"))
        }

        for idx in 0...99 {
            let idxString = idx < 10 ? ".0\(idx)" : ".\(idx)"
            floatPart.append(HCPickerItemModel(title: "\(idxString)"))
        }

        return [HCPickerSectionData(items: intPart),
                HCPickerSectionData(items: floatPart),
                HCPickerSectionData(items: staticItem)]
    }
    
    /// 创建体重数据
    public static func createWeightDatas() ->[HCPickerSectionData] {
        var intPart: [HCPickerItemModel] = []
        var floatPart: [HCPickerItemModel] = []
        let staticItem: [HCPickerItemModel] = [HCPickerItemModel(title: "kg")]

        for idx in 20...150 {
            intPart.append(HCPickerItemModel(title: "\(idx)"))
        }

        for idx in 0...99 {
            let idxString = idx < 10 ? ".0\(idx)" : ".\(idx)"
            floatPart.append(HCPickerItemModel(title: "\(idxString)"))
        }

        return [HCPickerSectionData(items: intPart),
                HCPickerSectionData(items: floatPart),
                HCPickerSectionData(items: staticItem)]
    }
}

struct HCPickerItemModel {
    var title: String = ""
}
