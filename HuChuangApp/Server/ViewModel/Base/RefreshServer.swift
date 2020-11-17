//
//  Protocol.swift
//  StoryReader
//
//  Created by 020-YinTao on 2017/4/6.
//  Copyright © 2017年 020-YinTao. All rights reserved.
//

import Foundation
import UIKit
import MJRefresh
import RxSwift

extension UIScrollView {

    final func prepare<T>(_ ower: RefreshVM<T>,
                          showFooter: Bool = true,
                          showHeader: Bool = true,
                          isAddNoMoreContent: Bool = true) {
        addFreshView(ower: ower, showFooter: showFooter, showHeader: showHeader)
        bind(ower, showFooter, showHeader, isAddNoMoreContent: isAddNoMoreContent)
    }
    
    final func headerRefreshing() {
        if mj_footer != nil {
            mj_footer.isHidden = true
        }

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25) { [weak self] in
            self?.mj_header.beginRefreshing()
        }
    }
}

extension UIScrollView {

    fileprivate func addFreshView<T>(ower: RefreshVM<T>, showFooter: Bool, showHeader: Bool) {

        if showHeader == true {
            mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
                ower.requestData(true)
            })
        }
        
        if showFooter == true {
            mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: {
                ower.requestData(false)
            })
            mj_footer.isHidden = true
        }
    }
    
    fileprivate func bind<T>(_ ower: RefreshVM<T>,
                             _ hasFooter: Bool,
                             _ hasHeader: Bool,
                             isAddNoMoreContent: Bool) {
        _ = ower.refreshStatus
            .asObservable()
            .bind(onNext: { [weak self] statue in
            
                switch statue {
                case .DropDownSuccess:
                    if hasHeader {
                        self?.mj_header.endRefreshing()
                    }
                    if hasFooter == true {
                        self?.mj_footer.isHidden = false
                    }
                case .DropDownSuccessAndNoMoreData:
                    if hasHeader {
                        self?.mj_header.endRefreshing()
                    }
                    if hasFooter == true {
                        self?.mj_footer.isHidden = true
                    }
                case .PullSuccessHasMoreData:
                    if hasFooter == true { self?.mj_footer.endRefreshing() }
                case .PullSuccessNoMoreData:
                    if hasFooter == true {
                        self?.mj_footer.isHidden = true
                    }
                case .InvalidData:
                    if hasHeader {
                        self?.mj_header.endRefreshing()
                    }
                    if hasFooter == true { self?.mj_footer.endRefreshing() }
                }
            })
        
        if isAddNoMoreContent {
            _ = ower.isEmptyContentObser.asDriver()
                .drive(onNext: { [weak self] in
                    self?.addNoMoreDataFooter(isAdd: $0)
                })
        }
    }
    
    private func addNoMoreDataFooter(isAdd: Bool) {
        viewWithTag(20020)?.removeFromSuperview()
        isScrollEnabled = !isAdd

        if isAdd {
            let view = HCListEmptyView.init(frame: bounds)
            view.tag = 20020
            addSubview(view)
        }
    }

}

enum RefreshStatus: Int {
   
    case DropDownSuccess              // 下拉成功，有更多的数据
    case DropDownSuccessAndNoMoreData // 下拉成功，并且没有更多数据了
    case PullSuccessHasMoreData       // 上拉，还有更多数据
    case PullSuccessNoMoreData        // 上拉，没有更多数据
    case InvalidData                  // 无效的数据
}

class RefreshVM<T>: BaseViewModel {
    
    public var datasource    = Variable([T]())
    public var pageModel     = PageModel()
    public var refreshStatus = Variable(RefreshStatus.InvalidData)
    
    public let itemSelected = PublishSubject<IndexPath>()
    public let modelSelected = PublishSubject<T>()

    /// 用于多table
    private var pageModels:[String: PageModel] = [:]
    
    /**
     * 子类重写，响应上拉下拉加载数据
     * 单个table中必须调用super，否则分页参数不正确
     */
    func requestData(_ refresh: Bool) {
        pageModel.currentPage = refresh ? 1 : (pageModel.currentPage + 1)
    }
}

//MARK:--单个table
extension RefreshVM {
    /**
     * 刷新方法，发射刷新信号 - 用于列表数据(只有一个table)
     * models - 列表数据
     * pages - 总共分页数
     */
    public final func updateRefresh(_ refresh: Bool,
                                    _ models: [T]?,
                                    _ pages: Int) {
        pageModel.totlePage = pages
        let retData = models ?? [T]()

        if refresh {
            // 下拉刷新处理
            isEmptyContentObser.value = retData.count == 0
            refreshStatus.value = pageModel.hasNext ? .DropDownSuccess : .DropDownSuccessAndNoMoreData
            datasource.value = retData
        } else {
            // 上拉刷新处理
            if retData.count > 0 {
                refreshStatus.value = pageModel.hasNext ? .PullSuccessHasMoreData : .PullSuccessNoMoreData
                datasource.value.append(contentsOf: retData)
            }else {
                pageModel.currentPage = pageModel.currentPage > 1 ? (pageModel.currentPage - 1) : 1
                refreshStatus.value = .PullSuccessNoMoreData
            }
        }
    }
        
