//
//  LoginViewController.swift
//  Instagram
//
//  Created by 畑中 彩里 on 2020/05/11.
//  Copyright © 2020 sari.hatanaka. All rights reserved.
//
import UIKit
import Firebase
import SVProgressHUD

class LoginViewController: UIViewController {
    
//MARK: Outlet
    
   @IBOutlet weak var mailAddressTextField: UITextField!
   @IBOutlet weak var passwordTextField: UITextField!
   @IBOutlet weak var displayNameTextField: UITextField!
    
    //MARK: Lifecycle
        override func viewDidLoad() {
    }
    

    
//MARK: Action
    
    
    /// ログイン時
    /// - Parameter sender: UIButton
    @IBAction func handleLoginButton(_ sender: UIButton) {
       if let address = mailAddressTextField.text, let password = passwordTextField.text {
          if address.isEmpty || password.isEmpty {
            // エラーの旨を表す HUD を表示する
            SVProgressHUD.showError(withStatus: "必要項目を入力して下さい")
            return
        }
         // HUDで処理を表示
          SVProgressHUD.show()
        
        Auth.auth().signIn(withEmail: address, password: password) {authResult, error in
            if let error = error {
                print("DEBUG_PRINT:" + error.localizedDescription)
                SVProgressHUD.showError(withStatus: "サインインに失敗しました。")
                return
            }
            // HUDを消す
            SVProgressHUD.dismiss()
            print("DEBUG_PRINT: ログインに成功しました。")
            self.dismiss(animated: true, completion: nil)
        }
        }
    }
    
    
    /// アカウント作成時
    /// - Parameter sender: UIButton
    @IBAction func handleCreateAccountButton(_ sender: UIButton) {
      if let address = mailAddressTextField.text, let password = passwordTextField.text, let displayName = displayNameTextField.text {
               // いずれかがか入力されていない時は何もしない
         if address.isEmpty || password.isEmpty || displayName.isEmpty {
            print("DEBUG_PRINT: 何かが空文字です。")
            SVProgressHUD.showError(withStatus: "必要項目を入力して下さい")
            return
               }
               
            SVProgressHUD.show()
              
     // アドレスとパスワードでユーザー作成。ユーザー作成に成功すると、自動的にログインする
     Auth.auth().createUser(withEmail: address, password: password) { authResult, error in
      if let error = error {
            // エラーがあったら原因をprintして、returnすることで以降の処理を実行せずに処理を終了する
            print("DEBUG_PRINT: " + error.localizedDescription)
            SVProgressHUD.showError(withStatus: "ユーザー作成に失敗しました。")
            return
                   }
                print("DEBUG_PRINT: ユーザー作成に成功しました。")
                SVProgressHUD.showSuccess(withStatus: "アカウントを作成しました。")
               }
           // ユーザープロフィールの更新
        let user = Auth.auth().currentUser
        if let user = user {
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = displayName
            changeRequest.commitChanges { error in
        if let error = error {
            // プロフィールの更新でエラーが発生
            print("DEBUG_PRINT: " + error.localizedDescription)
            SVProgressHUD.showError(withStatus: "表示名の設定に失敗しました。")
            return
        }
            print("DEBUG_PRINT: [displayName = \(user.displayName!)]の設定に成功しました。")
                
            SVProgressHUD.dismiss()
                
            // 画面を閉じてタブ画面に戻る
            self.dismiss(animated: true, completion: nil)
               }
             }
           }
        }
}
