//
//  HCDoctorInfoHeaderView.swift
//  HuChuangApp
//
//  Created by yintao on 2019/12/4.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit

class HCDoctorInfoHeaderView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var headerCover: UIImageView!
    
    @IBOutlet weak var titleOutlet: UILabel!
    @IBOutlet weak var subtitleOutlet: UILabel!
    
    @IBOutlet weak var attentionOutlet: UIButton!
    @IBOutlet weak var timeOutlet: UILabel!
    @IBOutlet weak var consultNumOutlet: UILabel!
    @IBOutlet weak var scoreOutlet: UILabel!
    @IBOutlet weak var scoreIconOutlet: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView = (Bundle.main.loadNibNamed("HCDoctorInfoHeaderView", owner: self, options: nil)?.first as! UIView)
        addSubview(contentView)
        
        contentView.snp.makeConstraints{ $0.edges.equalTo(UIEdgeInsets.zero) }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var model: HCDoctorInfoModel! {
        didSet {
            headerCover.setImage(model.headPath)
            titleOutlet.text = "\(model.userName) \(model.technicalPost)"
            subtitleOutlet.text = model.unitName
            
            let timeText = ""
        }
    }
}
