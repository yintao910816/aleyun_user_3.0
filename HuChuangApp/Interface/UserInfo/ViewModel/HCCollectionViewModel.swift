//
//  HCCollectionViewModel.swift
//  HuChuangApp
//
//  Created by yintao on 2020/8/21.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation

class HCCollectionViewModel: RefreshVM<HCAttentionStoreModel> {
    
    // 记录当前第几页数据
    private var page: Int = 0

    override init() {
        super.init()
        
        requestData(true)
    }
    
    override func requestData(_ refresh: Bool) {
        
        updatePage(for: "\(page)", refresh: refresh)
        var signal = HCProvider.request(.attentionStore(moduleType: .information, pageNum: currentPage(for: "\(page)"), pageSize: pageSize(for: "\(page)")))
            .mapJSON()
        if page == 0 {
            
        }else {
            
        }
        
        signal
            .subscribe(onSuccess: { res in
                
            })
        .disposed(by: disposeBag)
        
//        if page == 0 {
//            //            signal = HCProvider.request(.allChannelArticle(cmsType: .webCms001, pageNum: currentPage(for: "\(page)"), pageSize: pageSize(for: "\(page)")))
//            //                .map(model: HCArticlePageDataModel.self)
//        }
//
//        signal.subscribe(onSuccess: { [weak self] data in
//            guard let strongSelf = self else { return }
//            if strongSelf.menuPageListData[strongSelf.page] == nil {
//                strongSelf.menuPageListData[strongSelf.page] = [HCArticleItemModel]()
//            }
//            strongSelf.updateRefresh(refresh: refresh, models: data.records, dataModels: &(strongSelf.menuPageListData[strongSelf.page])!, pages: data.pages, pageKey: "\(strongSelf.page)")
//            self?.pageListData.onNext((strongSelf.menuPageListData[strongSelf.page]!, strongSelf.page))
//        }) { [weak self] error in
//            guard let strongSelf = self else { return }
//            strongSelf.revertCurrentPageAndRefreshStatus(pageKey: "\(strongSelf.page)")
//        }
//        .disposed(by: disposeBag)
        
    }
    
}
