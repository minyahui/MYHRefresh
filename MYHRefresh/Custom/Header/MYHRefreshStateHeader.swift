//
//  MYHRefreshStateHeader.swift
//  MYHRefresh
//
//  Created by hs015 on 2019/11/6.
//  Copyright © 2019 MYH. All rights reserved.
//

import UIKit

open class MYHRefreshStateHeader: MYHRefreshHeader {
    // MARK: 刷新时间相关
    /// 显示上一次刷新时间的label
    open weak var lastUpdatedTimeLabel: UILabel! {
        if self.privateLastUpdatedTimeLabel == nil {
            let label = UILabel.myh_init()
            self.addSubview(label)
            self.privateLastUpdatedTimeLabel = label
        }
        return self.privateLastUpdatedTimeLabel
    }
    private weak var privateLastUpdatedTimeLabel: UILabel?
    /// 利用这个block来决定显示的更新时间文字 -- 优先显示这个时间，没有就取本地存储的时间
    open var lastUpdatedTimeText: ((Date)->(String))?
    
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
    
    override open var state: MYHRefreshComponent.RefreshState {
        willSet{
            // 设置状态文字
            self.stateLabel.text = self.stateTitles[newValue]
            if self.state == newValue {
                return
            }
            super.state = newValue
            
            // 重新设置key（重新显示时间）
            self.refreshTime()
        }
    }
    
    /// 设置箭头的样式
    open var arrowType: MYHRefreshComponent.ArrowType = .black {
        willSet {
            switch newValue {
            case .black:
                self.stateLabel.textColor = UIColor.myh_black
                self.lastUpdatedTimeLabel.textColor = UIColor.myh_black
                break
            case .white:
                self.stateLabel.textColor = UIColor.myh_white
                self.lastUpdatedTimeLabel.textColor = UIColor.myh_white
                break
            }
        }
    }
    
    /// 文字距离圈圈、箭头的距离
    open var labelLeftInset: CGFloat = MYHRefreshConst.shared.MYHRefreshLabelLeftInset
    
    /// 所有状态对应的文字
    private var stateTitles: [MYHRefreshComponent.RefreshState:String] = [MYHRefreshComponent.RefreshState:String]()
    
    override open var lastUpdatedTimeKey: String {
        didSet{
            self.refreshTime()
        }
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
    
    // MARK: 重写父类的方法
    override open func prepare() {
        // 初始化间距
        self.labelLeftInset = MYHRefreshConst.shared.MYHRefreshLabelLeftInset
        // 初始化文字
        self.setTitle(Bundle.myh_localizedString(key: MYHRefreshConst.shared.MYHRefreshHeaderPullingText), state: .pulling)
        self.setTitle(Bundle.myh_localizedString(key: MYHRefreshConst.shared.MYHRefreshHeaderRefreshingText), state: .refreshing)
        self.setTitle(Bundle.myh_localizedString(key: MYHRefreshConst.shared.MYHRefreshHeaderIdleText), state: .idle)
        super.prepare()
    }
    override open func placeSubviews() {
        super.placeSubviews()
        if self.stateLabel.isHidden == true {
            return
        }
        let noConstrainsOnStatusLabel: Bool = self.stateLabel.constraints.count == 0
        
        if self.lastUpdatedTimeLabel.isHidden {
            if noConstrainsOnStatusLabel {
                self.stateLabel.frame = self.bounds
            }
        } else {
            let stateLabelHeight = self.myh_h * 0.5
            if noConstrainsOnStatusLabel {
                self.stateLabel.frame = CGRect.init(x: 0, y: 0, width: self.myh_w, height: stateLabelHeight)
            }
            if self.lastUpdatedTimeLabel.constraints.count == 0{
                self.lastUpdatedTimeLabel.frame = CGRect.init(x: 0, y: stateLabelHeight, width: self.myh_w, height: self.myh_h - self.lastUpdatedTimeLabel.myh_y)
            }
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
        let arrowType = self.arrowType
        self.arrowType = arrowType
    }
}

// MARK: 私有方法
extension MYHRefreshStateHeader{
    
    /// <#Description#>
    private func refreshTime() {
        if self.lastUpdatedTimeLabel.isHidden {
            return
        }
        guard let lastUpdatedTime = UserDefaults.standard.object(forKey: self.lastUpdatedTimeKey) as? Date else {
            self.lastUpdatedTimeLabel.text = Bundle.myh_localizedString(key: MYHRefreshConst.shared.MYHRefreshHeaderLastTimeText) + Bundle.myh_localizedString(key: MYHRefreshConst.shared.MYHRefreshHeaderNoneLastDateText)
            return
        }
        if let timeStr = self.lastUpdatedTimeText?(lastUpdatedTime) {
            self.lastUpdatedTimeLabel.text = timeStr
            return
        }
        let calender = Calendar.init(identifier: Calendar.Identifier.gregorian)
        let components = Set<Calendar.Component>.init(arrayLiteral: .year, .month, .day, .hour, .minute)
        
        let cmp1 = calender.dateComponents(components, from: lastUpdatedTime)
        let cmp2 = calender.dateComponents(components, from: Date.init())
        
        let formatter = DateFormatter.init()
        
        var isToday = false
        if let day1 = cmp1.day, day1 == cmp2.day {// 今天
            formatter.dateFormat = " HH:mm"
            isToday = true
        } else if let year1 = cmp1.year, year1 == cmp2.year {// 今年
            formatter.dateFormat = "MM-dd HH:mm"
        } else {
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
        }
        let time = formatter.string(from: lastUpdatedTime)
        self.lastUpdatedTimeLabel.text = Bundle.myh_localizedString(key: MYHRefreshConst.shared.MYHRefreshHeaderLastTimeText) + (isToday ? Bundle.myh_localizedString(key: MYHRefreshConst.shared.MYHRefreshHeaderDateTodayText) : "") + time
    }
    
    
}
