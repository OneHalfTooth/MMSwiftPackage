//
//  MMTagView.swift
//  MMTagView
//
//  Created by 马扬 on 2020/4/14.
//  Copyright © 2020 mayang. All rights reserved.
//

import UIKit
import SnapKit
import SwiftyJSON

public class MMTagView: UIView {

    fileprivate var collectionView : UICollectionView!
    fileprivate var layout : MMTagCollectionViewLayout!
    fileprivate var className = ""
    fileprivate var cellNumber = 0

    fileprivate var datas = JSON.null
    fileprivate var key : String? = nil

    /** cell 布局调用 每次刷新时调用 */
    var cellLayerCallBack : ((UICollectionViewCell,IndexPath) -> Void)?

    /** MMTagViewCollectionViewCell 加载时调用，非MMTagViewCollectionViewCell 不调用 */
    var cellAwakeCallBack : ((UICollectionViewCell) -> Void)?

    /** cell 被点击的回调
     * 若使用自定义的cell 那么 json 返回为JSON.null
     */
    var cellClickCallBack : ((JSON,IndexPath) -> Void)?

    /** 高度回调 */
    var tagViewContentSizeCallBack :((CGSize) -> Void)?


    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createView()
        self.backgroundColor = UIColor.white
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.createView()
    }


    /// 直接设置数据源，使用MMTagViewCollectionViewCell
    /// - Parameters:
    ///   - datas: 数据源 JSON类型
    ///   - key: 若key为空则表示是[string]类型
    func setDatas(datas:JSON,key:String? = nil){
        self.datas = datas
        self.key = key
        self.collectionView.reloadData()
    }


    /// 刷新标签
    /// - Parameter CellNumber: cell 数量
    func reloadData(by CellNumber:Int){
        assert(self.className.count != 0,"请先调用registCell 进行自定义注册，否则请使用setDatas方法直接设置数据")
        self.cellNumber = CellNumber
        self.collectionView.reloadData()
    }

    /// 注册cell
    /// - Parameters:
    ///   - className: cell 名称
    ///   - isNib: 是否nib
    func registCell(className:String,isNib:Bool = true){
        self.className = className
        if isNib{
            self.collectionView.register(UINib.init(nibName: className, bundle: nil), forCellWithReuseIdentifier: className)
            return
        }
        self.collectionView.register(NSClassFromString(className), forCellWithReuseIdentifier: className)
    }

    /** 设置 Layout*/
    func setLayout(callBack:((MMTagCollectionViewLayout) -> Void)){
        callBack(self.layout)
    }

    fileprivate func createView(){
        self.layout = MMTagCollectionViewLayout.init()
        self.layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        self.collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: self.layout)
        self.collectionView.backgroundColor = UIColor.white
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { (make) in
            make.top.bottom.left.right.equalToSuperview()
        }
        self.collectionView.register(UINib.init(nibName: "MMTagViewCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MMTagViewCollectionViewCell")
        self.collectionView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let size = change?[NSKeyValueChangeKey.newKey] as? CGSize{
            self.tagViewContentSizeCallBack?(size)
        }
    }
    deinit {
        self.collectionView.removeObserver(self, forKeyPath: "contentSize")
    }
}

//MARK:delegate
extension MMTagView:UICollectionViewDelegate,UICollectionViewDataSource{

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.cellClickCallBack?(self.datas[indexPath.item],indexPath)
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.datas == JSON.null{
            return self.cellNumber
        }
        return self.datas.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if self.className.count > 0{
            let tcell = collectionView.dequeueReusableCell(withReuseIdentifier: self.className, for: indexPath)
            /** cell 布局 */
            self.cellLayerCallBack?(tcell,indexPath)
            return tcell
        }
        let tcell = collectionView.dequeueReusableCell(withReuseIdentifier: "MMTagViewCollectionViewCell", for: indexPath)
        guard let cell = tcell as? MMTagViewCollectionViewCell else { return tcell }
        cell.cellAwakeCallBack = {[weak self] (cell) in
            self?.cellAwakeCallBack?(cell)
        }
        if self.datas == JSON.null {
            /** cell 布局 */
            self.cellLayerCallBack?(cell,indexPath)
            return cell
        }
        if self.key == nil {
            cell.titleLabel.text = self.datas[indexPath.item].stringValue
        }else{
            cell.titleLabel.text = self.datas[indexPath.item][self.key!].stringValue
        }
        return cell

    }


}
