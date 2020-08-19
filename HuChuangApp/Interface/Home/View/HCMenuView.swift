//
//  HCMenuView.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/13.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCMenuView: UIView {

    private var collectionView: UICollectionView!
    private var animotionView: UIView!
    
    private var lastSelectedIdx: IndexPath = .init(row: 0, section: 0)
    
    public var menuChanged: ((HCMenuItemModel)->())?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var datasource: [HCMenuItemModel] = [] {
        didSet {
            for idx in 0..<datasource.count {
                if datasource[idx].isSelected {
                    lastSelectedIdx = .init(row: idx, section: 0)
                    break
                }
            }
            
            collectionView.performBatchUpdates({
                collectionView.reloadData()
            }) { [weak self] flag in
                if flag, let strongSelf = self {
                    strongSelf.beginAnimotion(to: strongSelf.lastSelectedIdx, animotion: false)
                }
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        collectionView.frame = .init(x: 0, y: 0, width: width, height: height - 4)
        animotionView.frame = .init(x: 0, y: height - 4, width: 15, height: 4)
    }
}

extension HCMenuView {
    
    private func initUI() {
        backgroundColor = .white
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = backgroundColor
        collectionView.dataSource = self
        collectionView.delegate = self
        
        animotionView = UIView()
        animotionView.backgroundColor = RGB(255, 79, 120)
        animotionView.layer.cornerRadius = 2
        animotionView.clipsToBounds = true
        
        addSubview(collectionView)
        addSubview(animotionView)
        
        collectionView.register(HCMenuCell.self, forCellWithReuseIdentifier: HCMenuCell_identifier)
    }
    
    private func beginAnimotion(to: IndexPath, animotion: Bool) {
        if let frame = collectionView.layoutAttributesForItem(at: to)?.frame {
            let convertFrame = collectionView.convert(frame, to: self)
            
            let animotionViewX: CGFloat = convertFrame.minX + (convertFrame.size.width - animotionView.width) / 2.0
            let animotionViewFrame = CGRect.init(x: animotionViewX, y: animotionView.y, width: animotionView.width, height: animotionView.height)
            
            if animotion {
                UIView.animate(withDuration: 0.25) { [weak self] in
                    self?.animotionView.frame = animotionViewFrame
                }
            }else {
                animotionView.frame = animotionViewFrame
            }
        }
    }
}

extension HCMenuView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HCMenuCell_identifier, for: indexPath) as! HCMenuCell
        cell.model = datasource[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: datasource[indexPath.row].contentWidth, height: datasource[indexPath.row].contentHeight)
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 25
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row != lastSelectedIdx.row {
            datasource[lastSelectedIdx.row].isSelected = false
            datasource[indexPath.row].isSelected = true
            
            lastSelectedIdx = indexPath
            collectionView.reloadData()
            
            beginAnimotion(to: indexPath, animotion: true)
            
            menuChanged?(datasource[indexPath.row])
        }
    }
}

// MARK:
// MARK: HCMenuCell
private let HCMenuCell_identifier = "HCMenuCell"
class HCMenuCell: UICollectionViewCell {
    private var titleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel = UILabel()
        titleLabel.backgroundColor = .clear
        titleLabel.textAlignment = .center
        titleLabel.font = .font(fontSize: 14)
        addSubview(titleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var model: HCMenuItemModel! {
        didSet {
            titleLabel.text = model.titleText
            titleLabel.font = model.textFont
            titleLabel.textColor = model.isSelected ? model.selectedTextColor : model.textColor
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.frame = bounds
    }
}

// MARK:
// MARK: HCMenuItemModel
class HCMenuItemModel {
    public var textColor: UIColor = RGB(153, 153, 153)
    public var selectedTextColor: UIColor = RGB(51, 51, 51)
    
    public var textFont: UIFont = .font(fontSize: 18, fontName: .PingFMedium)
    public var selectedTextFont: UIFont = .font(fontSize: 18)
    
    public var titleText: String = ""
    public var isSelected: Bool = false
    /// 服务器返回id
    public var itemId: String = ""
    
    public var contentHeight: CGFloat = 45

    public var contentWidth: CGFloat {
        get {
            return self.titleText.ty_textSize(font: isSelected ? selectedTextFont : textFont,
                                              width: CGFloat(MAXFLOAT),
                                              height: contentHeight).width
        }
    }
}
