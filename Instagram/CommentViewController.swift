//
//  CommentViewController.swift
//  Instagram
//
//  Created by 畑中 彩里 on 2020/05/15.
//  Copyright © 2020 sari.hatanaka. All rights reserved.
//

import UIKit
import Firebase

class CommentViewController: UIViewController {
    
    @IBOutlet weak var commentTextField: UITextField!
    
    var postData: PostData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func handleCommentButton(_ sender: UIButton) {
        // 保存場所の定義
        let commentRef = Firestore.firestore().collection(Const.PostPath).document(postData!.id)
        
        // FireStoreにコメントデータ保存
        
        let name = Auth.auth().currentUser?.displayName
        let postCommentData =
            [name! + "_" + self.commentTextField.text!]
        var updateValue: FieldValue
        updateValue = FieldValue.arrayUnion(postCommentData)
        commentRef.updateData(["comment" : updateValue])
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
