//
//  HCExpertConsultation.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/25.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation
import HandyJSON

class HCBannerModel: HJModel, CarouselSource {
    var bak: String = ""
    var beginDate: String = ""
    var code: String = ""
    var content: String = ""
    var createDate: String = ""
    var creates: String = ""
    var del: Bool = false
    var endDate: String = ""
    var id: String = ""
    var modifyDate: String = ""
    var modifys: String = ""
    var path: String = ""
    var positionId: String = ""
    var sort: String = ""
    var title: String = ""
    var type: String = ""
    var unitId: String = ""
    var link: String = ""
    
    override func mapping(mapper: HelpingMapper) {
        mapper.specify(property: &link, name: "url")
    }
    
    var url: String? { return path }
}

class HCStatisticsDoctorHopitalModel: HJModel {
    var expertDoctor: String = "0"
    var reproductiveCenter: String = "0"
    var tripleA: String = "0"
}

class HCDoctorListItemModel: HJModel, HCSearchDataProtocol {
    var account: String = ""
    var age: String = ""
    var areaCode: String = ""
    var bak: String = ""
    var birthday: String = ""
    var brief: String = ""
    var cityName: String = ""
    var consult: String = ""
    var consultNum: Int = 0
    var replyNum: Int = 0
    var prasiRat: Float = 0
    var respRate: Float = 0
    var consultPrice: String = ""
    var createDate: String = ""
    var creates: String = ""
    var departmentId: String = ""
    var departmentName: String = ""
    var email: String = ""
    var enable: Bool = false
    var environment: String = ""
    var headPath: String = ""
    var hisCode: String = ""
    var hisNo: String = ""
    var id: String = ""
    var ip: String = ""
    var lastLogin: String = ""
    var linueupNo: String = ""
    var mobile: String = ""
    var modifyDate: String = ""
    var modifys: String = ""
    var name: String = ""
    var numbers: String = ""
    var practitionerYear: String = ""
    var provinceName: String = ""
    var recom: String = ""
    var sex: String = ""
    var skilledIn: String = ""
    var skilledInIds: String = ""
    var skin: String = ""
    var smsNotice: String = ""
    var sort: String = ""
    var spellBrevityCode: String = ""
    var spellCode: String = ""
    var status: String = ""
    var technicalPost: String = ""
    var technicalPostId: String = ""
    var token: String = ""
    var unitId: String = ""
    var unitName: String = ""
    var viewProfile: String = ""
    var wubiCode: String = ""
    
    var consultProject: [HCConsultProjectModel] = []

    private var skidInHeight: CGFloat?
    private var cellHeight: CGFloat?
    
    public lazy var doctorInfoText: NSAttributedString = {
        let string = NSMutableAttributedString.init(string: "\(self.name) \(self.technicalPost)")
        string.addAttribute(NSAttributedString.Key.font,
                            value: UIFont.font(fontSize: 14),
                            range: .init(location: self.name.count + 1, length: self.technicalPost.count))
        return string
    }()
    
    /**
     String prise = "咨询数<font color='#F4AE3E' size='12'>"
             + (item.getConsultNum() == null ? 0 : item.getConsultNum()) + "</font>，"
             
     + "回复率<font color='#F4AE3E' size='12'>"
             + ((item.getReplyNum() == null || item.getConsultNum() == null || item.getConsultNum() == 0) ? "良好" : item.getReplyNum() / item.getConsultNum() < 0.8 ? "良好" : "高") + "</font>，"
     +
             "好评率<font color='#F4AE3E' size='12'>" + ((TextUtils.isEmpty(item.getPrasiRat()) || item.getPrasiRat().equals("0.00")) ? "100"
             : Double.valueOf(100 * Double.valueOf(item.getPrasiRat())).intValue()) + "%</font>";
     */
    
    public lazy var briefText: NSAttributedString = {
        // 咨询数
        let consultText = "\(consultNum)"
        // 回复率
        let replyText = consultNum == 0 ? "良好" : Float(replyNum / consultNum) < 0.8 ? "良好" : "高"
        // 好评率
        let praiseText = prasiRat == 0 ? "100%" : "\(Int(prasiRat * 100))%"
        
        let string = NSMutableAttributedString.init(string: "咨询数\(consultText)，回复率\(replyText)，好评率\(praiseText)")
        
        string.addAttribute(NSAttributedString.Key.foregroundColor,
                            value: RGB(244, 174, 62),
                            range: .init(location: 3, length: consultText.count))
        string.addAttribute(NSAttributedString.Key.font,
                            value: UIFont.font(fontSize: 12, fontName: .PingFSemibold),
                            range: .init(location: 3, length: consultText.count))

        string.addAttribute(NSAttributedString.Key.foregroundColor,
                            value: RGB(244, 174, 62),
                            range: .init(location: 3 + consultText.count + 4,
                                         length: replyText.count))
        string.addAttribute(NSAttributedString.Key.font,
                            value: UIFont.font(fontSize: 12, fontName: .PingFSemibold),
                            range: .init(location: 3 + consultText.count + 4,
                                         length: replyText.count))

        string.addAttribute(NSAttributedString.Key.foregroundColor,
                            value: RGB(244, 174, 62),
                            range: .init(location: 3 + consultText.count + 4 + replyText.count + 4,
                                         length: praiseText.count))
        string.addAttribute(NSAttributedString.Key.font,
                            value: UIFont.font(fontSize: 12, fontName: .PingFSemibold),
                            range: .init(location: 3 + consultText.count + 4 + replyText.count + 4,
                                         length: praiseText.count))
        
        return string
    }()

    public lazy var skidInText: String = {
        let text = "擅长: \(skilledIn)"
        return text
    }()
    
    public var getSkidInHeight: CGFloat {
        get {
            if skidInHeight == nil {
                let h = skidInText.ty_textSize(font: .font(fontSize: 14), width: PPScreenW - 80, height: CGFloat.greatestFiniteMagnitude).height
                skidInHeight = min(40, h)
            }
            return skidInHeight!
        }
    }
    
    public var getCellHeight: CGFloat {
        get {
            if cellHeight == nil {
                cellHeight = 156 + getSkidInHeight
            }
            return cellHeight!
        }
    }
    
    public lazy var isOpenAnyConsult: Bool = {
        if consultProject.count == 0 { return true }
        
        var flag = false
        for item in consultProject {
            if item.open {
                flag = true
                break
            }
        }
        return flag
    }()
}

class HCConsultProjectModel: HJModel {
    var type: Int = 1
    var name: String = ""
    var open: Bool = true
    var price: String = "0.0"
    var unit: Int = 1
    
    public lazy var nameText: NSAttributedString = {
        let priceText = "¥\(price)"
        let text = open ? "\(name)\(priceText)" :"\(name)未开通"
        if open {
            return text.attributed(.init(location: name.count, length: priceText.count),
                                   RGB(255, 79, 120),
                                   .font(fontSize: 14, fontName: .PingFMedium))
        }else {
            return text.attributed(.init(location: 0, length: text.count),
                                   RGB(153, 153, 153),
                                   .font(fontSize: 14, fontName: .PingFMedium))
        }
    }()
}

class HCHCDoctorListModel: HJModel {
    var records: [HCDoctorListItemModel] = []
}
