//
//  HCConsultChatController.swift
//  HuChuangApp
//
//  Created by sw on 2021/1/11.
//  Copyright © 2021 sw. All rights reserved.
//

import UIKit

import HandyJSON
import RxSwift

class HCConsultChatController: HCH5ViewController {

    private let pickerManager = HCImagePickerManager()

    override func setupUI() {
        super.setupUI()
        
    }
        
    override func configList() -> [String] {
        var names = super.configList()
        names.append("openMoreMenu")
        return names
    }
    
    override func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        super.userContentController(userContentController, didReceive: message)

        if message.name == "openMoreMenu" {
            openMoreMenu(json: message.body)
        }
    }
}

extension HCConsultChatController {
    
    private func openMoreMenu(json: Any) {
        guard let jsonStr = json as? String,
              let model = JSONDeserializer<HCConsultInfoModel>.deserializeFrom(json: jsonStr),
              let consultType = HCConsultType(rawValue: model.consultType) else {
            return
        }
        
        let pickerContrl = HCMediaPickerController()
        pickerContrl.pickerMenuData = HCPickerMenuSectionModel.createChatPicker(consultMode: consultType)
        self.model(for: pickerContrl, controllerHeight: self.view.height)
        
        pickerContrl.selectedMenu = { [unowned self] in
            switch $0.title {
            case "视频通话":
                prepareVideoCall(model: model)
            case "相册":
                pickerManager.presentPhotoLibrary(presentVC: self)
            case "拍摄":
                pickerManager.presentCamera(presentVC: self)
            case "问诊历史":
                webView.evaluateJavaScript("openInquiryHistory()") { (msg, error) in
                    if let err = error {
                        NoticesCenter.alert(message: err.localizedDescription)
                    }
                }
            default:
                break
            }
        }
        
        pickerContrl.selectedImage = { [unowned self] _ in  }
    }
    
    private func prepareVideoCall(model: HCConsultInfoModel) {
        hud.noticeLoading()
        
        HCHelper.requestStartPhone(userId: model.userId)
            .flatMap { [weak self] res -> Observable<CallingUserModel?> in
                if res {
                    return HCHelper.requestVideoCallUserInfo(userId: model.userId, consultId: model.consultId)
                }
                
                self?.hud.noticeHidden()
                return Observable.just(nil)
            }
            .subscribe(onNext: { [weak self] user in
                if let callingUser = user {
                    HCSystemAudioPlay.share.videoCallPlay()
                    self?.presentVideoCallCtrl(callUser: callingUser, model: model)
                }
                self?.hud.noticeHidden()
            }, onError: { [weak self] _ in
                self?.hud.noticeHidden()
            })
            .disposed(by: disposeBag)

    }
    
    private func presentVideoCallCtrl(callUser: CallingUserModel, model: HCConsultInfoModel) {
        let callVC = HCConsultVideoCallController(sponsor: nil)
        
        callVC.dismissBlock = { }
        
        callVC.modalPresentationStyle = .fullScreen
        callVC.resetWithUserList(users: [callUser], isInit: true)
        present(callVC, animated: true, completion: nil)
        
        TRTCCalling.shareInstance().call(model.userId, roomId: UInt32(model.consultId) ?? 0, type: .video)
    }

}

class HCConsultInfoModel: HJModel {
    var consultId: String = ""
    var consultType: Int = 0
    var userId: String = ""
    var userName: String = ""
}
