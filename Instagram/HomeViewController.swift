//
//  HomeViewController.swift
//  Instagram
//
//  Created by 畑中 彩里 on 2020/05/11.
//  Copyright © 2020 sari.hatanaka. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - Outlet
    
    @IBOutlet weak var tableView: UITableView!
    
    // 投稿データを格納する配列
    var postArrary: [PostData] = []
    var listener: ListenerRegistration!
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("DEBAG_PRINT: viewWillAppear")
        
        // listener未登録なら、登録してスナップショットを受信する
        if Auth.auth().currentUser != nil {
            if listener == nil {
                let postRef = Firestore.firestore().collection(Const.PostPath).order(by: "date", descending: true)
                listener = postRef.addSnapshotListener() { (querySnapshot, error) in
                    if let error = error {
                        print("DEBAG_PRINT: snapshotの取得が失敗しました。\(error)")
                        return
                    }
                    // 取得したdocumentをもとにPostDataを作成し、postArrayの配列にする。
                    self.postArrary = querySnapshot!.documents.map { document in
                        print("DEBUG_PRINT: document取得　\(document.documentID)")
                        let postData = PostData(document: document)
                        return postData
                    }
                    // TableViewの表示を更新する
                    self.tableView.reloadData()
                }
            }
        } else {
            if listener != nil {
                listener.remove()
                listener = nil
                postArrary = []
                self.tableView.reloadData()
            }
        }
        
    }
    //MARK: - func
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArrary.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostTableViewCell
        cell.setPostData(postArrary[indexPath.row])
        cell.likeButton.addTarget(self, action: #selector(handleButton(_:forEvent:)), for: .touchUpInside)
        cell.commentButton.addTarget(self, action: #selector(handleCommentButton(_:forEvent:)), for: .touchUpInside)
        return cell
    }
    
    @objc func handleButton(_ sender: UIButton, forEvent event: UIEvent) {
        print("DEBUG_PRINT: Likeボタンがタップされました。")
        
        // タップされたセルのインデックスを求める
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        // 配列からタップされたインデックスのデータを取り出す
        let postData = postArrary[indexPath!.row]
        
        // Likesを更新する
        if let myid = Auth.auth().currentUser?.uid {
            var updateValue: FieldValue
            if postData.isLiked {
                updateValue = FieldValue.arrayRemove([myid])
            } else {
                updateValue = FieldValue.arrayUnion([myid])
            }
            // likesに更新データを書き込む
            let postRef = Firestore.firestore().collection(Const.PostPath).document(postData.id)
            postRef.updateData(["likes" : updateValue])
        }
    }
    @objc func handleCommentButton(_ sender: UIButton, forEvent event: UIEvent) {
        print("DEBUG_PRINT: Commentボタンがタップされました。")
        
        // タップされたセルのインデックスを求める
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        // 配列からタップされたインデックスのデータを取り出す
        let postData = postArrary[indexPath!.row]
        
        let commentViewController = self.storyboard?.instantiateViewController(identifier: "CommentViewController") as! CommentViewController
        commentViewController.postData = postData
        self.present(commentViewController, animated: true, completion: nil)
    }
}
