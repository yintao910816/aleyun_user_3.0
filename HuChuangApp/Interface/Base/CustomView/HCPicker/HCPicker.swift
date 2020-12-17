//
//  HCPickerView.swift
//  HuChuangApp
//
//  Created by sw on 2019/9/25.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit

class HCPickerView: HCPicker {

    public var selectedComponent: Int = 0
    public var selectedRow: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        modalPresentationStyle = .fullScreen
        
        containerView.addSubview(picker)
    }
        
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let containViewHeight = pickerHeight + 44
        containerView.frame = .init(x: 0, y: view.height - containViewHeight, width: view.width, height: containViewHeight)

        picker.frame = .init(x: 0, y: 44, width: containerView.width, height: pickerHeight)
    }
    
    override func doneAction() {
        finishSelected?((.ok, datasource[selectedComponent].items[selectedRow].title))
        super.doneAction()
    }
    
    //MARK: - lazy
    private lazy var picker: UIPickerView = {
        let p = UIPickerView()
        p.backgroundColor = .white
        p.delegate = self
        p.dataSource = self
        return p
    }()
    
    //MARK: - interface
    public var datasource: [HCPickerSectionData] = [] {
        didSet {
            picker.reloadAllComponents()
        }
    }
    
    public func selectRow(_ row: Int, inComponent component: Int, animated: Bool) {
        selectedComponent = component
        selectedRow = row
        picker.selectRow(row, inComponent: component, animated: animated)
    }
        
    override var pickerHeight: CGFloat {
        didSet {
            view.setNeedsLayout()
            view.layoutIfNeeded()
        }
    }
}

extension HCPickerView: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return datasource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return datasource[component].items.count
    }
        
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        selectedComponent = component
        selectedRow = row
        
//        if component == 0 {
//            let label = picker.view(forRow: row, forComponent: component) as? UILabel
//            label?.textColor = .red
//        }
    }
    
//    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
//
//        var lable: UILabel? = (view as? UILabel)
//        if lable == nil {
//            lable = UILabel()
//            lable?.textAlignment = .center
//            lable?.font = UIFont.font(fontSize: 15)
//            lable?.backgroundColor = .clear
//        }
//
////        if component == selectedComponent && row == selectedRow {
////            lable?.textColor = .red
////        }else {
//            lable?.textColor = .black
////        }
//
//        lable?.text = component == 0 ? datasource[row] : "天"
//
//        return lable!
//    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return datasource[component].items[row].title
    }
}


public enum HCPickerAction {
    case cancel
    case leftItemAction
    case ok
}

class HCPicker: UIViewController {
        
    public var toolBar: UIToolbar!
    public var tapGes: UITapGestureRecognizer!
    public var containerView: UIView!
    public var cancelButton: UIButton!
    public var doneButton: UIButton!

    public var titleDes: String = ""
    public var cancelTitle: String = "取消"
    public var okTitle: String = "完成"
    /// 取消按钮是否有除了隐藏picker的其它功能
    public var isCustomCancel: Bool = false

    public var finishSelected: (((HCPickerAction, String))->())?

    public var pickerHeight: CGFloat = 150
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ///
        containerView = UIView.init(frame: .init(x: 0, y: view.height - self.pickerHeight - 44, width: view.width, height: self.pickerHeight + 44))
        containerView.backgroundColor = .white
        view.addSubview(containerView)
        
        toolBar = UIToolbar.init()
        
        cancelButton = UIButton.init(frame: .init(x: 0, y: 0, width: 40, height: 44))
        cancelButton.setTitle(cancelTitle, for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        cancelButton.setTitleColor(.black, for: .normal)
        cancelButton.titleLabel?.font = .font(fontSize: 15, fontName: .PingFMedium)
                
        let titleLable = UILabel.init(frame: .init(x: 0, y: 0, width: view.width - 80, height: 44))
        titleLable.font = .font(fontSize: 14)
        titleLable.textAlignment = .center
        titleLable.textColor = .black
        titleLable.text = titleDes

        doneButton = UIButton.init(frame: .init(x: 0, y: 0, width: 40, height: 44))
        doneButton.setTitle(okTitle, for: .normal)
        doneButton.addTarget(self, action: #selector(doneAction), for: .touchUpInside)
        doneButton.setTitleColor(.black, for: .normal)
        doneButton.titleLabel?.font = .font(fontSize: 15, fontName: .PingFMedium)

        toolBar.items = [UIBarButtonItem.init(customView: cancelButton),
                         UIBarButtonItem.init(customView: titleLable),
                         UIBarButtonItem.init(customView: doneButton)]

        containerView.addSubview(toolBar)
        toolBar.frame = .init(x: 0, y: 0, width: view.width, height: 44)
        
        ///
        tapGes = UITapGestureRecognizer.init(target: self, action: #selector(tapAction))
        tapGes.delegate = self
        view.addGestureRecognizer(tapGes)
    }
    
    @objc func tapAction() {
        finishSelected?((HCPickerAction.cancel, ""))
        dismiss(animated: true, completion: nil)
    }
    
    @objc func cancelAction() {
        if !isCustomCancel {
            finishSelected?((HCPickerAction.leftItemAction, ""))
        }
        dismiss(animated: true, completion: nil)
    }
    
    @objc func doneAction() {
        dismiss(animated: true, completion: nil)
    }
        
}

extension HCPicker: UIGestureRecognizerDelegate {

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return !containerView.frame.contains(gestureRecognizer.location(in: view))
    }
}
