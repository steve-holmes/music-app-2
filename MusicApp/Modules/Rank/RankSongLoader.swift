//
//  RankSongLoader.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/30/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import RxSwift

protocol RankSongLoader {
    
    func getTracks(on country: String) -> Observable<[Track]>
    
}

class MARankSongLoader: RankSongLoader {
    
    func getTracks(on country: String) -> Observable<[Track]> {
        return API.rankTracks(country: country).json()
            .map { data in
                guard let tracks = data["tracks"] as? [[String:Any]] else {
                    fatalError("Can not get the field 'tracks")
                }
                
                return tracks.map { Track(json: $0) }
        }
    }
    
}
