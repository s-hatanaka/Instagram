//
//  SettingViewController.swift
//  Instagram
//
//  Created by 畑中 彩里 on 2020/05/11.
//  Copyright © 2020 sari.hatanaka. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class SettingViewController: UIViewController {

//MARK: - Outlet
    
    @IBOutlet weak var displayNameTextField: UITextField!
    
//MARK: - Lifecycle
    
    override func viewDidLoad() {
    }
        // 画面を表示するたびに実行する
        override func viewWillAppear(_ animated: Bool) {
            // 表示名を取得してTextFieldに表示させる
            let user = Auth.auth().currentUser
            if let user = user {
            displayNameTextField.text = user.displayName
            }
        }
    
// MARK: - Action
    
    @IBAction func handleChangeButton(_ sender: UIButton) {
        if let displayName = displayNameTextField.text {
            if displayName.isEmpty {
            SVProgressHUD.showError(withStatus: "表示名を入力して下さい")
            return
            }
           // 表示名を設定する
        let user = Auth.auth().currentUser
        if let user = user {
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = displayName
            changeRequest.commitChanges{ error in
        if let error = error {
            SVProgressHUD.showError(withStatus: "表示名の変更に失敗しました。")
            print("DEBUG_PRINT:" + error.localizedDescription)
            return
            }
            print("DEBUG_PRINT: [displayName = \(user.displayName!)] の設定に成功しました。")
            SVProgressHUD.showSuccess(withStatus: "表示名を変更しました。")
            }
            }
        }
        self.view.endEditing(true)
    }
    @IBAction func handleLogoutButton(_ sender: UIButton) {
        // ログアウトする
        try! Auth.auth().signOut()
        // ログイン画面の表示
        let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
        self.present(loginViewController!, animated: true, completion: nil)
        // ログイン画面から戻ってきた時のためにホーム画面（index = 0）を選択している状態にしておく
        tabBarController?.selectedIndex = 0
    }
}
