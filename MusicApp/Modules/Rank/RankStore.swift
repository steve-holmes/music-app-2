//
//  RankStore.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/9/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import RxSwift

protocol RankStore {
    
    var songs: Variable<[Song]> { get }
    var playlists: Variable<[Playlist]> { get }
    var videos: Variable<[Video]> { get }
    
    var category: Variable<CategoryInfo> { get }
    var categories: Variable<[CategoriesInfo]> { get }
    
}

class MARankStore: RankStore {
    
    let songs = Variable<[Song]>([])
    let playlists = Variable<[Playlist]>([])
    let videos = Variable<[Video]>([])
    
    let category = Variable<CategoryInfo>(CategoryInfo(
        name: "Việt Nam",
        new: true,
        newlink: "nhac-viet",
        hotlink: "nhac-viet"
    ))
    
    let categories = Variable<[CategoriesInfo]>([])
    
}
