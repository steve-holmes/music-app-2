//
//  SongStore.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/9/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import RxSwift

protocol SongStore {
    
    var songs: Variable<[Song]> { get }
    var category: Variable<CategoryInfo> { get }
    
    var songLoading: Variable<Bool> { get }
    var loadMoreEnabled: Variable<Bool> { get }
    
    var categories: Variable<[CategoriesInfo]> { get }
    
}

class MASongStore: SongStore {
    
    let songs = Variable<[Song]>([])
    
    let category = Variable<CategoryInfo>(CategoryInfo(
        name: "Mới & Hot",
        new: true,
        newlink: "bai-hat-moi",
        hotlink: "bai-hat-moi-nhat"
    ))
    
    let songLoading = Variable<Bool>(false)
    
    let loadMoreEnabled = Variable<Bool>(true)
    
    let categories = Variable<[CategoriesInfo]>([])
    
}
