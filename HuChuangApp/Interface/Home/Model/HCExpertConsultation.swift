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

class HCDoctorListItemModel: HJModel {
    var account: String = ""
    var age: String = ""
    var areaCode: String = ""
    var bak: String = ""
    var birthday: String = ""
    var brief: String = ""
    var cityName: String = ""
    var consult: String = ""
    var consultNum: String = ""
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
    var prasiRat: String = ""
    var provinceName: String = ""
    var recom: String = ""
    var respRate: String = ""
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
    
    public lazy var doctorInfoText: NSAttributedString = {
        let string = NSMutableAttributedString.init(string: "\(self.name) \(self.technicalPost)")
        string.addAttribute(NSAttributedString.Key.font,
                            value: UIFont.font(fontSize: 14),
                            range: .init(location: self.name.count + 1, length: self.technicalPost.count))
        return string
    }()
    
    public lazy var briefText: NSAttributedString = {
        let string = NSMutableAttributedString.init(string: "咨询数\(self.consultNum)，回复率\(self.numbers)，好评率\(self.prasiRat)")
        
        string.addAttribute(NSAttributedString.Key.foregroundColor,
                            value: RGB(244, 174, 62),
                            range: .init(location: 3, length: self.consultNum.count))
        string.addAttribute(NSAttributedString.Key.font,
                            value: UIFont.font(fontSize: 12, fontName: .PingFSemibold),
                            range: .init(location: 3, length: self.consultNum.count))

        string.addAttribute(NSAttributedString.Key.foregroundColor,
                            value: RGB(244, 174, 62),
                            range: .init(location: 3 + self.consultNum.count + 4,
                                         length: self.numbers.count))
        string.addAttribute(NSAttributedString.Key.font,
                            value: UIFont.font(fontSize: 12, fontName: .PingFSemibold),
                            range: .init(location: 3 + self.consultNum.count + 4,
                                         length: self.numbers.count))

        string.addAttribute(NSAttributedString.Key.foregroundColor,
                            value: RGB(244, 174, 62),
                            range: .init(location: 3 + self.consultNum.count + 4 + self.numbers.count + 4,
                                         length: self.prasiRat.count))
        string.addAttribute(NSAttributedString.Key.font,
                            value: UIFont.font(fontSize: 12, fontName: .PingFSemibold),
                            range: .init(location: 3 + self.consultNum.count + 4 + self.numbers.count + 4,
                                         length: self.prasiRat.count))

        
        return string
    }()

}

class HCHCDoctorListModel: HJModel {
    var records: [HCDoctorListItemModel] = []
}
