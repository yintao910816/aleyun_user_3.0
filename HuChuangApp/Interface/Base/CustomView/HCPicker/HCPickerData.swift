//
//  HCPickerData.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/17.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation

struct HCPickerSection {
    var items: [HCPickerItemModel] = []
    
//    public static func createTemperature() ->HCPickerSectionData {
//        var intPart: [HCPickerItemModel] = []
//        var floatPart: [HCPickerItemModel] = []
//
//        for idx in 35...38 {
//            intPart.append(HCPickerItemModel(title: "\(idx)"))
//        }
//
//        for idx in 0...99 {
//            let idxString = idx < 10 ? ".0\(idx)" : ".\(idx)"
//            floatPart.append(HCPickerItemModel(title: "\(idxString)"))
//        }
//
//        return HCPickerSectionData(sectionData: [intPart, floatPart])
//    }
}

struct HCPickerItemModel {
    var title: String = ""
}
