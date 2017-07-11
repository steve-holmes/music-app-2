//
//  LyricLoader.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/25/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import RxSwift
import RxAlamofire

protocol LyricLoader {
    
    func load(_ url: String) -> Observable<[Lyric]>
    
}

class MALyricLoader: LyricLoader {
    
    func load(_ url: String) -> Observable<[Lyric]> {
        return RxAlamofire.string(.get, url)
            .flatMap { [weak self] content -> Observable<[Lyric]> in
                guard let this = self else { return .just([]) }
                return this.load(encryptedContent: content)
                    .retry(1)
                    .catchErrorJustReturn([])
            }
    }
    
    private func load(encryptedContent: String) -> Observable<[Lyric]> {
        let lyricBaseURL = "http://innoxious-cork.000webhostapp.com/crypto.php"
        
        return RxAlamofire.json(.post, lyricBaseURL, parameters: ["text": encryptedContent])
            .map { data -> [(content: String, times: [String])] in
                guard let lyrics = data as? [[String:Any]] else { return [] }
                
                return lyrics.map { lyric in
                    guard let content = lyric["lyric"] as? String else {
                        fatalError("Can not get the field 'lyric'")
                    }
                    guard let times = lyric["times"] as? [String] else {
                        fatalError("Can not get the field 'times'")
                    }
                    
                    return (content: content, times: times)
                }
            }
            .map { rawLyrics in
                rawLyrics.flatMap { content, times in
                    times.map { time in Lyric(time:time.timeToSeconds, content: content) }
                }
            }
            .map { lyrics in lyrics.sorted() }
    }
    
}

fileprivate extension String {
    
    var timeToSeconds: Int {
        let minuteString = substring(to: index(startIndex, offsetBy: 2))
        let minute = Int(minuteString) ?? 0
        
        let secondString = substring(with: index(startIndex, offsetBy: 3) ..< index(startIndex, offsetBy: 5))
        let second = Int(secondString) ?? 0
        
        let miliSecondString = substring(with: index(endIndex, offsetBy: -2) ..< endIndex)
        let miliSecond = Int(miliSecondString)!
        
        return minute * 60 + second + ((miliSecond > 50) ? 1 : 0)
    }
    
}
