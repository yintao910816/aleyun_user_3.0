//
//  HCAccountSettingViewController.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/13.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCAccountSettingViewController: BaseViewController {

    private var containerView: HCAccountSettingContainer!

    private var viewModel: HCAccountSettingViewModel!
    
    override func setupUI() {
        title = "账号设置"
        
        containerView = HCAccountSettingContainer.init(frame: .init(x: 0, y: 0, width: view.width, height: view.height))
        view.addSubview(containerView)
        
        containerView.didSelected = { [weak self] in
            if $0.title == "昵称" {
                self?.navigationController?.pushViewController(HCEditInfoViewController(), animated: true)
            }else if $0.title == "头像" {
                self?.presetentSheet()
            }
        }
    }
    
    override func rxBind() {
        viewModel = HCAccountSettingViewModel()
        
        viewModel.listItemSubject
            .subscribe(onNext: { [weak self] in self?.containerView.reloadData(data: $0) })
            .disposed(by: disposeBag)
        
        viewModel.reloadSubject.onNext(Void())
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        containerView.frame = view.bounds
    }
}

extension HCAccountSettingViewController {
   
    func takePhoto(){
        if HCHelper.checkCameraPermissions() {
            let photoVC = UIImagePickerController()
            photoVC.sourceType = UIImagePickerController.SourceType.camera
            photoVC.delegate = self
            photoVC.allowsEditing = true
            photoVC.showsCameraControls = true
            UIApplication.shared.keyWindow?.rootViewController?.present(photoVC, animated: true, completion: nil)
        }else{
            HCHelper.authorizationForCamera(confirmBlock: { [weak self]()in
                let photoVC = UIImagePickerController()
                photoVC.sourceType = UIImagePickerController.SourceType.camera
                photoVC.delegate = self
                photoVC.allowsEditing = true
                photoVC.showsCameraControls = true
                UIApplication.shared.keyWindow?.rootViewController?.present(photoVC, animated: true, completion: nil)
            })
            NoticesCenter.alert(title: nil, message: "请在手机设置-隐私-相机中开启权限")
        }
    }
    
    func systemPic(){
        let systemPicVC = UIImagePickerController()
        systemPicVC.sourceType = UIImagePickerController.SourceType.photoLibrary
        systemPicVC.delegate = self
        systemPicVC.allowsEditing = true
        UIApplication.shared.keyWindow?.rootViewController?.present(systemPicVC, animated: true, completion: nil)
    }
}

extension HCAccountSettingViewController : UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            viewModel.uploadIconSubject.onNext(img)
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension HCAccountSettingViewController {
    
    private func presetentSheet() {
        let takePhotoAction = UIAlertAction.init(title: "拍照", style: .default) { [weak self] _ in
            self?.takePhoto()
        }
        let systemPicAction = UIAlertAction.init(title: "相册", style: .default) { _ in
            self.systemPic()
        }
        
        let alert = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(takePhotoAction)
        alert.addAction(systemPicAction)

        present(alert, animated: true, completion: nil)
    }
}
