//
//  HCPicAndTextAskFooterReusableView.swift
//  HuChuangApp
//
//  Created by yintao on 2019/12/2.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit

private let remindText = "咨询添知\n1、一间一答，医生本人回复\n2、24小时内无人回复，系统自动退款\n3、医生的建议谨慎参考，对于咨询过程中出现的后果，本APP不承担法律责任\n4、医生提供的是在线咨询服务非医疗行为提交问题"

public let HCPicAndTextAskFooterReusableView_identifier = "HCPicAndTextAskFooterReusableView"
public let HCPicAndTextAskFooterReusableView_size = remindText.ty_textSize(font: .font(fontSize: 11,
                                                                                       fontName: .PingFRegular),
                                                                           width: PPScreenW - 30,
                                                                           height: CGFloat(MAXFLOAT))

class HCPicAndTextAskFooterReusableView: UICollectionReusableView {

    private var remindLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        remindLabel = UILabel.init(frame: .init(x: 15, y: 0, width: HCPicAndTextAskFooterReusableView_size.width,
                                                height: HCPicAndTextAskFooterReusableView_size.height))
        remindLabel.text = remindText
        remindLabel.font = .font(fontSize: 11, fontName: .PingFRegular)
        remindLabel.numberOfLines = 0
        remindLabel.textColor = RGB(204, 204, 204)
        addSubview(remindLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
