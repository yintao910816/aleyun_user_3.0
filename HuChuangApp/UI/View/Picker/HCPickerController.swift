//
//  HCTemperaturePickerController.swift
//  HuChuangApp
//
//  Created by sw on 2019/12/20.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit

class HCPickerController: HCPicker {

    private var selectedComponent: Int = 0
    private var selectedRow: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        modalPresentationStyle = .fullScreen
    }
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        
        let containViewHeight = pickerHeight + 44
        containerView.frame = .init(x: 0, y: view.height - containViewHeight, width: view.width, height: containViewHeight)

        picker.frame = .init(x: 0, y: 44, width: containerView.width, height: pickerHeight)

        containerView.addSubview(picker)
        
        containerView.transform = .init(translationX: 0, y: pickerHeight + 44)

        show(animotion: true)
    }

    override func doneAction() {
        let intRow = picker.selectedRow(inComponent: 0)
        let floatRow = picker.selectedRow(inComponent: 1)
        let selectedContent = "\(sectionModel.sectionData[0][intRow].title)\(sectionModel.sectionData[1][floatRow].title)"
        finishSelected?((HCPickerAction.ok, selectedContent))
        
        cancelAction()
    }
    
    public var sectionModel: HCPickerSectionData! {
        didSet {
            picker.reloadAllComponents()
        }
    }
    
    //MARK: - lazy
    private lazy var picker: UIPickerView = {
        let p = UIPickerView()
        p.backgroundColor = .white
        p.delegate = self
        p.dataSource = self
        return p
    }()

    override var pickerHeight: CGFloat {
        didSet {
            var frame = picker.frame
            frame.size.height = pickerHeight
            picker.frame = frame
            
            frame = containerView.frame
            frame.size.height = pickerHeight + 44
            frame.origin.y = view.width - (frame.size.height)
            containerView.frame = frame
            
            containerView.transform = .init(translationX: 0, y: pickerHeight + 44)
        }
    }

}

extension HCPickerController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return sectionModel.sectionData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sectionModel.sectionData[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 1 {
            return "\(sectionModel.sectionData[component][row].title)℃"
        }
        return sectionModel.sectionData[component][row].title
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
        
}

struct HCPickerSectionData {
    var sectionData: [[HCPickerItemModel]] = []
    
    public static func createTemperature() ->HCPickerSectionData {
        var intPart: [HCPickerItemModel] = []
        var floatPart: [HCPickerItemModel] = []

        for idx in 35...38 {
            intPart.append(HCPickerItemModel(title: "\(idx)"))
        }
        
        for idx in 0...99 {
            let idxString = idx < 10 ? ".0\(idx)" : ".\(idx)"
            floatPart.append(HCPickerItemModel(title: "\(idxString)"))
        }
        
        return HCPickerSectionData(sectionData: [intPart, floatPart])
    }
}

struct HCPickerItemModel {
    var title: String = ""
}
