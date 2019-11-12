//
//  MYHRefreshHeader.swift
//  MYHRefresh
//
//  Created by hs015 on 2019/11/5.
//  Copyright © 2019 MYH. All rights reserved.
//

import UIKit

open class MYHRefreshHeader: MYHRefreshComponent {
    /// 忽略多少scrollView的contentInset的top
    public var ignoredScrollViewContentInsetTop: CGFloat = 0
    /// 这个key用来存储上一次下拉刷新成功的时间
    public var lastUpdatedTimeKey: String = MYHRefreshHeaderLastUpdatedTimeKey
    /// 上一次下拉刷新成功的时间
    public var lastUpdatedTime: Date?
    
    private var insetTopDelta: CGFloat = 0
    
    override public var state: MYHRefreshComponent.RefreshState {
        willSet{
            guard let scrollView = self.superview as? UIScrollView else { return }
            if self.state == newValue {
                return
            }
            
            if newValue == .idle {
                if self.state != .refreshing {
                    return
                }
                UserDefaults.standard.set(Date.init(), forKey: self.lastUpdatedTimeKey)
                UserDefaults.standard.synchronize()
                
                UIView.animate(withDuration: MYHRefreshSlowAnimationDuration, animations: {
                    scrollView.myh_inset_top += self.insetTopDelta
                    if self.isAutomaticallyChangeAlpha {
                        self.alpha = 0
                    }
                }) { (finished) in
                    self.pullingPercent = 0
                    self.endRefreshingCompletionBlock?()
                }
            } else if newValue == .refreshing {
                DispatchQueue.main.async { [weak self] () in
                    guard let strongSelf = self else { return }
                    UIView.animate(withDuration: MYHRefreshFastAnimationDuration, animations: {
                        let top = (strongSelf.scrollViewOriginalInset?.top ?? 0) + strongSelf.myh_h
                        scrollView.myh_inset_top = top
                        var offset = scrollView.contentOffset
                        offset.y = -top
                        scrollView.setContentOffset(offset, animated: false)
                    }) { (finish) in
                        strongSelf.executeRefreshingCallback()
                    }
                }
            }
            super.state = newValue
        }
    }
    
    convenience init(target: AnyObject, refreshingAction: Selector) {
        self.init()
        self.setRefreshing(target: target, refreshingAction: refreshingAction)
    }
    
    convenience init(refreshingBlock: (()->())?) {
        self.init()
        self.refreshingBlock = refreshingBlock
    }
    
    override public func prepare() {
        super.prepare()
        self.lastUpdatedTimeKey = MYHRefreshHeaderLastUpdatedTimeKey
        self.myh_h = MYHRefreshHeaderHeight
    }

    override public func placeSubviews() {
        super.placeSubviews()
        // 设置y值(当自己的高度发生改变了，肯定要重新调整Y值，所以放到placeSubviews方法中设置y值)
        self.myh_y = -self.myh_h - self.ignoredScrollViewContentInsetTop
    }
    
    override public func scrollView(contentOffsetDid change: [NSKeyValueChangeKey : Any]?) {
        super.scrollView(contentOffsetDid: change)
        guard let scrollView = self.superview as? UIScrollView else { return }
        if self.state == .refreshing {
            if self.window == nil, self.scrollViewOriginalInset == nil {
                return
            }
            var inset_top = -scrollView.myh_offset_y > self.scrollViewOriginalInset!.top ? -scrollView.myh_offset_y : self.scrollViewOriginalInset!.top
            inset_top = inset_top > self.myh_h + self.scrollViewOriginalInset!.top ? self.myh_h + self.scrollViewOriginalInset!.top : inset_top
            scrollView.myh_inset_top = inset_top
            self.insetTopDelta = self.scrollViewOriginalInset!.top - inset_top
            return
        }
        // 跳转到下一个控制器时，contentInset可能会变
        self.scrollViewOriginalInset = scrollView.myh_inset
        // 当前的contentOffset
        let offsetY = scrollView.myh_offset_y
        // 头部控件刚好出现的offsetY
        let happenOffsetY = -self.scrollViewOriginalInset!.top
        // 如果是向上滚动到看不见头部控件，直接返回
        if offsetY > happenOffsetY {
            return
        }
        // 普通 和 即将刷新 的临界点
        let normal2pullingOffsetY = happenOffsetY - self.myh_h
        let pullingPercent = (happenOffsetY - offsetY) / self.myh_h
        if scrollView.isDragging {
            self.pullingPercent = pullingPercent
            if self.state == .idle, offsetY < normal2pullingOffsetY {
                // 转为即将刷新状态
                self.state = .pulling
            } else if self.state == .pulling, offsetY >= normal2pullingOffsetY {
                // 转为普通状态
                self.state = .idle
            }
        } else if self.state == .pulling {// 即将刷新 && 手松开
            self.beginRefreshing()
        } else if pullingPercent < 1 {
            self.pullingPercent = pullingPercent
        }
    }
    
    override public func scrollView(panStateDid change: [NSKeyValueChangeKey : Any]?) {
        super.scrollView(panStateDid: change)
    }
    
    override public func scrollView(contentSizeDid change: [NSKeyValueChangeKey : Any]?) {
        super.scrollView(contentSizeDid: change)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    

}
// MARK: 公共方法
extension MYHRefreshHeader {
    /// 获取上次更新成功的时间
    public func getLastUpdatedTime() -> Date? {
        return UserDefaults.standard.object(forKey: self.lastUpdatedTimeKey) as? Date
    }
}
