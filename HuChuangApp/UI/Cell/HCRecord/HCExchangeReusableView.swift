//
//  HCExchangeReusableView.swift
//  HuChuangApp
//
//  Created by yintao on 2019/12/14.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit

public let HCExchangeReusableView_height: CGFloat = 60
public let HCExchangeReusableView_identifier: String = "HCExchangeReusableView"

class HCExchangeReusableView: UICollectionReusableView {

    @IBOutlet var contentView: UICollectionReusableView!
    
    public var exchangeCallBack: (()->())?
    
    @IBAction func actions(_ sender: UIButton) {
        exchangeCallBack?()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView = (Bundle.main.loadNibNamed("HCExchangeReusableView", owner: self, options: nil)?.first as! UICollectionReusableView)
        addSubview(contentView)
        
        contentView.snp.makeConstraints{ $0.edges.equalTo(UIEdgeInsets.zero) }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
