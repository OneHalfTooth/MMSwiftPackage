//
//  UUSteamPublicAlert.swift
//  UUSteam
//
//  Created by 马扬 on 2020/9/7.
//  Copyright © 2020 mayang. All rights reserved.
//

import UIKit
import SnapKit
/*
UUSteamPublicAlert.show(title: "----", message: "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX", attrMessage: nil, buttonTitle: "确定", cancelTitle: "取消", isAutoClose: true, isOnlyButton: false, isUseButton: true, callBack: { (isT, _) in
    print(isT)
}, layerCallBack:{[weak self]  (v) in
    let v1 = UIView.init(frame: .zero)
    v1.backgroundColor = UIColor.yellow
    v.addSubview(v1)
    v1.snp.makeConstraints { (make) in
        make.height.equalTo(100)
        make.top.left.right.equalToSuperview()
    }
})
*/

/// 项目公共弹窗
class UUSteamPublicAlert: UIWindow {

    /** 被点击的回调 */
       var callBack : ((Bool,UUSteamPublicAlert?) -> Void)?


    fileprivate var controller : UUSteamPublicViewController!


    /// 展示公共弹窗
    /// - Parameters:
    ///   - title: 弹窗标题
    ///   - message: 普通文办
    ///   - attrMessage: 富文本
    ///   - buttonTitle: 确定按钮文本
    ///   - cancelTitle: 取消按钮文本
    ///   - isAutoClose: 是否自动关闭 默认 true
    ///   - isOnlyButton: 是否只展示 确定按钮
    ///   - isUseButton: 是否只有按钮可响应。（黑色区域点击不响应）
    ///     callBack 点击回调  bool = true 用户点击确定按钮
    ///     layerCallBack 自定义布局回调， uiview 内容view
    @discardableResult
    class func show(title:String? = nil,
                    message:String? = nil,
                    attrMessage:NSMutableAttributedString? = nil,
                    buttonTitle:String,
                    cancelTitle:String? = nil,
                    isAutoClose : Bool = true,
                    isOnlyButton:Bool = false,
                    isUseButton : Bool = true,
                    callBack : @escaping ((Bool,UUSteamPublicAlert?) -> Void),
                    layerCallBack:((UIView) -> Void)? = nil) -> UUSteamPublicAlert{

        let window = UUSteamPublicAlert.init(frame: UIScreen.main.bounds)
        window.callBack = callBack
        window.controller.setValue(title: title, message: message, attrMessage: attrMessage, buttonTitle: buttonTitle, cancelTitle: cancelTitle, isAutoClose: isAutoClose, isOnlyButton: isOnlyButton, isUseButton: isUseButton,layerCallBack:layerCallBack)
        CFRunLoopRun()
        return window
    }

    func close(){
        self.isHidden = true
        CFRunLoopStop(CFRunLoopGetCurrent())
    }



       /** 私有化init方法 */
       fileprivate override init(frame:CGRect) {
           super.init(frame: frame)
           self.windowLevel = UIWindow.Level.alert
           self.isHidden = false
           self.backgroundColor = RGBA(R: 0, G: 0, B: 0, A: 0.5)
           self.createView()
           self.createAction()
       }

