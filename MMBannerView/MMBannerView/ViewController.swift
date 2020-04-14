//
//  ViewController.swift
//  MMBannerView
//
//  Created by 马扬 on 2019/10/8.
//  Copyright © 2019 mayang. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    var banner : MMBannerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.banner = MMBannerView.init(frame: .zero)
        self.view.addSubview(self.banner)
        self.banner.snp.makeConstraints {[weak self] (make) in
            make.top.equalTo(self!.view.snp.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(200)
        }
        let data = [UIImage.init(named: "1")]
//        ,UIImage.init(named: "2"),UIImage.init(named: "3"),UIImage.init(named: "4"),UIImage.init(named: "5")
        self.banner.load(by: data)
        self.banner.setClickCallBack { (index, x) in
            print(index)
            print(x)
        }
        self.banner.setPageCallBack { (x) in
            print(x)
        }
//        self.banner.setCellLayoutSubviewCallBack { (_, index) in
//            print("-----------------------------------")
//            print(index)
//            print("-----------------------------------")
//        }
    }

    func click() {
        let second = SecondViewController()
        self.show(second, sender: nil)
    }


    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.click()
    }

}

