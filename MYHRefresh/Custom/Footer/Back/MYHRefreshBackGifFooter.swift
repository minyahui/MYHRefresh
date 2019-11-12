//
//  MYHRefreshBackGifFooter.swift
//  MYHRefresh
//
//  Created by hs015 on 2019/11/6.
//  Copyright © 2019 MYH. All rights reserved.
//

import UIKit

public class MYHRefreshBackGifFooter: MYHRefreshBackStateFooter {

    public weak var gifImageView: UIImageView! {
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
    
    override public var pullingPercent: CGFloat {
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
    
    override public var state: MYHRefreshComponent.RefreshState {
        willSet {
            if self.state == newValue {
                return
            }
            if newValue == .pulling || newValue == .refreshing {
                guard let images = self.stateImages?[newValue], images.count > 0 else {
                    return
                }
                self.gifImageView.isHidden = false
                self.gifImageView.stopAnimating()
                if images.count == 1 {
                    self.gifImageView.image = images.last
                } else {
                    self.gifImageView.animationImages = images
                    self.gifImageView.animationDuration = self.stateDurations?[newValue] ?? 0.1
                    self.gifImageView.startAnimating()
                }
            } else if newValue == .idle{
                self.gifImageView.isHidden = false
            } else if newValue == .noMoreData{
                self.gifImageView.isHidden = false
            }
            super.state = newValue
        }
    }
    
    
    override public func placeSubviews() {
        super.placeSubviews()
        if self.gifImageView.constraints.count > 0 {
            return
        }
        self.gifImageView.frame = self.bounds
        if self.stateLabel.isHidden == true {
            self.gifImageView.contentMode = .center
        } else {
            self.gifImageView.contentMode = .right
            self.gifImageView.myh_w = self.myh_w * 0.5 - self.stateLabel.myh_textWidth() * 0.5 - self.labelLeftInset
        }
    }
    
    override public func prepare() {
        // 初始化间距
        self.labelLeftInset = 20
        super.prepare()
    }
    
    public func setImages(images: [UIImage], duration: TimeInterval, state: MYHRefreshComponent.RefreshState) {
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
    
    public func setImages(images: [UIImage], state: MYHRefreshComponent.RefreshState) {
        self.setImages(images: images, duration: Double(images.count) * 0.1, state: state)
    }
}
