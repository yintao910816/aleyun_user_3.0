//
//  HomeViewModel.swift
//  HuChuangApp
//
//  Created by sw on 02/02/2019.
//  Copyright © 2019 sw. All rights reserved.
//

import Foundation
import RxSwift

class HomeViewModel: RefreshVM<HCArticleItemModel>, VMNavigation {
    
    var bannerModelObser = Variable([HomeBannerModel]())
    var articleModels: [HCArticleItemModel] = []
    var pregnancyProbabilityData = HCPregnancyProbabilityModel()

    /// 设置右上角消息数量提醒
    var unreadCountObser = Variable(("", CGFloat(0.0)))
    
    let goodnewsDidSelected = PublishSubject<Int>()
    let gotoPageHomeSubject = PublishSubject<Void>()

    let messageListPublish = PublishSubject<UINavigationController?>()
    let refreshUnreadPublish = PublishSubject<Void>()
    let refreshCollectionView = PublishSubject<Void>()

    private var articleTypeID: String = ""

    override init() {
        super.init()
        messageListPublish
            ._doNext(forNotice: hud)
            .flatMap{ [unowned self] _ in self.requestH5(type: .notification) }
            .subscribe(onNext: { [unowned self] model in
                self.hud.noticeHidden()
                self.pushH5(model: model)
                }, onError: { error in
                    self.hud.failureHidden(self.errorMessage(error))
            })
            .disposed(by: disposeBag)
        
        goodnewsDidSelected
            ._doNext(forNotice: hud)
            .flatMap{ [unowned self] _ in self.requestH5(type: .goodNews) }
            .subscribe(onNext: { [unowned self] model in
                self.hud.noticeHidden()
                self.pushH5(model: model)
            }, onError: { error in
                self.hud.failureHidden(self.errorMessage(error))
            })
            .disposed(by: disposeBag)
                
        refreshUnreadPublish
            .subscribe(onNext: { [unowned self] in
                self.requestUnread()
            })
            .disposed(by: disposeBag)

        gotoPageHomeSubject
            .subscribe(onNext: { [weak self] in
                self?.gotoPageHome()
            })
            .disposed(by: disposeBag)

        NotificationCenter.default.rx.notification(NotificationName.User.LoginSuccess)
            .subscribe(onNext: { [weak self] data in
                self?.requestData(true)
            })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(NotificationName.UserInterface.jsReloadHome)
            .subscribe(onNext: { [weak self] data in
                self?.requestData(true)
            })
            .disposed(by: disposeBag)
    }
    
    override func requestData(_ refresh: Bool) {
        super.requestData(refresh)

        if refresh {
            /// 加载未读消息
            requestUnread()

            Observable.combineLatest(requestBanner(),
                                     requestPregnancyProbability(),
                                     requestChannelArticle()){ ($0, $1, $2) }
                .subscribe(onNext: { [weak self] data in
                    guard let strongSelf = self else { return }
                    strongSelf.bannerModelObser.value = data.0
                    strongSelf.pregnancyProbabilityData = data.1
                    strongSelf.updateRefresh(refresh, data.2.records, data.2.pages)
                    strongSelf.articleModels = strongSelf.datasource.value
                    strongSelf.refreshCollectionView.onNext(Void())
                    }, onError: { [unowned self] error in
                        self.hud.failureHidden(self.errorMessage(error))
                        self.revertCurrentPageAndRefreshStatus()
                })
                .disposed(by: disposeBag)
        }else {
            requestChannelArticle()
                .subscribe(onNext: { [weak self] data in
                    guard let strongSelf = self else { return }
                    strongSelf.updateRefresh(refresh, data.records, data.pages)
                    strongSelf.articleModels = strongSelf.datasource.value
                    strongSelf.refreshCollectionView.onNext(Void())
                }, onError: { [weak self] error in
                    self?.hud.failureHidden(self?.errorMessage(error))
                    self?.revertCurrentPageAndRefreshStatus()
                })
                .disposed(by: disposeBag)
        }
    }
        
    private func pushH5(model: H5InfoModel) {
        guard model.setValue.count > 0 else { return }
        let url = "\(model.setValue)?token=\(userDefault.token)&unitId=\(userDefault.unitId)"
        HomeViewModel.push(BaseWebViewController.self, ["url": url, "title": model.name])
    }
    
