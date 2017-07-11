//
//  LyricService.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/25/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import RxSwift

protocol LyricService {
    
    var repository: LyricRepository { get }
    
    func load(_ url: String) -> Observable<[Lyric]>
    
}

class MALyricService: LyricService {
    
    let repository: LyricRepository
    
    init(repository: LyricRepository) {
        self.repository = repository
    }
    
    func load(_ url: String) -> Observable<[Lyric]> {
        if !url.lyricURLValid {
            print("Lyric URL Invalid")
            return .just([])
        }
        
        return repository.load(url)
    }
    
}

fileprivate extension String {
    
    var lyricURLValid: Bool {
        return self.hasSuffix(".lrc")
    }
    
}
