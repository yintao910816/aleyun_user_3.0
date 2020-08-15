//
//  HCVerifyViewContainer.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/7.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCVerifyViewContainer: UIView {

    private var titlelabel: UILabel!
    private var subTitleLabel: UILabel!
    private var subIcon: UIImageView!

    private var codeView: HCCodeInputView!
    public var timeLabel: UILabel!
    
    public var finishInput: ((String)->())?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @discardableResult
    override func becomeFirstResponder() -> Bool {
        super.becomeFirstResponder()

        return codeView.becomeFirstResponder()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titlelabel.frame = .init(x: 40, y: 0, width: width - 80, height: 45)
        
        let tempSize = subTitleLabel.sizeThatFits(.init(width: Double(MAXFLOAT), height: 20.0))
        subTitleLabel.frame = .init(x: titlelabel.frame.minX, y: titlelabel.frame.maxY + 5, width: tempSize.width, height: 20)
        subIcon.frame = .init(x: subTitleLabel.frame.maxX + 5, y: subTitleLabel.frame.minY + 2.5, width: 18, height: 15)

        codeView.frame = .init(x: 40, y: subTitleLabel.frame.maxY + 15, width: width - 80, height: 60)
        timeLabel.frame = .init(x: 40, y: codeView.frame.maxY + 32, width: width - 80, height: 16)
    }
    
}

extension HCVerifyViewContainer {
    
    private func initUI() {
        titlelabel = UILabel()
        titlelabel.text = "登录进入爱乐孕"
        titlelabel.font = .font(fontSize: 16, fontName: .PingFSemibold)
        titlelabel.textColor = .black
        
        subTitleLabel = UILabel()
        subTitleLabel.text = "为爱孕育生命"
        subTitleLabel.font = .font(fontSize: 14, fontName: .PingFRegular)
        subTitleLabel.textColor = RGB(51, 51, 51)

        subIcon = UIImageView.init(image: nil)
        
        codeView = HCCodeInputView()
        codeView.codeCount = 4
        codeView.finishInput = { [weak self] in self?.finishInput?($0) }
        
        timeLabel = UILabel()
        timeLabel.text = ""
        timeLabel.textAlignment = .center
        timeLabel.font = .font(fontSize: 12, fontName: .PingFRegular)
        timeLabel.textColor = RGB(54, 54, 54)

        addSubview(titlelabel)
        addSubview(subTitleLabel)
        addSubview(subIcon)
        addSubview(codeView)
        addSubview(timeLabel)
    }
}
