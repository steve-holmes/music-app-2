//
//  VideoStore.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/10/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import RxSwift

protocol VideoStore {
    
    var videos: Variable<[Video]> { get }
    var category: Variable<CategoryInfo> { get }
    
    var videoLoading: Variable<Bool> { get }
    var loadMoreEnabled: Variable<Bool> { get }
    
    var categories: Variable<[CategoriesInfo]> { get }
    
}

class MAVideoStore: VideoStore {
    
    let videos = Variable<[Video]>([])
    
    let category = Variable<CategoryInfo>(CategoryInfo(
        name: "Nhạc Trẻ",
        new: true,
        newlink: "am-nhac-viet-nam-nhac-tre",
        hotlink: "am-nhac-viet-nam-nhac-tre-moi-nhat"
    ))
    
    let videoLoading = Variable<Bool>(false)
    
    let loadMoreEnabled = Variable<Bool>(true)
    
    let categories = Variable<[CategoriesInfo]>([])
    
}
