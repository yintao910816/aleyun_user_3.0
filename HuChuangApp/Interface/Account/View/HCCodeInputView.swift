//
//  HCCodeInputView.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/7.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCCodeInputView: UIView {

    private var textView: UITextView!
    private var frontView: UIButton!
    
    public var finishInput: ((String)->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var codeCount: Int = 0 {
        didSet {
            creatCodeUI()
        }
    }
    
    private func initUI() {
        backgroundColor = .clear
        textView = UITextView()
        textView.backgroundColor = .clear
        textView.keyboardType = .numberPad
        textView.delegate = self
        textView.isUserInteractionEnabled = false
        textView.tintColor = .clear
        
        frontView = UIButton()
        frontView.backgroundColor = .clear
        frontView.addTarget(self, action: #selector(tapAction), for: .touchUpInside)
                
        addSubview(textView)
        addSubview(frontView)
    }
    
    private func creatCodeUI() {
        for idx in 200..<(200 + codeCount) {
            let label = UILabel()
            label.tag = idx
            label.font = .font(fontSize: 16, fontName: .PingFSemibold)
            label.textColor = RGB(50, 50, 50)
            label.textAlignment = .center
            label.layer.cornerRadius = 5
            label.layer.borderColor = RGB(235, 235, 235).cgColor
            label.layer.borderWidth = 2
            frontView.addSubview(label)
        }
    }
    
    @objc private func tapAction() {
        if !textView.isFirstResponder {
            textView.becomeFirstResponder()
        }
    }
    
    /// 一次性设置所有code
    public func setAll(with content: String) {
        for idx in 0..<content.count {
            if idx < codeCount {
                let index = content.index(content.startIndex, offsetBy: idx)
                let label = frontView.viewWithTag(200 + idx) as? UILabel
                label?.text = String(content[index])
            }
        }
    }
    
    /// 单个的输入code
    public func setCode(with code: String) {
        var result = ""
        for idx in 0..<codeCount {
            let label = frontView.viewWithTag(200 + idx) as? UILabel
            
            var needBreak = false
            if label?.text == nil || label?.text?.count == 0 {
                label?.text = code
                result += code
                needBreak = true
            }else {
                result += label?.text ?? ""
            }
            
            if idx == codeCount - 1 {
               finishInput?(result)
            }else {
                if needBreak {
                    break
                }
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textView.frame = bounds
        frontView.frame = bounds
        
        if codeCount > 1 {
            let margin = (width - CGFloat(codeCount) * height) / CGFloat(codeCount - 1)
            for idx in 0..<codeCount {
                frontView.viewWithTag(idx + 200)?.frame = .init(x: CGFloat(idx) *  (height + margin),
                                                          y: 0,
                                                          width: height,
                                                          height: height)
            }
        }
    }
    
}

extension HCCodeInputView: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        setCode(with: text)
        return false
    }
}
