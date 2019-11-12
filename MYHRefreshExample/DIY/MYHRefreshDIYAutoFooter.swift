//
//  MYHRefreshDIYAutoFooter.swift
//  MYHRefresh
//
//  Created by hs015 on 2019/11/12.
//  Copyright © 2019 MYH. All rights reserved.
//

import UIKit

class MYHRefreshDIYAutoFooter: MYHRefreshAutoFooter {
    private weak var label: UILabel?
    private weak var s: UISwitch?
    private weak var loading: UIActivityIndicatorView?
    override func prepare() {
        
        self.myh_h = 50
        
        let label = UILabel.init()
        label.textColor = UIColor.init(red: 1, green: 0.5, blue: 0, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        self.addSubview(label)
        self.label = label
        
        let s = UISwitch.init()
        self.addSubview(s)
        self.s = s
        
        let loading = UIActivityIndicatorView.init(style: .gray)
        self.addSubview(loading)
        self.loading = loading
        super.prepare()
    }
    
    override func placeSubviews() {
        super.placeSubviews()
        self.label?.frame = self.bounds
        self.s?.center = CGPoint.init(x: self.myh_w - 20, y: self.myh_h - 20)
        self.loading?.center = CGPoint.init(x: 30, y: self.myh_h * 0.5)
    }
    
    override var state: MYHRefreshComponent.RefreshState {
        willSet{
            if self.state == newValue {
                return
            }
            switch newValue {
            case .idle:
                self.loading?.stopAnimating()
                self.s?.setOn(false, animated: true)
                self.label?.text = "赶紧上拉吖(开关是打酱油滴)"
                break
            case .refreshing:
                self.loading?.startAnimating()
                self.s?.setOn(true, animated: true)
                self.label?.text = "加载数据中(开关是打酱油滴)"
                break
            case .noMoreData:
                self.s?.setOn(false, animated: true)
                self.label?.text = "木有数据了(开关是打酱油滴)"
                self.loading?.stopAnimating()
                break
            default:
                break
            }
            super.state = newValue
        }
    }

    override func scrollView(panStateDid change: [NSKeyValueChangeKey : Any]?) {
        super.scrollView(panStateDid: change)
    }
    
    override func scrollView(contentSizeDid change: [NSKeyValueChangeKey : Any]?) {
        super.scrollView(contentSizeDid: change)
    }
    
    override func scrollView(contentOffsetDid change: [NSKeyValueChangeKey : Any]?) {
        super.scrollView(contentOffsetDid: change)
    }

}
