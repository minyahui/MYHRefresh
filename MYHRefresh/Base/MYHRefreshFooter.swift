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
    open var ignoredScrollViewContentInsetBottom: CGFloat = 0
    
    private var insetTDelta: CGFloat = 0
    
    
    
    public convenience init(target: AnyObject, refreshingAction: Selector) {
        self.init()
        self.setRefreshing(target: target, refreshingAction: refreshingAction)
    }
    
    public convenience init(refreshingBlock: (()->())?) {
        self.init()
        self.refreshingBlock = refreshingBlock
    }
    
    override open func prepare() {
        super.prepare()
        self.myh_h = MYHRefreshConst.shared.MYHRefreshFooterHeight
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    /// 提示没有更多的数据
    open func endRefreshingWithNoMoreData() {
        DispatchQueue.main.async { [weak self]() in
            self?.state = .noMoreData
        }
    }
    
    /// 重置没有更多的数据（消除没有更多数据的状态）
    open func resetNoMoreData() {
        DispatchQueue.main.async {[weak self]() in
            self?.state = .idle
        }
    }
    
}

