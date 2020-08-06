//
//  HCLoginViewController.swift
//  HuChuangApp
//
//  Created by sw on 02/02/2019.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit
import RxSwift

class HCLoginViewController: BaseViewController {

    @IBOutlet weak var accountInputOutlet: UITextField!
    @IBOutlet weak var passInputOutlet: UITextField!
    
    @IBOutlet weak var loginOutlet: UIButton!
    @IBOutlet weak var getAuthorOutlet: UIButton!
    
    @IBOutlet weak var contentBgView: UIView!
    @IBOutlet weak var agreeButton: UIButton!
    @IBOutlet weak var isAgreeButton: UIButton!
    @IBOutlet weak var weChatLoginButton: UIButton!
    
    private let loginTypeObser = Variable(LoginType.phone)
    
    private var timer: CountdownTimer!
    
    private var viewModel: LoginViewModel!
    
//    private let keyBoardManager = KeyboardManager()
    
    private var agreeObservable = Variable(true)
    
    @IBAction func tapAction(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func actions(_ sender: UIButton) {
        if sender.tag == 1000 {
            let webVC = BaseWebViewController()
            webVC.url = "https://ileyun.ivfcn.com/cms/alyyhxy.html"
            navigationController?.pushViewController(webVC, animated: true)
        }else if sender.tag == 1001 {
            sender.isSelected = !sender.isSelected
            agreeObservable.value = sender.isSelected
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {        
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
//        keyBoardManager.registerNotification()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
//        keyBoardManager.removeNotification()
    }

    override func setupUI() {        
        let agreeText = "我已阅读并接受《用户协议》"
        agreeButton.setAttributedTitle(agreeText.attributed(.init(location: 7, length: 6), HC_MAIN_COLOR, nil), for: .normal)
        
        timer = CountdownTimer.init(totleCount: 120)
        
        #if DEBUG
        accountInputOutlet.text = "13995631675"
//        accountInputOutlet.text = "15717102067"
//        accountInputOutlet.text = "13244762499"
        passInputOutlet.text  = "8888"
        #else
        accountInputOutlet.text = userDefault.loginPhone
        #endif
    }
    
    override func rxBind() {
        timer.showText.asDriver()
            .skip(1)
            .drive(onNext: { [weak self] second in
                if second == 0 {
                    self?.viewModel.codeEnable.value = true
                    self?.getAuthorOutlet.setTitle("获取验证码", for: .normal)
                }else {
                    self?.getAuthorOutlet.setTitle("\(second)s", for: .normal)
                }
            })
            .disposed(by: disposeBag)
        
        let loginDriver = loginOutlet.rx.tap.asDriver()
            .do(onNext: { [unowned self] _ in
                self.view.endEditing(true)
            })
        let sendCodeDriver = getAuthorOutlet.rx.tap.asDriver()
            .do(onNext: { [unowned self] _ in
                self.timer.timerStar()
                self.view.endEditing(true)
            })

        viewModel = LoginViewModel.init(input: (account: accountInputOutlet.rx.text.orEmpty.asDriver(),
                                                pass: passInputOutlet.rx.text.orEmpty.asDriver(),
                                                loginType: loginTypeObser.asDriver()),
                                        tap: (loginTap: loginDriver,
                                              sendCodeTap: sendCodeDriver,
                                              agreeTap: agreeObservable,
                                              weChatTap: weChatLoginButton.rx.tap.asDriver()))
        viewModel.codeEnable.asDriver()
            .drive(getAuthorOutlet.rx.enabled)
            .disposed(by: disposeBag)
        
//        viewModel.enableLogin.asDriver()
//            .drive(onNext: { [weak self] flag in
//                self?.loginOutlet.backgroundColor = flag ? RGB(237, 146, 158) : RGB(180, 180, 180)
//                self?.loginOutlet.isUserInteractionEnabled = flag
//            })
//            .disposed(by: disposeBag)
        
        viewModel.popSubject
            .subscribe(onNext: { [weak self] in
                HCHelper.share.isPresentLogin = false
                NotificationCenter.default.post(name: NotificationName.User.LoginSuccess, object: nil)
                self?.navigationController?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        viewModel.pushBindSubject
            .subscribe(onNext: { [weak self] in
                self?.performSegue(withIdentifier: "bindPhoneSegue", sender: $0)
            })
            .disposed(by: disposeBag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "bindPhoneSegue" {
            segue.destination.prepare(parameters: ["model": sender!])
        }
    }
}

extension HCLoginViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        keyBoardManager.move(coverView: loginOutlet, moveView: contentBgView)
        return true
    }
}
