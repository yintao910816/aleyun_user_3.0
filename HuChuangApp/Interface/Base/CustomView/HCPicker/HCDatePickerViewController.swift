//
//  HCDatePickerViewController.swift
//  HuChuangApp
//
//  Created by sw on 2019/9/26.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit

class HCDatePickerViewController: HCPicker {

    private var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerHeight = 250
        
        datePicker = UIDatePicker.init()
        datePicker.locale = Locale.init(identifier: "zh")
        
        datePicker.datePickerMode = .date
        datePicker.setDate(Date.init(), animated: false)
        datePicker.backgroundColor = .white
//        datePicker.maximumDate
        datePicker.addTarget(self, action: #selector(dateChange(picker:)), for: .valueChanged)
                
        containerView.addSubview(datePicker)
    }
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
    
        let containViewHeight: CGFloat = pickerHeight + 44
        containerView.frame = .init(x: 0, y: view.height - containViewHeight, width: view.width, height: containViewHeight)
        datePicker.frame = .init(x: 0, y: 44, width: containerView.width, height: 250)
        
        containerView.transform = CGAffineTransform.init(translationX: 0, y: containerView.height)
        
        show(animotion: true)
    }
    
    //MARK: - action
    @objc private func dateChange(picker: UIDatePicker) {

    }
    
    override func doneAction() {
        let formatter = DateFormatter.init()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateStr = formatter.string(from: datePicker.date)
        PrintLog("当前选择时间: \(dateStr)")

        finishSelected?((HCPickerAction.ok, dateStr))
        
        super.cancelAction()
    }
    
    override func cancelAction() {
        super.cancelAction()
        
        if isCustomCancel {
            let formatter = DateFormatter.init()
            formatter.dateFormat = "yyyy-MM-dd"
            let dateStr = formatter.string(from: datePicker.date)
            PrintLog("当前选择时间: \(dateStr)")

            finishSelected?((HCPickerAction.cancel, dateStr))
        }
    }
}
