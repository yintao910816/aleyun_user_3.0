//
//  Doctor.swift
//  HuChuangApp
//
//  Created by yintao on 2019/9/29.
//  Copyright © 2019 sw. All rights reserved.
//

import Foundation

/// 医生列表总数据
class HCDoctorModel: HJModel {

    var records: [HCDoctorItemModel] = []
}

/// 医生列表
class HCDoctorItemModel: HJModel {
    var brief: String = ""
    var consultNumber: String = ""
    var consultReplyNumber: String = ""
    var headPath: String = ""
    var practitionerNumber: String = ""
    var practitionerYear: String = ""
    var price: String = ""
    var reviewNum: String = ""
    var skilledIn: String = ""
    var technicalPost: String = ""
    var unitId: String = ""
    var unitName: String = ""
    var userId: String = ""
    var userName: String = ""

    /// 标签lable的frame
    var labelFrames: [CGRect] = []
    /// 标签总高度
    var labelContainerHeight: CGFloat = 0

    /// 标签
    lazy var labels: [String] = {
        return self.skilledIn.components(separatedBy: ",")
    }()


    /// 展示回答总数
    lazy var anwserCountText: String = {
        return "\(consultReplyNumber)个回答"
    }()

    /// 所属医院顶部间距
    lazy var infoTopMargin: CGFloat = {
        return self.unitName.count > 0 ? 5 : 0
    }()

    /// 医生擅长顶部间距
    lazy var adeptTopMargin: CGFloat = {
        return self.skilledIn.count > 0 ? 5 : 0
    }()

    lazy var cellHeight: CGFloat = {
        var totleHeight: CGFloat = 15 + 23
        let contentWidth: CGFloat = UIScreen.main.bounds.width - 82 - 15

        // 医生所属医院
        totleHeight += self.infoTopMargin
        if self.unitName.count > 0 {
            totleHeight += self.unitName.getTextHeigh(fontSize: 14, width: contentWidth, fontName: FontName.PingFRegular.rawValue)
        }

        // 擅长
        totleHeight += self.adeptTopMargin
        if self.skilledIn.count > 0 {
            totleHeight += self.skilledIn.getTextHeigh(fontSize: 14, width: contentWidth, fontName: FontName.PingFRegular.rawValue)
        }

        // 回答总数
        totleHeight += (10 + 20)

        // 标签
        if self.skilledIn.count > 0 {
            totleHeight += 8
            // label 的字体
            let labelFontSize: Float = 14
            let labelFontName: String = FontName.PingFMedium.rawValue
            // 布局相关
            let h_margin: CGFloat = 10
            let v_margin: CGFloat = 5
            // 计算frame
            var lastLabelFrame: CGRect = .zero
            for item in self.labels {
                var labelFrame: CGRect = .zero
                let labelW: CGFloat = item.getTexWidth(fontSize: labelFontSize, height: 25, fontName: labelFontName) + 20
                // 一个标签占据一行以上
                if labelW > contentWidth {
                    let labelY: CGFloat = lastLabelFrame == .zero ? 0 : (lastLabelFrame.maxY + v_margin)

                    let labelH: CGFloat = item.getTextHeigh(fontSize: labelFontSize,
                                                            width: (contentWidth - 20),
                                                            fontName: labelFontName) + 10
                    labelFrame = .init(x: 0, y: labelY, width: contentWidth - 20, height: labelH)
                    self.labelFrames.append(labelFrame)

                    lastLabelFrame = labelFrame
                    continue
                }

                // 需要换行
                if lastLabelFrame.maxX + labelW + h_margin > contentWidth {
                    let labelY: CGFloat = lastLabelFrame == .zero ? 0 : (lastLabelFrame.maxY + v_margin)
                    // 设定label高度为17
                    labelFrame = .init(x: 0, y: labelY, width: labelW, height: 17 + 10)
                    self.labelFrames.append(labelFrame)

                    lastLabelFrame = labelFrame
                    continue
                }

                // 不需要换行
                let labelX = lastLabelFrame == .zero ? 0 : (lastLabelFrame.maxX + h_margin)
                labelFrame = .init(x: labelX, y: lastLabelFrame.minY, width: labelW, height: 17 + 10)
                self.labelFrames.append(labelFrame)

                lastLabelFrame = labelFrame
            }

            labelContainerHeight = lastLabelFrame.maxY

            // 加上最后一个标签的maxY
            totleHeight += (lastLabelFrame.maxY + 15)
        }else {
            totleHeight += 15
            labelContainerHeight = 0
        }

        return totleHeight
    }()
    
    /// 标题
    lazy var titleText: String = {
        return "\(self.userName) \(self.technicalPost)"
    }()
    
    /// 展示价格
    lazy var priceAttText: NSAttributedString = {
        if self.price == "0" {
            return "免费".attributed(NSMakeRange(0, 2), HC_MAIN_COLOR, .font(fontSize: 15, fontName: .PingFSemibold))
        }
        return "¥\(self.price)".attributed(NSMakeRange(0, 1), HC_MAIN_COLOR, .font(fontSize: 10, fontName: .PingFSemibold))
    }()
    
    /// 咨询人数
    lazy var askNumText: String = {
        return "\(self.consultNumber)人咨询"
    }()
    
    /// 医院
    lazy var unitNameText: String = {
        var text = ""
        if self.technicalPost.count > 0 && self.unitName.count > 0 {
            text = "\(self.technicalPost)·\(self.unitName)"
        }else if self.technicalPost.count > 0 {
            text = self.technicalPost
        }else if self.unitName.count > 0 {
            text = self.unitName
        }
        return text
    }()
    
    /// 擅长
    lazy var skilledInText: String = {
        var text = ""
        if self.skilledIn.count > 0 {
            text = "擅长: \(self.skilledIn)"
        }
        return text
    }()

    public class func transform(model: HCSearchDoctorItemModel) ->HCDoctorItemModel {
        let m = HCDoctorItemModel()
        m.userId = "\(model.userId)"
        m.userName = model.userName
        m.technicalPost = model.technicalPost
        m.headPath = model.headPath
        return m
    }
}

extension HCDoctorItemModel: HCDataSourceAdapt {

    var viewHeight: CGFloat { return cellHeight }
}

extension HCDoctorItemModel {
    /// 创建测试数据
    public class func createTestData() ->[HCDoctorItemModel] {
        var datas: [HCDoctorItemModel] = []
        for _ in 0..<2 {
            let model = HCDoctorItemModel()
            model.userName = "张三"
            model.technicalPost = "地方吗暗"
            model.unitName = "短发看风景看啦放"
            model.skilledIn = "发送到发送,发送打开风口浪尖啊沙发上对方,罚款房间里卡上对方卡"
            model.reviewNum = "999"
            model.anwserCountText = "100000"

            datas.append(model)
        }

        return datas
    }
}

/// 专家问诊
class HCExpertConsultListModel: HJModel {
    var records: [HCDoctorItemModel] = []
}


/// 医生信息
class HCDoctorInfoModel: HJModel {
    var userId: String = ""
    var userName: String = ""
    var headPath: String = ""
    var technicalPost: String = ""
    var skilledIn: String = ""
    var unitId: String = ""
    var unitName: String = ""
    var price: String = ""
    var consultNumber: Int = 0
    var consultReplyNumber: Int = 0
    var reviewNum: Int = 0
    var practitionerYear: String = ""
    var brief: String = ""
}
