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
    public static func createTemperatureDatas() ->([HCPickerSectionData], Int) {
        var intPart: [HCPickerItemModel] = []
        var floatPart: [HCPickerItemModel] = []
        let staticItem: [HCPickerItemModel] = [HCPickerItemModel(title: "°C")]

        for idx in 30...42 {
            intPart.append(HCPickerItemModel(title: "\(idx)"))
        }
        let selectedIdx: Int = intPart.firstIndex(where: { $0.title == "36" }) ?? 0

        for idx in 0...9 {
            let idxString = ".\(idx)"
            floatPart.append(HCPickerItemModel(title: "\(idxString)"))
        }

        let datas = [HCPickerSectionData(items: intPart),
                     HCPickerSectionData(items: floatPart),
                     HCPickerSectionData(items: staticItem)]
        return (datas, selectedIdx)
    }
    
    /// 创建体重数据
    public static func createWeightDatas() ->([HCPickerSectionData], Int) {
        var intPart: [HCPickerItemModel] = []
        var floatPart: [HCPickerItemModel] = []
        let staticItem: [HCPickerItemModel] = [HCPickerItemModel(title: "kg")]

        for idx in 20...120 {
            intPart.append(HCPickerItemModel(title: "\(idx)"))
        }
        let selectedIdx: Int = intPart.firstIndex(where: { $0.title == "50" }) ?? 0

        for idx in 0...99 {
            let idxString = idx < 10 ? ".0\(idx)" : ".\(idx)"
            floatPart.append(HCPickerItemModel(title: "\(idxString)"))
        }

        let datas = [HCPickerSectionData(items: intPart),
                     HCPickerSectionData(items: floatPart),
                     HCPickerSectionData(items: staticItem)]
        return (datas, selectedIdx)
    }
}

struct HCPickerItemModel {
    var title: String = ""
}
