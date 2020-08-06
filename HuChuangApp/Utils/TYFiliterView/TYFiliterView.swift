//
//  TYSearchRecordView.swift
//  HuChuangApp
//
//  Created by sw on 2019/10/9.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit

class TYFiliterView: UIView {

    private var contentView: UIView!
    private var collectionView: UICollectionView!
    private var bottomView: UIView!
    private var resetButton: UIButton!
    private var commitButton: UIButton!

    private var tapGes: UITapGestureRecognizer!
    
    private var lvDatas: [TYFiliterModel] = []
    private var addDatas: [TYFiliterModel] = []
    private var skillIndDatas: [TYFiliterModel] = []

    /// 医生等级 - 加号 - 擅长类型
    public var commitCallBack: ((([TYFiliterModel], [TYFiliterModel], [TYFiliterModel]))->())?
    
    public var datasource: [TYFiliterSectionModel] = [] {
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
        
        let layout = TYFiliterLayout()
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
        resetButton.titleLabel?.font = .font(fontSize: 12)
        resetButton.setTitle("重置", for: .normal)
        resetButton.setTitleColor(RGB(61, 55, 68), for: .normal)
        resetButton.layer.cornerRadius = 20
        resetButton.clipsToBounds = true
        resetButton.layer.borderWidth = 1
        resetButton.layer.borderColor = RGB(221, 221, 221).cgColor
        resetButton.addTarget(self, action: #selector(resetAction), for: .touchUpInside)
        bottomView.addSubview(resetButton)

        commitButton = UIButton()
        commitButton.titleLabel?.font = .font(fontSize: 12)
        commitButton.setTitle("确定", for: .normal)
        commitButton.layer.cornerRadius = 20
        commitButton.clipsToBounds = true
        commitButton.backgroundColor = HC_MAIN_COLOR
        commitButton.setTitleColor(.white, for: .normal)
        commitButton.addTarget(self, action: #selector(commitAction), for: .touchUpInside)
        bottomView.addSubview(commitButton)

        collectionView.register(TYFiliterViewCell.self, forCellWithReuseIdentifier: TYFiliterViewCell_identifier)
        collectionView.register(TYFiliterViewReusableViewHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: TYFiliterViewReusableViewHeader_identifier)
        
        tapGes = UITapGestureRecognizer.init(target: self, action: #selector(tapAction(tap:)))
        tapGes.delegate = self
        addGestureRecognizer(tapGes)
        
        contentView.snp.makeConstraints {
            $0.right.bottom.top.equalTo(0)
            $0.left.equalTo(80)
        }

        bottomView.snp.makeConstraints {
            $0.right.bottom.equalTo(0)
            $0.left.equalTo(0)
            $0.height.equalTo(60)
        }
        
        resetButton.snp.makeConstraints {
            $0.left.equalTo(15)
            $0.top.equalTo(10)
            $0.bottom.equalTo(-10)
        }
        
        commitButton.snp.makeConstraints {
            $0.left.equalTo(resetButton.snp.right).offset(15)
            $0.centerY.equalTo(resetButton.snp.centerY)
            $0.size.equalTo(resetButton.snp.size)
            $0.right.equalTo(-15)
        }

        collectionView.snp.makeConstraints {
            $0.right.top.left.equalTo(0)
            $0.bottom.equalTo(commitButton.snp.top)
        }
        
        datasource = TYFiliterSectionModel.createData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension TYFiliterView {
    
    public func excuteAnimotion(_ animotion: Bool = true) {
        isHidden = false
        
        if animotion {
            UIView.animate(withDuration: 0.25, animations: {
                if self.contentView.transform.tx == 0 {
                    self.contentView.transform = CGAffineTransform.init(translationX: self.contentView.width, y: 0)
                }else {
                    self.contentView.transform = CGAffineTransform.identity
                }
            }) { flag in
                if flag && self.contentView.transform.tx != 0 { self.isHidden = true }
            }
        }else {
            if contentView.transform.tx == 0 { self.isHidden = true }

            if contentView.transform.tx == 0 {
                contentView.transform = CGAffineTransform.init(translationX: collectionView.width, y: 0)
            }else {
                contentView.transform = CGAffineTransform.identity
            }
        }
    }
    
    @objc private func tapAction(tap: UITapGestureRecognizer) {
        excuteAnimotion(true)
    }
    
    @objc private func resetAction() {
        for item in lvDatas {
            item.isSelected = false
        }
        lvDatas.removeAll()
        
        for item in addDatas {
            item.isSelected = false
        }
        addDatas.removeAll()

        for item in skillIndDatas {
            item.isSelected = false
        }
        skillIndDatas.removeAll()

        collectionView.reloadData()        
    }
    
    @objc private func commitAction() {
        excuteAnimotion(true)
        
        commitCallBack?((lvDatas, addDatas, skillIndDatas))
    }
}

extension TYFiliterView: UIGestureRecognizerDelegate {
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return !contentView.frame.contains(gestureRecognizer.location(in: self))
    }
}

extension TYFiliterView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
        return .init(width: width, height: 44)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: TYFiliterViewCell_identifier, for: indexPath) as! TYFiliterViewCell)
        cell.model = datasource[indexPath.section].datas[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = (collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                          withReuseIdentifier: TYFiliterViewReusableViewHeader_identifier,
                                                                          for: indexPath) as! TYFiliterViewReusableViewHeader)
            let sectionModel = datasource[indexPath.section]
            header.configContent(title: sectionModel.sectionTitle)
            return header
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cellModel = datasource[indexPath.section].datas[indexPath.row]
        cellModel.isSelected = !cellModel.isSelected

        if cellModel.isSelected {
            switch indexPath.section {
            case 0:
                if !lvDatas.contains(where: { $0.title == cellModel.title }) || lvDatas.count == 0 {
                    lvDatas.append(cellModel)
                }
            case 1:
                if !addDatas.contains(where: { $0.title == cellModel.title }) || addDatas.count == 0 {
                    addDatas.append(cellModel)
                }
            case 2:
                if !skillIndDatas.contains(where: { $0.title == cellModel.title }) || skillIndDatas.count == 0 {
                    skillIndDatas.append(cellModel)
                }
            default:
                break
            }
        }else {
            switch indexPath.section {
            case 0:
                lvDatas = lvDatas.filter{ $0.title != cellModel.title }
            case 1:
                addDatas = lvDatas.filter{ $0.title != cellModel.title }
            case 2:
                skillIndDatas = lvDatas.filter{ $0.title != cellModel.title }
            default:
                break
            }
        }
        
        collectionView.reloadData()
    }
}

