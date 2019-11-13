//
//  MYHRefreshComponent.swift
//  MYHRefresh
//
//  Created by hs015 on 2019/11/5.
//  Copyright © 2019 MYH. All rights reserved.
//

import UIKit

open class MYHRefreshComponent: UIView {
    
    /// 下拉刷新箭头的样式，后面跟着的是图片的名称
    public enum ArrowType: String {
        case black = "MYH_arrow_black@2x"
        case white = "MYH_arrow_white@2x"
    }
    
    /// 下拉刷新的状态
    public enum RefreshState: Int {
        /// 普通闲置状态
        case none = 0
        /// 普通闲置状态
        case idle = 1
        /// 松开就可以进行刷新的状态
        case pulling
        /// 正在刷新中的状态
        case refreshing
        /// 即将刷新的状态
        case willRefresh
        /// 所有数据加载完毕，没有更多的数据了
        case noMoreData
    }
    
    /// 是否支持暗黑模式-支持单个页面修改，默认支持
    open var isFollowDrakMode: Bool = true {
        willSet {
            if newValue == self.isFollowDrakMode {
                return
            }
        }
        didSet {
            self.modeChange()
        }
    }
    
    /// 刷新状态 一般交给子类内部实现
    open var state: RefreshState = .none {
        didSet{
            /// 加入主队列的目的是等setState:方法调用完毕、设置完文字后再去布局子控件
            DispatchQueue.main.async {[weak self] () in
                self?.setNeedsLayout()
            }
        }
    }
    
    // MARK: 交给子类去访问
    /// 父控件
    open weak var scrollView: UIScrollView? {
        didSet {
            if #available(iOS 11.0, *) {
                self.scrollView?.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
            } else {
                self.scrollView?.myh_getCurrentViewController()?.automaticallyAdjustsScrollViewInsets = false
            }
        }
    }
    /// 记录scrollView刚开始的inset
    open var scrollViewOriginalInset: UIEdgeInsets?
    
    // MARK: 刷新状态控制
    /// 开始刷新后的回调(进入刷新状态后的回调)
    open var beginRefreshingWithCompletionBlock: (()->())?
    /// 结束刷新的回调
    open var endRefreshingCompletionBlock: (()->())?
    open var isRefreshing: Bool {
        get {
            return self.state == .refreshing || self.state == .willRefresh
        }
    }
    
    
    // MARK: 刷新回调
    /// 回调对象
    open weak var refreshingTarget: AnyObject?
    /// 回调方法
    open var refreshingAction: Selector?
    /// 正在刷新的回调
    open var refreshingBlock: (()->())?
    
    // MARK: 其他
    /// 拉拽的百分比(交给子类重写)
    open var pullingPercent: CGFloat = 0 {
        willSet {
            if self.isRefreshing == true {
                return
            }
            if self.isAutomaticallyChangeAlpha == true {
                self.alpha = newValue
            }
        }
    }
    /// 根据拖拽比例自动切换透明度
    open var isAutomaticallyChangeAlpha: Bool = false {
        willSet{
            if self.isRefreshing == true {
                return
            }
            if newValue == true {
                self.alpha = pullingPercent
            } else {
                self.alpha = 1
            }
        }
    }
    
    private var pan: UIPanGestureRecognizer?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        if #available(iOS 13.0, *) {
            if UITraitCollection.current.userInterfaceStyle == .dark {
                MYHRefreshConst.shared.isDark = true
            } else {
                MYHRefreshConst.shared.isDark = false
            }
        } else {
            MYHRefreshConst.shared.isDark = false
        }
        self.modeChange()
        self.prepare()
    }
        
    open override func layoutSubviews() {
        self.placeSubviews()
        super.layoutSubviews()
    }
    
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        if self.state == .willRefresh {
            // 预防view还没显示出来就调用了beginRefreshing
            self.state = .refreshing
        }
    }
    
    open override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        // 旧的父控件移除监听
        self.removeObservers()
        // 如果不是UIScrollView，不做任何事情
        guard let scrollView = newSuperview as? UIScrollView else { return }
        self.scrollView = scrollView
        self.myh_w = scrollView.myh_w
        self.myh_x = -scrollView.myh_inset_left
        self.scrollView?.alwaysBounceVertical = true
        self.scrollViewOriginalInset = scrollView.myh_inset
        self.addObservers()
    }
        
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    // MARK: 交给子类实现的方法
    /// 初始化
    open func prepare() {
        self.state = .idle
        self.autoresizingMask = .flexibleWidth
        self.backgroundColor = UIColor.clear
    }
    
    /// 摆放子控件frame
    open func placeSubviews() {
        
    }
    
    /// 当暗黑模式切换的时候调用
    open func modeChange() {
        if !self.isFollowDrakMode {
            MYHRefreshConst.shared.isDark = false
        }
    }
    
    /// 当scrollView的contentOffset发生改变的时候调用
    /// - Parameter change: kvo监听的值
    open func scrollView(contentOffsetDid change: [NSKeyValueChangeKey : Any]?) {
        
    }
    
    /// 当scrollView的contentSize发生改变的时候调用
    /// - Parameter change: kvo监听的值
    open func scrollView(contentSizeDid change: [NSKeyValueChangeKey : Any]?) {
        
    }
    
    /// 当scrollView的拖拽状态发生改变的时候调用
    /// - Parameter change: kvo监听的值
    open func scrollView(panStateDid change: [NSKeyValueChangeKey : Any]?) {
        
    }
    
    // MARK: 刷新状态控制
    /// 开始刷新
    open func beginRefreshing() {
        UIView.animate(withDuration: MYHRefreshConst.shared.MYHRefreshFastAnimationDuration) {
            self.alpha = 1
        }
        
        self.pullingPercent = 1
        // 只要正在刷新，就完全显示
        if self.window != nil {
            self.state = .refreshing
        } else {
            // 预防正在刷新中时，调用本方法使得header inset回置失败
            if self.state != .refreshing {
                self.state = .willRefresh
                // 刷新(预防从另一个控制器回到这个控制器的情况，回来要重新刷新一下)
                self.setNeedsDisplay()
            }
        }
    }
    
    /// 开始刷新
    /// - Parameter completionBlock: 开始刷新后的回调(进入刷新状态后的回调)
    open func beginRefreshing(completionBlock: @escaping ()->()) {
        self.beginRefreshingWithCompletionBlock = completionBlock
        self.beginRefreshing()
    }
    
    /// 结束刷新
    open func endRefreshing() {
        DispatchQueue.main.async { [weak self] () in
            self?.state = .idle
        }
    }
    
    /// 结束刷新
    /// - Parameter completionBlock: 结束刷新的回调
    open func endRefreshing(completionBlock: @escaping ()->()) {
        self.endRefreshingCompletionBlock = completionBlock
        self.endRefreshing()
    }
    
    deinit {
        self.removeObservers()
        debugPrint(self.classForCoder, #function)
    }
    
    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 13.0, *) {
            if UITraitCollection.current.userInterfaceStyle == .dark {
                MYHRefreshConst.shared.isDark = true
            } else {
                MYHRefreshConst.shared.isDark = false
            }
        } else {
            MYHRefreshConst.shared.isDark = false
        }
        self.modeChange()
    }
    
    
}
// MARK: KVO监听
extension MYHRefreshComponent {
    private func removeObservers() {
        if self.pan == nil {
            return
        }
        self.superview?.removeObserver(self, forKeyPath: MYHRefreshConst.shared.MYHRefreshKeyPathContentOffset)
        self.superview?.removeObserver(self, forKeyPath: MYHRefreshConst.shared.MYHRefreshKeyPathContentSize)
        self.pan?.removeObserver(self, forKeyPath: MYHRefreshConst.shared.MYHRefreshKeyPathPanState)
        self.pan = nil
    }
    
