//
//  HCNavBarTitleView.swift
//  HuChuangApp
//
//  Created by yintao on 2020/7/21.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCNavBarTitleView: UIView {

    public var contentSize: CGSize = .zero
    public var titleContentView: HCNavBarTitleItemView!

    init(frame: CGRect, model: HCNavBarTitleMode) {
        super.init(frame: frame)
        
        contentSize = frame.size
        
        switch model {
        case .orderRecord:
            titleContentView = HCNavBarOrderRecordTitleView.init(frame: frame)
        }
        addSubview(titleContentView)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override var intrinsicContentSize: CGSize {
        return contentSize
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleContentView.frame = bounds
    }
}

class HCNavBarTitleItemView: UIView {
    
    public var title: String = ""
    public var titleClicked: (()->())?

    public func disAppear() { }
}

class HCNavBarOrderRecordTitleView: HCNavBarTitleItemView {

    private var bgView: UIButton!
    private var titleLabel: UILabel!
    private var arrowImgV: UIImageView!

    private lazy var floatView: HCNavBarOrderRecordModeView = {
        let viewY = 44 + LayoutSize.topVirtualArea_1
        let view = HCNavBarOrderRecordModeView.init(frame: .init(x: 0, y: viewY, width: PPScreenW, height: PPScreenH - viewY))
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        bgView = UIButton.init(type: .custom)
        bgView.backgroundColor = .clear
        bgView.addTarget(self, action: #selector(arrowClicekd), for: .touchUpInside)
        
        titleLabel = UILabel()
        titleLabel.text = "全部"
        titleLabel.textAlignment = .center
        titleLabel.backgroundColor = .clear
        titleLabel.font = .font(fontSize: 15, fontName: .PingFRegular)
        titleLabel.textColor = .black
        
        arrowImgV = UIImageView.init(image: UIImage(named: "arrow_down"))
        
        addSubview(bgView)
        addSubview(titleLabel)
        addSubview(arrowImgV)
    }
    
    @objc private func arrowClicekd() {
        bgView.isSelected = !bgView.isSelected
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.arrowImgV.transform = .init(rotationAngle: self?.bgView.isSelected == true ? CGFloat.pi : 0)
        }
        
        titleClicked?()
        
        floatView.viewPresent()
    }
    
    public override func disAppear() {
        floatView.viewDisAppear()
    }
    
    public override var title: String {
        didSet {
            titleLabel.text = title
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let titleSize = titleLabel.sizeThatFits(.init(width: .greatestFiniteMagnitude, height: height))
        let arrowSize = CGSize.init(width: 11, height: 11)
        let titleX = (width - titleSize.width - 11 - 5) / 2.0
        
        let bgWidth = titleSize.width + 5 + arrowSize.width
        
        bgView.frame = .init(x: (width - bgWidth) / 2.0, y: 0, width: bgWidth, height: height)
        titleLabel.frame = .init(x: titleX, y: 0, width: titleSize.width, height: height)
        arrowImgV.frame = .init(x: titleLabel.frame.maxX + 5, y: (height - arrowSize.height) / 2.0, width: arrowSize.width, height: arrowSize.height)
    }
}