    /**
     网络请求失败和出错都会统一调用这个方法
     */
    public final func revertCurrentPageAndRefreshStatus() {
        pageModel.currentPage = pageModel.currentPage > 1 ? (pageModel.currentPage - 1) : 1

        // 修改刷新view的状态
        refreshStatus.value = .InvalidData
    }
}

//MARK:--多table
extension RefreshVM {
   
    /**
     * 子类重写 func requestData(_ refresh: Bool)
     *  必须调用，否则分页参数不正确
     */
    public final func updatePage(for pageKey: String, refresh: Bool) {
        checkPage(pageKey: pageKey)
        let curPageModel = pageModels[pageKey]!
        curPageModel.currentPage = refresh ? 1 : (curPageModel.currentPage + 1)
    }
    
    /**
     * 刷新方法，发射刷新信号 - 用于多个table
     */
    public final func updateRefresh(refresh: Bool,
                                    models: [T]?,
                                    dataModels: inout [T],
                                    pages: Int,
                                    pageKey: String) {
        
        checkPage(pageKey: pageKey)
        guard let page = pageModels[pageKey] else { return }
        
        page.totlePage = pages

        let retData = models ?? [T]()

        if refresh {
            // 下拉刷新处理
            isEmptyContentObser.value = retData.count == 0
            refreshStatus.value = pages > 1 ? .DropDownSuccess : .DropDownSuccessAndNoMoreData
            dataModels.removeAll()
            dataModels.append(contentsOf: retData)
        } else {
            // 上拉刷新处理
            if retData.count > 0 {
                refreshStatus.value = page.hasNext ? .PullSuccessHasMoreData : .PullSuccessNoMoreData
                dataModels.append(contentsOf: retData)
            }else {
                page.currentPage = page.currentPage > 1 ? (page.currentPage - 1) : 1
                refreshStatus.value = .PullSuccessNoMoreData
            }
        }
    }
        
    /**
     网络请求失败和出错都会统一调用这个方法
     */
    public final func revertCurrentPageAndRefreshStatus(pageKey: String) {
        guard let page = pageModels[pageKey] else { return }

        page.currentPage = page.currentPage > 1 ? (page.currentPage - 1) : 1

        // 修改刷新view的状态
        refreshStatus.value = .InvalidData
    }

    public func currentPage(for pageKey: String) ->Int {
        checkPage(pageKey: pageKey)
        return pageModels[pageKey]!.currentPage
    }
    
    public func pageSize(for pageKey: String) ->Int {
        checkPage(pageKey: pageKey)
        return pageModels[pageKey]!.pageSize
    }

    private func checkPage(pageKey: String) {
        if pageModels[pageKey] == nil {
            let pageModel = PageModel()
            pageModel.pageSize = 10
            pageModels[pageKey] = pageModel
        }
    }

}

//MARK: 列表空数据
class HCListEmptyView: UIView {
    private var contentView: UIView!
    private var remindImgV: UIImageView!
    private var remindLabel: UILabel!

    private var remindText: String = "暂无数据"

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        contentView = UIView()
        contentView.backgroundColor = backgroundColor
        
        remindImgV = UIImageView(image: UIImage.init(named: "underDev"))
        
        remindLabel = UILabel()
        remindLabel.textColor = RGB(154, 159, 180)
        remindLabel.font = .font(fontSize: 14)
        remindLabel.text = remindText
        remindLabel.textAlignment = .center
        
        addSubview(contentView)
        contentView.addSubview(remindImgV)
        contentView.addSubview(remindLabel)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
       
        let imgSize: CGSize = remindImgV.image?.size ?? .init(width: 160, height: 100)
        let contentH: CGFloat = imgSize.height + 35 + 20
        
        contentView.frame = .init(x: 0,
                                  y: (height - contentH) / 2,
                                  width: width,
                                  height: contentH)
        remindImgV.frame = .init(x: (contentView.width - imgSize.width) / 2.0,
                                 y: 0,
                                 width: imgSize.width,
                                 height: imgSize.height)
        remindLabel.frame = .init(x: 15,
                                  y: remindImgV.frame.maxY + 35,
                                  width: contentView.width - 30,
                                  height: 20)

    }
}
