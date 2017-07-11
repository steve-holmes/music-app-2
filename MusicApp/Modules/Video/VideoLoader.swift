//
//  VideoLoader.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/13/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import RxSwift

protocol VideoLoader {
    
    func getVideos(onCategory category: String, at page: Int) -> Observable<ItemResponse<VideoInfo>>
    
}

class MAVideoLoader: VideoLoader {
    
    func getVideos(onCategory category: String, at page: Int) -> Observable<ItemResponse<VideoInfo>> {
        return API.videos(category: category, page: page).json()
            .map { data in
                guard let category = data["category"] as? [String:Any] else {
                    fatalError("Can not get the field 'category'")
                }
                guard let videos = data["videos"] as? [[String:Any]] else {
                    fatalError("Can not get the field 'videos'")
                }
                return VideoInfo(
                    category: CategoryInfo(json: category),
                    videos: videos.map { Video(json: $0) }
                )
        }
        .map { .item($0) }
        .startWith(.loading)
    }
    
}
