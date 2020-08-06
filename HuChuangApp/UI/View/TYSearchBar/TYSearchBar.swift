//
//  TYSearchBar.swift
//  HuChuangApp
//
//  Created by yintao on 2019/9/22.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class TYSearchBar: UIView {
    
    private let disposeBag = DisposeBag()
    
    /// 点击按钮的回调
    public var tapInputCallBack: (()->())?
    /// 左边按钮点击事件
    public var leftItemTapBack: (()->())?
    /// 右边边按钮点击事件
    public var rightItemTapBack: (()->())?
    /// 点击return建调用
    public var beginSearch: ((String)->())?
    /// 将要弹出键盘
    public var willSearch: (()->())?
    
    /// 文字变化监听
    public let textObser = PublishSubject<String>()

    /// 搜索框高度
    public class var baseHeight: CGFloat {
        return 44.0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = .clear
        
        leftItem.snp.makeConstraints{
            $0.left.equalTo(snp.left).offset(17)
            $0.centerY.equalTo(snp.centerY)
            $0.size.equalTo(CGSize.init(width: 30, height: 30))
        }

        contentContainer.snp.makeConstraints{
            $0.left.equalTo(leftItem.snp.right).offset(6)
            $0.right.equalTo(rightItem.snp.left).offset(-10)
            $0.top.equalTo(snp.top).offset(7)
            $0.bottom.equalTo(snp.bottom).offset(-7)
        }

        searchIcon.snp.makeConstraints{
            $0.left.equalTo(contentContainer.snp.left).offset(10)
            $0.centerY.equalTo(contentContainer.snp.centerY)
            $0.size.equalTo(CGSize.init(width: 15, height: 15))
        }

        searchTf.snp.makeConstraints{
            $0.left.equalTo(searchIcon.snp.right).offset(12)
            $0.right.equalTo(contentContainer.snp.right).offset(-12)
            $0.centerY.equalTo(contentContainer.snp.centerY)
            $0.height.equalTo(22)
        }

        rightItem.snp.makeConstraints{
            $0.right.equalTo(snp.right).offset(-15)
            $0.centerY.equalTo(leftItem.snp.centerY)
            $0.size.equalTo(CGSize.init(width: 16, height: 14))
        }
        
        bottomLine.snp.makeConstraints{
            $0.left.bottom.right.equalTo(0)
            $0.height.equalTo(1)
        }
        
        inputCover.snp.makeConstraints {
            $0.left.right.top.bottom.equalTo(contentContainer)
        }
        
        searchTf.rx.text.asObservable()
            .map{ ($0 == nil ? "" : $0!) }
            .bind(to: textObser)
            .disposed(by: disposeBag)        
    }
    
    private func updateRightItem() {
        if rightItemIcon.count > 0 {
            rightItem.setTitle(nil, for: .normal)

            rightItem.setImage(.image(for: rightItemIcon), for: .normal)
        }else {
            rightItem.setImage(nil, for: .normal)

            rightItem.titleLabel?.font = .font(fontSize: 14)
            rightItem.setTitle(rightItemTitle, for: .normal)
            rightItem.setTitleColor(RGB(51, 51, 51), for: .normal)
        }
        
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    private func updateLeftItem() {
        if leftItemIcon.count > 0 {
            leftItem.setTitle(nil, for: .normal)

            leftItem.setImage(.image(for: leftItemIcon), for: .normal)
        }else {
            leftItem.setImage(nil, for: .normal)

            leftItem.titleLabel?.font = .font(fontSize: 14)
            leftItem.setTitle(leftItemTitle, for: .normal)
            leftItem.setTitleColor(RGB(51, 51, 51), for: .normal)
        }

        setNeedsLayout()
        layoutIfNeeded()
    }
    
    //MARK: - public
    
    /// 点击右边按钮是否搜索
    public var isRightItemSearch: Bool = false
    
    public var returnKeyType: UIReturnKeyType = .default {
        didSet {
            searchTf.returnKeyType = .search
        }
    }
    
    public var searchPlaceholder: String? {
        didSet {
            if searchPlaceholder?.count ?? 0 > 0 {
                let attributeText = NSMutableAttributedString.init(string: searchPlaceholder!)
                attributeText.addAttributes([NSAttributedString.Key.foregroundColor: RGB(102, 102, 102)],
                                            range: .init(location: 0, length: searchPlaceholder!.count))
                attributeText.addAttributes([NSAttributedString.Key.font: UIFont.font(fontSize: 13)],
                                            range: .init(location: 0, length: searchPlaceholder!.count))

                searchTf.attributedPlaceholder = attributeText
            }
        }
    }

    public var tfBgColor: UIColor? {
        didSet {
            if tfBgColor != nil {
                contentContainer.backgroundColor = tfBgColor
            }
        }
    }
    
    public var safeArea: UIEdgeInsets = .zero {
        didSet {
            leftItem.snp.updateConstraints { $0.centerY.equalTo(snp.centerY).offset(safeArea.top / 2.0) }
            contentContainer.snp.updateConstraints { $0.top.equalTo(snp.top).offset(7 + safeArea.top) }
        }
    }
    
    public var hasBottomLine: Bool = false {
        didSet {
            bottomLine.isHidden = !hasBottomLine
        }
    }
    
    //MARK: - lazy
    private lazy var leftItem: TYClickedButton = {
        let item = TYClickedButton()
        item.setTitleColor(RGB(51, 51, 51), for: .normal)
        item.addTarget(self, action: #selector(TYSearchBar.leftItemTapAction), for: .touchUpInside)
        self.addSubview(item)
        return item;
    }()
    
    private lazy var rightItem: TYClickedButton = {
        let item = TYClickedButton()
        item.setTitleColor(RGB(51, 51, 51), for: .normal)
        item.addTarget(self, action: #selector(TYSearchBar.rightItemTapAction), for: .touchUpInside)
        self.addSubview(item)

        return item;
    }()

    private lazy var contentContainer: UIView = {
        let container = UIView()
        container.backgroundColor = RGB(255, 255, 255, 0.6)
        self.addSubview(container)
        return container
    }()

    private lazy var searchIcon: UIImageView = {
        let imgV = UIImageView.init(image: .image(for: "nav_search"))
        imgV.contentMode = .scaleAspectFill
        imgV.clipsToBounds = true
        self.contentContainer.addSubview(imgV)
        return imgV
    }()

    private lazy var searchTf: UITextField = {
        let tf = UITextField()
        tf.font = .font(fontSize: 13)
        tf.textColor = RGB(60, 60, 60)
        tf.delegate = self
        self.contentContainer.addSubview(tf)
        return tf
    }()
    
    private lazy var bottomLine: UIView = {
        let line = UIView()
        line.backgroundColor = RGB(235, 235, 235)
        line.isHidden = true
        self.addSubview(line)
        self.bringSubviewToFront(line)
        return line
    }()
    
    private lazy var inputCover: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(TYSearchBar.tapAction), for: .touchUpInside)
        self.addSubview(button)
        return button
    }()
    
    //MARK: - 控制UI显示
    public var coverButtonEnable: Bool = true {
        didSet {
            inputCover.isUserInteractionEnabled = coverButtonEnable
        }
    }
    
    public var leftItemIcon: String = "" {
        didSet {
            updateLeftItem()
        }
    }
    
    public var leftItemTitle: String = "" {
        didSet {
            updateRightItem()
        }
    }

    public var rightItemIcon: String = "" {
        didSet {
            updateRightItem()
        }
    }
    
    public var rightItemTitle: String = "" {
        didSet {
            updateRightItem()
        }
    }
    
    public var inputBackGroundColor: UIColor? {
        didSet {
            contentContainer.backgroundColor = inputBackGroundColor
        }
    }
    
    public var tfSearchIcon: String = "" {
        didSet {
            searchIcon.image = UIImage.init(named: tfSearchIcon)
        }
    }
    
    //MARK: - private
    
    @objc private func tapAction() {
        tapInputCallBack?()
    }
    
    @objc private func leftItemTapAction() {
        leftItemTapBack?()
    }

    @objc private func rightItemTapAction() {
        searchTf.resignFirstResponder()
        if isRightItemSearch {
            beginSearch?(searchTf.text ?? "")
        }else {
            rightItemTapBack?()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentContainer.layer.cornerRadius = contentContainer.height / 2.0
        if rightItemIcon.count > 0 {
            rightItem.snp.updateConstraints{ $0.size.equalTo(CGSize.init(width: 30, height: 30)) }
        }else if rightItemTitle.count > 0 {
            let cancelW = rightItemTitle.getTexWidth(fontSize: 14, height: 30, fontName: FontName.PingFRegular.rawValue)
            rightItem.snp.updateConstraints{ $0.size.equalTo(CGSize.init(width: cancelW, height: 30)) }
        }else {
            rightItem.snp.updateConstraints{ $0.size.equalTo(CGSize.init(width: 0, height: 30)) }
            contentContainer.snp.updateConstraints { $0.right.equalTo(rightItem.snp.left) }
        }
        
        if leftItemIcon.count > 0 {
            leftItem.snp.updateConstraints{ $0.size.equalTo(CGSize.init(width: 30, height: 30)) }
        }else if leftItemTitle.count > 0 {
            let leftTitleW = leftItemTitle.getTexWidth(fontSize: 14, height: 30, fontName: FontName.PingFRegular.rawValue)
            leftItem.snp.updateConstraints{ $0.size.equalTo(CGSize.init(width: leftTitleW, height: 30)) }
        }else {
            leftItem.snp.updateConstraints{ $0.size.equalTo(CGSize.zero) }
            contentContainer.snp.updateConstraints { $0.left.equalTo(leftItem.snp.right) }
        }
    }
}

extension TYSearchBar: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        willSearch?()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        beginSearch?(textField.text ?? "")
        return true
    }
}

extension TYSearchBar {
    
    public func reloadInput(content: String?) {
        searchTf.text = content
    }
    
    public func resignSearchFirstResponder() {
        searchTf.resignFirstResponder()
    }
}
