//
//  MYHRefreshBackFooter.swift
//  MYHRefresh
//
//  Created by hs015 on 2019/11/5.
//  Copyright © 2019 MYH. All rights reserved.
//

import UIKit

public class MYHRefreshBackFooter: MYHRefreshFooter {

    private var lastBottomDelta: CGFloat = 0
    private var lastRefreshCount: Int = 0
    
    override public func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        self.scrollView(contentSizeDid: nil)
    }
    
    override public func scrollView(contentOffsetDid change: [NSKeyValueChangeKey : Any]?) {
        super.scrollView(contentOffsetDid: change)
        if self.state == .refreshing {
            return
        }
        guard let scrollView = self.scrollView else { return }
        self.scrollViewOriginalInset = scrollView.myh_inset
        // 当前的contentOffset
        let currentOffsetY = scrollView.myh_offset_y
        // 尾部控件刚好出现的offsetY
        let happenOffsetY = self.happenOffsetY()
        // 如果是向下滚动到看不见尾部控件，直接返回
        if currentOffsetY <= happenOffsetY {
            return
        }
        let pullingPercent = (currentOffsetY - happenOffsetY) / self.myh_h
        
        if self.state == .noMoreData {
            self.pullingPercent = pullingPercent
            return
        }
        
        if scrollView.isDragging {
            self.pullingPercent = pullingPercent
            // 普通 和 即将刷新 的临界点
            let normal2pullingOffsetY = happenOffsetY + self.myh_h
            if self.state == .idle, currentOffsetY > normal2pullingOffsetY {
                self.state = .pulling
            } else if self.state == .pulling, currentOffsetY <= normal2pullingOffsetY {
                self.state = .idle
            }
        } else if self.state == .pulling {// 即将刷新 && 手松开
            self.beginRefreshing()
        } else if pullingPercent < 1 {
            self.pullingPercent = pullingPercent
        }
    }

    override public func scrollView(contentSizeDid change: [NSKeyValueChangeKey : Any]?) {
        super.scrollView(contentSizeDid: change)
        guard let scrollView = self.scrollView else { return }
        // 内容的高度
        let contentHeight = scrollView.myh_content_height + self.ignoredScrollViewContentInsetBottom
        // 表格的高度
        let scrollHeight = scrollView.myh_h - (self.scrollViewOriginalInset?.top ?? 0) - (self.scrollViewOriginalInset?.bottom ?? 0) + self.ignoredScrollViewContentInsetBottom
        self.myh_y = contentHeight > scrollHeight ? contentHeight : scrollHeight
    }
    
    override public var state: MYHRefreshComponent.RefreshState {
        willSet {
            if newValue == self.state {
                return
            }
            let oldValue = self.state
            super.state = newValue
            guard let scrollView = self.scrollView else {
                return
            }
            if newValue == .noMoreData || newValue == .idle {
                // 刷新完毕
                if oldValue == .refreshing {
                    UIView.animate(withDuration: MYHRefreshSlowAnimationDuration, animations: {
                        self.scrollView!.myh_inset_bottom -= self.lastBottomDelta
                        self.endRefreshingCompletionBlock?()
                        // 自动调整透明度
                        if self.isAutomaticallyChangeAlpha {
                            self.alpha = 0
                        }
                    }) { (finish) in
                        self.pullingPercent = 0
                        self.endRefreshingCompletionBlock?()
                    }
                }
                let deltaH = self.heightForContentBreakView()
                // 刚刷新完毕
                if oldValue == .refreshing, deltaH > 0, scrollView.myh_totalDataCount() != self.lastRefreshCount {
                    self.scrollView?.myh_offset_y = scrollView.myh_offset_y
                }
            } else if newValue == .refreshing {
                self.lastRefreshCount = scrollView.myh_totalDataCount()
                UIView.animate(withDuration: MYHRefreshFastAnimationDuration, animations: {
                    var bottom = self.myh_h + (self.scrollViewOriginalInset?.bottom ?? 0)
                    let deltaH = self.heightForContentBreakView()
                    if deltaH < 0 {// 如果内容高度小于view的高度
                        bottom -= deltaH
                    }
                    self.lastBottomDelta = bottom - scrollView.myh_inset_bottom
                    self.scrollView?.myh_inset_bottom = bottom
                    self.scrollView?.myh_offset_y = self.happenOffsetY() + self.myh_h
                }) { (finish) in
                    self.executeRefreshingCallback()
                }
            }
            
        }
    }
    
    /// 刚好看到上拉刷新控件时的contentOffset.y
    private func happenOffsetY() -> CGFloat {
        let deltaH = self.heightForContentBreakView()
        if deltaH > 0 {
            return deltaH - (self.scrollViewOriginalInset?.top ?? 0)
        } else {
            return -(self.scrollViewOriginalInset?.top ?? 0)
        }
    }
    
    /// 获得scrollView的内容 超出 view 的高度
    private func heightForContentBreakView() -> CGFloat {
        guard let scrollView = self.scrollView, let scrollViewOriginalInset = self.scrollViewOriginalInset  else { return 0 }
        let h = scrollView.myh_h - scrollViewOriginalInset.bottom - scrollViewOriginalInset.top
        return scrollView.contentSize.height - h
    }
}
