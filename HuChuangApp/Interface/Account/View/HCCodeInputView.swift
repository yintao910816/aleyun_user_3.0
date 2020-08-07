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
    private var frontView: UIView!
    
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
        textView.keyboardType = .namePhonePad
        textView.delegate = self
        textView.isUserInteractionEnabled = false
        
        frontView = UIView()
        frontView.backgroundColor = .clear
        
        let tapGes = UITapGestureRecognizer.init(target: self, action: #selector(tapAction))
        frontView.addGestureRecognizer(tapGes)
        
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
        textView.becomeFirstResponder()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textView.frame = bounds
        frontView.frame = bounds
        
        if codeCount > 1 {
            let margin = (width - CGFloat(codeCount) * height) / CGFloat(codeCount - 1)
            for idx in 200..<(200 + codeCount) {
                frontView.viewWithTag(idx)?.frame = .init(x: CGFloat(idx - 200) * margin,
                                                          y: 0,
                                                          width: height,
                                                          height: height)
            }
        }
    }
    
}

extension HCCodeInputView: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return true
    }
}
