//
//  PostData.swift
//  Instagram
//
//  Created by 畑中 彩里 on 2020/05/13.
//  Copyright © 2020 sari.hatanaka. All rights reserved.
//

import UIKit
import Firebase

class PostData: NSObject {
    var id: String
    var name: String?
    var caption: String?
    var date: Date?
    var comment: [String] = []
    var likes: [String] = []
    var isLiked: Bool = false
    
    init(document: QueryDocumentSnapshot) {
        self.id = document.documentID
        let postDic = document.data()
        self.name = postDic["name"] as? String
        self.caption = postDic["caption"] as? String
        let timestamp = postDic["date"] as? Timestamp
        self.date = timestamp?.dateValue()
        if let comment = postDic["comment"] as? [String]{
            self.comment = comment
        }
        if let likes = postDic["likes"] as? [String]{
            self.likes = likes
            if let myid = Auth.auth().currentUser?.uid {
                // likesの配列の中にmyidが含まれているかチェックすることで、自分がいいねを押しているかを判断
                if self.likes.firstIndex(of: myid) != nil {
                    // myidがあれば、いいねを押していると認識する
                    self.isLiked = true
                }
            }
        }
    }
}
