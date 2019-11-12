//
//  MYHRefreshBackStateFooter.swift
//  MYHRefresh
//
//  Created by hs015 on 2019/11/6.
//  Copyright © 2019 MYH. All rights reserved.
//

import UIKit

public class MYHRefreshBackStateFooter: MYHRefreshBackFooter {
    
    /// 设置箭头的样式
    public var arrowType: MYHRefreshComponent.ArrowType = .black {
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
    public var labelLeftInset: CGFloat = MYHRefreshLabelLeftInset
        
    /// 所有状态对应的文字
    private var stateTitles: [MYHRefreshComponent.RefreshState:String] = [MYHRefreshComponent.RefreshState:String]()

    // MARK: 状态相关
    /// 显示刷新状态的label
    public weak var stateLabel: UILabel! {
        if self.privateStateLabel == nil {
            let label = UILabel.myh_init()
            self.addSubview(label)
            self.privateStateLabel = label
        }
        return self.privateStateLabel
    }
    private weak var privateStateLabel: UILabel?
    
    
    override public func prepare() {
        // 初始化间距
        self.labelLeftInset = MYHRefreshLabelLeftInset
        // 初始化文字
        self.setTitle(Bundle.myh_localizedString(key: MYHRefreshBackFooterPullingText), state: .pulling)
        self.setTitle(Bundle.myh_localizedString(key: MYHRefreshBackFooterRefreshingText), state: .refreshing)
        self.setTitle(Bundle.myh_localizedString(key: MYHRefreshBackFooterNoMoreDataText), state: .noMoreData)
        self.setTitle(Bundle.myh_localizedString(key: MYHRefreshBackFooterIdleText), state: .idle)
        self.arrowType = .black
        super.prepare()
        
    }
    
    convenience init(target: AnyObject, refreshingAction: Selector, arrowType: MYHRefreshComponent.ArrowType) {
       self.init()
       self.setRefreshing(target: target, refreshingAction: refreshingAction)
       self.arrowType = arrowType
    }
       
    convenience init(refreshingBlock: (()->())?, arrowType: MYHRefreshComponent.ArrowType) {
       self.init()
       self.refreshingBlock = refreshingBlock
       self.arrowType = arrowType
    }
    
    override public func placeSubviews() {
        super.placeSubviews()
        if self.stateLabel.constraints.count > 0 {
            return
        }
        self.stateLabel.frame = self.bounds
    }
    
    override public var state: MYHRefreshComponent.RefreshState {
        willSet {
            self.stateLabel.text = self.stateTitles[newValue]
            if self.state == newValue {
                return
            }
            
            super.state = newValue
        }
    }
    
    /// 设置状态对应的标题
    /// - Parameter title: 标题
    /// - Parameter state: 状态
    public func setTitle(_ title: String?, state: MYHRefreshComponent.RefreshState) {
        guard let t = title else { return }
        self.stateTitles[state] = t
        self.stateLabel.text = self.stateTitles[state]
    }
    
    /// 获取state状态下的title
    /// - Parameter state: 状态
    public func title(for state: MYHRefreshComponent.RefreshState) -> String? {
        return self.stateTitles[state]
    }
    
    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        let arrow = self.arrowType
        self.arrowType = arrow
    }
}

