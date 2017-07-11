//
//  VideoDetailLoader.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 7/2/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import RxSwift

protocol VideoDetailLoader {
    
    func getVideoDetail(_ video: Video) -> Observable<VideoDetailInfo?>
    
}

class MAVideoDetailLoader: VideoDetailLoader {
    
    func getVideoDetail(_ video: Video) -> Observable<VideoDetailInfo?> {
        return API.video(id: video.id).json()
            .map { data in
                guard let track = data["track"] as? [String:Any] else {
                    fatalError("Can not get the field 'track'")
                }
                guard let others = data["videos"] as? [[String:Any]] else {
                    fatalError("Can not get the field 'videos'")
                }
                guard let singers = data["singers"] as? [[String:Any]] else {
                    fatalError("Can not get the field 'singers'")
                }
                
                return VideoDetailInfo(
                    track:      VideoTrack(json: track),
                    others:     others.map { Video(json: $0) },
                    singers:    singers.map { Video(json: $0) }
                )
            }
            .startWith(nil)
    }
    
}
