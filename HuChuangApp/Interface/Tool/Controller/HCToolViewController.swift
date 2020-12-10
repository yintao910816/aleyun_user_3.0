//
//  HCToolViewController.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/13.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCToolViewController: BaseViewController {

    private var containerView: HCToolViewContainer!
    private var titleView: HCNavBarTitleView!
    
    private var viewModel: HCToolViewModel!
    
    override func setupUI() {
        navigationItem.title = "工具"
        
        containerView = HCToolViewContainer.init(frame: .init(x: 0, y: 0, width: view.width, height: view.height))
        view.addSubview(containerView)
        
        containerView.didSelected = { [unowned self] in
            if $0.title == "经期设置" {
                self.navigationController?.pushViewController(HCMenstruationSettingViewController(), animated: true)
            }else if $0.title == "体温" {
                let picker = HCTemperaturePicker()
                picker.datasource = HCPickerSectionData.createTemperatureDatas()
                picker.pickerHeight = 230
                self.model(for: picker, controllerHeight: self.view.height)
                picker.finishSelected = { [unowned self] in
                    if $0.0 == .ok, $0.1.count > 0 {
                        self.viewModel.editTemperatureSignal.onNext($0.1)
                    }
                }
            }else if $0.title == "体重" {
                let picker = HCPickerView()
                picker.datasource = HCPickerSectionData.createWeightDatas()
                picker.pickerHeight = 230
                self.model(for: picker, controllerHeight: self.view.height)
                picker.finishSelected = { [unowned self] in
                    if $0.0 == .ok, $0.1.count > 0 {
                        self.viewModel.editWeightSignal.onNext($0.1)
                    }
                }
            }
        }
        
        titleView = HCNavBarTitleView.init(frame: .init(x: 0, y: 0, width: view.size.width - 120, height: 44), mode: .tool)
        titleView.titleContentView.titleFont = .font(fontSize: 18, fontName: .PingFMedium)
        navigationItem.titleView = titleView
        
        titleView.titleContentView.titleClicked = {
            let picker = HCDatePickerViewController()
            picker.pickerHeight = 230
//            if let before = TYDateFormatter.getDate(fromData: Date(), identifier: .previous),
//               let after = TYDateFormatter.getDate(fromData: Date(), identifier: .next){
//                picker.minimumDate = before
//                picker.maximumDate = after
//            }
            self.model(for: picker, controllerHeight: self.view.height)
            picker.finishSelected = { [unowned self] in
                if $0.0 == .ok, $0.1.count > 0 {
                    self.viewModel.reloadMenstruaSignal.onNext($0.1)
                }
                self.titleView.titleContentView.resetArrow()
            }
        }
    }
    
    override func rxBind() {
        viewModel = HCToolViewModel()
        
        addBarItem(title: "回今天", titleColor: RGB(51, 51, 51), right: false)
            .asDriver()
            .drive(viewModel.backTodaySignal)
            .disposed(by: disposeBag)
        
        viewModel.listItemsSignal.asDriver()
            .drive(onNext: { [weak self] in
                let datas = (self?.viewModel.selectedDayItem?.isAfterToday ?? true) == true ? [] : $0
                self?.containerView.reloadData(data: datas, selectedDayItem: self?.viewModel.selectedDayItem)
            })
            .disposed(by: disposeBag)
        
        viewModel.calendarDatasSignal.asDriver()
            .drive(onNext: { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.containerView.reloadCalendar(calendarDatas: $0,
                                                        currentPage: strongSelf.viewModel.currentPage)
            })
            .disposed(by: disposeBag)

        viewModel.navTitleChangeSignal
            .subscribe(onNext: { [weak self] in
                self?.titleView.titleContentView.title = $0
            })
            .disposed(by: disposeBag)
        
        containerView.dayItemSelectedSignal
            .bind(to: viewModel.dayItemSelectedSignal)
            .disposed(by: disposeBag)

        containerView.switchChangeSignal
            .bind(to: viewModel.switchChangeSignal)
            .disposed(by: disposeBag)

        containerView.didScrollSignal
            .bind(to: viewModel.didScrollSignal)
            .disposed(by: disposeBag)

        viewModel.reloadSubject.onNext(Void())
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        containerView.frame = view.bounds
    }
}
