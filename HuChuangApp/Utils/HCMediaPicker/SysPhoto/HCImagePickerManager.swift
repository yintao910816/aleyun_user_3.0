//
//  HCSystemPhotosManager.swift
//  HuChuangApp
//
//  Created by yintao on 2020/11/7.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation

class HCImagePickerManager: NSObject {
    
    private var picker: UIImagePickerController!
    
    public var selectedImageCallBack:((UIImage?)->())?
    
    override init() {
        super.init()
    }
    
    deinit {
        if picker != nil {
            picker.delegate = nil
            picker = nil
        }
    }
    
    public func presentPhotoLibrary(presentVC: UIViewController) {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            NoticesCenter.alert(message: "相册不可用")
            return
        }
        
        HCAssetManager.checkPhotoLibrary { [weak self] flag in
            guard let strongSelf = self else { return }
            if flag {
                if strongSelf.picker == nil {
                    strongSelf.picker = UIImagePickerController()
                    strongSelf.picker.isEditing = false
                }
                strongSelf.picker.sourceType = .photoLibrary
                strongSelf.picker.delegate = nil
                strongSelf.picker.delegate = strongSelf
                presentVC.present(strongSelf.picker, animated: true, completion: nil)
            }else {
                NoticesCenter.alert(message: "请设置相册权限")
            }
        }
    }
    
    public func presentCamera(presentVC: UIViewController) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            NoticesCenter.alert(message: "相机不可用")
            return
        }
        
        HCAssetManager.checkCamera { [weak self] flag in
            guard let strongSelf = self else { return }
            if flag {
                if strongSelf.picker == nil {
                    strongSelf.picker = UIImagePickerController()
                    strongSelf.picker.isEditing = false
                }
                strongSelf.picker.sourceType = .camera
                strongSelf.picker.delegate = nil
                strongSelf.picker.delegate = strongSelf
                presentVC.present(strongSelf.picker, animated: true, completion: nil)
            }else {
                NoticesCenter.alert(message: "请设置相机权限")
            }
        }
    }

}

extension HCImagePickerManager:UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        selectedImageCallBack?(info[UIImagePickerController.InfoKey.originalImage] as? UIImage)
        picker.delegate = nil
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.delegate = nil
        picker.dismiss(animated: true, completion: nil)
    }
}
