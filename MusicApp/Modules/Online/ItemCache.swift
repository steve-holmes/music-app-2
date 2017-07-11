//
//  ItemCache.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/20/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import Foundation

class ItemCache<Item> {
    
    private let cache = NSCache<NSString, ItemValue<Item>>()
    
    func setItem(_ item: Item, for id: String) {
        cache.setObject(ItemValue(item), forKey: id as NSString)
    }
    
    func getItem(_ id: String) -> Item? {
        let value = cache.object(forKey: id as NSString)
        return value?.item
    }
    
    func removeItem(_ id: String) {
        cache.removeObject(forKey: id as NSString)
    }
    
    func removeAllItems() {
        cache.removeAllObjects()
    }
    
}

fileprivate class ItemValue<Item> {
    
    let item: Item
    
    init(_ item: Item) {
        self.item = item
    }
    
}
