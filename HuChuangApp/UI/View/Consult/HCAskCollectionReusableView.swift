//
//  HCAskCollectionReusableView.swift
//  HuChuangApp
//
//  Created by yintao on 2019/11/24.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit

public let HCAskCollectionReusableView_identifier = "HCAskCollectionReusableView"
public let HCAskCollectionReusableView_height: CGFloat = 350

class HCAskCollectionReusableView: UICollectionReusableView {

    private var titleLabel: UILabel!
    private var addArchivesButton: UIButton!
    private var sepLine: UIView!
    private var desTitleLabel: UILabel!
    private var inputTextView: UITextView!
    private var footerLabel: UILabel!
    
    public var addArchivesCallBack: (()->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupUI()
    }
    
    private func setupUI() {
        titleLabel = UILabel()
        titleLabel.textColor = RGB(51, 51, 51)
        titleLabel.font = .font(fontSize: 16, fontName: .PingFRegular)
        titleLabel.text = "健康档案"
        
        addArchivesButton = UIButton()
        addArchivesButton.setTitleColor(HC_MAIN_COLOR, for: .normal)
        addArchivesButton.titleLabel?.font = .font(fontSize: 12, fontName: .PingFRegular)
        addArchivesButton.setTitle("添加健康档案", for: .normal)
        addArchivesButton.layer.cornerRadius = 3
        addArchivesButton.layer.borderWidth = 1
        addArchivesButton.layer.borderColor = HC_MAIN_COLOR.cgColor
        addArchivesButton.addTarget(self, action: #selector(addArchivesAction), for: .touchUpInside)
        
        sepLine = UIView()
        sepLine.backgroundColor = RGB(249, 249, 249)
        
        desTitleLabel = UILabel()
        desTitleLabel.textColor = RGB(51, 51, 51)
        desTitleLabel.font = .font(fontSize: 16, fontName: .PingFRegular)
        desTitleLabel.text = "病情描述"

        inputTextView = UITextView()
        inputTextView.textColor = RGB(51, 51, 51)
        inputTextView.font = .font(fontSize: 12, fontName: .PingFRegular)
        inputTextView.text = "请详细描述你的疾病发生的部位、主要症状、持续时间、已就诊的信息和主治医生的建议，您也可以上传症状部位照片或者检查单，完整的病历资料，会得到医生更详细的指导！"
        
        footerLabel = UILabel()
        footerLabel.textColor = RGB(102, 102, 102)
        footerLabel.font = .font(fontSize: 14, fontName: .PingFRegular)
        footerLabel.text = "添加照片(最多9张)"

        addSubview(titleLabel)
        addSubview(addArchivesButton)
        addSubview(sepLine)
        addSubview(desTitleLabel)
        addSubview(inputTextView)
        addSubview(footerLabel)

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(10)
            $0.left.equalTo(15)
        }
        
        addArchivesButton.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.left.equalTo(titleLabel.snp.left)
            $0.size.equalTo(CGSize.init(width: 98, height: 25))
        }
        
        sepLine.snp.makeConstraints {
            $0.left.right.equalTo(0)
            $0.top.equalTo(addArchivesButton.snp.bottom).offset(20)
            $0.height.equalTo(10)
        }
        
        desTitleLabel.snp.makeConstraints {
            $0.top.equalTo(sepLine.snp.bottom).offset(15)
            $0.left.equalTo(15)
        }

        inputTextView.snp.makeConstraints {
            $0.top.equalTo(desTitleLabel.snp.bottom).offset(13)
            $0.left.equalTo(15)
            $0.right.equalTo(-15)
            $0.height.equalTo(150)
        }

        footerLabel.snp.makeConstraints {
            $0.top.equalTo(inputTextView.snp.bottom).offset(15)
            $0.left.equalTo(15)
        }

    }
    
    @objc private func addArchivesAction() {
        addArchivesCallBack?()
    }
}
