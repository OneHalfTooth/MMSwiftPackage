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
    @IBOutlet weak var titleLabel: UILabel!
    public override func awakeFromNib() {
        super.awakeFromNib()
        self.cellAwakeCallBack?(self)
    }

}
