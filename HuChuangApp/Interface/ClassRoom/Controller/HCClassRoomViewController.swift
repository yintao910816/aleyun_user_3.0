//
//  HCCircleViewController.swift
//  HuChuangApp
//
//  Created by sw on 02/02/2019.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit

class HCClassRoomViewController: BaseViewController {

    private var viewModel: HCClassRoomViewModel!
    private var container: HCClassRoomContainer!
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func setupUI() {
        view.backgroundColor = .white
                       
        container = HCClassRoomContainer.init(frame: view.bounds)
        view.addSubview(container)
    }
    
    override func rxBind() {
        viewModel = HCClassRoomViewModel.init()
        
        viewModel.reloadSignal
            .subscribe(onNext: { [weak self] in self?.container.reload(with: $0.0, bannerDatas: $0.1) })
            .disposed(by: disposeBag)
        
        viewModel.reloadSubject.onNext(Void())
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        container.frame = view.bounds
    }
}
