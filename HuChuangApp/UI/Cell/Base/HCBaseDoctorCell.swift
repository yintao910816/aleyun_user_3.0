//
//  HCBaseDoctorCell.swift
//  HuChuangApp
//
//  Created by yintao on 2019/12/16.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit

class HCBaseDoctorCell: UITableViewCell {

    public var coverImgV: UIImageView!
    public var titleLabel: UILabel!
    public var subTitleLabel: UILabel!
    public var infoLabel: UILabel!
    public var priceLabel: UILabel!
    private var sepLine: UIView!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        _setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        _setupUI()
    }

    private func _setupUI() {
        selectionStyle = .none
        
        coverImgV = UIImageView()
        coverImgV.backgroundColor = RGB(245, 245, 245)
        coverImgV.contentMode = .scaleAspectFill
        coverImgV.clipsToBounds = true
        
        titleLabel = UILabel()
        titleLabel.textColor = RGB(51, 51, 51)
        titleLabel.font = .font(fontSize: 15, fontName: .PingFSemibold)
        
        subTitleLabel = UILabel()
        subTitleLabel.textColor = RGB(102, 102, 102)
        subTitleLabel.font = .font(fontSize: 13, fontName: .PingFRegular)

        infoLabel = UILabel()
        infoLabel.textColor = RGB(153, 153, 153)
        infoLabel.numberOfLines = 2
        infoLabel.font = .font(fontSize: 11, fontName: .PingFSemibold)

        priceLabel = UILabel()
        priceLabel.textColor = HC_MAIN_COLOR
        priceLabel.font = .font(fontSize: 18, fontName: .PingFSemibold)
        
        sepLine = UIView()
        sepLine.backgroundColor = RGB(249, 249, 249)
        
        contentView.addSubview(coverImgV)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(infoLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(sepLine)
        
        sepLine.snp.makeConstraints {
            $0.left.equalTo(coverImgV.snp.left)
            $0.right.equalTo(contentView.snp.right)
            $0.bottom.equalTo(0)
            $0.height.equalTo(1)
        }

        setupUI()
    }
        
    public func setupUI() {
        
    }
    
    public var model: Any! {
        didSet {
            PrintLog("设置数据")
        }
    }
}