    fileprivate func createView(){
        self.controller = UUSteamPublicViewController.init()
        self.rootViewController = self.controller
        self.controller.callBack = {[weak self] (isT) in
            self?.callBack?(isT,self)
        }
        self.controller.closeCallBack = {[weak self] in
            self?.close()
        }
    }
    fileprivate func createAction(){

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


class UUSteamPublicViewController: UUSteamBaseViewController {

    var backView : UUSteamPublicView!

    /** 弹窗自动关闭 */
    var isAutoClose = true
    /** 是否只展示一个button */
    var isOnlyButton : Bool = false
    /** 是否只有button 可以响应事件 */
    var isUseButton : Bool = false
    /** button 点击回调 */
    var callBack : ((Bool) -> Void)?
    /** 关闭回调 */
    var closeCallBack : (() -> Void)?


    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.clear
        self.createAction()
    }

    fileprivate func setValue(title:String?,
                              message:String?,
                              attrMessage:NSMutableAttributedString?,
                              buttonTitle:String,
                              cancelTitle:String? = nil,
                              isAutoClose : Bool = true,
                              isOnlyButton:Bool = false,
                              isUseButton : Bool = true,
                              layerCallBack:((UIView) -> Void)? = nil){
        layerCallBack?(self.backView.contentView!)
        if layerCallBack != nil{ /** 如果自定义展示内容则 不展示messageLabel */
            self.backView.messageLabel.text = nil
            self.backView.messageLabel.attributedText = nil
        }else{
            self.backView.messageLabel.text = message
            if attrMessage != nil{
                self.backView.messageLabel.attributedText = attrMessage
            }
        }
        self.isAutoClose = isAutoClose
        self.isOnlyButton = isOnlyButton
        self.isUseButton = isUseButton
        self.backView.titleLabel.text = title
        self.backView.doneButton?.setTitle(buttonTitle, for: .normal)
        self.backView.cancelButton?.setTitle(cancelTitle, for: .normal)
        if isOnlyButton{
            self.backView.cancelButton?.isHidden = true
            self.backView.lineView.isHidden = true
            self.backView.doneButton?.snp.remakeConstraints { (make) in
                make.bottom.left.right.equalToSuperview()
                make.top.equalToSuperview().offset(0.5)
            }
        }
    }

    fileprivate func createAction(){

        self.backView.doneButton?.addTarget(self, action: #selector(self.buttonClick(button:)), for: .touchUpInside)
        self.backView.cancelButton?.addTarget(self, action: #selector(self.buttonClick(button:)), for: .touchUpInside)
    }

    @objc func buttonClick(button:UIButton){
        self.callBack?((button.tag == 1219))
        if self.isAutoClose{ /** 开启自动关闭 */
            self.closeCallBack?()
        }
    }

    override func createView() {
        self.backView = UUSteamPublicView.init(frame: .zero)
        self.view.addSubview(self.backView)
        let width = screenWidth - 80.0
        self.backView.snp.makeConstraints { (make) in
            make.width.equalTo(width)
            make.height.greaterThanOrEqualTo(width * 0.618)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.isUseButton{
            return
        }
        let touch = ((touches as NSSet).anyObject() as AnyObject)
        let point = touch.location(in: self.view)
        if self.backView!.frame.contains(point) {
            return
        }
        self.callBack?(false)
        if self.isAutoClose{
            self.closeCallBack?()
        }
    }
}

class UUSteamPublicView: UIView {

    /** 标题按钮 */
    fileprivate var titleLabel : UILabel!
    /** 底部按钮背景 */
    fileprivate var bottomBackView : UIView!
    /** 中间承载内容的视图 */
    fileprivate var contentView : UIView!
    /** 取消按钮 */
    fileprivate var cancelButton : UIButton!
    /** 确定按钮 */
    fileprivate var doneButton : UIButton!
    /** 分割线 */
    fileprivate var lineView : UIView!
    /** 消息内容 */
    fileprivate var messageLabel : UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.cornetRadiu(radiu: 10)
        self.createView()
    }

    fileprivate func createView(){

        self.createTitleLabel()
        self.createContentView()
        self.createMessageLabel()
        self.createBottomView()
        self.createLineView()
        self.createCancelButton()
        self.createDoneButton()
    }
    fileprivate func createMessageLabel(){
        self.messageLabel = UILabel.init(frame: .zero)
        self.addSubview(self.messageLabel)
        self.messageLabel.textColor = KColor666
        self.messageLabel.font = UIFont.systemFont(ofSize: 14)
        self.messageLabel.textAlignment = .center
        self.messageLabel.numberOfLines = 0
        self.messageLabel.setContentHuggingPriority(.required, for: .vertical)
        self.messageLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        self.messageLabel.snp.makeConstraints {[weak self] (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.top.equalTo(self?.contentView.snp.top ?? 0).offset(10)
            make.bottom.equalTo(self?.contentView.snp.bottom ?? 0).offset(-10)
        }
    }
    fileprivate func createTitleLabel(){
        self.titleLabel = UILabel.init(frame: .zero)
        self.addSubview(self.titleLabel)
        self.titleLabel.textColor = KColor333
        self.titleLabel.font = UIFont.systemFont(ofSize: 15)
        self.titleLabel.textAlignment = .center
        self.titleLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(15)
            make.height.equalTo(20)
        }
    }
    fileprivate func createContentView(){
        self.contentView = UIView.init(frame: .zero)
        self.addSubview(self.contentView)
        self.contentView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        self.contentView.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        self.contentView.snp.makeConstraints {[weak self] (make) in
            make.top.equalTo(self?.titleLabel.snp.bottom ?? 0)
            make.left.right.equalToSuperview()
        }
    }
    fileprivate func createBottomView(){
        self.bottomBackView = UIView.init(frame: .zero)
        self.addSubview(self.bottomBackView)
        self.bottomBackView.snp.makeConstraints {[weak self] (make) in
            make.height.equalTo(44)
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(self?.contentView.snp.bottom ?? 0)
        }
        let line = UIView.init(frame: .zero)
        self.bottomBackView.addSubview(line)
        line.backgroundColor = RGB(R: 221, G: 221, B: 221)
        line.snp.makeConstraints { (make) in
            make.height.equalTo(0.5)
            make.left.right.top.equalToSuperview()
        }
    }
    fileprivate func createLineView(){
        self.lineView = UIView.init(frame: .zero)
        self.bottomBackView.addSubview(self.lineView)
        self.lineView.backgroundColor = RGB(R: 221, G: 221, B: 221)
        self.lineView.snp.makeConstraints { (make) in
            make.width.equalTo(0.5)
            make.centerX.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
    }
    fileprivate func createDoneButton(){
        self.doneButton = UIButton.init(type: .custom)
        self.doneButton.setTitleColor(KMainColor, for: .normal)
        self.doneButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        self.doneButton.tag = 1219
        self.bottomBackView.addSubview(self.doneButton)
        self.doneButton.snp.makeConstraints {[weak self] (make) in
            make.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(0.5)
            make.left.equalTo(self?.lineView.snp.right ?? 0)
        }
    }
    fileprivate func createCancelButton(){
        self.cancelButton = UIButton.init(type: .custom)
        self.bottomBackView.addSubview(self.cancelButton)
        self.cancelButton.setTitleColor(KColor666, for: .normal)
        self.cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        self.cancelButton.snp.makeConstraints {[weak self] (make) in
            make.left.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(0.5)
            make.right.equalTo(self?.lineView.snp.right ?? 0)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
