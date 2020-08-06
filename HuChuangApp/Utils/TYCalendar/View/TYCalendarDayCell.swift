//
//  TYCalendarDayCell.swift
//  HuChuangApp
//
//  Created by sw on 2019/10/17.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit

public let TYCalendarDayCell_identifier = "ty_calendarDayCell_identifier"
class TYCalendarDayCell: UICollectionViewCell {
    
    private var dayLabel: UILabel!
    private var rightLine: UIView!
    private var bottomLine: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - public
    public var model: TYCalendarItem! {
        didSet {
            dayLabel.text = "\(model.day)"
            dayLabel.textColor = model.textColor
        }
    }
    //MARK: - private
    private func setupUI() {
        dayLabel = UILabel()
        dayLabel.textAlignment = .center
        dayLabel.textColor = .black
        contentView.addSubview(dayLabel)
        
        rightLine = UIView()
        rightLine.backgroundColor = RGB(245, 245, 245)
        contentView.addSubview(rightLine)
     
        bottomLine = UIView()
        bottomLine.backgroundColor = RGB(245, 245, 245)
        contentView.addSubview(bottomLine)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        dayLabel.frame = bounds
        
        rightLine.frame = .init(x: width - 1, y: 0, width: 1, height: height)
        bottomLine.frame = .init(x: 0, y: height - 1, width: width, height: 1)
    }
}
