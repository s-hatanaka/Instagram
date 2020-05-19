//
//  PostTableViewCell.swift
//  Instagram
//
//  Created by 畑中 彩里 on 2020/05/13.
//  Copyright © 2020 sari.hatanaka. All rights reserved.
//

import UIKit
import FirebaseUI

class PostTableViewCell: UITableViewCell {
    
    //MARK: - Outlet
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var commentButton: UIButton!
    
    // nibからの読み込みが完全に終わった時に呼び出される
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    /// PostDataの内容をセルに表示
    /// - Parameter PostData: PostData
    func setPostData(_ PostData: PostData) {
        // ダウンロード中であることを示すインジケーターの表示の指定
        postImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        let imageRef = Storage.storage().reference().child(Const.ImagePath).child(PostData.id + ".jpg")
        // imageRefから画像をダウンロードしてUIImageViewに表示
        postImageView.sd_setImage(with: imageRef)
        
        // キャプションの表示
        self.captionLabel.text = "\(PostData.name!):\(PostData.caption!)"
        
        self.dateLabel.text = ""
        if let date = PostData.date {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            let dateString = formatter.string(from: date)
            self.dateLabel.text = dateString
        }
        
        // いいね数の表示
        let likeNumber = PostData.likes.count
        likeLabel.text = "\(likeNumber)"
        
        if PostData.isLiked {
            let buttonImage = UIImage(named: "like_exist")
            self.likeButton.setImage(buttonImage, for: .normal)
        } else {
            let buttonImage = UIImage(named: "like_none")
            self.likeButton.setImage(buttonImage, for: .normal)
        }
        
        self.commentLabel.text = PostData.comment.joined(separator: "\n")
        
        print("\(PostData.comment)")
    }
}
