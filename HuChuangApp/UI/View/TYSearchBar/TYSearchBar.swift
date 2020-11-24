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

    /// 点击右边按钮是否搜索
    public var isRightItemSearch: Bool = false
    
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
                
        searchTf.rx.text.asObservable()
            .map{ ($0 == nil ? "" : $0!) }
            .bind(to: textObser)
            .disposed(by: disposeBag)        
    }
        
    //MARK: - public
    public var hasBottomLine: Bool = false {
        didSet {
            bottomLine.isHidden = !hasBottomLine
        }
    }
        
    //MARK: - 控制UI显示
    public var coverButtonEnable: Bool = true {
        didSet {
            inputCover.isUserInteractionEnabled = coverButtonEnable
        }
    }
    
    /// 初始化时，必须负值
    public var viewConfig: TYSearchBarConfig = TYSearchBarConfig() {
        didSet {
            searchTf.returnKeyType = viewConfig.returnKeyType
            contentContainer.backgroundColor = viewConfig.tfBackGroundColor
            
            if viewConfig.existLeftItem() {
                leftItem.setImage(viewConfig.leftIcon, for: .normal)
                leftItem.setTitle(viewConfig.leftTitle, for: .normal)
                leftItem.titleLabel?.font = viewConfig.leftTitleFont
                leftItem.setTitleColor(viewConfig.leftTitleColor, for: .normal)
            }
            
            if viewConfig.existRightItem() {
                rightItem.setImage(viewConfig.rightIcon, for: .normal)
                rightItem.setTitle(viewConfig.rightTitle, for: .normal)
                rightItem.titleLabel?.font = viewConfig.rightTitleFont
                rightItem.setTitleColor(viewConfig.rightTitleColor, for: .normal)
            }
            
            if viewConfig.tfSearchIcon != nil {
                searchIcon.image = viewConfig.tfSearchIcon
            }
            
            reloadPlaceholder()

            setNeedsLayout()
            layoutIfNeeded()
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
        
        var saftAreaTop: CGFloat = 0
        if #available(iOS 11.0, *), viewConfig.isInNav {
            saftAreaTop = safeAreaInsets.top
        }

        let layoutH: CGFloat = height - saftAreaTop
        
        var tfBgX: CGFloat = 15
        var tfMaxBgX: CGFloat = width - viewConfig.inset.right

        var tempSize: CGSize = .zero
        if viewConfig.leftIcon != nil  {
            leftItem.frame = .init(x: viewConfig.inset.left,
                                   y: ((layoutH - viewConfig.leftIconSize.height) / 2) + saftAreaTop,
                                   width: viewConfig.leftIconSize.width,
                                   height: viewConfig.leftIconSize.height)
            tfBgX = leftItem.frame.maxX + viewConfig.tfBGLeftMargin
        }else if viewConfig.leftTitle.count > 0 {
            tempSize = leftItem.sizeThatFits(.init(width: CGFloat.greatestFiniteMagnitude, height: layoutH))
            leftItem.frame = .init(x: viewConfig.inset.left,
                                   y: ((layoutH - tempSize.height) / 2) + saftAreaTop,
                                   width: tempSize.width,
                                   height: tempSize.height)
            tfBgX = leftItem.frame.maxX + viewConfig.tfBGLeftMargin
        }else {
            
        }
        
        if viewConfig.rightIcon != nil {
            rightItem.frame = .init(x: width - viewConfig.inset.right - viewConfig.rightIconSize.width,
                                   y: ((layoutH - viewConfig.rightIconSize.height) / 2) + saftAreaTop,
                                   width: viewConfig.rightIconSize.width,
                                   height: viewConfig.rightIconSize.height)
            tfMaxBgX = rightItem.frame.minX - viewConfig.tfBGRightMargin
        }else if viewConfig.rightTitle.count > 0 {
            tempSize = rightItem.sizeThatFits(.init(width: CGFloat.greatestFiniteMagnitude, height: layoutH))
            rightItem.frame = .init(x: width - viewConfig.inset.right - tempSize.width,
                                    y: ((layoutH - tempSize.height) / 2) + saftAreaTop,
                                    width: tempSize.width,
                                    height: tempSize.height)
            tfMaxBgX = rightItem.frame.minX - viewConfig.tfBGRightMargin
        }else {
            
        }
        
        contentContainer.frame = .init(x: tfBgX,
                                       y: viewConfig.inset.top + saftAreaTop,
                                       width: tfMaxBgX - tfBgX,
                                       height: layoutH - viewConfig.inset.top - viewConfig.inset.bottom)

        if viewConfig.tfSearchIcon != nil {
            searchIcon.frame = .init(x: viewConfig.tfOrSearchIconX,
                                     y: (contentContainer.height - viewConfig.tfSearchIconSize.height) / 2,
                                     width: viewConfig.tfSearchIconSize.width,
                                     height: viewConfig.tfSearchIconSize.height)
            
            let tfX: CGFloat = searchIcon.frame.maxX + viewConfig.tfInset.left
            searchTf.frame = .init(x: tfX,
                                   y: viewConfig.tfInset.top,
                                   width: contentContainer.width - viewConfig.tfInset.right - tfX,
                                   height: (contentContainer.height - viewConfig.tfInset.top - viewConfig.tfInset.bottom))
        }else {
            searchTf.frame = .init(x: viewConfig.tfOrSearchIconX,
                                   y: viewConfig.tfInset.top,
                                   width: contentContainer.width - viewConfig.tfInset.right - viewConfig.tfOrSearchIconX,
                                   height: (contentContainer.height - viewConfig.tfInset.top - viewConfig.tfInset.bottom))
        }
        
        inputCover.frame = .init(x: 0, y: 0, width: contentContainer.width, height: contentContainer.height)
        bottomLine.frame = .init(x: 0, y: height - 0.5, width: width, height: 0.5)
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
        container.layer.cornerRadius = 5
        container.clipsToBounds = true
        self.addSubview(container)
        return container
    }()

    private lazy var searchIcon: UIImageView = {
        let imgV = UIImageView()
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
        self.contentContainer.addSubview(button)
        return button
    }()
}