extension TYFiliterView: TYFiliterLayoutDelegate {
    
    func itemSize(for indexPath: IndexPath, layout: TYFiliterLayout) -> CGSize {
        return datasource[indexPath.section].datas[indexPath.row].contentSize
    }
    
    func referenceSize(forHeader insSection: Int, layout: TYFiliterLayout) -> CGSize {
        return .init(width: collectionView.width, height: 44)
    }
    
    func minimumLineSpacing(in section: Int, layout: TYFiliterLayout) -> CGFloat {
        return 12
    }
    
    func minimumInterSpacing(in section: Int, layout: TYFiliterLayout) -> CGFloat {
        return 7
    }
    
    func sectionInset(in section: Int, layout: TYFiliterLayout) -> UIEdgeInsets {
        return .init(top: 12, left: 10, bottom: 0, right: 10)
    }
    
}

//MARK: -- TYFiliterViewCell
public let TYFiliterViewCell_identifier = "TYFiliterViewCell"
class TYFiliterViewCell: UICollectionViewCell {
    
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
    
    public var model: TYFiliterModel! {
        didSet {
            contentLabel.text = model.title
            backgroundColor = model.bgColor
            contentLabel.textColor = model.titleColor
        }
    }
    
}

//MARK: -- TYFiliterViewReusableViewHeader
public let TYFiliterViewReusableViewHeader_identifier = "TYFiliterViewReusableViewHeader"
class TYFiliterViewReusableViewHeader: UICollectionReusableView {
    private var titleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel = UILabel()
        titleLabel.font = .font(fontSize: 14, fontName: .PingFMedium)
        titleLabel.textColor = RGB(51, 51, 51)
                
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(10)
            $0.centerY.equalTo(snp.centerY)
        }
    }
    
    public func configContent(title: String) {
        titleLabel.text = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
