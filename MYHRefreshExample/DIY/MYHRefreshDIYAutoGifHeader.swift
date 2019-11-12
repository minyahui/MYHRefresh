//
//  MYHRefreshDIYAutoGifHeader.swift
//  MYHRefresh
//
//  Created by hs015 on 2019/11/7.
//  Copyright © 2019 MYH. All rights reserved.
//

import UIKit

class MYHRefreshDIYAutoGifHeader: MYHRefreshAutoGifHeader {

    override func prepare() {
        var idleImages = [UIImage]()
        var refreshingImages = [UIImage]()
        for i in 1 ... 60 {
            if let image = UIImage.init(named: "dropdown_anim__000\(i)") {
                idleImages.append(image)
            }
        }
        for i in 1 ... 3 {
            if let image = UIImage.init(named: "dropdown_loading_0\(i)") {
                refreshingImages.append(image)
            }
        }
        self.setImages(images: idleImages, state: .idle)
        self.setImages(images: refreshingImages, state: .pulling)
        self.setImages(images: refreshingImages, state: .refreshing)
        super.prepare()
    }

}
