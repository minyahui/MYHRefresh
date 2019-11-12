//
//  MYHRefreshAutoGifHeader.swift
//  MYHRefresh
//
//  Created by hs015 on 2019/11/6.
//  Copyright © 2019 MYH. All rights reserved.
//

import UIKit

open class MYHRefreshAutoGifHeader: MYHRefreshStateHeader {
    
    open weak var gifImageView: UIImageView! {
        if self.privateGifImageView == nil {
            let imageView = UIImageView()
            self.addSubview(imageView)
            self.privateGifImageView = imageView
        }
        return self.privateGifImageView
    }
    private weak var privateGifImageView: UIImageView?
    
    /// 所有状态对应的动画图片
    private var stateImages: [MYHRefreshComponent.RefreshState:[UIImage]]? = [MYHRefreshComponent.RefreshState:[UIImage]]()
    /// 所有状态对应的动画时间
    private var stateDurations: [MYHRefreshComponent.RefreshState:TimeInterval]? = [MYHRefreshComponent.RefreshState:TimeInterval]()
    
    
    override open var pullingPercent: CGFloat {
        willSet{
            super.pullingPercent = newValue
            if self.state != .idle  {
                return
            }
            guard let images = self.stateImages?[MYHRefreshComponent.RefreshState.idle], images.count > 0 else {
                return
            }
            self.gifImageView.stopAnimating()
            var index = Int(CGFloat(images.count) * (newValue))
            if index >= images.count {
                index = images.count - 1
            }
            self.gifImageView.image = images[index]
        }
    }
    
    override open var state: MYHRefreshComponent.RefreshState {
        willSet {
            if self.state == newValue {
                return
            }
            if newValue == .pulling || newValue == .refreshing {
                guard let images = self.stateImages?[newValue], images.count > 0 else {
                    return
                }
                self.gifImageView.stopAnimating()
                if images.count == 1 {
                    self.gifImageView.image = images.last
                } else {
                    self.gifImageView.animationImages = images
                    self.gifImageView.animationDuration = self.stateDurations?[newValue] ?? 0.1
                    self.gifImageView.startAnimating()
                }
            } else if newValue == .idle{
                self.gifImageView.stopAnimating()
            }
            super.state = newValue
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
    
    override open func placeSubviews() {
        super.placeSubviews()
        if self.gifImageView.constraints.count > 0 {
            return
        }
        self.gifImageView.frame = self.bounds
        if self.stateLabel.isHidden == true, self.lastUpdatedTimeLabel.isHidden == true {
            self.gifImageView.contentMode = .center
        } else {
            self.gifImageView.contentMode = .right
            let stateWidth = self.stateLabel.myh_textWidth()
            var timeWidth: CGFloat = 0
            if self.lastUpdatedTimeLabel.isHidden == false {
                timeWidth = self.lastUpdatedTimeLabel.myh_textWidth()
            }
            let textWidth = stateWidth > timeWidth ? stateWidth : timeWidth
            self.gifImageView.myh_w = self.myh_w * 0.5 - textWidth * 0.5 - self.labelLeftInset
        }
    }
    
    override open func prepare() {
        super.prepare()
        self.labelLeftInset = 20
    }
    
    open func setImages(images: [UIImage], duration: TimeInterval, state: MYHRefreshComponent.RefreshState) {
        self.stateImages?[state] = images
        if duration <= 0 {
            self.stateDurations?[state] = 0.1
        } else {
            self.stateDurations?[state] = duration
        }
        if images.count > 0 {
            self.myh_h = images[0].size.height
        }
    }
    
    open func setImages(images: [UIImage], state: MYHRefreshComponent.RefreshState) {
        self.setImages(images: images, duration: Double(images.count) * 0.1, state: state)
    }
}

