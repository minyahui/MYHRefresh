//
//  MYHRefreshConst.swift
//  MYHRefresh
//
//  Created by hs015 on 2019/11/5.
//  Copyright © 2019 MYH. All rights reserved.
//

import UIKit

//MARK: runtime添加属性的Key
var MYHRefreshHeaderKey: String = "0"
var MYHRefreshFooterKey: String = "1"
var MYHRefreshReloadDataBlockKey: String = "3"

open class MYHRefreshConst: NSObject {
    /// 单例化管理者
    static var shared: MYHRefreshConst {
        struct Static {
            static let instance: MYHRefreshConst = MYHRefreshConst()
        }
        return Static.instance
    }
    
    open var isDark = false
    
    /// 语言版本，默认使用系统语言，如果需要设置这个值，请在启动APP的时候设置
    open var MYHRefreshDefaultLanguage: String = ""

//MARK: 常量
    /// 字体大小
    internal let MYHRefreshLabelFont = UIFont.boldSystemFont(ofSize: 14)
    internal let MYHRefreshLabelLeftInset: CGFloat = 25
    internal let MYHRefreshHeaderHeight: CGFloat = 54
    internal let MYHRefreshFooterHeight: CGFloat = 44
    internal let MYHRefreshFastAnimationDuration: TimeInterval = 0.25
    internal let MYHRefreshSlowAnimationDuration: TimeInterval = 0.4
//MARK: KVO监听的Key
    internal let MYHRefreshKeyPathContentOffset: String = "contentOffset"
    internal let MYHRefreshKeyPathContentSize: String = "contentSize"
    internal let MYHRefreshKeyPathContentInset: String = "contentInset"
    internal let MYHRefreshKeyPathPanState: String = "state"
//MARK: 取状态对应文本的Key
    internal let MYHRefreshHeaderLastUpdatedTimeKey: String = "MJRefreshHeaderLastUpdatedTimeKey"

    internal let MYHRefreshHeaderIdleText: String = "MYHRefreshHeaderIdleText"
    internal let MYHRefreshHeaderPullingText: String = "MYHRefreshHeaderPullingText"
    internal let MYHRefreshHeaderRefreshingText: String = "MYHRefreshHeaderRefreshingText"

    internal let MYHRefreshAutoFooterIdleText: String = "MYHRefreshAutoFooterIdleText"
    internal let MYHRefreshAutoFooterRefreshingText: String = "MYHRefreshAutoFooterRefreshingText"
    internal let MYHRefreshAutoFooterNoMoreDataText: String = "MYHRefreshAutoFooterNoMoreDataText"

    internal let MYHRefreshBackFooterIdleText: String = "MYHRefreshBackFooterIdleText"
    internal let MYHRefreshBackFooterPullingText: String = "MYHRefreshBackFooterPullingText"
    internal let MYHRefreshBackFooterRefreshingText: String = "MYHRefreshBackFooterRefreshingText"
    internal let MYHRefreshBackFooterNoMoreDataText: String = "MYHRefreshBackFooterNoMoreDataText"

    internal let MYHRefreshHeaderLastTimeText: String = "MYHRefreshHeaderLastTimeText"
    internal let MYHRefreshHeaderDateTodayText: String = "MYHRefreshHeaderDateTodayText"
    internal let MYHRefreshHeaderNoneLastDateText: String = "MYHRefreshHeaderNoneLastDateText"

}
