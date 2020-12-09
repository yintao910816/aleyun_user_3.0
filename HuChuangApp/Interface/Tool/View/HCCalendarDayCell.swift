//
//  TYCalendarDayCell.swift
//  HuChuangApp
//
//  Created by sw on 2019/10/17.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit

public let HCCalendarDayCell_identifier = "HCCalendarDayCell"
class HCCalendarDayCell: UICollectionViewCell {
    
    private var dayLabel: UILabel!
    private var selectedBGView: UIView!
    private var container: UIView!
    private var topRightIcon: UIImageView!
    private var bottomLeftIcon: UIImageView!
    private var bottomRightIcon: UIImageView!

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
            dayLabel.textColor = model.mensturationMode.color

            if model.bottomRightIcon != nil {
                PrintLog("显示标记：\(model.dateText)")
            }
            
            if model.isInMonth {
                bottomLeftIcon.isHidden = model.isBottomLeftIconHidden
                dayLabel.isHidden = false
                selectedBGView.isHidden = !model.isSelected
                container.backgroundColor = model.bgColor
                topRightIcon.image = model.topRightIcon
                bottomLeftIcon.image = model.bottomLeftIcon
                bottomRightIcon.image = model.bottomRightIcon
            }else {
                bottomLeftIcon.isHidden = true
                dayLabel.isHidden = true
                selectedBGView.isHidden = true
                container.backgroundColor = .white
                topRightIcon.image = nil
                bottomLeftIcon.image = nil
                bottomRightIcon.image = nil
            }
            
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    //MARK: - private
    private func setupUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        selectedBGView = UIView()
        selectedBGView.backgroundColor = .white
        selectedBGView.layer.cornerRadius = 4
        selectedBGView.layer.borderWidth = 1
        selectedBGView.layer.borderColor = HC_MAIN_COLOR.cgColor
        selectedBGView.clipsToBounds = true

        container = UIView()
        container.backgroundColor = .white
        container.layer.cornerRadius = 4
        container.clipsToBounds = true

        dayLabel = UILabel()
        dayLabel.textColor = .black
        dayLabel.font = .font(fontSize: 16, fontName: .PingFMedium)
        
        topRightIcon = UIImageView()
        topRightIcon.contentMode = .scaleAspectFill
        topRightIcon.clipsToBounds = true

        bottomLeftIcon = UIImageView()
        bottomLeftIcon.contentMode = .scaleAspectFill
        bottomLeftIcon.clipsToBounds = true

        bottomRightIcon = UIImageView()
        bottomRightIcon.contentMode = .scaleAspectFill
        bottomRightIcon.clipsToBounds = true

        addSubview(selectedBGView)
        addSubview(container)
        container.addSubview(topRightIcon)
        container.addSubview(bottomLeftIcon)
        container.addSubview(bottomRightIcon)
        container.addSubview(dayLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        selectedBGView.frame = bounds
        
        container.frame = .init(x: 2.5, y: 2.5, width: width - 5, height: height - 5)
        
        var tempSize = dayLabel.sizeThatFits(.init(width: container.width - 10, height: CGFloat.greatestFiniteMagnitude))
        dayLabel.frame = .init(x: 5, y: 5, width: tempSize.width, height: tempSize.height)

        tempSize = topRightIcon.sizeThatFits(.init(width: CGFloat.greatestFiniteMagnitude, height: 12))
        topRightIcon.frame = .init(x: width - 6.5 - tempSize.width,
                                   y: 3.5,
                                   width: tempSize.width,
                                   height: tempSize.height)

        tempSize = bottomLeftIcon.sizeThatFits(.init(width: CGFloat.greatestFiniteMagnitude, height: 12))
        bottomLeftIcon.frame = .init(x: dayLabel.x,
                                     y: container.height - 2 - tempSize.height,
                                     width: tempSize.width,
                                     height: tempSize.height)
        
        tempSize = bottomRightIcon.sizeThatFits(.init(width: CGFloat.greatestFiniteMagnitude, height: 12))
        bottomRightIcon.frame = .init(x: width - 6.5 - tempSize.width,
                                   y: container.height - 2 - tempSize.height,
                                   width: tempSize.width,
                                   height: tempSize.height)
        
    }
}
