//
//  MMBannerView.swift
//  MMBannerView
//
//  Created by 马扬 on 2019/10/8.
//  Copyright © 2019 mayang. All rights reserved.
//

import UIKit
import SnapKit

/// 轮播
public class MMBannerView: UIView {


    /// collectionView
    fileprivate var collectionView : MMBannerCollectionView!
    fileprivate var placeholderView : UIView!
    fileprivate var pageControl : UIPageControl!
    /** 页码变化的回调 */
    fileprivate var pageCallBack : ((Int) -> Void)?

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.createView()
    }
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.createView()
    }



    /// 装载视图
    /// - Parameter datas: 数据源
    /// - Parameter prefix: 图片路径前缀
    /// - Parameter placeholder: 占位图片名称
    /// - Parameter key: url的键
    open func load(by datas:Any?,timeInterval : Int = 2, placeholder:String? = nil, key:String? = nil, prefix:String? = nil){
        if let model = datas as? [Any]{
            self.pageControl.numberOfPages = model.count
            self.collectionView.load(by: model, key: key, prefix: prefix, placeholder: placeholder ?? "placeholder")
            if model.count > 1{
                self.collectionView.timeInterval = timeInterval
                self.collectionView.createTimer()
                return
            }
            self.cancelTimer()
        }
    }
    /** 暂停计时器 */
    open func suspendTimer(){
        self.collectionView.suspendTimer()
    }
    /** 暂停之后 开始计时器 */
    open func resumeTimer(){
        self.collectionView.resumeTimer()
    }

    /// 停止计时器
    open func cancelTimer(){
        self.collectionView.cancelTimer()
    }
    /** 设置页码发生变化的回调 */
    open func setPageCallBack(callback : @escaping ((Int) -> Void)){
        self.pageCallBack = callback
    }

    /// 设置点击的回调
    /// - Parameter callBack: 回调
    open func setClickCallBack(callBack : @escaping ((_ index : Int, _ model : Any) -> Void)){
        self.collectionView.callBack = callBack
    }

    /// cell 被cellforitem 回调
    /// - Parameter callBack: 回调
    open func setCellLayoutSubviewCallBack(callBack : @escaping (_ cell : MMBannerCollectionViewCell,_ index : Int) -> Void){
        self.collectionView.cellLayoutSubviewCallBack = callBack
    }





    /// 创建视图
    fileprivate func createView(){
        self.createPlaceholderView()
        self.createCollectionView()
        self.createPageControl()
    }

    /// 创建 页码
    fileprivate func createPageControl(){
        self.pageControl = UIPageControl.init(frame: .zero)
        self.addSubview(self.pageControl)
        self.pageControl.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(10)
            make.bottom.equalToSuperview().offset(-5)
        }
    }
    /// 创建collectionView
    fileprivate func createCollectionView(){
        let layout = MMBannerCollectionViewFlowLayout()
        self.collectionView = MMBannerCollectionView.init(frame: .zero, collectionViewLayout: layout)
        self.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints {[weak self] (make) in
            make.top.equalTo(self!.placeholderView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        self.collectionView.pageCallBack = {[weak self] (index) in
            self?.pageControl.currentPage = index
            self?.pageCallBack?(index)
        }
    }
    /// 创建一个占位的view 放在顶部,防止因为各种偏移产生的64像素误差
    fileprivate func createPlaceholderView(){
        self.placeholderView = UIView()
        self.addSubview(self.placeholderView)
        self.placeholderView.snp.makeConstraints {(make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(0)
        }
    }
}
