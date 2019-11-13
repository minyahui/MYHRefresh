//
//  Bundle+MYHRefresh.swift
//  MYHRefresh
//
//  Created by hs015 on 2019/11/5.
//  Copyright © 2019 MYH. All rights reserved.
//

import UIKit

extension Bundle {
    
    /// 单例化
    public static var shared: Bundle {
        let bundle = Bundle.init(for: MYHRefreshComponent.classForCoder())
        if let bundlePath = bundle.path(forResource: "MYHRefresh", ofType: "bundle"), let bundle2 = Bundle.init(path: bundlePath) {
            return bundle2
        }
        return bundle
    }
    
    
    private static var languageBundle: Bundle? = nil
    
    /// 国际化-取文本
    /// - Parameter key: 文本的key
    /// - Parameter value: <#value description#>
    public static func myh_localizedString(key: String, value: String? = nil) -> String {
        if Bundle.languageBundle == nil {
            var language: String? = MYHRefreshConst.shared.MYHRefreshDefaultLanguage
            if language == nil || language!.count == 0 {
                language = Locale.preferredLanguages.first
            }
            if let have = language?.hasPrefix("en"), have == true {
                language = "en"
            } else if let have = language?.hasPrefix("zh"), have == true {
                if let location = (language as NSString?)?.range(of: "Hans").location, location != NSNotFound {
                    language = "zh-Hans"
                } else {
                    language = "zh-Hant"
                }
            } else if let have = language?.hasPrefix("ko"), have == true {
                language = "ko"
            } else if let have = language?.hasPrefix("ru"), have == true {
                language = "ru"
            } else if let have = language?.hasPrefix("uk"), have == true {
                language = "uk"
            } else {
                language = "en"
            }
            if let path = Bundle.shared.path(forResource: language, ofType: "lproj") {
                Bundle.languageBundle = Bundle.init(path: path)
            } else if let path = Bundle.shared.path(forResource: "zh-Hans", ofType: "lproj") {
                Bundle.languageBundle = Bundle.init(path: path)
            }
        }
        let newValue = Bundle.languageBundle?.localizedString(forKey: key, value: value, table: nil)
        return Bundle.main.localizedString(forKey: key, value: newValue, table: nil)
    }
    
    /// 获取下拉刷新的时候的箭头
    /// - Parameter arrowType: 箭头的样式
    public static func myh_arrowImage(arrowType: MYHRefreshComponent.ArrowType) -> UIImage? {
        
        var imageName: String = arrowType.rawValue
        switch arrowType {
        case .black:
            if MYHRefreshConst.shared.isDark {
                imageName = "MYH_arrow_white@2x"
            }
            break
        case .white:
            if MYHRefreshConst.shared.isDark {
                imageName = "MYH_arrow_black@2x"
            }
            break
        }
        guard let imagePath = Bundle.shared.path(forResource: imageName, ofType: "png") else { return nil }
        return UIImage.init(contentsOfFile: imagePath)?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
    }
    
    
}
