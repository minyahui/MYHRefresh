//
//  MYHRefreshAutoFooter.swift
//  MYHRefresh
//
//  Created by hs015 on 2019/11/5.
//  Copyright © 2019 MYH. All rights reserved.
//

import UIKit

class MYHRefreshAutoFooter: MYHRefreshFooter {
    /// 当底部控件出现多少时就自动刷新(默认为1.0，也就是底部控件完全出现时，才会自动刷新)
    public var triggerAutomaticallyRefreshPercent: CGFloat = 1
    /// 是否每一次拖拽只发一次请求
    public var isOnlyRefreshPerDrag: Bool = false
    /// 是否自动刷新(默认为true)
    public var isAutomaticallyRefresh: Bool = true
    
    /// 一个新的拖拽
    private var isOneNewPan: Bool = false
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        if newSuperview != nil {
            if self.scrollView != nil {
                
                if self.isHidden == false {
                    self.scrollView!.myh_inset_bottom += self.myh_h
                }
                self.myh_y = self.scrollView!.myh_content_height
            }
            
        } else {
            if self.isHidden == false, self.scrollView != nil {
                self.scrollView!.myh_inset_bottom -= self.myh_h
            }
        }
    }
    
    override func prepare() {
        super.prepare()
        self.triggerAutomaticallyRefreshPercent = 1
        self.isAutomaticallyChangeAlpha = false
        self.isAutomaticallyRefresh = true
    }
    
    override func scrollView(contentSizeDid change: [NSKeyValueChangeKey : Any]?) {
        super.scrollView(contentSizeDid: change)
        if self.scrollView != nil {
            self.myh_y = self.scrollView!.myh_content_height + self.ignoredScrollViewContentInsetBottom
        }
    }
    
    override func scrollView(contentOffsetDid change: [NSKeyValueChangeKey : Any]?) {
        super.scrollView(contentOffsetDid: change)
        if self.state != .idle || self.isAutomaticallyRefresh == false || self.myh_y == 0 {
            return
        }
        if self.scrollView == nil {
            return
        }
        if self.scrollView!.myh_inset_top + self.scrollView!.myh_content_height > self.scrollView!.myh_h {// 内容超过一个屏幕
            let offsetY = self.scrollView!.myh_content_height - self.scrollView!.myh_h + self.myh_h * self.triggerAutomaticallyRefreshPercent + self.scrollView!.myh_inset_bottom - self.myh_h
            if self.scrollView!.myh_offset_y >= offsetY {
                // 防止手松开时连续调用
                if let old = change?[.oldKey] as? CGPoint, let new = change?[.newKey] as? CGPoint, new.y <= old.y {
                    return
                }
                // 当底部刷新控件完全出现时，才刷新
                self.beginRefreshing()
            }
        }
    }
    
    
    override func scrollView(panStateDid change: [NSKeyValueChangeKey : Any]?) {
        super.scrollView(panStateDid: change)
        if self.state != .idle {
            return
        }
        guard let panState = self.scrollView?.panGestureRecognizer.state else {
            return
        }
        switch panState {
        case .ended:
            guard let scrollView = self.scrollView else { return }
            if scrollView.myh_inset_top + scrollView.myh_content_height <= scrollView.myh_h {// 不够一个屏幕
                if scrollView.myh_offset_y >= scrollView.myh_inset_top {// 向上拽
                    self.beginRefreshing()
                }
            } else {// 超出一个屏幕
                if scrollView.myh_offset_y >= scrollView.myh_content_height + scrollView.myh_inset_bottom - scrollView.myh_h {// 向上拽
                    self.beginRefreshing()
                }
            }// ‼️注意: 这里没有 break; fallthrough 执行重置 oneNewPan 语句 (Ended & Canceled & Failed)
        case .cancelled, .failed:
            self.isOneNewPan = false
            break
        case .began:
            self.isOneNewPan = true
            break
        default:
            break
        }
    }
    
    /// 在触发开始刷新前的刷新忽略逻辑, 默认由 isOnlyRefreshPerDrag 和 新手势决定, 用于特殊控制逻辑, 如果不清楚机制, 请勿使用
    public func ignoreRefreshAction() -> Bool {
        return !self.isOneNewPan && self.isOnlyRefreshPerDrag
    }
    
    override func beginRefreshing() {
        if self.ignoreRefreshAction() {
            return
        }
        super.beginRefreshing()
    }
    
    override var state: MYHRefreshComponent.RefreshState {
        willSet {
            if newValue == self.state {
                return
            }
            let oldValue = self.state
            super.state = newValue
            if newValue == .refreshing {
                self.executeRefreshingCallback()
            } else if newValue == .noMoreData || newValue == .idle {
                if oldValue == .refreshing {
                    self.endRefreshingCompletionBlock?()
                }
            }
        }
    }
    
    override var isHidden: Bool {
        willSet{
            let lastHidden = self.isHidden
            super.isHidden = newValue
            guard let scrollView = self.scrollView else { return }
            if !lastHidden && newValue {
                self.state = .idle
                self.scrollView!.myh_inset_bottom -= self.myh_h
            } else if lastHidden && !newValue {
                self.scrollView!.myh_inset_bottom += self.myh_h
                self.myh_y = scrollView.myh_content_height
            }
        }
    }
}
