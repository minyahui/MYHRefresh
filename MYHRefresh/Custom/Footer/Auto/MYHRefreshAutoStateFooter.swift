//
//  MYHRefreshAutoStateFooter.swift
//  MYHRefresh
//
//  Created by hs015 on 2019/11/6.
//  Copyright © 2019 MYH. All rights reserved.
//

import UIKit

open class MYHRefreshAutoStateFooter: MYHRefreshAutoFooter {
    /// 设置箭头的样式
    open var arrowType: MYHRefreshComponent.ArrowType = .black {
        willSet{
            switch newValue {
            case .black:
                self.stateLabel.textColor = UIColor.myh_black
                break
            case .white:
                self.stateLabel.textColor = UIColor.myh_white
                break
            }
        }
    }
    /// 文字距离圈圈、箭头的距离
    open var labelLeftInset: CGFloat = MYHRefreshConst.shared.MYHRefreshLabelLeftInset
    
    /// 隐藏刷新状态的文字
    open var isRefreshingTitleHidden: Bool = false
    
    
    /// 所有状态对应的文字
    private var stateTitles: [MYHRefreshComponent.RefreshState:String] = [MYHRefreshComponent.RefreshState:String]()
    /// 用于判断点击 Label 触发特殊的刷新逻辑
    private var labelIsTrigger: Bool = false
    // MARK: 状态相关
    /// 显示刷新状态的label
    open weak var stateLabel: UILabel! {
        if self.privateStateLabel == nil {
            let label = UILabel.myh_init()
            self.addSubview(label)
            self.privateStateLabel = label
        }
        return self.privateStateLabel
    }
    private weak var privateStateLabel: UILabel?
    
    private weak var stateButton: UIButton! {
        if self.privateStateButton == nil {
            let button = UIButton.init(type: UIButton.ButtonType.system)
            button.addTarget(self, action: #selector(self.stateLabelClick), for: .touchUpInside)
            self.addSubview(button)
            self.privateStateButton = button
        }
        return self.privateStateButton
    }
    
    private weak var privateStateButton: UIButton?
    
    
    override open func ignoreRefreshAction() -> Bool {
        return !self.labelIsTrigger && super.ignoreRefreshAction()
    }
    
    override open func prepare() {
        // 初始化间距
        self.labelLeftInset = MYHRefreshConst.shared.MYHRefreshLabelLeftInset
        // 初始化文字
        self.setTitle(Bundle.myh_localizedString(key: MYHRefreshConst.shared.MYHRefreshAutoFooterRefreshingText), state: .refreshing)
        self.setTitle(Bundle.myh_localizedString(key: MYHRefreshConst.shared.MYHRefreshAutoFooterNoMoreDataText), state: .noMoreData)
        self.setTitle(Bundle.myh_localizedString(key: MYHRefreshConst.shared.MYHRefreshAutoFooterIdleText), state: .idle)
        
        self.arrowType = .black
        // 监听
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(UIGestureRecognizer.init(target: self, action: #selector(self.stateLabelClick)))
        super.prepare()
    }
    
    override open func placeSubviews() {
        super.placeSubviews()
        if self.stateLabel.constraints.count > 0 {
            return
        }
        self.stateLabel.frame = self.bounds
        self.stateButton.frame = self.bounds
    }
    
    public convenience init(target: AnyObject, refreshingAction: Selector, arrowType: MYHRefreshComponent.ArrowType) {
       self.init()
       self.setRefreshing(target: target, refreshingAction: refreshingAction)
       self.arrowType = arrowType
    }
       
    public convenience init(refreshingBlock: (()->())?, arrowType: MYHRefreshComponent.ArrowType) {
       self.init()
       self.refreshingBlock = refreshingBlock
       self.arrowType = arrowType
    }
    
    public convenience init(target: AnyObject, refreshingAction: Selector, arrowType: MYHRefreshComponent.ArrowType, isFollowDrakMode: Bool) {
        self.init()
        self.setRefreshing(target: target, refreshingAction: refreshingAction)
        self.arrowType = arrowType
        self.isFollowDrakMode = isFollowDrakMode
    }
       
    public convenience init(refreshingBlock: (()->())?, arrowType: MYHRefreshComponent.ArrowType, isFollowDrakMode: Bool) {
        self.init()
        self.refreshingBlock = refreshingBlock
        self.arrowType = arrowType
        self.isFollowDrakMode = isFollowDrakMode
    }
    
    public convenience init(target: AnyObject, refreshingAction: Selector, isFollowDrakMode: Bool) {
        self.init()
        self.setRefreshing(target: target, refreshingAction: refreshingAction)
        self.isFollowDrakMode = isFollowDrakMode
    }
       
    public convenience init(refreshingBlock: (()->())?, isFollowDrakMode: Bool) {
        self.init()
        self.refreshingBlock = refreshingBlock
        self.isFollowDrakMode = isFollowDrakMode
    }
    
    override open var state: MYHRefreshComponent.RefreshState {
        willSet {
            if self.isRefreshingTitleHidden, newValue == .refreshing {
                self.stateLabel.text = ""
            } else {
                self.stateLabel.text = self.stateTitles[newValue]
            }
            if self.state == newValue {
                return
            }
            super.state = newValue
        }
    }
    
    /// 设置状态对应的标题
    /// - Parameter title: 标题
    /// - Parameter state: 状态
    open func setTitle(_ title: String?, state: MYHRefreshComponent.RefreshState) {
        guard let t = title else { return }
        self.stateTitles[state] = t
        self.stateLabel.text = self.stateTitles[state]
    }
    
    open override func modeChange() {
        super.modeChange()
        let arrow = self.arrowType
        self.arrowType = arrow
    }
}

// MARK: 私有方法
extension MYHRefreshAutoStateFooter {
    @objc private func stateLabelClick() {
        if self.state == .idle {
            self.labelIsTrigger = true
            self.beginRefreshing()
            self.labelIsTrigger = false
        }
    }
}
