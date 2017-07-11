//
//  SingerStore.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/9/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import RxSwift

protocol SingerStore {
    
    var singers: Variable<[Singer]> { get }
    var category: Variable<CategoryInfo> { get }
    
    var singerLoading: Variable<Bool> { get }
    var loadMoreEnabled: Variable<Bool> { get }
    
    var categories: Variable<[CategoriesInfo]> { get }
    
}

class MASingerStore: SingerStore {
    
    let singers = Variable<[Singer]>([])
    
    let category = Variable<CategoryInfo>(CategoryInfo(
        name: "HOT",
        new: true,
        newlink: "",
        hotlink: ""
    ))
    
    let singerLoading = Variable<Bool>(false)
    
    let loadMoreEnabled = Variable<Bool>(true)
    
    let categories = Variable<[CategoriesInfo]>([])
    
}
