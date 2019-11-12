//
//  MYHRefreshConst.swift
//  MYHRefresh
//
//  Created by hs015 on 2019/11/5.
//  Copyright © 2019 MYH. All rights reserved.
//

import UIKit

/// 语言版本，默认使用系统语言
let MYHRefreshDefaultLanguage: String = ""

/// 字体大小
let MYHRefreshLabelFont = UIFont.boldSystemFont(ofSize: 14)

// 常量
let MYHRefreshLabelLeftInset: CGFloat = 25
let MYHRefreshHeaderHeight: CGFloat = 54
let MYHRefreshFooterHeight: CGFloat = 44
let MYHRefreshFastAnimationDuration: TimeInterval = 0.25
let MYHRefreshSlowAnimationDuration: TimeInterval = 0.4

let MYHRefreshKeyPathContentOffset: String = "contentOffset"
let MYHRefreshKeyPathContentSize: String = "contentSize"
let MYHRefreshKeyPathContentInset: String = "contentInset"
let MYHRefreshKeyPathPanState: String = "state"

let MYHRefreshHeaderLastUpdatedTimeKey: String = "MJRefreshHeaderLastUpdatedTimeKey"

let MYHRefreshHeaderIdleText: String = "MYHRefreshHeaderIdleText"
let MYHRefreshHeaderPullingText: String = "MYHRefreshHeaderPullingText"
let MYHRefreshHeaderRefreshingText: String = "MYHRefreshHeaderRefreshingText"

let MYHRefreshAutoFooterIdleText: String = "MYHRefreshAutoFooterIdleText"
let MYHRefreshAutoFooterRefreshingText: String = "MYHRefreshAutoFooterRefreshingText"
let MYHRefreshAutoFooterNoMoreDataText: String = "MYHRefreshAutoFooterNoMoreDataText"

let MYHRefreshBackFooterIdleText: String = "MYHRefreshBackFooterIdleText"
let MYHRefreshBackFooterPullingText: String = "MYHRefreshBackFooterPullingText"
let MYHRefreshBackFooterRefreshingText: String = "MYHRefreshBackFooterRefreshingText"
let MYHRefreshBackFooterNoMoreDataText: String = "MYHRefreshBackFooterNoMoreDataText"

let MYHRefreshHeaderLastTimeText: String = "MYHRefreshHeaderLastTimeText"
let MYHRefreshHeaderDateTodayText: String = "MYHRefreshHeaderDateTodayText"
let MYHRefreshHeaderNoneLastDateText: String = "MYHRefreshHeaderNoneLastDateText"


var MYHRefreshHeaderKey: String = "0"
var MYHRefreshFooterKey: String = "1"
var MYHRefreshReloadDataBlockKey: String = "3"

/// light模式
var MYH_isLight: Bool {
    get {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.keyWindow?.traitCollection.userInterfaceStyle == .light
        }
        return true
    }
}


