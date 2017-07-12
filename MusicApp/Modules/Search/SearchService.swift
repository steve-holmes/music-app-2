//
//  SearchService.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 7/11/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import RxSwift

protocol SearchService {
    
    func search(_ query: String) -> Observable<ItemResponse<SearchInfo>>
    
    func play(song: Song) -> Observable<Void>
    
    func presentPlaylist(_ playlist: Playlist) -> Observable<Void>
    func presentVideo(_ video: Video) -> Observable<Void>
    
    func openContextMenu(_ song: Song) -> Observable<Void>
    
}

class MASearchService: SearchService {
    
    let loader: SearchLoader
    let notification: SongNotification
    let coordinator: SearchCoordinator
    
    init(loader: SearchLoader, notification: SongNotification, coordinator: SearchCoordinator) {
        self.loader = loader
        self.notification = notification
        self.coordinator = coordinator
    }
    
    func search(_ query: String) -> Observable<ItemResponse<SearchInfo>> {
        return loader.search(query.noAccent.url)
    }
    
    func play(song: Song) -> Observable<Void> {
        return notification.play(song)
    }
    
    func presentPlaylist(_ playlist: Playlist) -> Observable<Void> {
        return coordinator.presentPlaylist(playlist)
    }
    
    func presentVideo(_ video: Video) -> Observable<Void> {
        return coordinator.presentVideo(video)
    }
    
    func openContextMenu(_ song: Song) -> Observable<Void> {
        return coordinator.openContextMenu(song)
    }
    
}

fileprivate let aCharacters: String.CharacterView = "ạảãàáâậầấẩẫăắằặẳẵẠẢÃÀÁÂẬẦẤẨẪĂẮẰẶẲẴ".characters
fileprivate let oCharacters: String.CharacterView = "óòọõỏôộổỗồốơờớợởỡÓÒỌÕỎÔỘỔỖỒỐƠỜỚỢỞỠ".characters
fileprivate let eCharacters: String.CharacterView = "éèẻẹẽêếềệểễÉÈẺẸẼÊẾỀỆỂỄ".characters
fileprivate let uCharacters: String.CharacterView = "úùụủũưựữửừứÚÙỤỦŨƯỰỮỬỪỨ".characters
fileprivate let iCharacters: String.CharacterView = "íìịỉĩÍÌỊỈĨ".characters
fileprivate let yCharacters: String.CharacterView = "ýỳỷỵỹÝỲỶỴỸ".characters
fileprivate let dCharacters: String.CharacterView = "đĐ".characters

fileprivate extension String {
    
    var noAccent: String {
        var noAccentString = ""
        
        for character in self.characters {
            if aCharacters.contains(character) {
                noAccentString.append("a")
            } else if oCharacters.contains(character) {
                noAccentString.append("o")
            } else if eCharacters.contains(character) {
                noAccentString.append("e")
            } else if uCharacters.contains(character) {
                noAccentString.append("u")
            } else if iCharacters.contains(character) {
                noAccentString.append("i")
            } else if yCharacters.contains(character) {
                noAccentString.append("y")
            } else if dCharacters.contains(character) {
                noAccentString.append("d")
            } else {
                noAccentString.append(character)
            }
        }
        
        return noAccentString
    }
    
    var url: String {
        return self.replacingOccurrences(of: " ", with: "+")
    }
    
}
