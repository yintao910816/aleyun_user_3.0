//
//  HCAudioPlay.swift
//  HuChuangApp
//
//  Created by sw on 2021/1/11.
//  Copyright © 2021 sw. All rights reserved.
//

import Foundation
import AudioToolbox

class HCSystemAudioPlay {
    
    private var soundId: SystemSoundID = 1

    public static let share = HCSystemAudioPlay()
    
    public func videoCallPlay() {
        videoCallStop()
        
        if let sourcePath = Bundle.main.resourcePath {
            let path = "\(sourcePath)/call.wav"
            soundId = 1
            //获取沙箱目录中文件所在的路径 waw等格式会读不到，建议使用mp3
//            let path = Bundle.main.path(forResource: "call", ofType: "mp3")
             
            let soundUrl = URL(fileURLWithPath: path)
            AudioServicesCreateSystemSoundID(soundUrl as CFURL, &soundId)
            //对于静音按键，下拉菜单音等较短的声音，可以使用系统音频服务来播放
            AudioServicesPlaySystemSound(soundId)
            
            //添加音频结束时的回调
            let observer = UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque())
            AudioServicesAddSystemSoundCompletion(soundId, nil, nil, {
            (soundID, inClientData) -> Void in
            let mySelf = Unmanaged<HCSystemAudioPlay>.fromOpaque(inClientData!).takeUnretainedValue()
            mySelf.audioServicesPlaySystemSoundCompleted()
            }, observer)
        }
    }
    
    public func videoCallStop() {
        AudioServicesRemoveSystemSoundCompletion(soundId)
        AudioServicesDisposeSystemSoundID(soundId)
    }
    
    //音频结束时的回调
    private func audioServicesPlaySystemSoundCompleted() {
        AudioServicesRemoveSystemSoundCompletion(soundId)
        AudioServicesDisposeSystemSoundID(soundId)
        
        NotificationCenter.default.post(name: NotificationName.ChatCall.finishAudio, object: nil)
    }

}
