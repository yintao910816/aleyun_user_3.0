//
//  HCMenstruationSettingViewModel.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/14.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

class HCMenstruationSettingViewModel: BaseViewModel {
    
    private var sectionDatas: [HCMenstruationSettingSection] = []
    private var menstruationModel: HCMenstruationModel?
    
    private let durationSignal = Variable("")
    private let cycleSignal = Variable("")

    public let listDatasource = Variable([HCMenstruationSettingSection]())
    public var enableCommitSignal: Driver<Bool>!
    
    init(tap: Driver<Void>) {
        super.init()
        
        let inputSignal = Driver.combineLatest(durationSignal.asDriver(), cycleSignal.asDriver()){ ($0, $1) }
        
        enableCommitSignal = inputSignal
            .map { [unowned self] data -> Bool in
                guard let model = self.menstruationModel else {
                    return data.0.count > 0 || data.1.count > 0
                }
                if "\(model.menstruationCycle)" == data.1, "\(model.menstruationDuration)" == data.0 {
                    return false
                }

                return data.0.count > 0 && data.1.count > 0
            }
        
        tap.withLatestFrom(inputSignal)
            ._doNext(forNotice: hud)
            .drive(onNext: { [unowned self] in self.requestSaveOrUpdateBasis(menstruationCycle: $0.1,
                                                                             menstruationDuration: $0.0) })
            .disposed(by: disposeBag)
                        
        reloadSubject
            .subscribe(onNext: { [unowned self] in self.requestGetMenstruationBasis() })
            .disposed(by: disposeBag)
    }
}

extension HCMenstruationSettingViewModel {
    
    private func requestGetMenstruationBasis() {
        prepareDatas()

        HCProvider.request(.getMenstruationBasis)
            .map(model: HCMenstruationModel.self)
            .subscribe(onSuccess: { [weak self] in
                self?.menstruationModel = $0
                self?.prepareDatas()
            }) { [weak self] in
                self?.hud.failureHidden(self?.errorMessage($0))
            }
            .disposed(by: disposeBag)
    }
    
    private func requestSaveOrUpdateBasis(menstruationCycle: String, menstruationDuration: String) {
        HCProvider.request(.saveOrUpdateBasis(menstruationCycle: menstruationCycle,
                                              menstruationDuration: menstruationDuration))
            .map(model: HCMenstruationModel.self)
            .subscribe { [weak self] _ in
                self?.hud.successHidden("设置成功", {
                    self?.popSubject.onNext(Void())
                })
            } onError: { [weak self] in
                self?.hud.failureHidden(self?.errorMessage($0))
            }
            .disposed(by: disposeBag)
    }
}

extension HCMenstruationSettingViewModel {
    
    private func prepareDatas() {
        sectionDatas.removeAll()
        
        let sectionTitles = ["您的月经大概持续几天", "两次月经开始大概间隔多久", "建议开启只能预测"]
        let rowTitles = ["经期长度", "周期长度", "使用智能预测"]
        
        let duration = menstruationModel?.menstruationDuration == nil || menstruationModel?.menstruationDuration == 0 ? "" : "\(menstruationModel!.menstruationDuration)"
        let cycle = menstruationModel?.menstruationCycle == nil || menstruationModel?.menstruationCycle == 0 ? "" : "\(menstruationModel!.menstruationCycle)"
        let rowDetailsTitles: [String] = [duration, cycle, ""]
        let identifier = [HCListDetailInputCell_identifier, HCListDetailInputCell_identifier, HCListSwitchCell_identifier]

        for idx in 0..<sectionTitles.count {
            let rowItem = HCListCellItem()
            rowItem.title = rowTitles[idx]
            rowItem.cellIdentifier = identifier[idx]
            rowItem.shwoArrow = false
            rowItem.detailTitle = rowDetailsTitles[idx]
            rowItem.detailInputTextAlignment = .right
            
            if rowTitles[idx] == "经期长度" {
                rowItem.textSignal.asDriver()
                    .drive(durationSignal)
                    .disposed(by: disposeBag)
            }
            
            if rowTitles[idx] == "周期长度" {
                rowItem.textSignal.asDriver()
                    .drive(cycleSignal)
                    .disposed(by: disposeBag)
            }
                    
            sectionDatas.append(HCMenstruationSettingSection.init(sectinoTitle: sectionTitles[idx], itemDatas: [rowItem]))
        }
        
        listDatasource.value = sectionDatas
    }
}
