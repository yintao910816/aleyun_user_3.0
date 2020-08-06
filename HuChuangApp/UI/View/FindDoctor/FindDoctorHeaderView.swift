//
//  FindDoctorHeaderView.swift
//  HuChuangApp
//
//  Created by sw on 2019/10/2.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit

class FindDoctorHeaderView: UIView {

    private var pregnancyImgV: UIImageView!
    private var ovaryImgV: UIImageView!
    private var otherImgV: UIImageView!

    private var pregnancyLabel: UILabel!
    private var ovaryLabel: UILabel!
    private var otherLabel: UILabel!
    
    private var bottomLine: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        pregnancyImgV = UIImageView.init(image: nil)
        pregnancyImgV.contentMode = .scaleAspectFill
        pregnancyImgV.clipsToBounds = true
        pregnancyImgV.backgroundColor = .darkGray

        pregnancyLabel = UILabel()
        pregnancyLabel.backgroundColor = .clear
        pregnancyLabel.textColor = RGB(51, 51, 51)
        pregnancyLabel.font = .font(fontSize: 14, fontName: .PingFMedium)
        pregnancyLabel.text = "备孕中"
        
        ovaryImgV = UIImageView.init(image: nil)
        ovaryImgV.contentMode = .scaleAspectFill
        ovaryImgV.clipsToBounds = true
        ovaryImgV.backgroundColor = .darkGray

        ovaryLabel = UILabel()
        ovaryLabel.backgroundColor = .clear
        ovaryLabel.textColor = RGB(51, 51, 51)
        ovaryLabel.font = .font(fontSize: 14, fontName: .PingFMedium)
        ovaryLabel.text = "卵巢功能"

        otherImgV = UIImageView.init(image: nil)
        otherImgV.contentMode = .scaleAspectFill
        otherImgV.clipsToBounds = true
        otherImgV.backgroundColor = .darkGray

        otherLabel = UILabel()
        otherLabel.backgroundColor = .clear
        otherLabel.textColor = RGB(51, 51, 51)
        otherLabel.font = .font(fontSize: 14, fontName: .PingFMedium)
        otherLabel.text = "其它"

        bottomLine = UIView()
        bottomLine.backgroundColor = RGB(245, 245, 245)
        
        addSubview(ovaryImgV)
        addSubview(ovaryLabel)
        addSubview(pregnancyImgV)
        addSubview(pregnancyLabel)
        addSubview(otherImgV)
        addSubview(otherLabel)
        addSubview(bottomLine)

        ovaryImgV.snp.makeConstraints {
            $0.centerX.equalTo(snp.centerX)
            $0.centerY.equalTo(snp.centerY).offset(-18)
            $0.size.equalTo(CGSize.init(width: 80, height: 80))
        }
        ovaryLabel.snp.makeConstraints {
            $0.centerX.equalTo(ovaryImgV.snp.centerX)
            $0.top.equalTo(ovaryImgV.snp.bottom).offset(14)
        }
        
        pregnancyImgV.snp.makeConstraints {
            $0.right.equalTo(ovaryImgV.snp.left).offset(-38)
            $0.centerY.equalTo(ovaryImgV.snp.centerY)
            $0.size.equalTo(CGSize.init(width: 80, height: 80))
        }
        pregnancyLabel.snp.makeConstraints {
            $0.centerX.equalTo(pregnancyImgV.snp.centerX)
            $0.top.equalTo(pregnancyImgV.snp.bottom).offset(14)
        }

        otherImgV.snp.makeConstraints {
            $0.left.equalTo(ovaryImgV.snp.right).offset(38)
            $0.centerY.equalTo(ovaryImgV.snp.centerY)
            $0.size.equalTo(CGSize.init(width: 80, height: 80))
        }
        otherLabel.snp.makeConstraints {
            $0.centerX.equalTo(otherImgV.snp.centerX)
            $0.top.equalTo(otherImgV.snp.bottom).offset(14)
        }

        bottomLine.snp.makeConstraints {
            $0.left.right.bottom.equalTo(0)
            $0.height.equalTo(8)
        }
    }
    
    /// 高度
    public class func viewHeight() ->CGFloat {
        return 190
    }
}