    private func addObservers() {
        
        let options: NSKeyValueObservingOptions = [NSKeyValueObservingOptions.new, NSKeyValueObservingOptions.old]
        self.scrollView?.addObserver(self, forKeyPath: MYHRefreshConst.shared.MYHRefreshKeyPathContentOffset, options: options, context: nil)
        self.scrollView?.addObserver(self, forKeyPath: MYHRefreshConst.shared.MYHRefreshKeyPathContentSize, options: options, context: nil)
        self.pan = self.scrollView?.panGestureRecognizer
        self.pan?.addObserver(self, forKeyPath: MYHRefreshConst.shared.MYHRefreshKeyPathPanState, options: options, context: nil)
    }
    
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        guard let keyPath = keyPath else { return }
        // 遇到这些情况就直接返回
        if self.isUserInteractionEnabled == false {
            return
        }
        
        // 这个就算看不见也需要处理
        if keyPath == MYHRefreshConst.shared.MYHRefreshKeyPathContentSize {
            self.scrollView(contentSizeDid: change)
        }
        
        // 看不见
        if self.isHidden == true {
            return
        }
        if keyPath == MYHRefreshConst.shared.MYHRefreshKeyPathContentOffset {
            self.scrollView(contentOffsetDid: change)
        } else if keyPath == MYHRefreshConst.shared.MYHRefreshKeyPathPanState {
            self.scrollView(panStateDid: change)
        }
    }
}
// MARK: 公共方法
extension MYHRefreshComponent {
    /// 设置回调对象和回调方法
    open func setRefreshing(target: AnyObject?, refreshingAction: Selector) {
        self.refreshingTarget = target
        self.refreshingAction = refreshingAction
    }
}
// MARK: 内部方法
extension MYHRefreshComponent {
    /// 触发回调（交给子类去调用）
    open func executeRefreshingCallback() {
        DispatchQueue.main.async { [weak self] () in
            guard let strongSelf = self else { return }
            strongSelf.refreshingBlock?()
            if let target = strongSelf.refreshingTarget, let action = strongSelf.refreshingAction, target.responds(to: action) == true {
                _ = strongSelf.refreshingTarget?.perform(strongSelf.refreshingAction!)
            }
            strongSelf.beginRefreshingWithCompletionBlock?()
        }
    }
}

