//
//  TabBarController.swift
//  Instagram
//
//  Created by 畑中 彩里 on 2020/05/11.
//  Copyright © 2020 sari.hatanaka. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
//MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // タブアイコンの色
        self.tabBar.tintColor = UIColor(red: 1.0, green: 0.44, blue: 0.11, alpha: 1)
        // タブバーの背景色
        self.tabBar.barTintColor = UIColor(red: 0.96, green: 0.91, blue: 0.87, alpha: 1)
        self.delegate = self

        // Do any additional setup after loading the view.
    }
    
//MARK: func
    /// タブバーのアイコンがタップされた時に呼ばれるメソッド(タブの切り替えをして良いか否か)
    /// - Parameter tabBarController: UITabBarController
    /// - Parameter viewController: UIViewController
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        // ImageSelectViewControllerクラスかどうかの判断で、真ん中のカメラのボタンが押されたか否かを判定
        if viewController is ImageSelectViewController {
            let imageSelectViewController = storyboard!.instantiateViewController(withIdentifier: "ImageSelect")
            // モーダル画面遷移
            present(imageSelectViewController, animated: true)
            // このメソッドを戻ることで、タブ切り替えは動作しないようにする
            return false
        } else {
            // 通常のタブ切り替えが動作するようにする
            return true
        }
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
