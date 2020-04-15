//
//  MMTagViewCollectionViewCell.swift
//  MMTagView
//
//  Created by 马扬 on 2020/4/14.
//  Copyright © 2020 mayang. All rights reserved.
//

import UIKit

public class MMTagViewCollectionViewCell: UICollectionViewCell {

    
    var cellAwakeCallBack : ((UICollectionViewCell) -> Void)?
    var titleLabel: UILabel!
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.createView()
        self.cellAwakeCallBack?(self)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    fileprivate func createView(){
        self.titleLabel = UILabel.init(frame: .zero)
        self.titleLabel.textColor = UIColor.init(red: 102 / 255.0, green: 102 / 255.0, blue: 102 / 255.0, alpha: 1)
        self.titleLabel.font = UIFont.systemFont(ofSize: 12)
        self.contentView.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
            make.height.equalTo(25)
            make.width.greaterThanOrEqualTo(10)
        }
    }

}
