//
//  MMBannerCollectionViewCell.swift
//  MMBannerView
//
//  Created by 马扬 on 2019/10/8.
//  Copyright © 2019 mayang. All rights reserved.
//

import UIKit
import Kingfisher
import SwiftyJSON

public class MMBannerCollectionViewCell: UICollectionViewCell {

    open var imageView : UIImageView?

    fileprivate var model : Any? = nil

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.purple
        self.createImageView()
    }

    open func updateImageViewBy(model:Any,key:String? = nil,prefix : String? = nil,placeholder:String = "placeholder"){
        if self.imageView == nil {
            return
        }
        if let t = model as? JSON{
            self.updateImageViewByJSON(model: t, key: key, prefix: prefix, placeholder: placeholder)
            return
        }
        if let t = model as? UIImage{
            self.updateImageViewByImage(model: t)
            return
        }
        if var t = model as? String{
            if prefix != nil { /** 图片地址添加前缀 */
                t = prefix! + t
            }
            self.updateImageViewByString(model: t, placeholder: placeholder)
            return
        }
    }

    open func removeImageView(){
        self.imageView?.removeFromSuperview()
        self.imageView = nil
    }

    fileprivate func updateImageViewByJSON(model:JSON,key:String? = nil,prefix : String? = nil,placeholder:String = "placeholder"){
        var imageName = model.stringValue
        if key != nil {
            imageName = model[key!].stringValue
        }
        if prefix != nil {
            imageName = prefix! + imageName
        }
        guard let url = URL.init(string: imageName) else { return  }
        self.imageView?.kf.setImage(with: ImageResource.init(downloadURL: url),
                                    placeholder: UIImage.init(named: placeholder))
    }
    fileprivate func updateImageViewByString(model:String,placeholder:String = "placeholder"){
        guard let url = URL.init(string: model) else { return  }
        self.imageView?.kf.setImage(with: ImageResource.init(downloadURL: url),
                                    placeholder: UIImage.init(named: placeholder))
    }
    fileprivate func updateImageViewByImage(model:UIImage){
        self.imageView?.image = model
    }




    fileprivate func createImageView(){
        self.imageView = UIImageView()
        self.contentView.addSubview(self.imageView!)
        self.imageView?.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
