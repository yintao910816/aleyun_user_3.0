//
//  TYSearchRecordView.swift
//  HuChuangApp
//
//  Created by sw on 2019/10/9.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit

class HCListFilterContainer: UIView {

    private var contentView: UIView!
    private var collectionView: UICollectionView!
    private var bottomView: UIView!
    private var resetButton: UIButton!
    private var commitButton: UIButton!

    private var tapGes: UITapGestureRecognizer!
    
    public var commitCallBack: ((HCListFilterModel?)->())?
    public var dismissCallBack: (()->())?

    public var datasource: [HCListFilterSectionModel] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = RGB(10, 10, 10, 0.3)
        
        contentView = UIView()
        contentView.backgroundColor = .white
        addSubview(contentView)
        
        let layout = HCListFilterLayout()
        layout.layoutDelegate = self
        
        collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        contentView.addSubview(collectionView)
        
        bottomView = UIView()
        bottomView.backgroundColor = .white
        contentView.addSubview(bottomView)
        
        resetButton = UIButton()
        resetButton.titleLabel?.font = .font(fontSize: 16)
        resetButton.setTitle("重置", for: .normal)
        resetButton.setTitleColor(RGB(51, 51, 51), for: .normal)
        resetButton.addTarget(self, action: #selector(resetAction), for: .touchUpInside)
        bottomView.addSubview(resetButton)

        commitButton = UIButton()
        commitButton.titleLabel?.font = .font(fontSize: 12)
        commitButton.setTitle("确定", for: .normal)
        commitButton.backgroundColor = HC_MAIN_COLOR
        commitButton.setTitleColor(.white, for: .normal)
        commitButton.addTarget(self, action: #selector(commitAction), for: .touchUpInside)
        bottomView.addSubview(commitButton)

        collectionView.register(HCListFilterCell.self, forCellWithReuseIdentifier: HCListFilterCell_identifier)
        collectionView.register(HCListFilterReusableViewHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: HCListFilterReusableViewHeader_identifier)
        
        tapGes = UITapGestureRecognizer.init(target: self, action: #selector(tapAction(tap:)))
        tapGes.delegate = self
        addGestureRecognizer(tapGes)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = .init(x: 0, y: 0, width: width, height: height / 2)
        
        bottomView.frame = .init(x: 0, y: contentView.height - 50, width: contentView.width, height: 50)
        resetButton.frame = .init(x: 0, y: 0, width: bottomView.width / 2, height: bottomView.height)
        commitButton.frame = .init(x: resetButton.frame.maxX, y: 0, width: bottomView.width / 2, height: bottomView.height)
        
        collectionView.frame = .init(x: 0, y: 0, width: width, height: contentView.height - 50)
    }
}

extension HCListFilterContainer {
    
    public func excuteAnimotion(_ animotion: Bool = true, complement:@escaping ((Bool)->())) {
        if animotion {
            UIView.animate(withDuration: 0.25, animations: {
                var rect = self.contentView.frame
                if self.contentView.y == 0 {
                    rect.origin.y = -self.contentView.height
                    self.contentView.frame = rect
                }else {
                    rect.origin.y = 0
                    self.contentView.frame = rect
                }
            }) { [weak self] flag in
                if flag {
                    complement(self?.contentView.y != 0)
                }
            }
        }else {
            var rect = self.contentView.frame
            if self.contentView.y == 0 {
                rect.origin.y = -self.contentView.height
                self.contentView.frame = rect
            }else {
                rect.origin.y = 0
                self.contentView.frame = rect
            }

            complement(contentView.y != 0)
        }
    }
    
    @objc private func tapAction(tap: UITapGestureRecognizer) {
        dismissCallBack?()
    }
    
    @objc private func resetAction() {
        commitCallBack?(nil)
    }
    
    @objc private func commitAction() {
        var filterModel: HCListFilterModel? = nil
        
        for item in datasource {
            var isContinue: Bool = true
            for model in item.datas {
                if model.isSelected {
                    filterModel = model
                    isContinue = false
                    break
                }
            }
            
            if !isContinue {
                break
            }
        }
        
        commitCallBack?(filterModel)
    }
}

extension HCListFilterContainer: UIGestureRecognizerDelegate {
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return !contentView.frame.contains(gestureRecognizer.location(in: self))
    }
}

extension HCListFilterContainer: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return datasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource[section].datas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return datasource[indexPath.section].datas[indexPath.row].contentSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let sectionModel = datasource[section]
        if sectionModel.sectionTitle.count > 0 {
            return .init(width: width, height: 44)
        }
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: HCListFilterCell_identifier, for: indexPath) as! HCListFilterCell)
        cell.model = datasource[indexPath.section].datas[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let sectionModel = datasource[indexPath.section]
        if kind == UICollectionView.elementKindSectionHeader, sectionModel.sectionTitle.count > 0 {
            let header = (collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                          withReuseIdentifier: HCListFilterReusableViewHeader_identifier,
                                                                          for: indexPath) as! HCListFilterReusableViewHeader)
            header.configContent(title: sectionModel.sectionTitle)
            return header
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sectionData = datasource[indexPath.section].datas
        let idx = sectionData.firstIndex(where: { $0.isSelected == true })
        if idx == nil || (idx != nil && idx! != indexPath.row) {
            if let index = idx {
                sectionData[index].isSelected = false
            }
            sectionData[indexPath.row].isSelected = true
            
            collectionView.reloadData()
        }
    }
}

