//
//  HCHomePregnancyClassroomCell.swift
//  HuChuangApp
//
//  Created by sw on 2019/10/2.
//  Copyright © 2019 sw. All rights reserved.
//  孕柚课堂cell

import UIKit

public let HCHomePregnancyClassroomCell_identifier = "HCHomePregnancyClassroomCell"
class HCHomePregnancyClassroomCell: UICollectionViewCell {

    @IBOutlet weak var menuCollection: UICollectionView!
    @IBOutlet weak var coverOutlet: UIButton!
    @IBOutlet weak var countOutlet: UILabel!
    @IBOutlet weak var timeOutlet: UILabel!
    
    public class var itemHeight: CGFloat { return 247 }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        coverOutlet.imageView?.contentMode = .scaleAspectFill
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = .init(top: 0, left: 10, bottom: 0, right: 10)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 0
        
        menuCollection.collectionViewLayout = layout
        
        menuCollection.delegate = self
        menuCollection.dataSource = self
        
        menuCollection.register(UINib.init(nibName: "HCHomePregnancyClassroomCellItemCell",
                                           bundle: Bundle.main),
                                forCellWithReuseIdentifier: HCHomePregnancyClassroomCellItemCell_identifier)
    }
    
    public var menuDatas: [HCHomePregnancyClassroomMenuModel]! {
        didSet {
            menuCollection.reloadData()
        }
    }
}

extension HCHomePregnancyClassroomCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuDatas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: HCHomePregnancyClassroomCellItemCell_identifier, for: indexPath) as! HCHomePregnancyClassroomCellItemCell)
        cell.model = menuDatas[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return menuDatas[indexPath.row].itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let lastIdx = menuDatas.firstIndex(where: { $0.isSelected == true }), lastIdx != indexPath.row {
            menuDatas[lastIdx].isSelected = false
            menuDatas[indexPath.row].isSelected = true
            menuCollection.reloadData()
        }
    }
}
