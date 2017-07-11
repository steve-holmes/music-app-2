//
//  VideoDetailService.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 7/2/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import RxSwift

protocol VideoDetailService {
    
    func getVideoDetail(_ video: Video) -> Observable<VideoDetailInfo?>
    
}

class MAVideoDetailService: VideoDetailService {
    
    let loader: VideoDetailLoader
    
    init(loader: VideoDetailLoader) {
        self.loader = loader
    }
    
    func getVideoDetail(_ video: Video) -> Observable<VideoDetailInfo?> {
        return loader.getVideoDetail(video)
    }
    
}