    //MARK:
    //MARK: request
    private func requestBanner() ->Observable<[HomeBannerModel]>{
        return HCProvider.request(.selectBanner)
            .map(models: HomeBannerModel.self)
            .asObservable()
            .catchErrorJustReturn([HomeBannerModel]())
    }
    
    private func requestChannelArticle() ->Observable<HCArticlePageDataModel>{
        return HCProvider.request(.allChannelArticle(cmsType: .webCms001, pageNum: pageModel.currentPage, pageSize: pageModel.pageSize))
            .map(model: HCArticlePageDataModel.self)
            .asObservable()
            .catchErrorJustReturn(HCArticlePageDataModel())
    }
    
    private func requestH5(type: H5Type) ->Observable<H5InfoModel> {
        return HCProvider.request(.unitSetting(type: type))
            .map(model: H5InfoModel.self)
            .asObservable()
    }
    
    private func requestUnread() {
        HCProvider.request(.messageUnreadCount)
            .mapJSON()
            .subscribe(onSuccess: { [weak self] res in
                if let dic = res as? [String: Any],
                    let count = dic["data"] as? Int,
                    count > 0{
                    let countString = "\(count)"
                    let countWidth = countString.getTexWidth(fontSize: 12, height: 20) + 10
                    self?.unreadCountObser.value = (countString, countWidth)
                }else {
                    self?.unreadCountObser.value = ("", 0)
                }
            }) { error in
                PrintLog(error)
            }
            .disposed(by: disposeBag)
    }
    
    private func requestPregnancyProbability()->Observable<HCPregnancyProbabilityModel> {
        return HCProvider.request(.probability)
            .map(model: HCPregnancyProbabilityModel.self)
            .asObservable()
            .catchErrorJustReturn(HCPregnancyProbabilityModel())
    }
    
    private func increReadingRequest(id: String) {
        HCProvider.request(.increReading(id: id))
            .mapJSON()
            .subscribe(onSuccess: { res in
                PrintLog("阅读量更新：\(res)")
            }) { error in
                PrintLog("阅读量更新失败：\(error)")
            }
            .disposed(by: disposeBag)
    }
}

extension HomeViewModel {
    
    private func functionPush(model: HomeFunctionModel, navigationVC: UINavigationController?) {
        if model.functionUrl.count > 0 {
            var url = model.functionUrl
            PrintLog("h5拼接前地址：\(url)")
            if url.contains("photoSeach") == true {
                HomeViewModel.push(HCScanViewController.self, nil)
                return
            }else if url.contains("?") == false {
                url += "?token=\(userDefault.token)&unitId=\(model.unitId)"
            }else {
                url += "&token=\(userDefault.token)&unitId=\(model.unitId)"
            }
            PrintLog("h5拼接后地址：\(url)")
            
            let webVC = BaseWebViewController()
            webVC.title = model.name
            webVC.url   = url
            navigationVC?.pushViewController(webVC, animated: true)
        }else {
//            hud.failureHidden("功能暂不开放")
        }
    }
    
    // 今日知识push
    private func pushH5(url: String, navigationVC: UINavigationController?) {
        guard url.count > 0 else { return }
        
        let webVC = BaseWebViewController()
        webVC.url   = url
        navigationVC?.pushViewController(webVC, animated: true)
    }
    
    private func gotoPageHome() {
        guard var link = bannerModelObser.value.first?.link, link.count > 0 else {
            NoticesCenter.alert(message: "链接不存在")
            return
        }
        
        PrintLog("h5拼接前地址：\(link)")
        if link.contains("?") == false {
            link += "?token=\(userDefault.token)&unitId=\(userDefault.unitIdNoEmpty)"
        }else {
            link += "&token=\(userDefault.token)&unitId=\(userDefault.unitIdNoEmpty)"
        }
        
        let urlLink = userDefault.loginInfoString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        link += "&userInfo=\(urlLink!)"
        
        PrintLog("h5拼接后地址：\(link)")
        
        HomeViewModel.push(BaseWebViewController.self, ["url": link])
    }
}
