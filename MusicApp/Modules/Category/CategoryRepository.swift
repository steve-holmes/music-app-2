//
//  CategoryRepository.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/13/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import RxSwift

protocol CategoryRepository {
    
    func getPlaylists() -> Observable<[CategoriesInfo]>
    func getSongs() -> Observable<[CategoriesInfo]>
    func getVideos() -> Observable<[CategoriesInfo]>
    func getSingers() -> Observable<[CategoriesInfo]>
    
    var singers: CategoriesInfo { get }
    
}

class MACategoryRepository: CategoryRepository {
    
    let loader: CategoryLoader
    
    init(loader: CategoryLoader) {
        self.loader = loader
    }
    
    func getPlaylists() -> Observable<[CategoriesInfo]> {
        return loader.getPlaylists()
    }
    
    func getSongs() -> Observable<[CategoriesInfo]> {
        return loader.getSongs()
    }
    
    func getVideos() -> Observable<[CategoriesInfo]> {
        return loader.getVideos()
    }
    
    private(set) lazy var singers: CategoriesInfo = {
        let characters = [
            "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m",
            "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"
        ]
        
        return CategoriesInfo(name: "Singers", categories:
            [Category(name: "HOT", newlink: "", hotlink: "")] +
            characters.map { Category(name: $0.uppercased(), newlink: $0, hotlink: $0) }
        )
    }()
    
    func getSingers() -> Observable<[CategoriesInfo]> {
        return .just([singers])
    }
    
}
