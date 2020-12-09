//
//  HCTemperaturePicker.swift
//  HuChuangApp
//
//  Created by yintao on 2020/12/7.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCTemperaturePicker: HCPickerView {

    private var selectedInfo: [Int: Int] = [0: 0, 1: 0]
        
    override func doneAction() {
        if let firstRow = selectedInfo[0], let secondRow = selectedInfo[1], datasource.count >= 2 {
            let text = datasource[0].items[firstRow].title + datasource[1].items[secondRow].title
            PrintLog("选中温度：\(text)")
            finishSelected?((.ok, text))
        }
        super.cancelAction()
    }
    
    override func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        super.pickerView(pickerView, didSelectRow: row, inComponent: component)
        
        if component != 2 {
            selectedInfo[component] = row
        }
    }
}
