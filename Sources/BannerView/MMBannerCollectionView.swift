//
//  MMBannerCollectionView.swift
//  MMBannerView
//
//  Created by 马扬 on 2019/10/8.
//  Copyright © 2019 mayang. All rights reserved.
//

import UIKit

class MMBannerCollectionView: UICollectionView {

    fileprivate var datas : [Any]? = nil
    fileprivate var prefix : String? = nil
    fileprivate var placeholder : String = "placeholder"
    fileprivate var key : String? = nil
    fileprivate var timer : DispatchSourceTimer? = nil

    fileprivate var curIndex = 0
    /** 自然滚动的时间间隔 */
    var timeInterval : Int = 2
    /** 图片被点击的回调 */
    var callBack : ((_ index : Int,_ model : Any) -> Void)?
    /** cell 复用的回调 */
    var cellLayoutSubviewCallBack :  ((_ cell : MMBannerCollectionViewCell,_ index : Int) -> Void)?

    /** 更新pageControl */
    var pageCallBack : ((_ index : Int) -> Void)?

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.delegate = self
        self.dataSource  = self
        self.bounces = false
        self.isPagingEnabled = true
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.register(MMBannerCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "MMBannerCollectionViewCell")
    }


    func load(by datas:[Any]?, key:String? = nil, prefix:String? = nil, placeholder:String = "placeholder"){
        if datas == nil {
            return
        }
        var model = datas
        if datas!.count > 1{
            model?.insert(datas!.last!, at: 0)
            model?.append(datas!.first!)
        }
        self.datas = model
        self.prefix = prefix
        self.placeholder = placeholder
        self.key = key
        self.reloadData()
        if self.datas?.count == 1{
            return
        }
        self.performBatchUpdates(nil) { (stop) in
            self.curIndex = 1
            self.scrollToItem(at: IndexPath.init(item: 1, section: 0), at: .centeredHorizontally, animated: false)
            self.pageCallBack?(0)
        }
    }
    /** 暂停计时器 */
    func suspendTimer(){
        self.timer?.schedule(deadline: .distantFuture, repeating: .never)
    }
    /** 暂停之后 开始计时器 */
    func resumeTimer(){
        self.timer?.schedule(deadline: .now() + .seconds(self.timeInterval), repeating: DispatchTimeInterval.seconds(self.timeInterval))
    }
    
    func cancelTimer(){
        if self.timer == nil {
            return
        }
        if self.timer?.isCancelled == true{
            self.timer = nil
            return
        }
        self.timer?.cancel()
        self.timer = nil
        self.timer?.suspend()
    }

    /** 创建计时器 */
    func createTimer() -> Void{
        if self.timer != nil {return}
        self.timer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
        self.timer?.schedule(deadline: .now()  + .seconds(self.timeInterval), repeating: .seconds(self.timeInterval))
        self.timer?.setEventHandler(handler:{[weak self] in
            DispatchQueue.main.async {
                self?.scrollToNext()
            }
        })
        self.timer?.resume()
    }
    /** 滚动到下一个 */
    fileprivate func scrollToNext(){
        if self.datas == nil {
            return
        }
        if self.datas!.count <= 1{
            return
        }
        var index = self.curIndex + 1
        if index >= self.datas!.count - 1{
            index = 1
            self.scrollToItem(at: IndexPath.init(item: 0, section: 0), at: UICollectionView.ScrollPosition.left, animated: false)
        }
        self.scrollToItem(at: IndexPath.init(item: index, section: 0), at: .left, animated: true)
        self.curIndex = index
    }

    /** 计算当前位置 */
    fileprivate func computCurIndex(){
        let index = Int(self.contentOffset.x / self.bounds.size.width)
        if index == 0 {
            self.curIndex = (self.datas?.count ?? 2) - 2
            self.scrollToItem(at: IndexPath.init(item: self.curIndex, section: 0), at: .left, animated: false)
            self.pageCallBack?(self.curIndex - 1)
            return
        }
        if index >=  (self.datas?.count ?? 0) - 1{
            self.curIndex = 1
            self.scrollToItem(at: IndexPath.init(item: self.curIndex, section: 0), at: .left, animated: false)
            self.pageCallBack?(0)
            return
        }
        self.curIndex = index
        self.pageCallBack?(self.curIndex - 1)
    }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
//MARK: collectionview delegate
extension MMBannerCollectionView:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let tcell = collectionView.dequeueReusableCell(withReuseIdentifier: "MMBannerCollectionViewCell", for: indexPath)
        guard let cell = tcell as? MMBannerCollectionViewCell else { return tcell }
        cell.updateImageViewBy(model: self.datas![indexPath.row],
                               key: self.key,
                               prefix: self.prefix,
                               placeholder: self.placeholder)
        var index = indexPath.row
        if self.datas?.count == 1{ /** 只有一个元素 */
            self.cellLayoutSubviewCallBack?(cell,0)
            return cell
        }
        if index == 0 { /** 如果是第0位元素 那么即为 总元素数 -3 因为 两边插入了2个元素 */
            index = self.datas!.count - 3
            self.cellLayoutSubviewCallBack?(cell,index)
            return cell
        }
        if index == self.datas!.count - 1{
            index = 0
            self.cellLayoutSubviewCallBack?(cell,index)
            return cell
        }
        self.cellLayoutSubviewCallBack?(cell,index - 1)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.datas == nil {
            return
        }
        let model = self.datas![indexPath.row]
        if self.datas?.count == 1{ /** 只有一个元素 */
            self.callBack?(0,model)
            return
        }
        var index = indexPath.row
        if index == 0 {/** 如果是第0位元素 那么即为 总元素数 -3 因为 两边插入了2个元素 */
            index = self.datas!.count - 3
            self.callBack?(index,model)
            return
        }
        if index == self.datas!.count - 1{
            index = 0
            self.callBack?(index,model)
            return
        }
        self.callBack?(index - 1,model)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.datas?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.bounds.size
    }
}
//MARK:scrollview delegate
extension MMBannerCollectionView{
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.suspendTimer()
    }
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.computCurIndex()
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.computCurIndex()
        self.resumeTimer()
    }
}


//MARK:layout 布局
class MMBannerCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
        self.minimumLineSpacing = 0.0
        self.minimumInteritemSpacing = 0.0
        self.scrollDirection = .horizontal
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.minimumLineSpacing = 0.0
        self.minimumInteritemSpacing = 0.0
        self.scrollDirection = .horizontal
    }
}
