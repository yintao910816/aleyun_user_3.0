//
//  CallingViewControllerResponder.swift
//  HuChuangApp
//
//  Created by yintao on 2020/11/6.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation

protocol CallingViewControllerResponder: UIViewController {
    var dismissBlock: (()->Void)? { get set }
    var curSponsor: CallingUserModel? { get }
    func enterUser(user: CallingUserModel)
    func leaveUser(user: CallingUserModel)
    func updateUser(user: CallingUserModel, animated: Bool)
    func updateUserVolume(user: CallingUserModel) // 更新用户音量
    func disMiss()
    func getUserById(userId: String) -> CallingUserModel?
    func resetWithUserList(users: [CallingUserModel], isInit: Bool)
    static func getRenderView(userId: String) -> VideoCallingRenderView?
}
