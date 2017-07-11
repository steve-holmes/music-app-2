//
//  API.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/13/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import RxSwift
import RxAlamofire

enum API {
    
    case categories(String)
    
    case home
    
    case playlists(category: String, page: Int)
    case playlist(id: String)
    
    case songs(category: String, page: Int)
    case song(id: String)
    
    case videos(category: String, page: Int)
    case video(id: String)
    
    case ranks(country: String)
    case rankTracks(country: String)
    
    case hotSingers
    case singers(category: String, page: Int)
    case singer(id: String)
    
    case topics
    case topic(id: String)
    
}

extension API {
    
//    var baseURL: String { return "https://music-api-kp.herokuapp.com" }
    var baseURL: String { return "http://192.168.1.103:3000" }
    
    var url: String { return baseURL + path }
    
    var path: String {
        switch self {
        case let .categories(category):
            return "/categories/\(category)"
            
        case .home:
            return "/online/home"
            
        case let .playlists(category, page):
            return "/online/playlists/\(category)/\(page)"
        case let .playlist(id):
            return "/playlists/\(id)"
            
        case let .songs(category, page):
            return "/online/songs/\(category)/\(page)"
        case let .song(id):
            return "/songs/\(id)"
            
        case let .videos(category, page):
            return "/online/videos/\(category)/\(page)"
        case let .video(id):
            return "/videos/\(id)"
            
        case let .ranks(country):
            return "/ranks/\(country)"
        case let .rankTracks(country):
            return "/ranks/songs/\(country)"
            
        case .hotSingers:
            return "/online/singers"
        case let .singers(category, page):
            return "/online/singers/\(category)/\(page)"
        case let .singer(id):
            return "/singers/\(id)"
            
        case .topics:
            return "/topics"
        case let .topic(id):
            return "/topics/\(id)"
        }
    }
    
}

extension API {
    
    func json() -> Observable<[String:Any]> {
        return RxAlamofire.json(.get, self.url)
            .map { json in
                guard let data = (json as? [String:Any])?["data"] as? [String:Any] else {
                    fatalError("Can not get the field 'data'")
                }
                return data
            }
            .retry(1)
    }
    
}
