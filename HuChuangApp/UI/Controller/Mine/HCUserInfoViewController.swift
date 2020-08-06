//
//  HCSettingViewController.swift
//  HuChuangApp
//
//  Created by yintao on 2019/9/30.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit
import RxDataSources

class HCUserInfoViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navBar: HCCustomNavBar!
    
    private var selectedImage: UIImage?

    private var headerView: HCEditAvatarHeaderView!
    
    private var viewModel: HCUserInfoViewModel!
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func setupUI() {
        view.backgroundColor = RGB(245, 245, 245)
        
        navBar.title = "个人资料"
        navBar.backCallBack = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        headerView = HCEditAvatarHeaderView.init(frame: .init(origin: .zero, size: .init(width: view.width, height: HCEditAvatarHeaderView_height)))
        headerView.avatarURL = HCHelper.share.userInfoModel?.headPath
        tableView.tableHeaderView = headerView
        
        headerView.tapIconCallBack = { [weak self] in
            self?.presetentSheet()
        }
        
        tableView.register(HCListDetailIconCell.self, forCellReuseIdentifier: HCListDetailIconCell_identifier)
        tableView.register(HCListDetailCell.self, forCellReuseIdentifier: HCListDetailCell_identifier)
        tableView.register(HCListSwitchCell.self, forCellReuseIdentifier: HCListSwitchCell_identifier)
        tableView.register(HCListButtonCell.self, forCellReuseIdentifier: HCListButtonCell_identifier)
    }
    
    override func rxBind() {
        viewModel = HCUserInfoViewModel()
        
        let datasource = RxTableViewSectionedReloadDataSource<SectionModel<Int, HCListCellItem>>.init(configureCell: { _,tb,indexPath,model -> HCBaseListCell in
            let cell = (tb.dequeueReusableCell(withIdentifier: model.cellIdentifier) as! HCBaseListCell)
            cell.model = model
            return cell
        })
        
        viewModel.datasource.asDriver()
            .drive(tableView.rx.items(dataSource: datasource))
            .disposed(by: disposeBag)

        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
}

extension HCUserInfoViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.cellModel(for: indexPath).cellHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = RGB(245, 245, 245)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cellModel = viewModel.cellModel(for: indexPath)
        if cellModel.isLoginOut {
            HCHelper.share.clearUser()
            HCHelper.presentLogin()
        }else {
            if cellModel.segue.count == 0 { return }
            
            performSegue(withIdentifier: cellModel.segue, sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editUserCitySegue" {
            let ctr = segue.destination as! HCEditUserCityController
        }
    }
}

extension HCUserInfoViewController {
   
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

extension HCUserInfoViewController : UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            selectedImage = img
            headerView.avatarImage = img
            
            viewModel.finishEdit.onNext(img)
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension HCUserInfoViewController {
    
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
