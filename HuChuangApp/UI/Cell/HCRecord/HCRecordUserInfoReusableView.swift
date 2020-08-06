//
//  HCRecordUserInfoReusableView.swift
//  HuChuangApp
//
//  Created by yintao on 2019/12/12.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit

public let HCRecordUserInfoReusableView_height: CGFloat = 121
public let HCRecordUserInfoReusableView_identifier: String = "HCRecordUserInfoReusableView"

class HCRecordUserInfoReusableView: UICollectionReusableView {

    @IBOutlet var contentView: UICollectionReusableView!
    @IBOutlet weak var jieduanOutlet: UILabel!
    @IBOutlet weak var jilvOutlet: UILabel!
    @IBOutlet weak var painuanriOutlet: UILabel!
        
    public var exchangeCallBack: (()->())?

    @IBAction func actions(_ sender: UIButton) {
        exchangeCallBack?()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView = (Bundle.main.loadNibNamed("HCRecordUserInfoReusableView", owner: self, options: nil)?.first as! UICollectionReusableView)
        addSubview(contentView)
        
        contentView.snp.makeConstraints{ $0.edges.equalTo(UIEdgeInsets.zero) }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func set(data: HCRecordItemDataModel, pailuanLeft: NSAttributedString) {
        jieduanOutlet.attributedText = data.newLv
        jilvOutlet.attributedText = data.probability
        painuanriOutlet.attributedText = pailuanLeft
    }
}
