//
//  SecondViewController.swift
//  MMBannerView
//
//  Created by 马扬 on 2019/10/9.
//  Copyright © 2019 mayang. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    @IBOutlet weak var banner: MMBannerView!
    override func viewDidLoad() {
        super.viewDidLoad()

        let data = [UIImage.init(named: "1"),UIImage.init(named: "3"),UIImage.init(named: "4")]
        //        ,UIImage.init(named: "2"),UIImage.init(named: "3"),UIImage.init(named: "4"),UIImage.init(named: "5")
                self.banner.load(by: data)
                self.banner.setClickCallBack { (index, x) in
                    print(index)
                    print(x)
                }
                self.banner.setPageCallBack { (x) in
//                    print(x)
                }
        //        self.banner.setCellLayoutSubviewCallBack { (_, index) in
        //            print("-----------------------------------")
        //            print(index)
        //            print("-----------------------------------")
        //        }
    }


    deinit {
        print("已经释放")
    }
}
