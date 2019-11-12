//
//  MYHRefreshFooter.swift
//  MYHRefresh
//
//  Created by hs015 on 2019/11/5.
//  Copyright © 2019 MYH. All rights reserved.
//

import UIKit

open class MYHRefreshFooter: MYHRefreshComponent {
    /// 忽略多少scrollView的contentInset的bottom
    public var ignoredScrollViewContentInsetBottom: CGFloat = 0
    
    private var insetTDelta: CGFloat = 0
    
    
    
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
        self.myh_h = MYHRefreshFooterHeight
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    /// 提示没有更多的数据
    public func endRefreshingWithNoMoreData() {
        DispatchQueue.main.async { [weak self]() in
            self?.state = .noMoreData
        }
    }
    
    /// 重置没有更多的数据（消除没有更多数据的状态）
    public func resetNoMoreData() {
        DispatchQueue.main.async {[weak self]() in
            self?.state = .idle
        }
    }
    
}

