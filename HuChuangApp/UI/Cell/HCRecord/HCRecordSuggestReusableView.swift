//
//  HCRecordSuggestReusableView.swift
//  HuChuangApp
//
//  Created by yintao on 2019/12/12.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit

public let HCRecordSuggestReusableView_height: CGFloat = 95
public let HCRecordSuggestReusableView_identifier: String = "HCRecordSuggestReusableView"

class HCRecordSuggestReusableView: UICollectionReusableView {

    @IBOutlet var contentView: UICollectionReusableView!
    @IBOutlet weak var shadowView: UIView!
    
    public var askDoctorCallBack: (()->())?
    
    @IBAction func askDoctorAction(_ sender: UIButton) {
        askDoctorCallBack?()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView = (Bundle.main.loadNibNamed("HCRecordSuggestReusableView", owner: self, options: nil)?.first as! UICollectionReusableView)
        addSubview(contentView)
        
        contentView.snp.makeConstraints{ $0.edges.equalTo(UIEdgeInsets.zero) }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOffset = .init(width: 0, height: 0)
        shadowView.layer.shadowOpacity = 0.5
        shadowView.layer.shadowRadius = 5
        shadowView.layer.cornerRadius = 5
        shadowView.layer.masksToBounds = false
        shadowView.clipsToBounds = false
    }
}
