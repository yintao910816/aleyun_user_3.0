//
//  HCMenuPickerView.swift
//  HuChuangApp
//
//  Created by yintao on 2020/11/5.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCPickerMenuView: UIView {

    private var collectionView: UICollectionView!
    
    public var selectedMenu:((HCPickerMenuItemModel)->())?
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView.init(frame: frame, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        addSubview(collectionView)
        
        collectionView.register(HCPickerMenuCell.self, forCellWithReuseIdentifier: HCPickerMenuCell_identifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public var sectionDatas: [HCPickerMenuSectionModel] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        collectionView.frame = bounds
    }
}

extension HCPickerMenuView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sectionDatas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sectionDatas[section].items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HCPickerMenuCell_identifier, for: indexPath)
        (cell as? HCPickerMenuCell)?.model = sectionDatas[indexPath.section].items[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionDatas[section].sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 60, height: 60 + sectionDatas[indexPath.section].items[indexPath.row].textHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let sectionModel = sectionDatas[section]
        return (collectionView.width - sectionModel.sectionInsets.left - sectionModel.sectionInsets.left - CGFloat(sectionModel.countForFull * 60)) / CGFloat(sectionModel.countForFull - 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedMenu?(sectionDatas[indexPath.section].items[indexPath.row])
    }
}

//MARK:
//MARK: cell
fileprivate let HCPickerMenuCell_identifier = "HCPickerMenuCell"
class HCPickerMenuCell: UICollectionViewCell {
    
    private var iconBgView: UIView!
    private var iconView: UIImageView!
    private var titleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        
        iconBgView = UIView()
        iconBgView.backgroundColor = .white
        iconBgView.clipsToBounds = true
        
        iconView = UIImageView()
        iconView.contentMode = .scaleAspectFill
        iconView.clipsToBounds = true
        
        titleLabel = UILabel()
        titleLabel.textAlignment = .center
        
        addSubview(iconBgView)
        iconBgView.addSubview(iconView)
        addSubview(titleLabel)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public var model: HCPickerMenuItemModel! {
        didSet {
            iconBgView.layer.cornerRadius = model.cornerRadius
            iconView.image = model.iconImage
            titleLabel.text = model.title
            titleLabel.font = model.titleFont
            titleLabel.textColor = model.titleColor
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        iconBgView.frame = .init(x: 0, y: 0, width: width, height: width)
        iconView.frame = .init(x: 15, y: 15, width: iconBgView.width - 30, height: iconBgView.height - 30)
        
        let titleY = iconBgView.frame.maxY + model.iconTitleMargin
        titleLabel.frame = .init(x: 0, y: titleY, width: width, height: height - titleY)
    }
}
