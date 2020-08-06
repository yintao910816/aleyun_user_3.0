//
//  MineHeader.swift
//  HuChuangApp
//
//  Created by yintao on 2019/2/13.
//  Copyright © 2019 sw. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class MineHeaderView: UIView {
    
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var userIconOutlet: UIButton!
    @IBOutlet weak var nickNameOutlet: UILabel!
    @IBOutlet weak var cornerBgView: UIView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var eidtUserInfoOutlet: TYButton!
    @IBOutlet weak var statuesOutlet: UILabel!
    
    @IBOutlet weak var titleTopCns: NSLayoutConstraint!
    @IBOutlet var contentView: UIView!
    
    let userModel = PublishSubject<HCUserModel>()
    let gotoEditUserInfo = PublishSubject<Void>()
    let openH5Publish = PublishSubject<H5Type>()
    let gotoSetting = PublishSubject<Void>()

    @IBAction func actions(_ sender: UIButton) {
        switch sender.tag {
        case 200:
            // 设置
            gotoSetting.onNext(Void())
        case 201:
            // 通知
            openH5Publish.onNext(.noticeAndMessage)
        case 202:
            // 订单
            openH5Publish.onNext(.csRecord)
        case 203:
            // 关注
            openH5Publish.onNext(.myFocused)
        case 204:
            // 收藏
            openH5Publish.onNext(.myCollection)
        default:
            break
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView = (Bundle.main.loadNibNamed("MineHeaderView", owner: self, options: nil)?.first as! UIView)
        addSubview(contentView)
        
        contentView.snp.makeConstraints{ $0.edges.equalTo(UIEdgeInsets.zero) }
                
        if UIDevice.current.isX {
            var frame = contentView.frame
            frame.size.height += LayoutSize.topVirtualArea
            contentView.frame = frame
            
            titleTopCns.constant += LayoutSize.fitTopArea
        }

        
        setupUI()
        rxBind()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        let tapGes = UITapGestureRecognizer.init(target: self, action: #selector(tapAction(_:)))
        tapGes.delegate = self
        contentView.addGestureRecognizer(tapGes)
    }
    
    @objc private func tapAction(_ tap: UITapGestureRecognizer) {
        gotoEditUserInfo.onNext(Void())
    }
    
    private func rxBind() {
        eidtUserInfoOutlet.rx.tap.asObservable()
            .bind(to: gotoEditUserInfo)
            .disposed(by: disposeBag)
        
        userModel.subscribe(onNext: { [weak self] user in
            self?.userIconOutlet.setImage(user.headPath, .userIcon)
            self?.nickNameOutlet.text = user.name
            let pregnantTypeName = user.pregnantTypeName.count > 0 ? user.pregnantTypeName : "未知"
            self?.statuesOutlet.text = "人生阶段：\(pregnantTypeName)"
        })
            .disposed(by: disposeBag)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
                                
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOffset = .init(width: 0, height: 0)
        shadowView.layer.shadowOpacity = 0.2
        shadowView.layer.shadowRadius = 5
        shadowView.layer.cornerRadius = 5
        shadowView.layer.masksToBounds = true
        shadowView.clipsToBounds = false
        
        userIconOutlet.layer.cornerRadius = userIconOutlet.height / 2.0
    }
}

extension MineHeaderView: UIGestureRecognizerDelegate {
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.location(in: self).y >= cornerBgView.y {
            return false
        }
        return true
    }
}
