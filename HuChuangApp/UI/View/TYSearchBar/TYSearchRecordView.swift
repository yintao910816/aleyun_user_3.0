//
//  TYSearchRecordView.swift
//  HuChuangApp
//
//  Created by sw on 2019/10/9.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit

class TYSearchRecordView: UIView {

    private var collectionView: UICollectionView!
    
    public var clearRecordsCallBack: (()->())?
    public var selectedCallBack: ((String)->())?

    public var recordDatasource: [TYSearchSectionModel] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        let layout = TYSearchRecordLayout()
        layout.layoutDelegate = self
        
        collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        addSubview(collectionView)
        
        collectionView.register(TYSearchRecordCell.self, forCellWithReuseIdentifier: TYSearchRecordCell_identifier)
        collectionView.register(TYSearchRecordReusableViewHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: TYSearchRecordReusableViewHeader_identifier)
        
        collectionView.snp.makeConstraints { $0.edges.equalTo(UIEdgeInsets.zero) }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension TYSearchRecordView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return recordDatasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recordDatasource[section].recordDatas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return recordDatasource[indexPath.section].recordDatas[indexPath.row].contentSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: width, height: 44)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: TYSearchRecordCell_identifier, for: indexPath) as! TYSearchRecordCell)
        cell.model = recordDatasource[indexPath.section].recordDatas[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = (collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                          withReuseIdentifier: TYSearchRecordReusableViewHeader_identifier,
                                                                          for: indexPath) as! TYSearchRecordReusableViewHeader)
            let sectionModel = recordDatasource[indexPath.section]
            header.configContent(title: sectionModel.sectionTitle, showDelete: sectionModel.showDelete)
            header.clearRecordsCallBack = { [weak self] in
                self?.clearRecordsCallBack?()
            }
            return header
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedCallBack?(recordDatasource[indexPath.section].recordDatas[indexPath.row].keyWord)
    }
}

extension TYSearchRecordView: TYSearchRecordLayoutDelegate {
    
    func itemSize(for indexPath: IndexPath, layout: TYSearchRecordLayout) -> CGSize {
        return recordDatasource[indexPath.section].recordDatas[indexPath.row].contentSize
    }
    
    func referenceSize(forHeader insSection: Int, layout: TYSearchRecordLayout) -> CGSize {
        return .init(width: collectionView.width, height: 44)
    }
    
    func minimumLineSpacing(in section: Int, layout: TYSearchRecordLayout) -> CGFloat {
        return 12
    }
    
    func minimumInterSpacing(in section: Int, layout: TYSearchRecordLayout) -> CGFloat {
        return 7
    }
    
    func sectionInset(in section: Int, layout: TYSearchRecordLayout) -> UIEdgeInsets {
        return .init(top: 12, left: 10, bottom: 0, right: 10)
    }
    
}

//MARK: -- TYSearchRecordCell
public let TYSearchRecordCell_identifier = "TYSearchRecordCell"
class TYSearchRecordCell: UICollectionViewCell {
    
    private var contentLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .white
        
        contentLabel = UILabel()
        contentLabel.font = .font(fontSize: 12, fontName: .PingFRegular)
        contentLabel.backgroundColor = RGB(246, 246, 246)
        contentLabel.textColor = RGB(61, 55, 68)
        contentLabel.layer.cornerRadius = 15
        contentLabel.textAlignment = .center
        contentLabel.clipsToBounds = true
                
        contentView.addSubview(contentLabel)
        
        contentLabel.snp.makeConstraints { $0.edges.equalTo(UIEdgeInsets.zero) }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var model: TYSearchRecordModel! {
        didSet {
            contentLabel.text = model.keyWord
        }
    }
    
}

//MARK: -- TYSearchRecordReusableViewHeader
public let TYSearchRecordReusableViewHeader_identifier = "TYSearchRecordReusableViewHeader"
class TYSearchRecordReusableViewHeader: UICollectionReusableView {
    private var titleLabel: UILabel!
    private var deleteButton: TYClickedButton!
    
    public var clearRecordsCallBack: (()->())?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel = UILabel()
        titleLabel.font = .font(fontSize: 14, fontName: .PingFMedium)
        titleLabel.textColor = RGB(51, 51, 51)
        
        deleteButton = TYClickedButton()
        deleteButton.backgroundColor = .clear
        deleteButton.setImage(UIImage(named: "search_delete"), for: .normal)
        deleteButton.setTitleColor(.black, for: .normal)
        deleteButton.addTarget(self, action: #selector(deleteAction), for: .touchUpInside)
        
        addSubview(titleLabel)
        addSubview(deleteButton)
        
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(10)
            $0.centerY.equalTo(snp.centerY)
        }
        
        deleteButton.snp.makeConstraints {
            $0.right.equalTo(-10)
            $0.centerY.equalTo(snp.centerY)
            $0.size.equalTo(CGSize(width: 20, height: 20))
        }
    }
    
    public func configContent(title: String, showDelete: Bool) {
        titleLabel.text = title
        deleteButton.isHidden = !showDelete
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func deleteAction() {
        clearRecordsCallBack?()
    }
}
