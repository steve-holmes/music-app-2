//
//  CategoryLoader.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/13/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import RxSwift

protocol CategoryLoader {
    
    func getPlaylists() -> Observable<[CategoriesInfo]>
    func getSongs() -> Observable<[CategoriesInfo]>
    func getVideos() -> Observable<[CategoriesInfo]>
    
}

class MACategoryLoader: CategoryLoader {
    
    func getPlaylists() -> Observable<[CategoriesInfo]> {
        return getCategories("playlists")
    }
    
    func getSongs() -> Observable<[CategoriesInfo]> {
        return getCategories("songs")
    }
    
    func getVideos() -> Observable<[CategoriesInfo]> {
        return getCategories("videos")
    }
    
    private func getCategories(_ category: String) -> Observable<[CategoriesInfo]> {
        return getTopics(category)
            .map { topics in
                return topics.map { topic in
                    guard let name = topic["name"] as? String else {
                        fatalError("Can not get the field 'name'")
                    }
                    guard let categories = topic["categories"] as? [[String:Any]] else {
                        fatalError("Can not get the field 'categories")
                    }
                    return CategoriesInfo(name: name, categories: categories.map { Category(json: $0) })
                }
        }
    }
    
    private func getTopics(_ category: String) -> Observable<[[String:Any]]> {
        return API.categories(category).json()
            .map { data in
                guard let topics = data["topics"] as? [[String:Any]] else {
                    fatalError("Can not get the field 'topics'")
                }
                return topics
            }
    }
    
}
