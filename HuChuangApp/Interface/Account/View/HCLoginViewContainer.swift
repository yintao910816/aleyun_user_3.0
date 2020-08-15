//
//  HCLoginViewContainer.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/7.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit
import RxSwift

class HCLoginViewContainer: UIView {
    
    private var titlelabel: UILabel!
    private var subTitleLabel: UILabel!
    private var subIcon: UIImageView!
    
    private var areaCodeLabel: UILabel!
    private var vLine: UIView!
    public var phoneTf: UITextField!
    private var hLine: UIView!
    public var getCodeButton: UIButton!

    private var remindLabel: UILabel!
    private var agreeButton: UIButton!
    private var agreeLabel: YYLabel!
    
    private var platformContainer: UIView!
    private var leftLine: UIView!
    private var platformRemindLabel: UILabel!
    private var rightLine: UIView!
    public var wchatLoginButton: UIButton!

    public let agreeSignal = Variable(false)
    public var agreementTap: (()->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func layoutSubviews() {
        super.layoutSubviews()
                
        titlelabel.frame = .init(x: 40, y: 0, width: width - 80, height: 45)
        
        var tempSize = subTitleLabel.sizeThatFits(.init(width: Double(MAXFLOAT), height: 20.0))
        subTitleLabel.frame = .init(x: titlelabel.frame.minX, y: titlelabel.frame.maxY + 5, width: tempSize.width, height: 20)
        subIcon.frame = .init(x: subTitleLabel.frame.maxX + 5, y: subTitleLabel.frame.minY + 2.5, width: 18, height: 15)
        
        tempSize = areaCodeLabel.sizeThatFits(.init(width: CGFloat(MAXFLOAT), height: 22))
        areaCodeLabel.frame = .init(x: titlelabel.frame.minX, y: subTitleLabel.frame.maxY + 65, width: tempSize.width, height: 22)
        vLine.frame = .init(x: areaCodeLabel.frame.maxX + 15, y: areaCodeLabel.frame.minY + 1, width: 1, height: 20)
        phoneTf.frame = .init(x: vLine.frame.maxX + 15, y: areaCodeLabel.frame.minY, width: 250, height: 22)
        hLine.frame = .init(x: titlelabel.frame.minX, y: vLine.frame.maxY + 12, width: width - 80, height: 1)
        getCodeButton.frame = .init(x: titlelabel.frame.minX, y: hLine.frame.maxY + 20, width: width - 80, height: 48)
        remindLabel.frame = .init(x: titlelabel.frame.minX, y: getCodeButton.frame.maxY + 20, width: width - 80, height: 16)
        agreeButton.frame = .init(x: titlelabel.frame.minX, y: remindLabel.frame.maxY + 12, width: 12, height: 12)
        
        let agreeLabelW: CGFloat = width - agreeButton.frame.maxX - 5 - 40
        tempSize = agreeLabel.sizeThatFits(.init(width: agreeLabelW, height: CGFloat(MAXFLOAT)))
        agreeLabel.frame = .init(x: agreeButton.frame.maxX + 5, y: agreeButton.frame.minY - 5, width: tempSize.width, height: tempSize.height)
        
        platformContainer.frame = .init(x: titlelabel.frame.minX, y: height - 85 - 50, width: width - 80, height: 85)
        
        tempSize = platformRemindLabel.sizeThatFits(.init(width: CGFloat(MAXFLOAT), height: 20))
        let lineW: CGFloat = (platformContainer.width - tempSize.width - 40) / 2.0
        leftLine.frame = .init(x: 0, y: 9, width: lineW, height: 1)
        platformRemindLabel.frame = .init(x: leftLine.frame.maxX + 20, y: 0, width: tempSize.width, height: 20)
        rightLine.frame = .init(x: platformRemindLabel.frame.maxX + 20, y: leftLine.frame.minY, width: lineW, height: 1)
        wchatLoginButton.frame = .init(x: (platformContainer.width - 50) / 2.0, y: platformRemindLabel.frame.maxY + 15, width: 50, height: 50)
    }
}

extension HCLoginViewContainer {
    