extension HCListFilterContainer: HCListFilterLayoutDelegate {
    
    func itemSize(for indexPath: IndexPath, layout: HCListFilterLayout) -> CGSize {
        return datasource[indexPath.section].datas[indexPath.row].contentSize
    }
    
    func referenceSize(forHeader insSection: Int, layout: HCListFilterLayout) -> CGSize {
        let sectionModel = datasource[insSection]
        if sectionModel.sectionTitle.count > 0 {
            return .init(width: collectionView.width, height: 44)
        }
        return .zero
    }
    
    func minimumLineSpacing(in section: Int, layout: HCListFilterLayout) -> CGFloat {
        return 12
    }
    
    func minimumInterSpacing(in section: Int, layout: HCListFilterLayout) -> CGFloat {
        return 7
    }
    
    func sectionInset(in section: Int, layout: HCListFilterLayout) -> UIEdgeInsets {
        return .init(top: 12, left: 10, bottom: 0, right: 10)
    }
    
}

//MARK: -- HCListFilterCell
public let HCListFilterCell_identifier = "HCListFilterCell"
class HCListFilterCell: UICollectionViewCell {
    
    private var contentLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .white
        
        contentLabel = UILabel()
        contentLabel.font = .font(fontSize: 12, fontName: .PingFRegular)
        contentLabel.backgroundColor = RGB(246, 246, 246)
        contentLabel.textColor = RGB(61, 55, 68)
        contentLabel.layer.cornerRadius = 5
        contentLabel.textAlignment = .center
        contentLabel.clipsToBounds = true
                
        contentView.addSubview(contentLabel)
        
        contentLabel.snp.makeConstraints { $0.edges.equalTo(UIEdgeInsets.zero) }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var model: HCListFilterModel! {
        didSet {
            contentLabel.text = model.title
            backgroundColor = model.bgColor
            contentLabel.textColor = model.titleColor
        }
    }
    
}

//MARK: -- HCListFilterReusableViewHeader
public let HCListFilterReusableViewHeader_identifier = "HCListFilterReusableViewHeader"
class HCListFilterReusableViewHeader: UICollectionReusableView {
    private var titleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel = UILabel()
        titleLabel.font = .font(fontSize: 14, fontName: .PingFMedium)
        titleLabel.textColor = RGB(51, 51, 51)
                
        addSubview(titleLabel)
    }
    
    public func configContent(title: String) {
        titleLabel.text = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.frame = .init(x: 10, y: 0, width: width - 20, height: height)
    }
}
