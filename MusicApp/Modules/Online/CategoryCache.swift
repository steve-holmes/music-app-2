//
//  CategoryCache.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/20/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import Foundation

class CategoryCache<Item> {
    
    private let cache = NSCache<NSString, ItemValue<Item>>()
    private var pages: [String:[Int]] = [:]
    
    func setItem(_ item: Item, category: String, page: Int) {
        let key = ItemKey(category: category, page: page)
        cache.setObject(ItemValue(item), forKey: key.description as NSString)
        
        if self.pages[category] == nil {
            self.pages[category] = []
        }
        
        var pages = self.pages[category]!
        if !pages.contains(page) {
            pages.append(page)
            self.pages[category] = pages
        }
    }
    
    func getItem(category: String, page: Int) -> Item? {
        let key = ItemKey(category: category, page: page)
        let value = cache.object(forKey: key.description as NSString)
        return value?.item
    }
    
    func removeItems(category: String) {
        guard let pages = self.pages[category] else { return }
        
        for page in pages {
            let key = ItemKey(category: category, page: page)
            cache.removeObject(forKey: key.description as NSString)
        }
        
        self.pages[category] = nil
    }
    
}

fileprivate class ItemKey: CustomStringConvertible {
    
    let category: String
    let page: Int
    
    init(category: String, page: Int) {
        self.category = category
        self.page = page
    }
    
    var description: String {
        return category + "/\(page)"
    }
    
}

fileprivate class ItemValue<Item> {
    
    let item: Item
    
    init(_ item: Item) {
        self.item = item
    }
    
}
