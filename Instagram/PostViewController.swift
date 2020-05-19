//
//  PostViewController.swift
//  Instagram
//
//  Created by 畑中 彩里 on 2020/05/11.
//  Copyright © 2020 sari.hatanaka. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class PostViewController: UIViewController {
    
    var image: UIImage!
    
//MARK: - Outlet
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var TextField: UITextField!
    
//MARK: - Lifecycle
    override func viewDidLoad() {
        // 受け取った画像をImageViewに設定する
        imageView.image = image
}
 
//MARK: - Action
    
    /// 投稿ボタンが押された時
    /// - Parameter sender: UIButton
    @IBAction func handlePostButton(_ sender: UIButton) {
        // 画像をJPEG形式に変換する
        let imageData = image.jpegData(compressionQuality: 0.75)
        // Firestoreに保存する投稿データの保存場所の定義
        let postRef = Firestore.firestore().collection(Const.PostPath).document()
        // Storageに保存する画像の保存場所を定義
        let imageRef = Storage.storage().reference().child(Const.ImagePath).child(postRef.documentID + ".jpg")
        SVProgressHUD.show()
        // (metadata)画像を保存する際のファイル形式
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        imageRef.putData(imageData!, metadata: metadata) { (metadata, error) in
            if error != nil {
                print(error!)
        SVProgressHUD.showError(withStatus: "画像のアップロードが失敗しました")
        // 先頭画面に戻る
        UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController?.dismiss(animated: true, completion: nil)}
                return
        }
        let name = Auth.auth().currentUser?.displayName
        let postDic = [
         "name": name!,
         "caption": self.TextField.text!,
         "date": FieldValue.serverTimestamp(),
        ] as [String: Any]
        // Firestoreにデータを保存
        postRef.setData(postDic)
        SVProgressHUD.showSuccess(withStatus: "投稿しました")
        // 先頭画面に戻る
        UIApplication.shared.windows.first{ $0.isKeyWindow }?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func handleCancelButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
