//
//  ViewController.swift
//  MMTagView
//
//  Created by 马扬 on 2020/4/14.
//  Copyright © 2020 mayang. All rights reserved.
//

import UIKit
import SwiftyJSON

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        let tag = MMTagView.init(frame: .zero)
        tag.setDatas(datas: JSON([["c":"111111111"],
                                  ["c":"2222"],
                                  ["c":"333"],
                                  ["c":"3333333"],
                                  ["c":"12312312dsfws"],
                                  ["c":"3112edsr231"],
                                  ["c":"12ds"],
                                  ["c":"123fd213ewfe213ewf"],
                                  ["c":"123efs"],
                                  ["c":"2"],
                                  ["c":"12ed21213ew21"],
                                  ["c":"2w"],
                                  ["c":"23ef12ewfw21ewf21ew12ew"],
                                  ["c":"fdf"],
                                  ["c":"efe213ew"],
                                  ["c":"12ewdfwee"]]) ,key: "c")
        self.view.addSubview(tag)
        tag.snp.makeConstraints { (make) in
            make.top.equalTo(100)
            make.left.right.equalToSuperview()
            make.height.equalTo(0)
        }
        tag.setLayout { (layout) in
            layout.sectionInset = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
            layout.minimumLineSpacing = 10
            layout.minimumInteritemSpacing = 10
        }
        tag.tagViewContentSizeCallBack = {[weak self] (size) in
            tag.snp.updateConstraints { (make) in
                make.height.equalTo(size.height)
            }
        }
    }


}

