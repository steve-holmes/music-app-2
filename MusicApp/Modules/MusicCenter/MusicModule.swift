//
//  MusicModule.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/12/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

class MusicModule: Module {
    
    override func register() {
        container.register(MusicNotification.self) { resolver in
            return MAMusicNotification(
                center: resolver.resolve(MusicCenter.self)!
            )
        }
        
        container.register(MusicCenter.self) { resolver in
            let playlistModule = self.parent?.playlistModule
            let songModule = self.parent?.songModule
            let rankModule = self.parent?.rankModule
            
            return MAMusicCenter(
                dataSource: resolver.resolve(MusicTrackDataSource.self)!,
                player: resolver.resolve(MusicPlayer.self)!,
                playlistRepository: playlistModule!.container.resolve(PlaylistRepository.self)!,
                songRepository: songModule!.container.resolve(SongRepository.self)!,
                rankRepository: rankModule!.container.resolve(RankSongRepository.self)!
            )
        }
        
        container.register(MusicTrackDataSource.self) { resolver in
            return MAMusicTrackDataSource()
        }
        
        container.register(MusicPlayer.self) { resolver in
            return MAMusicPlayer()
        }
    }
    
}