    private func initUI() {
        backgroundColor = .white
        
        titlelabel = UILabel()
        titlelabel.text = "登录进入爱乐孕"
        titlelabel.font = .font(fontSize: 16, fontName: .PingFSemibold)
        titlelabel.textColor = .black
        
        subTitleLabel = UILabel()
        subTitleLabel.text = "为爱孕育生命"
        subTitleLabel.font = .font(fontSize: 14, fontName: .PingFRegular)
        subTitleLabel.textColor = RGB(51, 51, 51)

        subIcon = UIImageView.init(image: UIImage(named: "login_title_icon"))
        
        // --
        areaCodeLabel = UILabel()
        areaCodeLabel.text = "+86"
        areaCodeLabel.font = .font(fontSize: 16, fontName: .PingFRegular)
        areaCodeLabel.textColor = RGB(51, 51, 51)

        vLine = UIView()
        vLine.backgroundColor = RGB(229, 229, 229)
        
        phoneTf = UITextField()
        phoneTf.keyboardType = .numberPad
        phoneTf.returnKeyType = .done
        phoneTf.borderStyle = .none
        phoneTf.font = .font(fontSize: 16, fontName: .PingFRegular)
        phoneTf.textColor = RGB(51, 51, 51)
        phoneTf.placeholder = "请输入您的手机号"
        
        hLine = UIView()
        hLine.backgroundColor = RGB(229, 229, 229)
        
        getCodeButton = UIButton()
        getCodeButton.layer.cornerRadius = 3
        getCodeButton.clipsToBounds = true
        getCodeButton.setTitle("获取验证码", for: .normal)
        getCodeButton.backgroundColor = RGB(242, 242, 242)
        getCodeButton.setTitleColor(RGB(191, 191, 191), for: .normal)
        getCodeButton.setTitleColor(.white, for: .selected)
        getCodeButton.titleLabel?.font = .font(fontSize: 13)
        
        remindLabel = UILabel()
        remindLabel.textColor = RGB(154, 154, 154)
        remindLabel.font = .font(fontSize: 12)
        remindLabel.text = "未注册手机验证后自动注册"
        
        agreeButton = UIButton()
        agreeButton.setImage(UIImage(named: "login_unselected_agree"), for: .normal)
        agreeButton.setImage(UIImage(named: "login_selected_agree"), for: .selected)
        agreeButton.addTarget(self, action: #selector(agreeClicked), for: .touchUpInside)
        
        agreeLabel = YYLabel()
        agreeLabel.textColor = RGB(154, 154, 154)
        agreeLabel.font = .font(fontSize: 12)
        agreeLabel.numberOfLines = 0
        let string = NSMutableAttributedString.init(string: "阅读并勾选以下协议《爱乐孕用户服务协议》《法律声明》《隐私政策》")
        string.yy_setTextHighlight(.init(location: 9, length: 11), color: RGB(57, 129, 247), backgroundColor: .clear) { [weak self] (_, _, _, _) in
            self?.agreementTap?()
        }
        string.yy_setTextHighlight(.init(location: 20, length: 6), color: RGB(57, 129, 247), backgroundColor: .clear) { [weak self] (_, _, _, _) in
            self?.agreementTap?()
        }
        string.yy_setTextHighlight(.init(location: 26, length: 6), color: RGB(57, 129, 247), backgroundColor: .clear) { [weak self] (_, _, _, _) in
            self?.agreementTap?()
        }
        agreeLabel.attributedText = string
        
        platformContainer = UIView()
        platformContainer.backgroundColor = .white
        
        leftLine = UIView()
        leftLine.backgroundColor = RGB(229, 229, 229)
        
        platformRemindLabel = UILabel()
        platformRemindLabel.text = "其它方式登录"
        platformRemindLabel.font = .font(fontSize: 14)
        platformRemindLabel.textColor = RGB(43, 43, 43)
        
        rightLine = UIView()
        rightLine.backgroundColor = RGB(229, 229, 229)

        wchatLoginButton = UIButton()
        wchatLoginButton.setImage(UIImage(named: "wchat_login"), for: .normal)
        
        addSubview(titlelabel)
        addSubview(subTitleLabel)
        addSubview(subIcon)
        addSubview(areaCodeLabel)
        addSubview(vLine)
        addSubview(phoneTf)
        addSubview(hLine)
        addSubview(getCodeButton)
        addSubview(remindLabel)
        addSubview(agreeButton)
        addSubview(agreeLabel)

        addSubview(platformContainer)
        platformContainer.addSubview(leftLine)
        platformContainer.addSubview(platformRemindLabel)
        platformContainer.addSubview(rightLine)
        platformContainer.addSubview(wchatLoginButton)
        
        #if DEBUG
//        phoneTf.text = "13995631675"
        //        accountInputOutlet.text = "15717102067"
        //        accountInputOutlet.text = "13244762499"
        phoneTf.text = "18627844751"
        #else
        phoneTf.text = userDefault.loginPhone
        #endif
    }

    @objc private func agreeClicked() {
        agreeButton.isSelected = !agreeButton.isSelected
        agreeSignal.value = agreeButton.isSelected
    }
}