extension TYSearchBar {
    
    private func reloadPlaceholder() {
        if let placeholder = viewConfig.searchPlaceholder {
            let attributeText = NSMutableAttributedString.init(string: placeholder)
            attributeText.addAttributes([NSAttributedString.Key.foregroundColor: viewConfig.searchPlaceholderColor],
                                        range: .init(location: 0, length: placeholder.count))
            attributeText.addAttributes([NSAttributedString.Key.font: viewConfig.tfFont],
                                        range: .init(location: 0, length: placeholder.count))

            searchTf.attributedPlaceholder = attributeText
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

struct TYSearchBarConfig {
    public var isInNav: Bool = true
    
    public var tfFont: UIFont = .font(fontSize: 14)
    public var tfTextColor: UIColor = RGB(51, 51, 51)
    public var searchPlaceholder: String?
    public var searchPlaceholderColor: UIColor = RGB(203, 203, 203)

    public var inset: UIEdgeInsets = .init(top: 5, left: 15, bottom: 5, right: 15)
    /// 输入框与左边item的间距
    public var tfBGLeftMargin: CGFloat = 12
    /// 输入框与右边边item的间距
    public var tfBGRightMargin: CGFloat = 12

    public var leftTitle: String = ""
    public var leftTitleFont: UIFont = .font(fontSize: 15)
    public var leftTitleColor: UIColor = .white
    
    public var rightTitle: String = ""
    public var rightTitleFont: UIFont = .font(fontSize: 15)
    public var rightTitleColor: UIColor = .white

    public var leftIcon: UIImage?
    public var leftIconSize: CGSize = .zero
    public var rightIcon: UIImage?
    public var rightIconSize: CGSize = .zero

    public var tfBackGroundRadius: CGFloat = 5
    public var tfBackGroundColor: UIColor = .white
    
    public var tfSearchIcon: UIImage? = UIImage.init(named: "searchBar_searchIcon")
    public var tfSearchIconSize: CGSize = .init(width: 14, height: 14)
    public var tfInset: UIEdgeInsets = .init(top: 5, left: 10, bottom: 5, right: 10)
    public var tfOrSearchIconX: CGFloat = 10

    public var returnKeyType: UIReturnKeyType = .search
    
    public func existLeftItem() ->Bool {
        return leftIcon != nil || leftTitle.count > 0
    }
    
    public func existRightItem() ->Bool {
        return rightIcon != nil || rightTitle.count > 0
    }
    
    /// 首页
    static public func createHomeSearch() ->TYSearchBarConfig {
        return TYSearchBarConfig.init(searchPlaceholder: "搜索", leftTitle: "试管婴儿", leftTitleFont: .font(fontSize: 18), rightIcon: UIImage.init(named: "nav_message"), rightIconSize: .init(width: 24, height: 27), tfBackGroundRadius: 5)
    }
    
    /// 搜索
    static public func createSearch() ->TYSearchBarConfig {
        return TYSearchBarConfig.init(searchPlaceholder: "搜索", rightTitle: "取消", rightTitleColor: RGB(51, 51, 51), leftIcon: UIImage(named: "navigationButtonReturnClick"), leftIconSize: .init(width: 30, height: 30), tfBackGroundColor: RGB(245, 245, 245))
    }
    
    /// 生殖中心
    static public func createSZZX() ->TYSearchBarConfig {
        return TYSearchBarConfig.init(isInNav: false, tfFont: .font(fontSize: 16), searchPlaceholder: "搜索医院", searchPlaceholderColor: RGB(153, 153, 153), tfBackGroundColor: RGB(243, 243, 243))
    }
    
    /// 药品百科
    static public func createYPBK() ->TYSearchBarConfig {
        return TYSearchBarConfig.init(isInNav: false, tfFont: .font(fontSize: 16), searchPlaceholder: "搜索药物", searchPlaceholderColor: RGB(153, 153, 153), inset: .init(top: 10, left: 15, bottom: 10, right: 15), tfBackGroundColor: RGB(243, 243, 243))
    }
}
